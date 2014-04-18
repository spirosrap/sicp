(controller
	(assign counter (const 1))
	(assign product (const 1))
	factorial
		(test (op >) (reg counter) (reg n))
		(branch (label factorial-done))
		(assign t (op *) (reg product) (reg counter))
		(assign product (reg t))
		(assign t1 (op +) (reg counter) (const 1))
		(assign counter (reg t1))
		(goto (label factorial))			  
    factorial-done
)
