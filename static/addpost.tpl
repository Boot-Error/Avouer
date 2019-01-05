<!DOCTYPE html>
	<head>
		<title></title>
		<style type="text/css">
		textarea {
			resize: none;
		}
		</style>
	</head>
	<body>
		<h2>Post something dope</h2>
		<p>Write your thoughts, a text is necessary!</p>
		<form name="post-submit" action="/add_post" method="POST" onsubmit="return addTimeStamp()" enctype="multipart/form-data">
			<textarea rows=5 cols=90 name="post_content"></textarea>
			<br/>
			<input id="input-timestamp" name="created" type="hidden" value=""/> 
			<input type="file" name="avoimage"></input>
			</br>
			<button type="submit">Submit</button>
		</form>
		<p>Please wait after pressing Submit until you are redirected to HomePage</p>
		<a href="/"><p id="go-back">Go Back</p></a>
		<script type="text/javascript">
			
			function addTimeStamp() {
			
				// var postSubmit = document.forms["form-submit"]["created"]	
				curtime = new Date();
				q = document.getElementById("input-timestamp");
				q.setAttribute("value", curtime)
				
			}
		</script>
	</body>
</html>
