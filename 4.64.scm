;4.64

(rule (outranked-by ?staff-person ?boss)
  (or (supervisor ?staff-person ?boss)
      (and (outranked-by ?middle-manager
                         ?boss)
           (supervisor ?staff-person 
                       ?middle-manager))))


;let's take an example: First the (supervisor (bitdiddle ben) ?who) of the first or expression gives: 

(supervisor (bitdiddle ben) (warbucks oliver))


Then the system tries to compute (outranked-by ?middle-manager (warbucks oliver)). So we again try to find (supervisor ?middle-manager (warbucks oliver)) which gives:
(supervisor (aull dewitt) (warbucks oliver))
(supervisor (scrooge eben) (warbucks oliver))
(supervisor (bitdiddle ben) (warbucks oliver))

;Let's continue with this.
(supervisor (bitdiddle ben) (warbucks oliver))

;next: (outranked-by ?middle-manager2 (warbucks oliver))

;It is clear now that we go at an infinite loop.
