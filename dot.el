(defvar dot-command "dot -Tpng" 
  "command to run on a dot representation")

(defun shell-to-string (start end command)
  (with-output-to-string
    (shell-command-on-region start end command standard-output)))

(defun dot-display (start end)
  "insert a picture of a graph, specified in 
   a provided region"
  (interactive "r")
  (insert-image
   (create-image
    (string-as-unibyte
     (shell-to-string start end dot-command)) nil t)))

(defun dot-display-at-point-backward ()
  "search backward for an occurence of a dot specification and display it"
  (interactive)
  (let ((pos (point))
        (end (search-backward "}"))
        (beg (search-backward "digraph")))
    (goto-char pos)
    (dot-display beg (1+ end))))

(provide 'dot)
