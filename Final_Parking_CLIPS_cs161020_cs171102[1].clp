;; ----------------------------------------------------------------
;;                   ΒΕΛΑΣΚΟ ΠΑΟΛΑ      cs161020
;;                   ΜΙΧΑ ΕΥΑΓΓΕΛΙΑ 	  cs171102
;; ----------------------------------------------------------------
;;              Τμήμα Μηχανικών Πληροφορικής και Υπολογιστών
;;         Εργαστήριο ΤΝ 2020/21 - Εργασία 2: Έμπειρα Συστήματα
;;            Το πρόβλημα του πάρκινγκ - Ολοκληρωμένη εκδοχή
;; ----------------------------------------------------------------
;;  Υπεύθυνος μαθήματος: ΓΕΩΡΓΟΥΛΗ ΚΑΤΕΡΙΝΑ
;;  Καθηγητές: ΒΟΥΛΟΔΗΜΟΣ ΘΑΝΟΣ, ΤΣΕΛΕΝΤΗ ΠΑΝΑΓΙΩΤΑ
;; ----------------------------------------------------------------


;; ----------------------------------------------------------------
;;                        Πρότυπα Γεγονότων
;; ----------------------------------------------------------------

(deftemplate space
  (slot s_name (type SYMBOL))
  (slot s_floor (type INTEGER))
  (slot s_state (type SYMBOL))
)

(deftemplate platform
  (slot p_name (type SYMBOL))
  (slot p_space (type SYMBOL))
  (slot p_state (type SYMBOL))
)

(deftemplate car
  (slot c_plate (type SYMBOL))
  (slot c_state (type SYMBOL) (default waiting))
)

;; ----------------------------------------------------------------
;;                        Αρχικά Γεγονότα
;; ----------------------------------------------------------------

(deffacts spaces "Γεγονότα: χώροι στάθμευσης"
  (space (s_name S01) (s_floor 1) (s_state P))
  (space (s_name S02) (s_floor 1) (s_state F))
  (space (s_name S03) (s_floor 1) (s_state P))
  (space (s_name S04) (s_floor 1) (s_state P))
  (space (s_name S05) (s_floor 1) (s_state P))
  (space (s_name S06) (s_floor 1) (s_state P))
  (space (s_name S11) (s_floor 2) (s_state F))
  (space (s_name S12) (s_floor 2) (s_state P))
  (space (s_name S13) (s_floor 2) (s_state P))
  (space (s_name S14) (s_floor 2) (s_state P))
  (space (s_name S15) (s_floor 2) (s_state P))
  (space (s_name S16) (s_floor 2) (s_state F))
  (space (s_name S21) (s_floor 3) (s_state F))
  (space (s_name S22) (s_floor 3) (s_state P))
  (space (s_name S23) (s_floor 3) (s_state P))
  (space (s_name S24) (s_floor 3) (s_state P))
  (space (s_name S25) (s_floor 3) (s_state P))
  (space (s_name S26) (s_floor 3) (s_state P))
)

(deffacts platforms "Γεγονότα: πλατφόρμες"
  (platform (p_name P1) (p_space S01) (p_state empty))
  (platform (p_name P2) (p_space S03) (p_state empty))
  (platform (p_name P3) (p_space S04) (p_state empty))
  (platform (p_name P4) (p_space S05) (p_state empty))
  (platform (p_name P5) (p_space S06) (p_state empty))
  (platform (p_name P6) (p_space S12) (p_state empty))
  (platform (p_name P7) (p_space S13) (p_state empty))
  (platform (p_name P8) (p_space S14) (p_state empty))
  (platform (p_name P9) (p_space S15) (p_state empty))
  (platform (p_name P10) (p_space S22) (p_state empty))
  (platform (p_name P11) (p_space S23) (p_state empty))
  (platform (p_name P12) (p_space S24) (p_state empty))
  (platform (p_name P13) (p_space S25) (p_state empty))
  (platform (p_name P14) (p_space S26) (p_state empty))
)

(deffacts neighbours "Γεγονότα: γειτνίαση των χώρων "
;;; Επίπεδο 0
  (east S01 S02)
  (east S02 S03)
  (east S04 S05)
  (east S05 S06)
  (north S01 S04)
  (north S02 S05)
  (north S03 S06)

;;; Επίπεδο 1
  (east S11 S12)
  (east S12 S13)
  (east S14 S15)
  (east S15 S16)
  (north S11 S14)
  (north S12 S15)
  (north S13 S16)

;;; Επίπεδο 2
  (east S21 S22)
  (east S22 S23)
  (east S24 S25)
  (east S25 S26)
  (north S21 S24)
  (north S22 S25)
  (north S23 S26)
)

;Γεγονός: πλήθος αυτοκινήτων που μπορεί να υποδεχτεί το πάρκινγκ
(deffacts initial
  (capacity 14)
)

;; ----------------------------------------------------------------
;;                            Κανόνες
;; ----------------------------------------------------------------

