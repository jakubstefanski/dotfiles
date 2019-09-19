;; -------
;; Memory
;; -------

(setq gc-cons-threshold 50000000)
(setq large-file-warning-threshold 100000000)

;; ---------
;; Packages
;; ---------

(require 'package)
(setq package-enable-at-startup nil)
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/"))
(add-to-list 'package-archives '("gnu" . "http://elpa.gnu.org/packages/"))
(package-initialize)

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(eval-when-compile
  (require 'use-package))

;; ------------
;; Basic setup
;; ------------

(prefer-coding-system 'utf-8)
(set-default-coding-systems 'utf-8)
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)

;; --------
;; Backups
;; --------
(setq make-backup-files nil)
(setq auto-save-default nil)
(setq create-lockfiles nil)

;; -------------
;; Visual setup
;; -------------

(menu-bar-mode -1)
(toggle-scroll-bar -1)
(tool-bar-mode -1)

(line-number-mode t)
(column-number-mode t)
(size-indication-mode t)

(setq inhibit-startup-screen t)

(setq frame-title-format
      '((:eval (if (buffer-file-name)
       (abbreviate-file-name (buffer-file-name))
       "%b"))))

;; ------------
;; Convenience
;; ------------
(global-set-key (kbd "C-x k") 'kill-this-buffer)
(fset 'yes-or-no-p 'y-or-n-p)

;; -----------
;; Extensions
;; -----------

(use-package evil
  :ensure t
  :config
  (evil-mode))
