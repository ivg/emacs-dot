(defvar dot-command "dot -Tpng" 
  "command to run on a dot representation")

(defun pread (start end command)
  "runs COMMAND on a region specified by START and END and returns 
   the result of command invokation as a string"
  (string-as-unibyte
   (with-output-to-string
     (shell-command-on-region start end command standard-output))))

(defun dot-insert-image (data)
  (insert-image (create-image data nil t)))


(defun dot-display (start end)
  "insert a picture of a graph, specified in a provided region"
  (interactive "r")
  (let ((data (pread start end dot-command)))
    (dot-insert-image data)))

(defun dot-ocaml-toplevel-autoinsert (text)
  (let ((beg (string-match "digraph" text))
        (end (string-match "}" text)))
    (when (and beg end)
      (let* ((input (substring text beg (1+ end)))
             (command (format "echo '%s' | %s" input dot-command))
             (data (shell-command-to-string command))
             (pos (point)))
        (search-backward "#")
        (dot-insert-image (string-as-unibyte data))
        (goto-char pos)
        (insert "\n#")))))

(add-hook 'comint-output-filter-functions 'dot-ocaml-toplevel-autoinsert)

(defun dot-display-at-point-backward ()
  "search backward for an occurence of a dot specification and display it"
  (interactive)
  (let ((pos (point))
        (end (search-backward "}"))
        (beg (search-backward "digraph")))
    (goto-char pos)
    (dot-display beg (1+ end))))

(provide 'dot)
