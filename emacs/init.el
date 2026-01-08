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
                    :height 240
                    :weight 'normal)

;; Theme
(use-package spacemacs-theme
  :defer t
  :init (load-theme 'spacemacs-dark t))

;; Start maximized and remember position
(add-to-list 'default-frame-alist '(fullscreen . maximized))

;; Save and restore frame position/size across sessions
(when (fboundp 'frameset-save)
  (defvar my-frame-geometry-file
    (expand-file-name "frame-geometry" user-emacs-directory)
    "File to save frame geometry.")

  (defun my-save-frame-geometry ()
    "Save frame geometry to file."
    (with-temp-file my-frame-geometry-file
      (prin1 (frame-parameters) (current-buffer))))

  (defun my-restore-frame-geometry ()
    "Restore frame geometry from file."
    (when (file-exists-p my-frame-geometry-file)
      (with-temp-buffer
        (insert-file-contents my-frame-geometry-file)
        (let ((params (read (current-buffer))))
          (when (and (assq 'left params) (assq 'top params))
            (modify-frame-parameters nil
                                     (list (assq 'left params)
                                           (assq 'top params))))))))

  (add-hook 'kill-emacs-hook 'my-save-frame-geometry)
  (add-hook 'after-init-hook 'my-restore-frame-geometry))

;; Better defaults
(setq-default
 inhibit-startup-screen t
 initial-scratch-message nil
 ring-bell-function 'ignore
 use-short-answers t
 confirm-kill-emacs 'yes-or-no-p
 initial-buffer-choice nil)

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

  ;; ESC quits/aborts like C-g
  (define-key evil-normal-state-map [escape] 'keyboard-quit)
  (define-key evil-visual-state-map [escape] 'keyboard-quit)
  (define-key minibuffer-local-map [escape] 'minibuffer-keyboard-quit)
  (define-key minibuffer-local-ns-map [escape] 'minibuffer-keyboard-quit)
  (define-key minibuffer-local-completion-map [escape] 'minibuffer-keyboard-quit)
  (define-key minibuffer-local-must-match-map [escape] 'minibuffer-keyboard-quit)
  (define-key minibuffer-local-isearch-map [escape] 'minibuffer-keyboard-quit)
  (global-set-key [escape] 'keyboard-escape-quit)

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
  (setq undo-fu-session-incompatible-files '("/tmp/" "/ssh:")
        undo-fu-session-directory (expand-file-name "undo-fu-session" user-emacs-directory))
  (undo-fu-session-global-mode))

;;==============================================================================
;; Which-key (Key Binding Helper)
;;==============================================================================

(use-package which-key
  :config
  (setq which-key-idle-delay 0.2
        which-key-popup-type 'side-window
        which-key-side-window-location 'bottom
        which-key-side-window-max-height 0.4
        which-key-max-description-length 32
        which-key-add-column-padding 1)
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
         ("C-x b" . helm-mini)
         :map helm-map
         ("C-g" . helm-keyboard-quit)))

;;==============================================================================
;; Projectile (Project Management)
;;==============================================================================

(use-package projectile
  :config
  (projectile-mode +1)
  (setq projectile-enable-caching t
        projectile-indexing-method 'alien  ; Use external tools
        projectile-generic-command "rg --files --color=never"
        projectile-git-command "rg --files --color=never"
        projectile-use-git-grep t)

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

;; Show recent projects on startup
(defun my/show-recent-projects ()
  "Show recent projects on startup."
  (interactive)
  (if (and (fboundp 'projectile-relevant-known-projects)
           (projectile-relevant-known-projects))
      (helm-projectile-switch-project)
    (when (get-buffer "*scratch*")
      (switch-to-buffer "*scratch*"))))

(add-hook 'emacs-startup-hook
          (lambda ()
            (when (and (not (daemonp))
                       (< (length command-line-args) 2))
              ;; Delay projectile to ensure frame is fully maximized
              (run-with-timer 0.1 nil #'my/show-recent-projects))))

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
  (setq sp-base-key-bindings 'paredit
        sp-highlight-pair-overlay nil
        sp-highlight-wrap-overlay nil
        sp-highlight-wrap-tag-overlay nil)
  (smartparens-global-mode 1)
  (show-smartparens-global-mode 1)

  ;; Enable strict mode for Lisp languages
  (add-hook 'emacs-lisp-mode-hook #'smartparens-strict-mode)
  (add-hook 'lisp-mode-hook #'smartparens-strict-mode)
  (add-hook 'scheme-mode-hook #'smartparens-strict-mode)

  ;; Simple Evil-friendly sexp navigation
  (with-eval-after-load 'evil
    (define-key evil-normal-state-map (kbd "H") 'sp-backward-sexp)
    (define-key evil-normal-state-map (kbd "L") 'sp-forward-sexp)
    (define-key evil-visual-state-map (kbd "H") 'sp-backward-sexp)
    (define-key evil-visual-state-map (kbd "L") 'sp-forward-sexp)))

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
        clojure-align-forms-automatically nil)

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
;; File Management Functions
;;==============================================================================

(defun my/delete-current-file ()
  "Delete the current file and kill the buffer."
  (interactive)
  (let ((filename (buffer-file-name)))
    (when filename
      (when (y-or-n-p (format "Delete file %s? " filename))
        (delete-file filename)
        (kill-buffer (current-buffer))
        (message "File '%s' deleted" filename)))))

(defun my/rename-current-file ()
  "Rename the current file and buffer."
  (interactive)
  (let ((filename (buffer-file-name)))
    (if (not filename)
        (message "Buffer is not visiting a file")
      (let ((new-name (read-file-name "New name: " filename)))
        (cond
         ((vc-backend filename) (vc-rename-file filename new-name))
         (t
          (rename-file filename new-name t)
          (set-visited-file-name new-name t t)
          (message "File '%s' renamed to '%s'" filename new-name)))))))

(defun my/copy-file-path ()
  "Copy the current buffer file path to the clipboard."
  (interactive)
  (let ((filename (if (equal major-mode 'dired-mode)
                      default-directory
                    (buffer-file-name))))
    (when filename
      (kill-new filename)
      (message "Copied: %s" filename))))

(defun my/open-config ()
  "Open the init.el configuration file."
  (interactive)
  (find-file (expand-file-name "init.el" user-emacs-directory)))

(defun my/open-early-init ()
  "Open the early-init.el configuration file."
  (interactive)
  (find-file (expand-file-name "early-init.el" user-emacs-directory)))

(defun my/reload-config ()
  "Reload the init.el configuration."
  (interactive)
  (load-file (expand-file-name "init.el" user-emacs-directory))
  (message "Configuration reloaded!"))

(defun my/quit-emacs ()
  "Quit Emacs."
  (interactive)
  (save-some-buffers)
  (kill-emacs))

(defun my/restart-emacs ()
  "Restart Emacs (requires restart-emacs package)."
  (interactive)
  (if (fboundp 'restart-emacs)
      (progn
        (save-some-buffers)
        (restart-emacs))
    (message "Install restart-emacs package for restart functionality. Use 'SPC q q' to quit manually.")))

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
  :commands aggressive-indent-mode)
  ;; Disabled by default - too aggressive
  ;; Enable manually with: M-x aggressive-indent-mode

(use-package bnf-mode
  :mode "\\.bnf\\'")

(use-package multiple-cursors)

(use-package restart-emacs
  :commands restart-emacs)

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
  "SPC" 'which-key-show-top-level
  ":"   'helm-M-x
  "f"   '(:ignore t :which-key "files")
  "ff"  'helm-find-files
  "fr"  'helm-recentf
  "fs"  'save-buffer
  "fS"  'save-some-buffers
  "fD"  'my/delete-current-file
  "fR"  'my/rename-current-file
  "fy"  'my/copy-file-path
  "fe"  '(:ignore t :which-key "emacs")
  "fed" 'my/open-config
  "feD" 'my/open-early-init
  "feR" 'my/reload-config
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
  "q"   '(:ignore t :which-key "quit")
  "qq"  'my/quit-emacs
  "qr"  'my/restart-emacs
  "k"   '(:ignore t :which-key "lisp")
  "k)"  'sp-forward-slurp-sexp
  "k("  'sp-backward-slurp-sexp
  "k}"  'sp-forward-barf-sexp
  "k{"  'sp-backward-barf-sexp
  "ks"  'sp-splice-sexp
  "kr"  'sp-raise-sexp
  "kS"  'sp-split-sexp
  "kj"  'sp-join-sexp
  "kw"  'sp-wrap-round
  "k["  'sp-wrap-square
  "kW"  'sp-unwrap-sexp
  "kt"  'sp-transpose-sexp
  "kc"  'sp-convolute-sexp
  "ka"  'sp-absorb-sexp
  "ke"  'sp-emit-sexp
  "k$"  'sp-end-of-sexp
  "j"   '(:ignore t :which-key "jack-in")
  "jj"  'cider-jack-in
  "jc"  'cider-jack-in-clj
  "js"  'cider-jack-in-cljs
  "ja"  'cider-jack-in-clj&cljs
  "jp"  'cider-jack-in-with-profile
  "o"   '(:ignore t :which-key "custom")
  "ok"  'my/kill-all-buffers-and-processes
  "oT"  'cider-reload-and-rerun-failed-tests)

;; Clojure-specific key bindings
(local-leader-key
  :keymaps 'clojure-mode-map
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
(global-set-key (kbd "C-<return>") (kbd "SPC k $ i RET"))

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
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(helm-minibuffer-history-key "M-p")
 '(package-selected-packages nil))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
