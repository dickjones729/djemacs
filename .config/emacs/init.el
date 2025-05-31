;;; package --- init.el -*- lexical-binding: t -*-
;;; Commentary:
;;; Code:

;;; Get rid of yes or no questions - y or n is enough
(defalias 'yes-or-no-p 'y-or-n-p)

;;; Setup Package manager
(require 'package)
(package-initialize)

(add-to-list 'package-archives
	     '("melpa" . "https://melpa.org/packages/"))

;;; Setup custom file or custom.el
(setq custom-file (locate-user-emacs-file "custom.el"))
(load custom-file :no-error-if-file-is-missing)

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
(setq column-number-mode t)
(setq create-lockfiles nil)
(setq make-backup-files nil)
(setq show-paren-mode t)

;; Highlight the line the cursor is on
(global-hl-line-mode 1)

(let ((mono-spaced-font "Monospace")
      (proportionately-space-font "Sans"))
  (set-face-attribute 'default nil :family mono-spaced-font :height 110)
  (set-face-attribute 'fixed-pitch nil :family mono-spaced-font :height 1.0)
  (set-face-attribute 'variable-pitch nil :family proportionately-space-font :height 1.0))

;;; delete highlighted text when pasting
(use-package delsel
  :ensure nil
  :hook (after-init . delete-selection-mode))
(delete-selection-mode 1)

;;; Modus Setup
(use-package modus-themes
  :ensure t
  :demand t
  :bind (("<f5>" . modus-themes-toggle)
         ("C-<f5>" . modus-themes-select)
         ("M-S-<f5>" . modus-themes-rotate))
  :config
  (setq modus-themes-custom-auto-reload nil
        modus-themes-to-toggle '(modus-operandi modus-vivendi)
        modus-themes-to-rotate modus-themes-items
        modus-themes-mixed-fonts t
        modus-themes-variable-pitch-ui t
        modus-themes-italic-constructs t
        modus-themes-bold-constructs t
        modus-themes-completions '((t . (bold)))
        modus-themes-prompts '(bold)
        modus-themes-headings
        '((agenda-structure . (variable-pitch light 2.2))
          (agenda-date . (variable-pitch regular 1.3))
          (t . (regular 1.15))
          (0 . (variable-pitch 2.0))
          (1 . (variable-pitch 1.5))
          (2 . (variable-pitch 1.30))
          (3 . (variable-pitch 1.1))
          (4 . (variable-pitch 1.0))
          (5 . (variable-pitch 0.95))
          (6 . (variable-pitch 0.9))
          (7 . (variable-pitch 0.85))
          (8 . (variable-pitch 0.8))))
  (setq modus-themes-common-palette-overrides
	'((bg-mode-line-active bg-lavender)
	  (fg-mode-line-active fg-main)
	  (border-mode-line-active bg-mode-line-active)
          (border-mode-line-inactive bg-mode-line-inactive)
          (border-mode-line-active bg-magenta-intense))))
(load-theme 'modus-vivendi :no-confirm)

;;; Find file config
;;;; When you first call `find-file' (C-x C-f by default), you do not
;;;; need to clear the existing file path before adding the new one.
;;;; Just start typing the whole path and Emacs will "shadow" the
;;;; current one.  For example, you are at ~/Documents/notes/file.txt
;;;; and you want to go to ~/.emacs.d/init.el: type the latter directly
;;;; and Emacs will take you there.
(file-name-shadow-mode 1)

;;; Compile key settings
;; Bind f6 to the compile command
(global-set-key [f6] 'compile)
;;; Compilation output settings
;; Set compilation buffer to scroll until the first compile error
(setq compilation-scroll-output 'first-error)
;; Set the compilation buffer to not stop at warnings
;;
;;   Compilation motion commands skip less important messages. The
;;   value can be either
;;   2 -- skip anything less than error
;;   1 -- skip anything less than warning or
;;   0 -- don't skip any messages
;;   Not that all messages not positively identified as warning or
;;   info, are considered errors.
;;
(setq compilation-skip-threshold 2)
;; Use the ansi-color package to compile output with proper colors and
;; without the ^[ characters
(use-package ansi-color
  :config
  (defun my-colorize-compilation-buffer ()
    (when (eq major-mode 'compilation-mode)
      (ansi-color-apply-on-region compilation-filter-start (point-max))))
  :hook (compilation-filter . my-colorize-compilation-buffer))

;; ibuffers-vc sets pu ibuffers groups by git repos
(use-package ibuffer-vc
  :ensure t
  :after (ibuffer vc)
  :bind (:map ibuffer-mode-map
	      ("/ V" . ibuffer-vc-set-filter-groups-by-vc-root)))

;;; EGLOT Setup
(require 'eglot)
(add-to-list 'eglot-server-programs '((c++-mode c-mode) "clangd"))
(add-hook 'c-mode-hook 'eglot-ensure)
(add-hook 'c++-mode-hook 'eglot-ensure)

;; Attempts to get c++ modes to indent four spaces
(setq-default indent-tabs-mode nil)
(setq-default c-basic-offset 4)

;;; Delete trailing whitespace on save
(add-hook 'before-save-hook
	  (lambda ()
	    (unless (eq major-mode 'fundamental-mode)
	      (delete-trailing-whitespace))))

;; Yasnippets setup
;; (require 'yasnippet)
;; (yas-global-mode)

;;; Vertico Setup
;; Install the `vertico' package to get a vertical view of the
;; minibuffer.  Vertico is optimised for performance and is also
;; highly configurable.  Here is my minimal setup:
(use-package vertico
  :ensure t
  :init
  (setq vertico-resize nil)
  (vertico-mode 1))

;;; Marginalia Setup
;; Install the `marginalia' package.  This will display useful
;; annotations next to entries in the minibuffer.  For example, when
;; using M-x it will show a brief description of the command as well
;; as the keybinding associated with it (if any).
;;; Detailed completion annotations (marginalia.el)
(use-package marginalia
  :ensure t
  :hook (after-init . marginalia-mode)
  :config
  (setq marginalia-max-relative-age 0)) ; absolute time

;; This works with `file-name-shadow-mode' enabled.  When you are in a
;; sub-directory and use, say, `find-file' to go to your home '~/' or
;; root '/' directory, Vertico will clear the old path to keep only
;; your current input.
(add-hook 'rfn-eshadow-update-overlay-hook #'vertico-directory-tidy)

;; Remember to do M-x and run `nerd-icons-install-fonts' to get the
;; font files.  Then restart Emacs to see the effect.
(use-package nerd-icons
  :ensure t)

(use-package nerd-icons-completion
  :ensure t
  :after marginalia
  :config
  (add-hook 'marginalia-mode-hook #'nerd-icons-completion-marginalia-setup))

(use-package nerd-icons-corfu
  :ensure t
  :after corfu
  :config
  (add-to-list 'corfu-margin-formatters #'nerd-icons-corfu-formatter))

(use-package nerd-icons-dired
  :ensure t
  :hook
  (dired-mode . nerd-icons-dired-mode))

;; When there are two Dired buffers side-by-side make Emacs
;; automatically suggest the other buffer as the target of copy or
;; rename operations.  Remember that you can always use M-p and M-n in
;; the minibuffer to cycle through the history, regardless of what
;; this does.  (The "dwim" stands for "Do What I Mean".)
(setq dired-dwim-target t)

;;; Dired Setup to elide details
;; Automatically hide the detailed listing when visiting a Dired
;; buffer.  This can always be toggled on/off by calling the
;; `dired-hide-details-mode' interactively with M-x or its keybindings
;; (the left parenthesis by default).
 (add-hook 'dired-mode-hook #'dired-hide-details-mode)

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

;;; Unfill
(use-package unfill
  :ensure t)

;;; This stops a warning at the bottom of this file
(provide 'init)
;;; init.el ends here
