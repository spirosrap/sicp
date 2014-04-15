(rule (reverse (?x) (?x)))

(rule (reverse (?head . ?rest)  ?x)
	(and (reverse ?rest ?x2)
		(append-to-form ?x2 (?head) ?x)	)
	)

;They can't answer ?x (1 2 3) because we have to make a choice which of the two pattern variables to
;analyze. We either analyze first to head,rest or the second. 