This provides a simple REST API for storing and quering SA forums threads, mostly aimed at storing CYOAs. 

The API allows for users to query the existing data (by user, post and most importantly thread), as well as adding new threads to be archived. 

As of right now your request to archive a thread will have to be manually approved by an admin. Send the request to the provided request API. 

Documentation on API functions here

Search documentation here.

How to set this up on your own here (full rails setup. postgress setup. figaro use.)

Route /sathread/ = index
Route /sathread/:thread_id = thread
Route /sathread/title/:title = thread
Route 