;; ----------------------------------------------------------------
;;                   ΒΕΛΑΣΚΟ ΠΑΟΛΑ      cs161020
;;                   ΜΙΧΑ ΕΥΑΓΓΕΛΙΑ 	cs171102
;; ----------------------------------------------------------------
;;              Τμήμα Μηχανικών Πληροφορικής και Υπολογιστών
;;           Εργαστήριο ΤΝ 2020 - Εργασία 2: Έμπειρα Συστήματα
;;                  Το πρόβλημα του πάρκινγκ - 1ο Μέρος 
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
    (slot c_plate (type INTEGER))
    (slot c_state (type SYMBOL))
)


;; ----------------------------------------------------------------
;;                        Αρχικά Γεγονότα
;; ----------------------------------------------------------------

(deffacts spaces
    (space (s_name S01) (s_floor 1) (s_state P))
    (space (s_name S02) (s_floor 1) (s_state F))
    (space (s_name S03) (s_floor 1) (s_state P))
    (space (s_name S04) (s_floor 1) (s_state P))
    (space (s_name S05) (s_floor 1) (s_state P))
    (space (s_name S06) (s_floor 1) (s_state P))
)

(deffacts platforms
    (platform (p_name P1) (p_space S01) (p_state empty))
    (platform (p_name P2) (p_space S03) (p_state empty))
    (platform (p_name P3) (p_space S04) (p_state empty))
    (platform (p_name P4) (p_space S05) (p_state empty))
    (platform (p_name P5) (p_space S06) (p_state empty))
)

(deffacts neighbours
    (east S01 S02)
    (east S02 S03)
    (east S04 S05)
    (east S05 S06)
    (north S01 S04)
    (north S02 S05)
    (north S03 S06)
)

(deffacts cars
    (car (c_plate 101) (c_state waiting))
    (car (c_plate 102) (c_state waiting))
    (car (c_plate 103) (c_state waiting))
    (car (c_plate 104) (c_state waiting))
    (car (c_plate 105) (c_state waiting))
)

(deffacts initial
    (capacity 5)
)

;; ----------------------------------------------------------------
;;                            Κανόνες
;; ----------------------------------------------------------------

(defrule begin "Αρχικοποίηση στρατηγικής και έναρξης προγράμματος"
    (declare (salience 100))    
    (initial-fact) 
=>    
;; Ανάθεση στρατηγικής "random" 
    (set-strategy random)    
;;  (set-strategy depth)
;;  (set-strategy breadth)
;;  (set-strategy simplicity)
;;  (set-strategy complexity)

    (printout t "Parking Begins !" crlf crlf) 
) 


(defrule check_capacity "Έλεγχος αυτοκινήτων και διαθέσιμων πλατφορμών"
(declare (salience 99))
    ?x <- (car (c_plate ?) (c_state ?))
    (capacity ?cap)
    (test (> (length (find-all-facts ((?c car)) (eq ?c:c_state waiting) ) ) ?cap ) )
=>    
    (printout t "More cars than spaces!" crlf)
    (halt)
)


(defrule enter_parking  "Είσοδος αυτοκινήτου"
(declare (salience 98))
    ?x <- (car (c_plate ?plate) (c_state waiting))
    ?y <- (platform (p_name ?pname) (p_space S02) (p_state empty))
=>
    (modify ?x (c_state ?pname))
    (modify ?y (p_state full))

    (printout t "Car with plate: " ?plate " parked on platform " ?pname crlf)
)


(defrule goal "Τερματισμός προγράμματος - Εύρεση λύσης"
    (declare (salience 100))
    (not (car (c_plate ?) (c_state waiting)) )
=>

    (printout t "Parking is full" crlf)
    (halt)
)


(defrule move_platform_east "Μετακίνηση πλατφόρμας δεξιά"
(declare (salience 50))
    (east ?s ?s_right)
    ?x <- (space (s_name ?s) (s_floor ?) (s_state P)) 
    ?y <- (space (s_name ?s_right) (s_floor ?) (s_state F))
    ?z <- (platform (p_name ?pname) (p_space ?s) (p_state ?)
) 
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
    ?z <- (platform (p_name ?pname) (p_space ?s) (p_state ?)
) 
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
