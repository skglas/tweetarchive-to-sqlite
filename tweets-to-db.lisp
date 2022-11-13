;; Copyright (c) 2019-2022 Sebastian Glas

;; This software is provided 'as-is', without any express or implied
;; warranty. In no event will the authors be held liable for any damages
;; arising from the use of this software.

;; Permission is granted to anyone to use this software for any purpose,
;; including commercial applications, and to alter it and redistribute it
;; freely, subject to the following restrictions:

;; 1. The origin of this software must not be misrepresented; you must not
;;    claim that you wrote the original software. If you use this software
;;    in a product, an acknowledgment in the product documentation would be
;;    appreciated but is not required.
;; 2. Altered source versions must be plainly marked as such, and must not be
;;    misrepresented as being the original software.
;; 3. This notice may not be removed or altered from any source distribution.


;;  Tweetarchive-to-SQLite v0.2
;; 
;;  A short hack to transfer your Twitter Archive (JSON File) to an SQLite DB.
;;  Only basic entities are written. I use it for local keyword searching via an SQL Client.
;;  Tested on Windows 10 with SBCL 2.1.10 for an Archive as of 11/2022. SQLite DLLs are required.
;;  For compilation, I used sbcl with --dynamic-space-size 8000
;;  Parsing 100 MB Tweets consumed ~2 GB RAM. Quotes are replaced by ''
;;  currently, all fields are TEXT! 


(ql:quickload :yason)
(ql:quickload :sqlite)
(ql:quickload :cl-ppcre)

(push #p"C:/Windows"  cffi:*foreign-library-directories*) ;place for your sqlite DLLs
(defvar *db* (sqlite:connect "C:/tmp/tweets.sqlite")) ; your tweet SQLite distination file

(defun setup-db ()
    (sqlite:execute-non-query *db*  "create table tweets (dbid integer primary key, source text, created_at text, lang text, display_text_range text, favorited text, favorite_count text, retweet_count text, full_text text, entities text, retweeted text, truncated text, id_str text, id text,  in_reply_to_screen_name text, in_reply_to_status_id_str text, in_reply_to_status_id text, in_reply_to_user_id_str text,  in_reply_to_user_id text, possibly_sensitive text, extended_entities text, edit_info text, withheld_copyright text, withheld_in_countries text)"))

(defun make-vallist-from-hash (h)
               (let ((result))
                 (maphash #'(lambda (x y) (push y result)) h)
                 (reverse result)))

(defun make-keylist-from-hash (h)
               (let ((result))
                 (maphash #'(lambda (x y) (push x result)) h)
                 (reverse result)))

(defun tweets-to-db (tweets-filename)
  (with-open-file (str tweets-filename :direction :input :external-format :utf8)
    (dolist (tweet (yason:parse str))
      (let ((tw (gethash "tweet" tweet)))
	(sqlite:execute-non-query *db*
				  (format nil
					  "insert into tweets (~A) values (~A)"
					  (format nil "~{~A~^, ~}" (make-keylist-from-hash tw))
					  (format nil "~{'~A'~^, ~}"
						  (mapcar #'(lambda (x) (cl-ppcre:regex-replace-all "'" (format nil "~A" x) "''" ))
							  (make-vallist-from-hash tw)))))))))

