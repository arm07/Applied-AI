

;;/////////////////////*******************/////////////////////
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Question and answer templates

(deftemplate question 
    "A question the application may ask" 
    (slot text)       ;; The question itself 
    (slot type)       ;; Can be multi, text, or numeric 
    (multislot valid) ;; The allowed answers for type multi
    (slot ident))     ;; The "name" of the question 

(deftemplate answer
  (slot ident)
  (slot text))

(do-backward-chaining answer)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defmodule trigger) 

(defrule trigger::supply-answers 
    (declare (auto-focus TRUE)) 
    (MAIN::need-answer (ident ?id)) 
    (not (MAIN::answer (ident ?id))) 
    (not (MAIN::ask ?)) 
    => 
    (assert (MAIN::ask ?id))
    (return))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; domain rules

(defrule MAIN::smartphone-os 
    (declare (auto-focus TRUE)) 
    (explicit (answer (ident smartphone-type) (text ~ios))) ;; change the text to ios/android/other as you select an option in check-box
    => 
    (recommend-action "consult a smartphone technician") 
    (halt)) 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; power,display, audio, battery and memory rules

(defrule MAIN::not-plugged-in 
    (declare (auto-focus TRUE)) 
    (answer (ident display) (text no)) 
    (answer (ident plugged-in) (text no)) 
    => 
    (recommend-action "plug in the smartphone") 
    (halt)) 

(defrule MAIN::battery-drained 
    (declare (auto-focus TRUE)) 
    (answer (ident display) (text no)) 
    (answer (ident plugged-in) (text yes)) 
    => 
    (recommend-action "repair or replace battery") 
    (halt)) 


(defrule MAIN::sudden-display-loss 
    (declare (auto-focus TRUE)) 
    (answer (ident display) (text yes)) 
    (answer (ident seek) (text yes)) 
    (answer (ident does-blur) (text yes)) 
    => 
    (recommend-action "consider switching-off the smart phone for some time") 
    (halt)) 

(defrule MAIN::tiny-motherboard 
    (declare (auto-focus TRUE)) 
    (answer (ident display) (text yes)) 
    (answer (ident seek) (text no)) 
    (answer (ident does-blur) (text yes)) 
    (answer (ident how-many-blurs) (text ?t)) 
    (test (>= (integer ?t) 3)) 
    => 
    (recommend-action "consult a smartphone-technician to replace tiny-motherboard") 
    (halt)) 

(defrule MAIN::no-restart 
    (declare (auto-focus TRUE)) 
    (answer (ident display) (text yes)) 
    (answer (ident seek) (text yes)) 
    (answer (ident restarts) (text no)) 
    => 
    (recommend-action  "repair RAM or processor or tiny-motherboard,/ if none works mostly the battery") 
    (halt)) 
	
(defrule MAIN::switch-on 
    (declare (auto-focus TRUE)) 
    (answer (ident display) (text yes)) 
    (answer (ident seek) (text no)) 
    (answer (ident restarts) (text yes)) 
	(answer (ident power-button) (text yes))
	(answer (ident camera) (text yes))
    (answer (ident shortcut) (text yes))
	(answer (ident slow) (text no))
    => 
    (recommend-action "Your Phone is absolutely fine")
    (halt)) 

(defrule MAIN::available-storage
    (declare (auto-focus TRUE)) 
    (check available-storage) 
    (answer (ident available-storage) (text yes)) 
    => 
    (recommend-action "delete and oragnise available memory ") 
    (halt)) 

(defrule MAIN::faulty-storage 
    (declare (auto-focus TRUE)) 
    (check available-storage) 
    (answer (ident available-storage) (text no))
	(answer (ident slow) (text yes))
	
    => 
    (recommend-action "delete app data that is causing problems  and retest") 
    (halt))
	
	
	
(defrule MAIN::faulty-power-button 
    (declare (auto-focus TRUE))
    (answer (ident restarts) (text no))	
    (answer (ident power-button) (text no)) 
    => 
    (recommend-action "replace power-button and it starts working") 
    (halt)) 
	
(defrule MAIN::broken-display 
    (declare (auto-focus TRUE)) 
    (answer (ident display) (text yes)) 
	(answer (ident plugged-in) (text yes))
	(answer (ident does-blur) (text yes))
	(answer (ident broken-glass) (text yes))
    => 
    (recommend-action "consult a smartphone-technician and replace your display screen") 
    (halt))
	
