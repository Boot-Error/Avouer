<!DOCTYPE html>
<meta name="viewport" content="width=device-width, initial-scale=1" user-scale=no/>
	<head>
		<title>Avouer - {{post[1]}}</title>
		<style type="text/css">
			#body {
				margin: 0 auto;
				padding: 0 auto;
				background-image: url(http://api.thumbr.it/whitenoise-361x370.png?background=fafafaff&noise=dbdbdb&density=37&opacity=100;);
			}
	
			#main {
				max-width: 800px;
				margin: 0 auto;
			}
			
			#post-box {
				max-width: 800px;
				margin: 5 auto;
			}
			#post-id {
				font-size: 0.6rem;
			}
			#post-content {
				margin: 10px auto;
				font-size: 1.2rem;
			}
			#post-timestamp {
				font-size: 0.6rem;
			}

			#add-comment {
				margin: 0 auto;
			}

			textarea {
				max-width: 800px;
				/*resize: none;*/
			}

			#comment-id {
				font-size: 0.6rem;
			}
			#comment-content {
				margin: 5px auto;
				font-size: 1.2rem;
			}
			#comment-timestamp {
				font-size: 0.6rem;
			}

			#post-box {
				/*border: 1px solid #000;*/
				-webkit-box-shadow: 0px 0px 16px -3px rgba(0,0,0,0.42);
				-moz-box-shadow: 0px 0px 16px -3px rgba(0,0,0,0.42);
				box-shadow: 0px 0px 16px -3px rgba(0,0,0,0.42);
				padding: 5px;
				margin-bottom: 5px; 
			}

			#comment-single-box {
				/*border: 1px solid #000;*/
				padding: 5px;
				margin-bottom: 5px;
				-webkit-box-shadow: 0px 0px 16px -3px rgba(0,0,0,0.42);
				-moz-box-shadow: 0px 0px 16px -3px rgba(0,0,0,0.42);
				box-shadow: 0px 0px 16px -3px rgba(0,0,0,0.42);
			}
			#add-comment {
				margin-top: 5px;
				margin-bottom: 5px;
			}
			#header {
				margin-bottom: 5px;
			}

			#post-image {
				max-width : 800px;
			}

			#post-image-content {
				width : 100%;
			}

		</style>
	</head>
	<body>
		<div id="main"> 
			<div id="header">
				<h2>Avouer</h2>
				<p id="content-display">Confess anything, no filters, totally anonymous, Enjoy!</p>
				<div id="add-post-box"><a href="/">Mainpage</a></div>
			</div>
			<div id="content">
				<div id="post-box">
					<a href="/post?post_id={{post[0]}}"><p id="post-id">{{post[0]}}</p></a>
					<p id="post-content">{{post[1]}}</p>
					% if post[4][:7] != "Nothing":
					<div id="post-image">
						<img id="post-image-content"src="image/{{post[4]}}"></img>
					</div>
					% end
					<p id="post-timestamp">{{post[3]}}</p>
				</div>
				<div id="comment-box">
					<div id="add-comment">
						<form action="/add_comment" method="POST" onsubmit="return addTimeStamp()" enctype="multipart/form-data">
							<input name="post_uid" type="hidden" value="{{post[0]}}"></input>
							<textarea cols=40 rows=5  name="comment"></textarea>
							<input id="input-timestamp" name="created" type="hidden" value=""/>
							<br/>
							<input type="file" name="avoimage"></input>	
							<br/>
							<button name="submit">Submit</button>
						</form>
					</div>
					% if comments is not None:
					<div id="nav-comments">
						% for comment in comments:
						<div id="comment-single-box">
							<!--- <p id="comment-id">{{comment[0]}}</p> -->
							<p id="comment-content">
								% for line in comment[2].split("\n"):
									<p>{{line}}</p>
								% end
							</p>
							<p id="comment-timestamp">{{comment[3]}}</p>
							% if comment[4][:7] != "Nothing":
							<div id="post-image">
								<img id="post-image-content"src="image/{{comment[4]}}"></img>
							</div>
							% end
						</div>
						% end
					</div>
					% end
					% if comments is None:
					<p id="no-comment">No Comments</p>
					% end
				</div>
			</div>
			<script type="text/javascript">
			
				function addTimeStamp() {
			
					// var postSubmit = document.forms["form-submit"]["created"]	
					curtime = new Date();
					q = document.getElementById("input-timestamp");
					q.setAttribute("value", curtime)
				
				}
			</script>
		</div>
	</body>
</html>
