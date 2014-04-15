;Let's take the case of reverse in which (reverse ?x '(1 2 3)) falls into an infinite loop.

(rule (reverse (?head . ?rest)  ?x)
	(and (reverse ?rest ?x2)
		(append-to-form ?x2 (?head) ?x)	)
	)

;We put in the history the rules that were applied. We store it in the current frame.
;if the same corresponding variables remain free in the history then were in a loop.

