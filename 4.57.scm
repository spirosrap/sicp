;4.57
;rules
(rule (same-job ?person1 ?person2) 
	(and (job ?person1 ?title) (job ?person2 ?title)))
	
(rule (can-do-p1p2 ?person1 ?person2)
	(and (job ?person1 ?title1) (job ?person2 ?title2) (can-do-job ?title1 ?title2)) )
	
(rule (replace ?person1 ?person2)
	(and (or (same-job ?person1 ?person2) (can-do-p1p2 ?person1 ?person2)) (not (same ?person1 ?person2))))

;queries
;all people who can replace Cy D. Fect;
(replace ?x (Fect Cy D))

;all people who can replace someone who is being paid more than they are, together with the two salaries.
(and (replace ?person1 ?person2) (salary ?person1 ?amount1) (salary ?person2 ?amount2) (lisp-value > ?amount2 ?amount1))
