ev-cond
  (save continue)
  (assign unev (op cond-clauses) (reg exp))  
  (goto (label ev-cond-loop))
ev-cond-loop
  (test (op null?) (reg unev))
  (goto (label end1))	   
  ;(perform (op user-print) (reg exp))
  (save unev)	 		
  (assign exp (op first-exp) (reg unev))
  (save exp)
  (test (op cond-else-clause?) (reg exp))
	  (branch (label ev-cond-else-action))
  (assign exp (op cond-predicate) (reg exp))
  (assign continue (label ev-cond-loop-decide))  
  (goto (label eval-dispatch))
ev-cond-loop-decide
   (restore exp)
   (restore unev)
   (assign unev (op rest-exps) (reg unev))
   (test (op true?) (reg val))
     (branch (label ev-cond-action))	 
   (goto (label ev-cond-loop))
ev-cond-else-action
  (restore exp)
  (restore unev)
  (assign unev (op cond-actions) (reg exp))
  (goto (label ev-sequence))
ev-cond-action
  (assign unev (op cond-actions) (reg exp))
  (goto (label ev-sequence))
end1
  (restore continue)
  (goto (reg continue))  

;in eceval-operations
   (list 'cond-clauses cond-clauses)    
   (list 'cond-else-clause? cond-else-clause?)    
   (list 'cond-predicate cond-predicate)    
   (list 'cond-actions cond-actions)    
