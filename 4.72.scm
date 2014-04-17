;From Chapter 3:

;Since interleave takes elements alternately from the two streams, every element of the second stream will eventually find its way into the ;interleaved stream, even if the first stream is infinite.

;To handle infinite streams, we need to devise an order of combination that ensures that every element will eventually be reached if we let our ;program run long enough. An elegant way to accomplish this is with the following interleave procedure:196

(define (interleave s1 s2)
  (if (stream-null? s1)
      s2
      (cons-stream 
       (stream-car s1)
       (interleave s2 (stream-cdr s1)))))



;in the case of disjoin:

      (interleave-delayed
       (qeval (first-disjunct disjuncts) frame-stream)
       (delay (disjoin (rest-disjuncts disjuncts)
                       frame-stream)))

;if qeval ouputs a very long stream (maybe an infinite stream) then disjoin will output something.

