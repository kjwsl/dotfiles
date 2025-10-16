;; Set up package.el to work with MELPA  -*- lexical-binding: t; -*-
(require 'package)
(add-to-list 'package-archives
             '("melpa" . "https://melpa.org/packages/"))
(package-initialize)

(unless package-archive-contents
  (package-refresh-contents))

(unless (package-installed-p 'use-package)
  (package-install 'use-package))

;; Load use-package and set defaults
(require 'use-package)
(setq use-package-always-ensure t)   ;; automatically install missing packages
(setq use-package-always-defer t)    ;; lazy-load by default

(use-package magit
  :bind (("C-x g" . magit-status))
  :config
  (setq magit-display-buffer-function
        #'magit-display-buffer-fullframe-status-v1))

(use-package evil
  :demand t
  :init
  (setq evil-want-C-u-scroll t)
  :config
  (evil-mode 1))

;; --- Catppuccin theme ---
(use-package catppuccin-theme
  :demand t
  :init
  (setq catppuccin-flavor 'mocha)  ;; set flavor before loading
  :config
  (load-theme 'catppuccin t))
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages nil))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