(defrule MAIN::speaker-problem 
    (declare (auto-focus TRUE)) 
    (answer (ident display) (text yes)) 
    (answer (ident audio-loss) (text no)) 
    => 
    (recommend-action "consult a smartphone technician and replace speakers")
    (halt)) 
	
(defrule MAIN::headphone-problem 
    (declare (auto-focus TRUE)) 
    (answer (ident display) (text yes)) 
    (answer (ident audio-loss) (text yes)) 
	(answer (ident headphones) (text no))
    => 
    (recommend-action "consider  replacing  your headphones")
    (halt)) 
(defrule MAIN::network-problem 
    (declare (auto-focus TRUE)) 
    (answer (ident display) (text yes)) 
    (answer (ident restarts) (text yes)) 
	(answer (ident network-issue) (text yes))
    => 
    (recommend-action "consider  removing your sim and restart")
    (halt)) 
(defrule MAIN::camera-problem 
    (declare (auto-focus TRUE)) 
    (answer (ident display) (text yes)) 
    (answer (ident restarts) (text yes)) 
	(answer (ident camera) (text yes))
	(answer (ident switch-off) (text yes))
    => 
    (recommend-action "consider  replacing  your  battery ")
    (halt))			
(defrule MAIN::shortcut-menu-problem 
    (declare (auto-focus TRUE)) 
    (answer (ident display) (text yes)) 
	(answer (ident shortcut) (text no))
    => 
    (recommend-action "consider  switching-off  your  smartphone and restarting it ")
    (halt))			
(defrule MAIN::software-update-problem 
    (declare (auto-focus TRUE)) 
    (answer (ident display) (text yes)) 
	(answer (ident seek) (text yes))
	(answer (ident slow) (text yes))
	(answer (ident available-storage) (text yes))
    => 
    (recommend-action "consider  deleting few apps and install/update your  smartphone os and restarting it ")
    (halt))			


 
	///////////////////*************************/////////////////////////////////

;; Defines Swing Layout
	
(import javax.swing.*)
(import java.awt.*)
(import java.awt.event.*)
(import java.awt.Color)

;; Don't clear defglobals on (reset)
(set-reset-globals FALSE)

