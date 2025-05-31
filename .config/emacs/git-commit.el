;;; package --- git-commit.el -*- lexical-binding: t -*-
;;; Commentary:
;;; Code:

;;; Get rid of yes or no questions - y or n is enough
(defalias 'yes-or-no-p 'y-or-n-p)

;; Those three belong in the early-init.el, but I am putting them here
;; for convenience.  If the early-init.el exists in the same directory
;; as the init.el, then Emacs will read+evaluate it before moving to
;; the init.el.
(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)

(setq inhibit-startup-screen t)
(setq initial-scratch-message nil)
(setq auto-save-default nil)
(setq blink-cursor-mode nil)
(setq delete-selection-mode t)
(setq column-number-mode t)
(setq create-lockfiles nil)
(setq make-backup-files nil)
(setq show-paren-mode t)

;;; delete highlighted text when pasting
(use-package delsel
  :ensure nil
  :hook (after-init . delete-selection-mode))
(delete-selection-mode 1)

;;; Delete trailing whitespace on save
(add-hook 'before-save-hook
	  (lambda ()
	    (unless (eq major-mode 'fundamental-mode)
	      (delete-trailing-whitespace))))

;;; Toggle whitespace viewing
(defun dj/toggle-whitespace ()
  "Toggle the display of indentation and space characters."
  (interactive)
  (if (bound-and-true-p whitespace-mode)
      (whitespace-mode -1)
    (whitespace-mode)))

;;; Toggle line numbers
(defun dj/toggle-line-numbers ()
  "Toggle the display of line numbers.  Apply to all buffers."
  (interactive)
  (if (bound-and-true-p display-line-numbers-mode)
      (global-display-line-numbers-mode -1)
    (global-display-line-numbers-mode)))

;;; ediff setup
(setq ediff-split-window-function 'split-window-horizontally)
(setq ediff-window-setup-function 'ediff-setup-windows-plain)

;;; This stops a warning at the bottom of this file
(provide 'git-commit)
;;; git-commit.el ends here
