(define (uniquely-asserted contents frame-stream)
    (stream-flatmap
     (lambda (frame)
       (if (= 1 (stream-length (qeval (car contents)
                                (singleton-stream frame))))
		  (qeval (car contents) (singleton-stream frame))
           the-empty-stream))
     frame-stream))


;Test your implementation by forming a query that lists all 
;people who supervise precisely one person.

(and (supervisor ?j ?x) 
     (unique (supervisor ?anyone ?x)))