(defrule begin "Αρχικοποίηση στρατηγικής και έναρξης προγράμματος"
(declare (salience 100))
  (initial-fact)
=>
;;;;;------- Ανάθεση στρατηγικής "random" -------------------------
  (set-strategy random)
  ;;  (set-strategy depth)
  ;;  (set-strategy breadth)
  ;;  (set-strategy simplicity)
  ;;  (set-strategy complexity)
  (printout t "Parking Begins!" crlf crlf)
  (assert (choice add))
)

(defrule add_car "Προσθήκη αυτοκινήτων"
(declare (salience 99))
  ?x <- (choice add)
=>
  (printout t "Give me the information of the cars waiting" crlf)
  (printout t "How many cars are waiting?" crlf)
  (bind ?n_cars (read))
  (bind ?count 0)
  (while (< ?count ?n_cars) do
    (printout t "Give me the plate of the car:" crlf)
    (assert(car (c_plate(read))))
    (bind ?count (+ ?count 1))
  )
)

(defrule check_capacity  "Έλεγχος εγκυρότητας εισαγωγή αριθμό αυτοκινήτων"
(declare (salience 99))
  ?x <- (car (c_plate ?) (c_state ?))
  (capacity ?cap)
  (test (> (length (find-all-facts ((?c car)) (eq ?c:c_state waiting) ) ) ?cap ) )
=>
  (printout t "More cars than spaces!" crlf)
  (halt)
)


(defrule enter_parking "Είσοδος αυτοκινήτου"
(declare (salience 98))
  ?x <- (car (c_plate ?plate) (c_state waiting))
  ?y <- (platform (p_name ?pname) (p_space S02) (p_state empty))
=>
  (modify ?x (c_state ?pname))
  (modify ?y (p_state full))
  (printout t "Car with plate: " ?plate " parked on platform " ?pname crlf)
)

(defrule choice "Μενού επιλογής"
(declare (salience 98))
  ?x <- (choice menu)
=>
  (printout t "Type 1. ADD car(s), 2. REMOVE car(s) or 0. TERMINATE" crlf)
  (bind ?ch(read))
  (if (= ?ch 0) then
    (halt)
  )
  else
    (if (= ?ch 1) then
      (retract ?x)
		  (assert (choice add))
    else
		  (retract ?x)
		  (assert (choice exit))
	  )
)

(defrule allparked_goal "Εύρεση στόχου - Εισαγωγή όλων των επιθυμητών αυτοκινήτων"
(declare (salience 97))
  (not (car (c_plate ?) (c_state waiting)))
  ?x <- (choice add)
=>
  (printout t "All cars waiting have parked" crlf)
  (retract ?x)
  (assert (choice menu))
)

(defrule want_exit "Επιλογή εξόδου αυτοκινήτου"
(declare (salience 75))
  ?x <- (choice exit)
=>
  (printout t "How many cars want to exit the parking?" crlf)
  (bind ?n_cars (read))
  (while (> ?n_cars 0)
  	(printout t "Give me plate of the car that wants to exit:" crlf)
  	(bind ?plate (read))
  	(assert(car (c_plate ?plate)(c_state exiting)))
  	(bind ?n_cars (- ?n_cars 1))
  )
)

(defrule empty_parking "Έλεγχος διαθεσιμότητας χώρου πάρκινγ - ΑΔΕΙΟΣ"
  (declare (salience 70))
  (not (exists (car)))
  ?x <- (choice exit)
=>
  (printout t "The parking is empty!" crlf)
  (retract ?x)
  (assert (choice menu))
)

(defrule all_platforms_full "Έλεγχος διαθεσιμότητας χώρου πάρκινγ - ΓΕΜΑΤΟΣ"
  (declare (salience 70))
  (not (platform (p_state empty)))
  ?x <- (choice add)
=>
  (printout t "All platforms are full!" crlf)
  (retract ?x)
  (assert (choice menu))
)

(defrule exit_done "Εύρεση στόχου - Εξαγωγή όλων των επιθυμητών αυτοκινήτων"
  (declare (salience 65))
  (not (car (c_state exiting)))
  ?x <- (choice exit)
=>
  (printout t "All choosen cars have exited the parking" crlf)
  (retract ?x)
  (assert (choice menu))
)

(defrule exit_parking "Αυτοκίνητα προς έξοδο"
  (declare (salience 96))
  ?x <- (car (c_plate ?plate) (c_state exiting))
  ?y <- (car (c_plate ?plate) (c_state ?s))
  ?z <- (platform (p_name ?s) (p_space S02) (p_state full))
=>
  (modify ?z (p_state empty))
  (retract ?x)
  (retract ?y)
  (printout t "Car with plate: " ?plate " exited parking" crlf)
)

(defrule car_not_exists "Έλεγχος αυτοκινήτου"
  (declare (salience 80))
  ?x <- (car (c_plate ?plate)(c_state exiting))
  (not(car (c_plate ?plate)(c_state ?s&~exiting)))
  (choice exit)
=>
  (printout t "The car with plate " ?plate " is not in the parking" crlf)
  (retract ?x)
)

