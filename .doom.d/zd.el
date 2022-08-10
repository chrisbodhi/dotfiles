;;; zd --- utils for working with zetteldeft

;;; Commentary:

;;; For my personal workflow, using zetteldeft, as it evolves
;;; zd/today-count:

;;; Code:

(require 'seq)

(defun zd/today-count ()
  "Return the number of notes created today. Depends on notes saved with the format YEAR-MONTH-DAY."
  (interactive)
  (defun get-today ()
    (format-time-string "%Y-%m-%d"))
  (defun get-today-files (day)
    (seq-filter
     (lambda (f) (string-match-p (regexp-quote day) f))
     (directory-files deft-directory)))
  (message "It's %s; you've written %d notes so far." (get-today) (length (get-today-files (get-today)))))

(provide 'zd)
;;; zd ends here
