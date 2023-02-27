#!/usr/bin/racket
#lang racket

(require json)
(require gregor)
(require net/http-easy)

#| Update the cached values |#

(define week
  (map (lambda (offset) (+days (today) offset))
       (range 7)))

(define (get-date-string date)
    (~t date "YYYY-MM-dd"))

(define (create-url date)
  (~a "https://api.sunrise-sunset.org/json?lat=47.4979937&lng=19.0403594&formatted=0&date="
      (get-date-string date)))

(define (get-responses)
  (map
    (lambda (day) (get (create-url day)))
    week))

(define (sunsets responses)
  (map
    (lambda (res)
      (hash-ref (hash-ref (response-json res) 'results) 'sunset))
    responses))

(define (cache)
  (with-output-to-file
    "sunsets.json" ; TODO Get this from the command line
    #:exists 'replace
    (lambda () (write-json (sunsets (get-responses))))))

#| Turn on lights if sunset is near |#

(define (check-and-toggle)
  (let* ([sunset
           (car (with-input-from-file
                  "sunsets.json" ; TODO
                  read-json))]
         [diff (minutes-between (now #:tz 0) (iso8601->datetime sunset))])
    (if (and (< diff 5) (> diff 0))
      (process "/usr/sbin/uhubctl --location 1-1 --ports 2 -a 1") ; TODO
      #f)))

(define (main)
  (let ([args (current-command-line-arguments)])

    (cond [(and (= (vector-length args) 1)
                (string=? (vector-ref args 0) "cache")) (cache)]
          [else (check-and-toggle)])))

(main)
