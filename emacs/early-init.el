;;; early-init.el --- Early initialization -*- lexical-binding: t -*-

;;; Commentary:
;; Emacs 27+ introduces early-init.el, which is loaded before init.el
;; and before the package system and GUI is initialized.
;; This is the perfect place for performance optimizations.

;;; Code:

;; Disable package.el in favor of manual initialization in init.el
(setq package-enable-at-startup nil)

;; Increase garbage collection threshold during startup
(setq gc-cons-threshold most-positive-fixnum
      gc-cons-percentage 0.6)

;; Reset garbage collection threshold after startup
(add-hook 'emacs-startup-hook
          (lambda ()
            (setq gc-cons-threshold 200000000
                  gc-cons-percentage 0.1)))

;; Disable unnecessary UI elements early
(push '(menu-bar-lines . 0) default-frame-alist)
(push '(tool-bar-lines . 0) default-frame-alist)
(push '(vertical-scroll-bars) default-frame-alist)

;; Prevent initial frame from showing up
(setq frame-inhibit-implied-resize t)

;; Disable bidirectional text rendering for a small performance boost
(setq-default bidi-display-reordering 'left-to-right
              bidi-paragraph-direction 'left-to-right)

;; Reduce rendering workload by not rendering cursors or regions in non-focused windows
(setq-default cursor-in-non-selected-windows nil)
(setq highlight-nonselected-windows nil)

;; Disable warnings from obsolete advice system
(setq ad-redefinition-action 'accept)

;; Resizing the Emacs frame can be expensive, disable it
(setq frame-resize-pixelwise t)

(provide 'early-init)
;;; early-init.el ends here
