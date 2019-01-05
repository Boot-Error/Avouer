
# nitdc server
# porting to postgres sql, supporting heroku architecture
# mega upload images

import bottle
import re
import time
import psycopg2
import os
import urlparse
import subprocess

from uuid import uuid4

# initialisation

app = bottle.Bottle()

urlparse.uses_netloc.append("postgres")

webdb = psycopg2.connect(
        database="DATABASE",
            user="USER",
            password="PASSWORD",
            host="HOST",
            port=5432,
        )

webcur = webdb.cursor()

# database stuff

def model_commit(server_instance):

    server_instance.commit()


def model_add_post(webcur, **post_data):

    post_uid = str(uuid4())

    values = {
                "poid" : post_uid,
                "poc" : post_data["post_content"],
                "ts" : post_data["created"],
                "iid" : "Nothing"
            }

    if type(post_data["post_image"]) is not str:
        values["iid"] = post_uid
        model_add_image(webcur, post_uid, post_data["post_image"])

    webcur.execute("INSERT INTO posts(post_id, post_content, created, image_id)VALUES (%(poid)s, %(poc)s, %(ts)s, %(iid)s)", values)
    
    model_commit(webdb)


def model_add_comment(webcur, **comment_data):
    
    comment_uid = str(uuid4())
    
    values = {
                "cid" : comment_uid,
                "cpid" : comment_data["post_uid"],
                "cc" : comment_data["comment_content"],
                "ts" : comment_data["created"],
                "iid" : "Nothing"
            }
   
    if type(comment_data["comment_image"]) is not str:
        values["iid"] = comment_uid
        model_add_image(webcur, comment_uid, comment_data["comment_image"])


    webcur.execute("INSERT INTO comments(comment_id, comment_post_id, comment_content, created, image_id) \
            VALUES(%(cid)s, %(cpid)s, %(cc)s, %(ts)s, %(iid)s)", values)
    webcur.execute("UPDATE posts SET comment_count = comment_count + 1 WHERE post_id=(%s)", (comment_data["post_uid"],))
    model_commit(webdb)


def model_show_comments(webcur, post_uid):

    webcur.execute("SELECT * FROM comments WHERE comment_post_id=(%s)" , (post_uid,))
    return webcur.fetchall()
    

def model_list_posts(webcur, start, end):

    statement = "SELECT * FROM posts LIMIT (%s) OFFSET (%s)"
    
    webcur.execute(statement, (start, end))
    result = webcur.fetchall()
    result.reverse()
    return result


def model_show_post(webcur, post_uid):

    webcur.execute("SELECT * FROM posts WHERE post_id=(%s)", (post_uid,))
    return webcur.fetchone()


def model_add_image(webcur, post_uid, image_obj):

    name, ext = os.path.splitext(image_obj.filename)
    image_obj.save("images/%s" % post_uid)

    mega_image_upload(post_uid)


# utils

def util_link_embedding(content):

    #url regexp
    urlregex = re.compile("http[s]?://(\w\d{1, 256})?\.\w\d{1, 256}\.\w\d{1, 256}/.")

def database_dump(webcur):

    from json import dump
    webcur.execute("SELECT * FROM posts")
    posts = webcur.fetchall()
    with open("posts.json", "w") as p:
        
        dump(posts, p)
        

# mega upload stuff
# implementing mega for image storage

def mega_image_upload(image_name):

    # spawns an upload process
    upprox = subprocess.Popen(["megacmd", "-conf", ".megacmd", "put", "images/%s" % image_name, "mega:/images/%s" % image_name])

    print "[+] Uploading by %d File : %s" % (upprox.pid, image_name)
    
# redis stuff

# spam filtering stuff
# RD Stuff here

# server controllers

def controller_mainpage():

    posts = model_list_posts(webcur, 50, 0)
    # mainpage_template = bottle.SimpleTemplate(open("static/mainpage.tpl").read(), {"posts" : posts})
    # rendered = mainpage_template.render()
    # posts = [model_show_post(webcur, "8d8c8751-b466-46d0-b8ac-a5b72a37d480")] + posts
    rendered = bottle.template(open("static/mainpage.tpl").read(), { "posts" : posts })
    return rendered


def controller_show_post():

    post_id  = bottle.request.GET.get("post_id")
    
    post_data = model_show_post(webcur, post_id)
    comment_data = model_show_comments(webcur, post_id)
    
    rendered = bottle.template(open("static/post.tpl").read(),  {"post" : post_data, "comments" : comment_data})

    return rendered


def controller_add_post_page():

    return open("static/addpost.tpl").read()


def controller_add_new_post():

    post_data = bottle.request.forms.get("post_content")
    post_ts   = bottle.request.forms.get("created")
    post_image = bottle.request.POST["avoimage"]
    
    print post_data, post_ts
    print post_image
    # if not post_data:
    # print post_data
    if len(post_data) > 0:
        model_add_post(webcur, post_content=post_data, created=post_ts, post_image=post_image)

    bottle.redirect("/")


def controller_append_new_comment():

    comment_data  = bottle.request.forms.get("comment")
    post_uid      = bottle.request.forms.get("post_uid")
    post_ts       = bottle.request.forms.get("created")
    comment_image = bottle.request.POST["avoimage"]

    # print comment_data.find("\n")
    # comment_data = comment_data.replace("\n", "<br/>")
    
    if len(comment_data) > 0:

        model_add_comment(webcur, comment_content=comment_data, comment_image=comment_image, created=post_ts, post_uid=post_uid)

    bottle.redirect("/post?post_id=%s" % post_uid)


def controller_show_about():

    return open("statc/about.tpl")


def controller_serve_images(imageid):

    return bottle.static_file(imageid, root="images/")


def controller_login():

    pass

# routes

app.route("/", "GET", controller_mainpage)
#app.route("/page/<number:int>", controller_z)
app.route("/post", "GET", controller_show_post)
app.route("/about", "GET", controller_show_about)
app.route("/add_post", "POST", controller_add_new_post)
app.route("/add_post", "GET", controller_add_post_page)
app.route("/add_comment", "POST", controller_append_new_comment)
app.route("/image/<imageid>", "GET", controller_serve_images)
app.route("/auth", "POST", controller_login)

# main config

app.run(host="0.0.0.0", port=int(os.environ.get("PORT", 5000)))
