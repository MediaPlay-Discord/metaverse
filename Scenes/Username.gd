extends Label

func _ready():
	# Create an HTTP request node and connect its completion signal.
	var http_request = HTTPRequest.new()
	var access_token = "syt_bGluZXJseQ_bMuYcePvEZGIAmHZLRgv_3i1bnl"
	add_child(http_request)
	http_request.connect("request_completed", self, "_http_request_completed")

	# Perform the HTTP request. The URL below returns a PNG image as of writing.
	var error = http_request.request("https://matrix-client.matrix.org/_matrix/client/r0/account/whoami?access_token=" + access_token)
	if error != OK:
		push_error("An error occurred in the HTTP request.")


# Called when the HTTP request is completed.
func _http_request_completed(result, response_code, headers, body):
	print(body)
	#Label.new().text = body.user_id