(defrule move_platform_east "Μετακίνηση πλατφόρμας δεξιά"
(declare (salience 50))
  (east ?s ?s_right)
  ?x <- (space (s_name ?s) (s_floor ?) (s_state P))
  ?y <- (space (s_name ?s_right) (s_floor ?) (s_state F))
  ?z <- (platform (p_name ?pname) (p_space ?s) (p_state ?))
=>
  (modify ?x (s_state F))
  (modify ?y (s_state P))
  (modify ?z (p_space ?s_right))
  (printout t "platform " ?pname " moved from " ?s " to " ?s_right crlf)
)

(defrule move_platform_north "Μετακίνηση πλατφόρμας πάνω"
(declare (salience 50))
  (north ?s ?s_above)
  ?x <- (space (s_name ?s) (s_floor ?) (s_state P))
  ?y <- (space (s_name ?s_above) (s_floor ?) (s_state F))
  ?z <- (platform (p_name ?pname) (p_space ?s) (p_state ?))
=>
  (modify ?x (s_state F))
  (modify ?y (s_state P))
  (modify ?z (p_space ?s_above))
  (printout t "platform " ?pname " moved from " ?s " to " ?s_above crlf)
)

(defrule move_platform_west "Μετακίνηση πλατφόρμας αριστερά"
(declare (salience 50))
(east ?s_left ?s)
  ?x <- (space (s_name ?s) (s_floor ?) (s_state P))
  ?y <- (space (s_name ?s_left) (s_floor ?) (s_state F))
  ?z <- (platform (p_name ?pname) (p_space ?s) (p_state ?))
=>
  (modify ?x (s_state F))
  (modify ?y (s_state P))
  (modify ?z (p_space ?s_left))
  (printout t "platform " ?pname " moved from " ?s " to " ?s_left crlf)
)

(defrule move_platform_south "Μετακίνηση πλατφόρμας κάτω"
(declare (salience 50))
  (north ?s_down ?s)
  ?x <- (space (s_name ?s) (s_floor ?) (s_state P))
  ?y <- (space (s_name ?s_down) (s_floor ?) (s_state F))
  ?z <- (platform (p_name ?pname) (p_space ?s) (p_state ?))
=>
  (modify ?x (s_state F))
  (modify ?y (s_state P))
  (modify ?z (p_space ?s_down))
  (printout t "platform " ?pname " moved from " ?s " to " ?s_down crlf)
)

(defrule move_platform_up_to_1 "Μετακίνηση πλατφόρμας από επίπεδο 0 στο επίπεδο 1"
(declare (salience 50))
  ?x <- (space (s_name S02) (s_floor 1) (s_state P))
  ?p <- (platform (p_name ?pname) (p_space S02) (p_state ?))
  ?y <- (space (s_name S12) (s_floor 2) (s_state F))
=>
  (modify ?x (s_state F))
  (modify ?p (p_space S12))
  (modify ?y (s_state P))
  (printout t "platform " ?pname " moved from S02 to S12" crlf)
)

(defrule move_platform_up_to_2 "Μετακίνηση πλατφόρμας από επίπεδο 1 στο επίπεδο 2"
(declare (salience 50))
  ?x <- (space (s_name S12) (s_floor 2) (s_state P))
  ?p <- (platform (p_name ?pname) (p_space S12) (p_state ?))
  ?y <- (space (s_name S22) (s_floor 3) (s_state F))
=>
  (modify ?x (s_state F))
  (modify ?p (p_space S22))
  (modify ?y (s_state P))
  (printout t "platform " ?pname " moved from S12 to S22" crlf)
)

(defrule move_platform_down_from_2 "Μετακίνηση πλατφόρμας από επίπεδο 2 στο επίπεδο 1"
(declare (salience 50))
  ?x <- (space (s_name S22) (s_floor 3) (s_state P))
  ?p <- (platform (p_name ?pname) (p_space S22) (p_state ?))
  ?y <- (space (s_name S12) (s_floor 2) (s_state F))
=>
  (modify ?x (s_state F))
  (modify ?p (p_space S12))
  (modify ?y (s_state P))
  (printout t "platform " ?pname " moved from S22 to S12" crlf)
)

(defrule move_platform_down_from_1 "Μετακίνηση πλατφόρμας από επίπεδο 1 στο επίπεδο 0"
(declare (salience 50))
  ?x <- (space (s_name S12) (s_floor 2) (s_state P))
  ?p <- (platform (p_name ?pname) (p_space S12) (p_state ?))
  ?y <- (space (s_name S02) (s_floor 1) (s_state F))
=>
  (modify ?x (s_state F))
  (modify ?p (p_space S02))
  (modify ?y (s_state P))
  (printout t "platform " ?pname " moved from S12 to S02" crlf)
)
