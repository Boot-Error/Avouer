<!DOCTYPE html>
<meta name="viewport" content="width=device-width, initial-scale=1" user-scale=no/>
	<head>
		<title>Avoeur</title>
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
			#post-no-comments {
				font-size: 0.9rem;
				/*font-style: #333;*/
				
			}
			#content-display {
				font-size: 0.9rem;
			}
			
			ul {
				margin: 0 auto;
				list-style: none;
			}

			#post-box {
				/*border: 1px solid #000;*/
				padding: 5px;
				margin-bottom: 5px;
				-webkit-box-shadow: 0px 0px 16px -3px rgba(0,0,0,0.42);
				-moz-box-shadow: 0px 0px 16px -3px rgba(0,0,0,0.42);
				box-shadow: 0px 0px 16px -3px rgba(0,0,0,0.42); 
			}

			#add-post-box {
				max-width : 800px;
				border: 1px solid #000;
				padding: 5px;
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
		<div id="mainpage">
			<div id="header">
				<h2>Avouer</h2>
				<p id="content-display">Confess anything, no filters, totally anonymous, Enjoy!</p>
				<div id="add-post-box"><a href="/add_post">Add new post</a></div>
			</div>
			<div id="navcontent">
				% for post in posts:
				<div id="post-box">
					<!--- <p id="post-id"><a href="/post?post_id={{post[0]}}">{{post[0]}}</a></p> -->
					<p id="post-timestamp">{{post[3]}}</p>
					% for sen in post[1].split("\n"):
						<p id="post-content">{{sen}}</p>
					% end
					% if post[4][:7] !=  "Nothing":
					<div id="post-image">
						<img id="post-image-content"src="image/{{post[4]}}"></img>
					</div>
					% end
					<a href="/post?post_id={{post[0]}}"><p id="post-no-comments">{{post[2]}} comments</p></a>
				</div>
				% end
			<div>
		</div>

	</body>
</html>
