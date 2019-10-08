;;; init.el --- Initialization file for Emacs
;;; Commentary:
;;; Code:

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

(if (window-system)
    (progn (set-frame-font "DejaVu Sans Mono")
           (set-face-attribute 'default nil :height 105)))

;; ------------
;; Parenthesis
;; ------------

(show-paren-mode t)
(defvar show-paren-delay 0)
(defvar blink-matching-paren nil)
(defvar show-paren-style 'parenthesis)

;; ------------
;; Convenience
;; ------------

(global-set-key (kbd "C-x k") 'kill-this-buffer)
(fset 'yes-or-no-p 'y-or-n-p)

(defun toggle-term ()
  "Toggle between terminal and current buffer."
  (interactive)
  (if (string= (buffer-name) "*ansi-term*")
      (switch-to-buffer (other-buffer (current-buffer)))
    (if (get-buffer "*ansi-term*")
        (switch-to-buffer "*ansi-term*")
      (progn (ansi-term (getenv "SHELL"))
             (setq show-trailing-whitespace nil)))))

(global-set-key (kbd  "C-`") 'toggle-term)

;; -----------
;; Extensions
;; -----------

(use-package spacemacs-theme
  :ensure t
  :defer t
  :init (load-theme 'spacemacs-light t))

(use-package evil-leader
  :ensure t
  :defer t
  :commands (evil-leader/set-leader)
  :config
  (global-evil-leader-mode)
  (evil-leader/set-leader "<SPC>"))

(use-package evil-magit
  :ensure t
  :defer t)

(use-package evil-numbers
  :ensure t
  :defer t
  :init
  (global-set-key (kbd "C-c +") 'evil-numbers/inc-at-pt)
  (global-set-key (kbd "C-c -") 'evil-numbers/dec-at-pt))

(use-package evil
  :ensure t
  :init
  (setq evil-want-C-u-scroll t)
  :config
  (evil-mode 1)
  (evil-leader/set-key
    "gs" 'magit-status))

(use-package smart-mode-line
  :ensure t
  :config
  (setq sml/no-confirm-load-theme t)
  (sml/setup))

(use-package company
  :ensure t
  :defer t
  :init (global-company-mode))

(use-package flycheck
  :ensure t
  :defer t
  :init (global-flycheck-mode))

(use-package ivy
  :ensure t
  :config
  (ivy-mode 1))

(use-package counsel
  :ensure t
  :bind (("M-x" . counsel-M-x)
         ("C-x C-f" . counsel-find-file)))

(use-package swiper
  :ensure t
  :bind (("C-s" . swiper-isearch)
         ("C-r" . swiper-isearch-backward)))

;; --------------
;; Autogenerated
;; --------------

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   (quote
    (evil-leader evil-magit spacemacs-theme smart-mode-line flycheck swiper counsel ivy evil use-package))))

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(show-paren-match ((t (:underline nil)))))

(provide 'init.el)
;;; init.el ends here
