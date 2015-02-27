# visualizing_fb_network
Chris and Jimmy's McHacks 2015 project

No longer requires rPython, which is hard to install on Windows. 
Instead, uses native R libraries: shiny, igraph and Rfacebook. 


# Known Errors: 
	Error: (#803) Some of the aliases you requested do not exist ...
	Some of the input fields aren't complete. One or more of access token, group ID and post ID is missing. Fill out all of the input fields. Also, group ID only works with numeric IDs for now. 
	
	Error: Unsupported get request. Please read the Graph API documentation at https://developers.facebook.com/docs/graph-api
	Make sure the post ID is from the group. 
	
	Doesn't work on stories or status posts. 
	
	
TODO: 
	see if we can get statuses too: 
		statuses are pretty much the same as posts, but in the ID field of comments, the post number is repeated. Therefore, they need slightly different handling to avoid getting <person-id>_<post-id>_<post-id>_<comment-id>. This should be done with a conditional panel
	make hierarchal clustering stop breaking when the graph is disconnected
	remove the Python file because it's useless now 
