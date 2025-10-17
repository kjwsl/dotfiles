;; Enable relative line numbers
(setq display-line-numbers-type 'relative)
(global-display-line-numbers-mode 1)

;; Remove menu bar
(menu-bar-mode -1)
;; Remove tool bar
(tool-bar-mode -1)

;; Enable which key
(which-key-mode 1)

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
  (evil-mode 1)
  (evil-set-leader '(normal visual) (kbd "SPC"))
  (evil-define-key '(normal visual) 'global (kbd "<leader>ww") 'save-buffer)
  (evil-define-key '(normal visual) 'global (kbd "<leader>qq") 'kill-buffer)
  (evil-define-key '(normal visual) 'global (kbd "<leader><leader>Q") 'kill-emacs)
  (evil-define-key '(normal visual) 'global (kbd "<leader>so") 'eval-buffer)
  (evil-define-key 'insert 'global (kbd "zx") 'eval-buffer)
  )

  ;; (my/leader "w w" '(save-buffer :which-key "Save buffer"))
  ;; (my/leader "q q" '(kill-buffer :which-key "Kill buffer"))
  ;; (my/leader "SPC Q" '(kill-emacs :which-key "Kill Emacs"))
  ;; (my/leader "s o" '(eval-buffer :which-key "Source Curent Buffer"))
  ;; )

;; --- Catppuccin theme ---
(use-package catppuccin-theme
  :demand t
  :init
  (setq catppuccin-flavor 'mocha)  ;; set flavor before loading
  :config
  (load-theme 'catppuccin t))


(set-face-attribute 'default nil :height 170)
