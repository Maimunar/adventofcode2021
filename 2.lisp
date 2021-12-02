; Part 1

(setq depth 0)
(setq forward 0)

(setq direction 0)
; 1 - Forward
; 2 - Down
; 3 - Up

(loop for line = (read nil nil :eof)
    until (eq line :eof)
    do         
    (if (string-equal (write-to-string line) "FORWARD") 
        (setq direction 1)
    )
    (if (string-equal (write-to-string line) "DOWN") 
        (setq direction 2)
    )
    (if (string-equal (write-to-string line) "UP") 
        (setq direction 3)
    )
    (if (numberp line)
        (cond
            ((= direction 1)  (setq forward (+ forward line)))
            ((= direction 2)  (setq depth (+ depth line)))
            ((= direction 3)  (setq depth (- depth line)))
        )
    )        
)

(print (* depth forward))


; Part 2

(setq depth 0)
(setq forward 0)
(setq aim 0)

(setq direction 0)
; 1 - Forward
; 2 - Down
; 3 - Up

(loop for line = (read nil nil :eof)
    until (eq line :eof)
    do         
    (if (string-equal (write-to-string line) "FORWARD") 
        (setq direction 1)
    )
    (if (string-equal (write-to-string line) "DOWN") 
        (setq direction 2)
    )
    (if (string-equal (write-to-string line) "UP") 
        (setq direction 3)
    )
    (if (numberp line)
        (cond
            ((= direction 1)  
                (setq forward (+ forward line)) 
                (setq depth (+ depth (* aim line))) 
            )
            ((= direction 2)  (setq aim (+ aim line)))
            ((= direction 3)  (setq aim (- aim line)))
        )
    )        
)

(print (* depth forward))

