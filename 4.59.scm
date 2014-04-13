;On Friday morning, Ben wants to query the data base for all the meetings that occur that day. What query should he use?	
(meeting ?x (Friday ?y))

;Alyssa P. Hacker is unimpressed. She thinks it would be much more useful to be able to ask for her meetings by specifying her name. 
;So she designs a rule that says that a person’s meetings include all whole-company meetings plus all meetings of that person’s division
(assert! (rule (meeting-time ?person
                    ?day-and-time)
					(or (and (job ?person (?division . ?rest)) (meeting ?division ?day-and-time)) (meeting whole-company ?day-and-time)) 
	  )
  
)

;Alyssa arrives at work on Wednesday morning and wonders what meetings she has to attend that day.
;Having defined the above rule, what query should she make to find this out?
(meeting-time (Hacker Alyssa P) (Wednesday . ?rest))