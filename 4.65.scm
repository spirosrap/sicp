(rule (wheel ?person)
      (and (supervisor ?middle-manager ?person)
           (supervisor ?x ?middle-manager)))


; (wheel ?who) first computes (supervisor ?middle-manager ?who)

(supervisor ?middle-manager ?who)
;;; Query results:
(supervisor (aull dewitt) (warbucks oliver))
(supervisor (cratchet robert) (scrooge eben))
(supervisor (scrooge eben) (warbucks oliver))
(supervisor (bitdiddle ben) (warbucks oliver))
(supervisor (reasoner louis) (hacker alyssa p))
(supervisor (tweakit lem e) (bitdiddle ben))
(supervisor (fect cy d) (bitdiddle ben))
(supervisor (hacker alyssa p) (bitdiddle ben))

; then for each ?middle-manager (supervised)  
(supervisor ?x ?middle-manager)
;then computes

(supervisor ?x (aull dewitt))
------------------------------
nothing

(supervisor ?x (cratchet robert) )
------------------------------
nothing

(supervisor ?x (scrooge eben))
------------------------------
1st: (warbucks oliver)

(supervisor ?x (bitdiddle ben))
------------------------------
(supervisor (tweakit lem e) (bitdiddle ben)) 2nd: (warbucks oliver)
(supervisor (fect cy d) (bitdiddle ben)) 4th:  (warbucks oliver)
(supervisor (hacker alyssa p) (bitdiddle ben)) 5th: (warbucks oliver)


(supervisor ?x (reasoner louis))

(supervisor ?x (tweakit lem e))

(supervisor ?x (fect cy d))

(supervisor ?x (hacker alyssa p))
----------------------------------
(supervisor (reasoner louis) (hacker alyssa p)) 3d: (bitdiddle ben)


;the time the system tries to bind (supervisor ?middle-manager ?person) to (supervisor (bitdiddle ben) (warbucks oliver)) the
; (supervisor ?x (bitdiddle ben)) gives the 3 results. It displays warbucks oliver and goes on to the next to find bitdiddle ben. Then it goes
; back to find the rest warbucks olivers