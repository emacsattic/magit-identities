;;; magit-identities.el --- Use several identities in magit.

;; Copyright © 2012 Sébastien Gross <seb•ɑƬ•chezwam•ɖɵʈ•org>

;; Author: Sébastien Gross <seb•ɑƬ•chezwam•ɖɵʈ•org>
;; Keywords: emacs, 
;; Created: 2012-08-30
;; Last changed: 2012-08-31 10:36:28
;; Licence: WTFPL, grab your copy here: http://sam.zoy.org/wtfpl/

;; This file is NOT part of GNU Emacs.

;;; Commentary:
;; 
;; Configure identities for `magit' such as `gnus-identities`.
;;


;;; Code:


(require 'magit)
(require 'cl)

(provide 'magit-identities)

(defcustom magit-identities-alist nil
  "List of all identities. Each item is a list of:

\(identity
  regexp
  \(list of fields\)\)

IDENTITY is a unique symbol defining the identity.

The remote repository location (see
`magit-identities-get-repo-string') is match against REGEXP.

LIST OF FIELD is a list suitable cells for
`magit-log-edit-set-fields': (field-symbol . \"content\")

Order matters: first matched identity is used.")

(defun magit-identities-get-repo-string ()
  "Return a the repository string using following format:

   remote-branch@remote::remote-url"
  (let* ((branch (magit-get-current-branch))
	 (remote (and branch (magit-get "branch" branch "remote")))
	 (remote-branch (or (and branch (magit-remote-branch-for branch)) branch))
	 (remote-url (and remote (magit-get "remote" remote "url"))))
    (format "%s@%s::%s" remote-branch remote remote-url)))

(defun magit-identities-get-id (repository)
  "Give REPOSITORY return a matching id from
`magit-identities-alist'."
  (loop for p in magit-identities-alist
	when (string-match (cadr p) repository)
	return (caddr p)))

;;;###autoload
(defun magit-identities-set-id()
  "Set default identity for current checkout."
  (magit-log-edit-set-fields
   (magit-identities-get-id
    (magit-identities-get-repo-string))))

(add-hook 'magit-log-edit-mode-hook 'magit-identities-set-id)

;; magit-identities.el ends here