(defglobal ?*crlf* = "
")

(defglobal ?*jframe* = (new JFrame "SMARTPHONE FIX"))
(?*jframe* setSize 640 320)
(?*jframe* setVisible TRUE)
;;(?*jframe* setColor (Color.blue))
;;(?*jframe* setBorder TitledBorder)
;;(?*jframe* setFont SANS_SERIF)



;; Question field

(defglobal ?*textfield* = (new JTextArea 5 40))
(bind ?scroll (new JScrollPane ?*textfield*))
((?*jframe* getContentPane) add ?scroll)
(?*textfield* setText "Answer the questions...")
(?*jframe* repaint)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Answer Area fields declarations

(defglobal ?*jpanelV* = (new JPanel))
(defglobal ?*jfieldV* = (new JTextField 40))
(defglobal ?*jfield-okV* = (new JButton OK))

(defglobal ?*jcomboV* = (new JComboBox (create$ "yes" "no")))
(defglobal ?*jcombo-okV* = (new JButton OK))

(?*jpanelV* add ?*jfieldV*)
(?*jpanelV* add ?*jfield-okV*)
((?*jframe* getContentPane) add ?*jpanelV* (get-member BorderLayout SOUTH))
(?*jframe* validate)
(?*jframe* repaint)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Results output

(deffunction recommend-action (?action)
  "Give final instructions to the user"
  (call JOptionPane showMessageDialog ?*jframe*
        (str-cat "I suggest you " ?action)
        "Recommendation"
        (get-member JOptionPane INFORMATION_MESSAGE)))
  
(defadvice before halt (?*textfield* setText "Close window to exit the application"))

;; Module ask

(defmodule ask)

(deffunction ask-user (?question ?type ?valid)
  "Set up the GUI to ask a question"
  (?*textfield* setText ?question)
  (?*jpanelV* removeAll)
  (if (eq ?type multi) then
    (?*jpanelV* add ?*jcomboV*)
    (?*jpanelV* add ?*jcombo-okV*)
    (?*jcomboV* removeAllItems)
    (foreach ?item ?valid
             (?*jcomboV* addItem ?item))
    else
    (?*jpanelV* add ?*jfieldV*)
    (?*jpanelV* add ?*jfield-okV*)
    (?*jfieldV* setText ""))
  (?*jpanelV* validate)
  (?*jpanelV* repaint))

(deffunction is-of-type (?answer ?type ?valid)
  "Check that the answer has the right form"
  (if (eq ?type multi) then
    (foreach ?item ?valid
             (if (eq (sym-cat ?answer) (sym-cat ?item)) then
               (return TRUE)))
    (return FALSE))
    
  (if (eq ?type number) then
    (return (is-a-number ?answer)))
    
  ;; plain text
  (return (> (str-length ?answer) 0)))

(deffunction is-a-number (?value)
  (try
   (integer ?value)
   (return TRUE)
   catch 
   (return FALSE)))

(defrule ask::ask-question-by-id
  "Given the identifier of a question, ask it"
  (declare (auto-focus TRUE))
  (MAIN::question (ident ?id) (text ?text) (valid $?valid) (type ?type))
  (not (MAIN::answer (ident ?id)))
  (MAIN::ask ?id)
  =>
  (ask-user ?text ?type ?valid)
  ((engine) waitForActivations))

(defrule ask::collect-user-input
  "Check an answer returned from the GUI, and optionally return it"
  (declare (auto-focus TRUE))
  (MAIN::question (ident ?id) (text ?text) (type ?type) (valid $?valid))
  (not (MAIN::answer (ident ?id)))
  ?user <- (user-input ?input)
  ?ask <- (MAIN::ask ?id)
  =>
  (if (is-of-type ?input ?type ?valid) then
    (retract ?ask ?user)
    (assert (MAIN::answer (ident ?id) (text ?input)))
    (return)
    else
    (retract ?ask ?user)
    (assert (MAIN::ask ?id))))
	
;; Answer area Event Handling

(deffunction read-input (?EVENT)
  "An event handler for the user input field"
  (assert (ask::user-input (sym-cat (?*jfieldV* getText)))))

(bind ?handler (new jess.awt.ActionListener read-input (engine)))
(?*jfieldV* addActionListener ?handler)
(?*jfield-okV* addActionListener ?handler)

(deffunction combo-input (?EVENT)
  "An event handler for the combo box"
  (assert (ask::user-input (sym-cat (?*jcomboV* getSelectedItem)))))

(bind ?handler (new jess.awt.ActionListener combo-input (engine)))
(?*jcombo-okV* addActionListener ?handler)

;; Questions Asked for identifying the problem

 (deffacts MAIN::question-data 
    (question (ident smartphone-type) 
      (type multi) (valid ios ) 
      (text "Select the os of smartphone...")) 
    (question 
      (ident display) (type multi) (valid yes no) 
      (text "Does the smartphone show any display?")) 
    (question 
      (ident plugged-in) (type multi) (valid yes no) 
      (text "Is the smartphone plugged in?")) 
    (question 
      (ident seek) (type multi) (valid yes no) 
      (text "Does the screen show \"blurring\" displays?")) 
    (question 
      (ident does-blur) (type multi) (valid yes no) 
      (text "Does the phone blur frequently?")) 
    (question 
      (ident how-many-blurs) (type number) (valid) 
      (text "How many times does it blur within a hour?")) 
    (question 
      (ident available-storage) (type multi) (valid yes no) 
      (text "Is the storage full?")) 
    (question 
      (ident restarts) (type multi) (valid yes no) 
      (text "Does the smartphone begin to restart immediately?"))
	  
	(question 
      (ident power-button) (type multi) (valid yes no) 
      (text "Does the smartphone power-button work?"))
	 (question 
      (ident audio-loss) (type multi) (valid yes no) 
     (text "Does the smartphone audio play outside?"))
    (question 
      (ident headphones) (type multi) (valid yes no) 
     (text "Does the smartphone headphones play sound?"))	 
	 
	 (question 
      (ident network-issue) (type multi) (valid yes no) 
      (text "Does the smartphone display no service?"))
	 (question 
      (ident camera) (type multi) (valid yes no) 
      (text "Is the smartphone camera working?"))
	 (question 
      (ident switch-off) (type multi) (valid yes no) 
      (text "Does the smartphone switch-off suddenly?"))
	  (question 
      (ident broken-glass) (type multi) (valid yes no) 
      (text "Is the smartphone display glass broken?"))
	 (question 
      (ident shortcut) (type multi) (valid yes no) 
      (text "Does the smartphone display shortcut-menu drop down(in iphone) ?"))
	  (question 
      (ident slow) (type multi) (valid yes no) 
      (text "Is the smartphone speed decreased in opening new apps?")) 
    (MAIN::ask smartphone-type) ) 

(deffunction recommend-action (?action) 
    "Give final instructions to the user" 
    (printout t "I suggest that you " ?action crlf)) 

  
(reset)
(run-until-halt)

