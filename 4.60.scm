(lives-near ?person-1 ?person-2)

;the above query works by first searching for each person-1 all the people that have the same address with the person-2 returns them and
;then continues to the next person. At one point let's say we exhaust all search for #p1 and have (#p1 #p2) (#p1 #p3). The next time for 
;#p2 the search returns (#p2 #p1) and other.

;We could bypass this problem by assigning to each person a unique id (number) and adding an additional statement for the (and) 
;that checks  (lisp-value ⟨predicate⟩ ⟨arg₁⟩ … ⟨argₙ⟩) if the first id is greater than the second. So each time we add one of the (#p1 #p2).

;for each name we add an id ((Hacker Alyssa P) (#13))
(rule (lives-near ?person-1 ?person-2)
      (and (address (?person-1 ?id1) (?town . ?rest-1))
           (address (?person-2 ?id2) (?town . ?rest-2))
		   (lisp-value > ?id1 ?id2) ;adding this
           (not (same ?person-1 ?person-2)) ))