;Exercise 4.58: Define a rule that says that a person is a “big shot” in a division 
;if the person works in the division but does not have a ;supervisor who works in the division.


(assert! (rule (bigshot ?person)
	(and (job ?person (?division . ?rest)) 
		(or (and (supervisor ?person ?super) (not (job ?super (?division . ?rest2)))) (not (supervisor ?person ?x)))  
	)))
