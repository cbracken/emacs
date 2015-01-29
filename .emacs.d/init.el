;; .emacs
;; Chris Bracken - 6 June, 2000

;; Inhibit the emacs startup message
(setq inhibit-startup-message t)

;; Some macros
(defmacro Xlaunch (&rest x)
  (list 'if (eq window-system 'x)(cons 'progn x)))
(cond
  ((string-match "apple-darwin" system-configuration)
    (setq os-type 'mac))
  ((string-match "linux" system-configuration)
    (setq os-type 'linux))
  ((string-match "freebsd" system-configuration)
    (setq os-type 'bsd)))
(defun mac? () (eq os-type 'mac))
(defun linux? () (eq os-type 'linux))
(defun bsd? () (eq os-type 'bsd))

;; Fix del key behaviour
(Xlaunch (define-key global-map [(delete)] "\C-d"))

;; Set username and email address
(setq user-mail-address "chris@bracken.jp")
(setq user-full-name "Chris Bracken")

;; Local lisp dir
(add-to-list 'load-path "~/.emacs.d/lisp/")

;; Hide the menubar
(menu-bar-mode nil)
(if (display-graphic-p)
  (tool-bar-mode -1))

;; Highlight the current line
(global-hl-line-mode 1)

;; Display current line/column in the status bar.
(line-number-mode 1)
(column-number-mode 1)

;; Dart support
(require 'dart-mode)

;; Set the default editing mode to text mode with word wrap
(setq default-major-mode 'text-mode)
(add-hook 'text-mode-hook 'turn-on-auto-fill)

;; Make ctrl-k kill the whole line
(setq kill-whole-line t)

;; Purge excess file versions quietly.
(setq trim-versions-without-asking t)

;; Ensure file always ends in newline
(setq require-final-newline t)

;; Diff options
(setq vc-diff-switches "-ubB")

;; Use spaces instead of tabs
(setq-default indent-tabs-mode nil)

;; Set C indentation style
(defun my-c-mode-common-hook ()
  (c-set-offset 'substatement-open 0)
  (setq c-basic-offset 2)
  (setq tab-width 2))
(add-hook 'c-mode-common-hook 'my-c-mode-common-hook)

(setq auto-mode-alist
  (append '(
    ("\\.dart\\'" . dart-mode)
  ) auto-mode-alist))

;; Add some handy shortcuts
(add-hook 'dired-load-hook (function (lambda () (load "dired-x"))))
(setq dired-omit-files-p t)

(global-set-key [f1] 'dired)
(global-set-key [f5] 'revert-buffer)
(global-set-key [f6] 'visit-tags-table)
(global-set-key [f7] 'compile)
(global-set-key [f12] 'goto-line)

;; Configure mouse wheel to work with emacs
(defun up-slightly () (interactive) (scroll-up 5))
(defun down-slightly () (interactive) (scroll-down 5))
(defun up-one () (interactive) (scroll-up 1))
(defun down-one () (interactive) (scroll-down 1))
(defun up-alot () (interactive) (scroll-up))
(defun down-alot () (interactive) (scroll-down))
(global-set-key [mouse-4] 'down-slightly)
(global-set-key [mouse-5] 'up-slightly)
(global-set-key [S-mouse-4] 'down-one)
(global-set-key [S-mouse-5] 'up-one)
(global-set-key [C-mouse-4] 'down-alot)
(global-set-key [C-mouse-5] 'up-alot)

;; Set custom colours
(if (mac?)
  (set-default-font "-apple-Menlo-medium-normal-normal-*-11-*-*-*-m-0-iso10646-1")
  (set-default-font "-misc-fixed-medium-r-normal--0-0-75-75-c-0-iso8859-1"))
(set-face-foreground 'default "Gainsboro")
(set-cursor-color "orange")
(set-face-background 'hl-line "grey24")

;; Turn on syntax highlighting
(cond ((fboundp 'global-font-lock-mode)
  (require 'font-lock)
  (setq font-lock-maximum-decoration t)
  (global-font-lock-mode t)
  (require 'color-theme)
  (color-theme-initialize)
  (load-file "~/.emacs.d/lisp/themes/lucius-theme.el")
  (color-theme-lucius)))

;; Allow keyboard text selection
(setq transient-mark-mode t)
