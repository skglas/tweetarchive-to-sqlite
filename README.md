# tweetarchive-to-sqlite
Transform a Twitter JSON Archive file (tweets.js) to an SQLite Database.
Advantages: works locally, no API required, just the Twitter Archive file.

1) Download your Twitter Archive
2) In the ZIP File, find data/tweets.js. These are your tweets.
3) Use the program to transform the Tweets into an SQLite Database.
4) Now you can use an SQL Client (like DB Visualizer or the SQLite Client Program) to search for tweets.

Example Queries:

select * from tweets where full_text like '%keyword%' order by id

TODO:
* Currently, all datatypes are TEXT, the counters should be numerical and the date needs to be destructured for an SQL insert to be able to search via Date Ranges. 
* It would probably be nice to also archive the originally posted tweets if the tweet was in_reply_to some tweet of someone else.
* It woule be even nicer to archive a complete thread if the tweet was part of a conversation. 

To my knowledge, CL-Chirp only supports the Twitter v1.0 API, so I am not sure how much work these use cases would be. 
