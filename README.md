## SAArchiver 

At some point, I'll update this to be a proper README, but for now, here's a quick overview of what this is.

### What is it?
This is a project to host a rails based API to archive something awful threads. Its been in "production" for a while now, but I've never really documented it.

### Why?
Because the only way to make sure content survives on the internet is to host it and back it up 

### How?
The API is a rails app, in the app/models/concerns folder there is a series of scripts that are used to populate the database. In essence you take the SAScraper and run SAScraper.new.main_logic("thread_url") and it will populate the database with the thread.

There a bunch of routes that are used to access the data, but I leave discovery to the reader, they're all in the routes file.