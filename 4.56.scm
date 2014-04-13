;4.56
;the names of all people who are supervised by Ben Bitdiddle, together with their addresses;
(and (supervisor ?supervised (Bitdiddle Ben)) (address ?supervised ?y))
;all people whose salary is less than Ben Bitdiddle’s, together with their salary and Ben Bitdiddle’s salary;
(and (salary ?person ?amount)  (salary (Bitdiddle Ben) ?amount2) (lisp-value < ?amount ?amount2))
;all people who are supervised by someone who is not in the computer division, together with the supervisor’s name and job.
(and (supervisor ?supervised ?supervisor) (not(job ?supervisor  (computer . ?title))) (job ?supervisor ?type) )
