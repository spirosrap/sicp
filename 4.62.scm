(rule (last-pair (?x) (?x)))
(rule (last-pair (?head . ?rest) ?x)
		(last-pair ?rest ?x))

;It doesn't work for (last-pair ?x (3)) because there are infinite pairs and 
;cannot be displayed.