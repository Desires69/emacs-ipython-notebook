(eval-when-compile (require 'cl))
(require 'ert)
(require 'ob-ein)


;; Test utils

;;; This is the content portion of a response fromt he content API.
(defvar eintest:ob-src-block
  "#+BEGIN_SRC ein :session 8888/Untitled.ipynb
import sys

a = 14500
b = a+1000
sys.version
#+END_SRC
")

(ert-deftest ein:ob-aware ()
  (let ((org-babel-load-languages (quote ((ipython . t) (ein . t)))))
    (with-temp-buffer
      (save-excursion
        (org-mode)
        (insert eintest:ob-src-block)
        (search-backward "SRC")
        (cl-letf (((symbol-function 'ein:org-find-or-open-session) (lambda (&rest args) (make-ein:$notebook))))
          (setq python-indent-guess-indent-offset-verbose nil)
          (should (call-interactively #'org-edit-special)))))))
