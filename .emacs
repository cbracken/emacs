;; .emacs
;; Chris Bracken - 6 June, 2000

;; Inhibit the emacs startup message
(setq inhibit-startup-message t)

;; Are we running XEmacs or GNU Emacs?
(defvar running-xemacs (string-match "XEmacs\\|Lucid" emacs-version))

;; Some macros
(defmacro GNUEmacs (&rest x)
  (list 'if (not running-xemacs) (cons 'progn x)))
(defmacro XEmacs (&rest x)
  (list 'if running-xemacs (cons 'progn x)))
(defmacro Xlaunch (&rest x)
  (list 'if (eq window-system 'x)(cons 'progn x)))

;; Fix del key behaviour
(GNUEmacs
  (Xlaunch (define-key global-map [(delete)] "\C-d")))
(XEmacs
  (if (eq window-system 'x)
    (global-set-key (read-kbd-macro "DEL") 'delete-char)))

;; Set username and email address
(setq user-mail-address "chris@bracken.jp")
(setq user-full-name "Chris Bracken")

;; Local lisp dir
(add-to-list 'load-path "~/.emacs.d/lisp/")

;; Hide the menubar
(GNUEmacs
  (menu-bar-mode nil)
  (if (display-graphic-p)
    (tool-bar-mode nil)))
(XEmacs
  (set-specifier top-toolbar-visible-p nil))

;; Display current line/column in the status bar.
(line-number-mode 1)
(column-number-mode 1)

(require 'sql)
(add-hook 'sql-mode-hook
  (lambda ()
    (setq font-lock-defaults '(sql-mode-font-lock-keywords t t))
    (setq sql-mode-font-lock-keywords
      (append sql-mode-font-lock-keywords
        '(("\"\\([^\"]*\\)\"" 0 font-lock-string-face t)
          ("'\\([^']*\\)'" 0 font-lock-string-face t))))))
(setq auto-mode-alist (cons '("\\.xi$" . xml-mode) auto-mode-alist))

;; Set up modes for XML and FIX
;; (add-to-list 'load-path (expand-file-name "~/local/share/site-lisp"))

;;----------------------------------------

;; Set the default editing mode to text mode with word wrap
(setq default-major-mode 'text-mode)
(add-hook 'text-mode-hook 'turn-on-auto-fill)

;; Make ctrl-k kill the whole line
(setq kill-whole-line t)

;; Purge excess file versions quietly.
(setq trim-versions-without-asking t)

;; Set font
;; (GNUEmacs
;;   (set-default-font "-apple-dejavu sans mono-medium-r-normal--0-0-0-0-m-0-mac-roman"))
;; (XEmacs
;;   (set-face-font 'default "-misc-fixed-medium-r-*-*-*-100-*-*-*-*-iso8859-1" nil))

;; Reduce noise pollution; increase light pollution.
(setq visible-bell t)

;; Ensure file always ends in newline
(setq require-final-newline t)

;; Diff options
;; (require 'vc)
(setq vc-diff-switches "-ubB")

;; Use spaces instead of tabs
(setq-default indent-tabs-mode nil)

;; Clean up semantic.cache
(setq semanticdb-default-save-directory (expand-file-name "~/.xemacs/semantic"))

;; Set C indentation style
(defun my-c-mode-common-hook ()
  (c-set-offset 'substatement-open 0)
  (setq c-basic-offset 2)
  (setq tab-width 2))
(add-hook 'c-mode-common-hook 'my-c-mode-common-hook)

;; Better C++ syntax highlighting
(autoload 'cpp-font-lock "cc-mode")

;; Configure makefile modes for configure.in and automake files
(setq auto-mode-alist
  (append '(
    ("\\.h$" . c++-mode)
    ("configure.in" . m4-mode)
    ("\\.m4\\'" . m4-mode)
    ("\\.am\\'" . makefile-mode)
    ("\\.s?html?\\'" . html-helper-mode)
    ("\\.xml\\(\\'\\|\\.\\)" . xml-mode)
    ("\\.css\\'" . css-mode)
  ) auto-mode-alist))

;; Add some handy shortcuts
(GNUEmacs
  (add-hook 'dired-load-hook (function (lambda () (load "dired-x"))))
  (setq dired-omit-files-p t))
(global-set-key [f1] 'dired)
(global-set-key [f2] 'dired-omit-toggle)
(global-set-key [f3] 'tshell)
(global-set-key [f4] 'find-file)
(global-set-key [f5] 'revert-buffer)
(global-set-key [f6] 'visit-tags-table)
(global-set-key [f7] 'compile)
(global-set-key [f8] 'add-change-log-entry-other-window)
(global-set-key [f10] 'font-lock-fontify-buffer)
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
(GNUEmacs
  (global-set-key [S-mouse-4] 'down-one)
  (global-set-key [S-mouse-5] 'up-one)
  (global-set-key [C-mouse-4] 'down-alot)
  (global-set-key [C-mouse-5] 'up-alot))
(XEmacs
  (cond (window-system (mwheel-install)))
  (global-set-key [shift-mouse-4] 'down-one)
  (global-set-key [shift-mouse-5] 'up-one)
  (global-set-key [ctrl-mouse-4] 'down-alot)
  (global-set-key [ctrl-mouse-5] 'up-alot))

;; CSS-mode
(autoload 'css-mode "css-mode" "Major mode to edit CSS files." t)

;; Configure PSGML module
(setq sgml-always-quote-attributes t)       ; expected by many clients
(setq sgml-auto-insert-required-elements t) ; auto insert required tags
(setq sgml-indent-data t)                   ; auto-indent
(setq sgml-indent-step 2)                   ; set the indent
(setq sgml-suppress-warning t)
(setq sgml-auto-activate-dtd nil)           ; don't preload dtd
(setq sgml-omittag nil)
(setq sgml-shorttag nil)
(setq sgml-recompile-out-of-date-cdtd nil)

;; Set custom colours
(set-face-foreground 'default "Gainsboro")

;;(GNUEmacs
(XEmacs
  (set-face-foreground 'modeline "Yellow")
  (set-face-background 'modeline "DarkSlateBlue"))
(set-face-foreground 'modeline "Yellow")
(set-face-background 'modeline "DarkBlue")
(set-cursor-color "orange")

;; Turn on syntax highlighting
(GNUEmacs
  (cond ((fboundp 'global-font-lock-mode)
    (require 'font-lock)
    (setq font-lock-maximum-decoration t)
    (global-font-lock-mode t)
    (require 'color-theme)
    (color-theme-initialize)
    (load-file "~/.emacs.d/lisp/themes/color-theme-blackboard.el"))))
(XEmacs
  (require 'font-lock))

;; Allow keyboard text selection
(setq transient-mark-mode t)

;; Set default frame attributes
(setq default-frame-plist
  '((cursor-color . "red")
    (cursor-type . box)
    (foreground-color . "white")
    (background-color . "black")
    (width . 100 )
    (height . 40)))

