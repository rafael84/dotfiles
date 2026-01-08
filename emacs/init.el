;;; init.el --- Minimal Emacs Configuration for Clojure Development -*- lexical-binding: t -*-

;; Author: Rafael Lopes
;; Description: A clean, focused Emacs configuration for Clojure development

;;; Commentary:
;; This configuration replaces Spacemacs with a minimal, modern setup
;; focused on Clojure development using CIDER, LSP, and Evil mode.

;;; Code:

;;==============================================================================
;; Package Management Setup
;;==============================================================================

(require 'package)

;; Add package archives
(setq package-archives
      '(("melpa" . "https://melpa.org/packages/")
        ("gnu" . "https://elpa.gnu.org/packages/")
        ("nongnu" . "https://elpa.nongnu.org/nongnu/")))

(package-initialize)

;; Bootstrap use-package
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(require 'use-package)
(setq use-package-always-ensure t)

;;==============================================================================
;; Performance Optimizations
;;==============================================================================

;; Increase garbage collection threshold for better performance
(setq gc-cons-threshold 200000000
      gc-cons-percentage 0.1)

;; Increase amount of data read from subprocess
(setq read-process-output-max (* 1024 1024)) ; 1MB

;; Reduce startup time
(setq package-enable-at-startup nil)

;;==============================================================================
;; Basic Emacs Settings
;;==============================================================================

;; Disable unnecessary UI elements
(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)
(blink-cursor-mode -1)

;; Display settings
(setq-default
 display-line-numbers-type 'relative
 line-spacing 0.3
 column-number-mode t
 truncate-lines t)

;; Show line numbers in programming modes
(add-hook 'prog-mode-hook 'display-line-numbers-mode)

;; Font configuration
(set-face-attribute 'default nil
                    :family "Fira Code"
                    :height 180
                    :weight 'normal)

;; Theme
(use-package spacemacs-theme
  :defer t
  :init (load-theme 'spacemacs-dark t))

;; Start maximized
(add-to-list 'default-frame-alist '(fullscreen . maximized))

;; Better defaults
(setq-default
 inhibit-startup-screen t
 initial-scratch-message nil
 ring-bell-function 'ignore
 use-short-answers t
 confirm-kill-emacs 'yes-or-no-p)

;; Whitespace handling
(setq-default
 indent-tabs-mode nil
 tab-width 2
 show-trailing-whitespace t)

;; Delete trailing whitespace before save
(add-hook 'before-save-hook 'delete-trailing-whitespace)

;; Auto-save and backup settings
(setq auto-save-default t
      auto-save-file-name-transforms `((".*" ,temporary-file-directory t))
      backup-directory-alist `(("." . ,(concat user-emacs-directory "backups")))
      backup-by-copying t
      delete-old-versions t
      kept-new-versions 6
      kept-old-versions 2
      version-control t)

;; History settings
(setq history-length 100)
(put 'minibuffer-history 'history-length 50)

;; Enable recent files
(recentf-mode 1)
(setq recentf-max-saved-items 100)

;; Server mode
(use-package server
  :ensure nil
  :config
  (unless (server-running-p)
    (server-start)))

;;==============================================================================
;; Evil Mode (Vim Emulation)
;;==============================================================================

(use-package evil
  :init
  (setq evil-want-keybinding nil
        evil-want-integration t
        evil-undo-system 'undo-fu
        evil-respect-visual-line-mode t
        evil-want-C-u-scroll t)
  :config
  (evil-mode 1)

  ;; Use ; for ex commands
  (define-key evil-motion-state-map (kbd ";") 'evil-ex)

  ;; Custom ex commands
  (evil-ex-define-cmd "q" 'kill-this-buffer)
  (evil-ex-define-cmd "quit" 'evil-quit)

  ;; Better escape
  (setq-default evil-escape-delay 0.2
                evil-escape-key-sequence "jk"))

(use-package evil-collection
  :after evil
  :config
  (evil-collection-init))

(use-package evil-surround
  :after evil
  :config
  (global-evil-surround-mode 1))

(use-package evil-commentary
  :after evil
  :config
  (evil-commentary-mode))

(use-package undo-fu
  :after evil)

(use-package undo-fu-session
  :after undo-fu
  :config
  (setq undo-fu-session-incompatible-files '("/tmp/" "/ssh:"))
  (undo-fu-session-global-mode))

;;==============================================================================
;; Which-key (Key Binding Helper)
;;==============================================================================

(use-package which-key
  :config
  (setq which-key-idle-delay 0.2
        which-key-popup-type 'side-window
        which-key-side-window-location 'right)
  (which-key-mode 1))

;;==============================================================================
;; General (Key Binding Framework)
;;==============================================================================

(use-package general
  :config
  (general-create-definer leader-key
    :states '(normal visual insert emacs)
    :prefix "SPC"
    :non-normal-prefix "M-SPC")

  (general-create-definer local-leader-key
    :states '(normal visual)
    :prefix ","))

;;==============================================================================
;; Helm (Completion Framework)
;;==============================================================================

(use-package helm
  :config
  (setq helm-M-x-fuzzy-match t
        helm-buffers-fuzzy-matching t
        helm-recentf-fuzzy-match t
        helm-move-to-line-cycle-in-source t)

  ;; Hide dotfiles
  (add-to-list 'helm-boring-file-regexp-list "\\`\\.")

  (helm-mode 1)

  :bind (("M-x" . helm-M-x)
         ("C-x C-f" . helm-find-files)
         ("C-x b" . helm-mini)))

;;==============================================================================
;; Projectile (Project Management)
;;==============================================================================

(use-package projectile
  :config
  (projectile-mode +1)
  (setq projectile-enable-caching t
        projectile-indexing-method 'native)

  (add-to-list 'projectile-project-root-files "project.clj")
  (add-to-list 'projectile-project-root-files "deps.edn")
  (add-to-list 'projectile-globally-ignored-directories "node_modules")
  (add-to-list 'projectile-globally-ignored-directories ".git")
  (add-to-list 'projectile-globally-ignored-directories "target")
  (add-to-list 'projectile-globally-ignored-directories ".clj-kondo"))

(use-package helm-projectile
  :after (helm projectile)
  :config
  (helm-projectile-on))

;;==============================================================================
;; Git Integration
;;==============================================================================

(use-package magit
  :commands magit-status)

(use-package git-link)

(use-package diff-hl
  :config
  (global-diff-hl-mode))

;;==============================================================================
;; Treemacs (File Tree)
;;==============================================================================

(use-package treemacs
  :defer t
  :config
  (setq treemacs-width 30))

(use-package treemacs-evil
  :after (treemacs evil))

(use-package treemacs-projectile
  :after (treemacs projectile))

(use-package treemacs-magit
  :after (treemacs magit))

;;==============================================================================
;; Auto-completion
;;==============================================================================

(use-package company
  :config
  (setq company-idle-delay 0.2
        company-minimum-prefix-length 2
        company-show-numbers t)
  (global-company-mode 1))

;;==============================================================================
;; Syntax Checking
;;==============================================================================

(use-package flycheck
  :config
  (global-flycheck-mode))

;;==============================================================================
;; Parentheses Management
;;==============================================================================

(use-package smartparens
  :config
  (require 'smartparens-config)
  (setq sp-base-key-bindings 'paredit)
  (smartparens-global-mode 1)
  (show-smartparens-global-mode 1))

(use-package rainbow-delimiters
  :hook (prog-mode . rainbow-delimiters-mode))

;;==============================================================================
;; LSP Mode
;;==============================================================================

(use-package lsp-mode
  :commands (lsp lsp-deferred)
  :init
  (setq lsp-keymap-prefix "C-c l")
  :config
  (setq lsp-restart 'ignore
        lsp-clojure-custom-server-command '("clojure-lsp")
        lsp-clojure-use-metadata-for-privacy t
        lsp-clojure-analyze-classpath t
        lsp-lens-enable t
        lsp-ui-sideline-show-code-actions nil
        lsp-ui-sideline-enable nil
        lsp-modeline-code-actions-enable nil
        lsp-diagnostics-provider :none
        lsp-modeline-diagnostics-enable nil))

(use-package lsp-ui
  :commands lsp-ui-mode
  :config
  (setq lsp-ui-doc-show-with-cursor nil))

;;==============================================================================
;; Clojure Configuration
;;==============================================================================

(use-package clojure-mode
  :mode (("\\.clj\\'" . clojure-mode)
         ("\\.cljs\\'" . clojurescript-mode)
         ("\\.cljc\\'" . clojurec-mode)
         ("\\.edn\\'" . clojure-mode))
  :config
  ;; Indentation for common Clojure forms
  (put-clojure-indent 'defroutes 'defun)
  (put-clojure-indent 'GET 2)
  (put-clojure-indent 'POST 2)
  (put-clojure-indent 'PUT 2)
  (put-clojure-indent 'DELETE 2)
  (put-clojure-indent 'context 2)

  ;; Indentation settings
  (setq clojure-indent-style 'align-arguments
        clojure-align-forms-automatically t)

  ;; Custom highlighting
  (defun my-custom-clojure-highlighting ()
    "Add custom syntax highlighting for Clojure."
    (font-lock-add-keywords
     nil
     '(("(\\(\\(?:\\sw\\|\\s_\\)+\\)" 1 font-lock-function-name-face))))

  (add-hook 'clojure-mode-hook 'my-custom-clojure-highlighting)
  (add-hook 'clojure-mode-hook #'smartparens-strict-mode)
  (add-hook 'clojure-mode-hook #'lsp-deferred))

(use-package cider
  :after clojure-mode
  :config
  ;; REPL settings
  (setq cider-repl-use-clojure-font-lock t
        cider-repl-use-pretty-printing t
        cider-repl-result-prefix ";; => "
        cider-print-fn 'fipp
        cider-show-eval-spinner t
        cider-reuse-dead-repls nil)

  ;; Error display
  (setq cider-show-error-buffer t
        cider-auto-select-error-buffer t)

  ;; Auto-save before eval
  (setq cider-save-file-on-load t)

  ;; Formatting
  (setq cider-format-code-command "cljfmt")

  ;; Inspector
  (setq cider-inspector-page-size 100)

  ;; CLI options
  (setq cider-clojure-cli-global-options "-J-XX:-OmitStackTraceInFastThrow")

  ;; Prompt settings
  (setq cider-prompt-for-symbol nil)

  ;; Test report improvements
  (add-hook 'cider-test-report-mode-hook 'visual-line-mode)

  ;; Test result transformer
  (setq cider-test-report-actual-result-transformer
        (lambda (result)
          (let ((result (cider-test-report--remap-ansi-colors result)))
            (with-temp-buffer
              (insert result)
              (fill-region (point-min) (point-max))
              (buffer-string))))))

;;==============================================================================
;; Custom Clojure Functions
;;==============================================================================

(defun cider-jack-in-with-profile ()
  "Start a CIDER REPL with a custom Leiningen profile."
  (interactive)
  (let* ((profile (read-string "Enter profile name: "))
         (lein-params (concat "with-profile +" profile " repl :headless")))
    (message "lein-params set to: %s" lein-params)
    (setq-local cider-lein-parameters lein-params)
    (cider-jack-in '())))

(defun my/kill-all-buffers-and-processes ()
  "Kill all buffers and processes without a prompt."
  (interactive)
  (mapc 'kill-buffer (buffer-list))
  (dolist (process (process-list))
    (delete-process process)))

(defun cider-reload-and-rerun-failed-tests ()
  "Reload namespace and rerun failed tests."
  (interactive)
  (save-some-buffers t)
  (cider-ns-refresh)
  (cider-switch-to-repl-buffer)
  (cider-repl-clear-buffer)
  (delete-window)
  (cider-test-rerun-failed-tests))

;;==============================================================================
;; Additional Useful Packages
;;==============================================================================

(use-package aggressive-indent
  :hook (clojure-mode . aggressive-indent-mode))

(use-package bnf-mode
  :mode "\\.bnf\\'")

(use-package multiple-cursors)

;; Org mode (for documentation/notes)
(use-package org
  :mode ("\\.org\\'" . org-mode)
  :config
  (setq org-startup-indented t
        org-hide-leading-stars t))

;;==============================================================================
;; Key Bindings
;;==============================================================================

(leader-key
  "SPC" 'helm-M-x
  "f"   '(:ignore t :which-key "files")
  "ff"  'helm-find-files
  "fr"  'helm-recentf
  "fs"  'save-buffer
  "b"   '(:ignore t :which-key "buffers")
  "bb"  'helm-mini
  "bd"  'kill-this-buffer
  "p"   '(:ignore t :which-key "project")
  "pf"  'helm-projectile-find-file
  "pp"  'helm-projectile-switch-project
  "pt"  'treemacs
  "g"   '(:ignore t :which-key "git")
  "gs"  'magit-status
  "gl"  'git-link
  "w"   '(:ignore t :which-key "window")
  "wh"  'evil-window-left
  "wj"  'evil-window-down
  "wk"  'evil-window-up
  "wl"  'evil-window-right
  "wd"  'delete-window
  "wo"  'delete-other-windows
  "ws"  'split-window-below
  "wv"  'split-window-right
  "o"   '(:ignore t :which-key "custom")
  "ok"  'my/kill-all-buffers-and-processes
  "oT"  'cider-reload-and-rerun-failed-tests)

;; Clojure-specific key bindings
(local-leader-key
  :keymaps 'clojure-mode-map
  "'"   'cider-jack-in
  "\"" 'cider-jack-in-with-profile
  "e"   '(:ignore t :which-key "eval")
  "eb"  'cider-eval-buffer
  "ee"  'cider-eval-last-sexp
  "ef"  'cider-eval-defun-at-point
  "er"  'cider-eval-region
  "t"   '(:ignore t :which-key "test")
  "ta"  'cider-test-run-ns-tests
  "tt"  'cider-test-run-test
  "tp"  'cider-test-run-project-tests
  "tr"  'cider-test-rerun-failed-tests
  "n"   '(:ignore t :which-key "namespace")
  "nr"  'cider-ns-refresh
  "r"   '(:ignore t :which-key "repl")
  "rs"  'cider-switch-to-repl-buffer
  "rq"  'cider-quit
  "f"   '(:ignore t :which-key "format")
  "ff"  'cider-format-buffer
  "d"   '(:ignore t :which-key "debug")
  "dd"  'cider-debug-defun-at-point)

;; Global custom key binding
(global-set-key (kbd "C-<return>") (kbd "SPC k $ RET i"))

;;==============================================================================
;; File Associations
;;==============================================================================

(add-to-list 'auto-mode-alist '("\\.gql\\'" . graphql-mode))

;;==============================================================================
;; Makefile Settings
;;==============================================================================

(add-hook 'makefile-mode-hook
          (lambda ()
            (setq indent-tabs-mode t
                  tab-width 2)))

(add-hook 'makefile-gmake-mode-hook
          (lambda ()
            (setq indent-tabs-mode t
                  tab-width 2)))

;;==============================================================================
;; Suppress Warnings
;;==============================================================================

(setq byte-compile-warnings '(not cl-functions))

;;==============================================================================
;; End of Configuration
;;==============================================================================

(provide 'init)
;;; init.el ends here
