(rule (greats (grandson) ?s ?g)
	(grandson ?s ?g))
	
(rule (greats (great . ?rel) ?s ?g)
	(and (greats ?rel ?s1 ?g) (son ?s ?s1) ))

	;i didn't use and with grandson. created a rule called greats instead.