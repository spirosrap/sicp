(rule (grandson ?s ?g) 
	(and (son ?father ?s) (son ?g ?father))
)
(rule (son ?m ?s)
  	(and (wife ?m ?w) (son ?w ?s))  
)

;grandsons of Cain
(grandson ?x Cain)

;grandsons of Methushael
(grandson ?x Methushael)

;Sons of Lamech
(son Lamech ?x)