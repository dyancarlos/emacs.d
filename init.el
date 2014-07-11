(setq inhibit-startup-message t)

(setenv "PATH" (concat (getenv "PATH") ":/usr/local/bin"))
(setq exec-path (append exec-path '("/usr/local/bin")))

;; Adding folders to the load path
;;(add-to-list 'load-path "~/.emacs.d/")
(add-to-list 'load-path "~/.emacs.d/vendor/")

;; Default to home dir
(cd "~/")

;; Using MELPA for packages
(when (>= emacs-major-version 24)
  (require 'package)
  (package-initialize)
  (add-to-list 'package-archives '("melpa" . "http://melpa.milkbox.net/packages/") t)
  )

;; Load necessary packages
(package-initialize)
(setq my-required-packages
      (list 'magit
            'evil
            'evil-jumper
            'evil-visualstar
            'surround
            'robe
            's
            'coffee-mode
            'sourcemap
            'bundler
            'projectile
            'projectile-rails
            'rubocop
            'scss-mode
            'sass-mode
            'f
            'jump
            'inflections
            'fiplr
            'ack-and-a-half
            'ruby-tools
            'highlight-indentation
            'window-number
            'rhtml-mode
            'dired-details
            'yasnippet
            'yari
            'ibuffer-vc
            'fill-column-indicator
            'rvm
            'rinari
            'web-mode
            'feature-mode
            'auto-compile
            'yaml-mode
            'rspec-mode
            'undo-tree
            'inf-ruby
            'discover-my-major
            'goto-chg))

(dolist (package my-required-packages)
  (when (not (package-installed-p package))
    (package-refresh-contents)
    (package-install package)))

;; Window numbers
(require 'window-number)
(window-number-mode)
(window-number-meta-mode)

;; Enable copy and pasting from clipboard
(setq x-select-enable-clipboard t)

;; To get rid of Weird color escape sequences in Emacs.
;; Instruct Emacs to use emacs term-info not system term info
;; http://stackoverflow.com/questions/8918910/weird-character-zsh-in-emacs-terminal
(setq system-uses-terminfo nil)

;; Prefer utf-8 encoding
(prefer-coding-system 'utf-8)

;; Go to last change
(require 'goto-chg)

;; Highlight 80 column margin
(require 'fill-column-indicator)
(setq fci-rule-use-dashes nil)
(setq fci-always-use-textual-rule nil)

;; Web mode
(require 'web-mode)
(add-to-list 'auto-mode-alist '("\\.erb\\'" . web-mode))

;; Coffee Script
(setq coffee-args-compile '("-c" "-m")) ;; generating sourcemap
(add-hook 'coffee-after-compile-hook 'sourcemap-goto-corresponding-point)
(defun coffee-after-compile-delete-file (props)
  (delete-file (plist-get props :sourcemap)))
(add-hook 'coffee-after-compile-hook 'coffee-after-compile-delete-file t)

;; Custom themes
(add-to-list 'custom-theme-load-path "~/.emacs.d/themes")

;; Prevent adding the coding line
(setq ruby-insert-encoding-magic-comment nil)

;; Always open split windows horizontally
(setq split-height-threshold 0)
(setq split-width-threshold nil)

;; Stop that bell sound
(setq visible-bell t)
(setq ring-bell-function (lambda () (message "*beep*")))

;; Yaml
(require 'yaml-mode)
(add-to-list 'auto-mode-alist '("\\.yml$" . yaml-mode))

;; Projectile mode
(require 'projectile)
(projectile-global-mode)
(add-hook 'projectile-mode-hook 'projectile-rails-on)

;; Load custom snippets
(require 'yasnippet)
(yas-global-mode 1)
(setq yas-snippet-dirs "~/.emacs.d/snippets")

;; BS mode
(setq bs-must-show-regexp "^\\*scratch*")
(setq bs-dont-show-regexp "TAGS")
(setq bs-attributes-list 
      '(("" 1 1 left bs--get-marked-string)
        ("M" 1 1 left bs--get-modified-string)
        ("R" 2 2 left bs--get-readonly-string)
        ("Buffer" bs--get-name-length 10 left bs--get-name)
        ("" 1 1 left " ")
        ("File" 12 12 left bs--get-file-name)
        ("" 2 2 left "  ")))

;; Always ident with 2 spaces
(setq-default indent-tabs-mode nil)
(setq-default tab-width 2)
(setq-default c-basic-offset 2)
(setq css-indent-offset 2)
(setq js-indent-level 2)

;; Use the short version for yes/no
(fset 'yes-or-no-p 'y-or-n-p)

;; Confirm quit
(setq confirm-kill-emacs 'yes-or-no-p)

;; Always refresh file contents if they change on disk
(global-auto-revert-mode 1)

;; Diable bold and underline faces
(mapc
 (lambda (face)
   (set-face-attribute face nil :weight 'normal :underline nil))
 (face-list))

;; Showing whitespace
(require 'whitespace)
(setq whitespace-line-column 80) ;; limit line length
(setq whitespace-style '(face lines-tail))
(setq whitespace-style (quote (spaces tabs newline space-mark tab-mark newline-mark)))
(setq whitespace-display-mappings
      ;; all numbers are Unicode codepoint in decimal. e.g. (insert-char 182 1)
      '(
        (space-mark nil) ; 32 SPACE, 183 MIDDLE DOT
        (newline-mark 10 [172 10]) ; 10 LINE FEED
        (tab-mark 9 [183 9] [92 9]) ; 9 TAB, MIDDLE DOT
        ))
(global-whitespace-mode -1)

;; Setting a default line-height
(setq-default line-spacing 1)

;; Make _ parts of the "word"
(modify-syntax-entry ?_ "w")

;; Don't save any backup files in the current directory
(setq backup-directory-alist `(("." . "~/.emacs_backups")))

;; Highlight parenthesis
(show-paren-mode 1)

;; Save point position between sessions
(require 'saveplace)
(setq-default save-place t)
(setq save-place-file (expand-file-name ".places" user-emacs-directory))

;; Dired
(load "~/.emacs.d/my-dired")

;; Magit
(load "~/.emacs.d/my-magit")

;; Custom functions
(load "~/.emacs.d/my-functions")

;; Evil stuff
(load "~/.emacs.d/my-evil")

;; Make CMD work like ALT (on the Mac)
(setq mac-command-modifier 'meta)
;; (setq mac-option-modifier 'none)
;; (setq mac-option-key-is-meta t)
;; (setq mac-right-option-modifier nil)

;; Choosing a dark theme
;; (load-theme 'base16-default t)
;; (load-theme 'tango-dark t)
(load-theme 'wilson t)

;; Default frame size
(setq initial-frame-alist
      '((top . 10) (left . 30) (width . 125) (height . 35)))
   
;; Making dabbrev a bit nicer
(setq dabbrev-abbrev-skip-leading-regexp ":")
(setq dabbrev-backward-only t)

;; Use frames instead of windows for compilation popups
;; (setq-default display-buffer-reuse-frames t)

;; Show line numbers only in opened files
;; Another option could be: http://www.emacswiki.org/emacs/linum-off.el
(add-hook 'find-file-hook (lambda () (linum-mode 1)))

;; Format line numbers
(setq linum-format "%4d ")

;; Disabling the fringe
(fringe-mode 0)

;; Disabling the toolbar
(tool-bar-mode 0)

;; Font
(set-frame-font "Monaco-13")

;; IBuffer
(setq ibuffer-formats
      '((mark modified read-only " "
              (name 50 50 :left :elide) " "
              filename-and-process)
        (mark " " (name 16 -1) " " filename)))

(setq ibuffer-show-empty-filter-groups nil)

(add-hook 'ibuffer-mode-hook
          '(lambda ()
             (ibuffer-auto-mode 1)
             (ibuffer-vc-set-filter-groups-by-vc-root)))

;; Uniquify buffers
(require 'uniquify)
(setq
  uniquify-buffer-name-style 'post-forward
  uniquify-separator " : ")

;; Ruby
(load "~/.emacs.d/my-ruby")

;; Rhtml mode
;; (require 'rhtml-mode)
;; (add-to-list 'auto-mode-alist '("\\.html.erb?\\'" . rhtml-mode))

;; Bind YARI to C-h R
(define-key 'help-command "R" 'yari)

;; RVM
(require 'rvm)
(rvm-use-default)

;; Cucumber
(require 'feature-mode)
(setq feature-use-rvm t)
(setq feature-cucumber-command "cucumber {options} {feature}")
(add-to-list 'auto-mode-alist '("\.feature$" . feature-mode))

;; Rspec
(require 'rspec-mode)
(setq rspec-use-rake-when-possible nil)

;; Scss
(autoload 'scss-mode "scss-mode")
(add-to-list 'auto-mode-alist '("\\.scss\\'" . scss-mode))

;; Undo tree
(require 'undo-tree)
(global-undo-tree-mode 1)

;; Ack
(require 'ack-and-a-half)
;; Always prompt for a directory root
(setq ack-and-a-half-prompt-for-directory t)
(setq ack-and-a-half-executable "/usr/local/bin/ack")

(defun font-lock-comment-annotations ()
  "Highlight a bunch of well known comment annotations.

This functions should be added to the hooks of major modes for programming."
  (font-lock-add-keywords
   nil '(("\\<\\(FIX\\(ME\\)?\\|TODO\\|OPTIMIZE\\|HACK\\|REFACTOR\\):"
          1 font-lock-warning-face t))))

(require 'highlight-symbol)
(global-set-key (kbd "C-8") 'highlight-symbol-next)
(global-set-key (kbd "C-*") 'highlight-symbol-prev)

(add-hook 'prog-mode-hook 'font-lock-comment-annotations)
(defun prelude-move-beginning-of-line (arg)
  "Move point back to indentation of beginning of line.

Move point to the first non-whitespace character on this line.
If point is already there, move to the beginning of the line.
Effectively toggle between the first non-whitespace character and
the beginning of the line.

If ARG is not nil or 1, move forward ARG - 1 lines first.  If
point reaches the beginning or end of the buffer, stop there."
  (interactive "^p")
  (setq arg (or arg 1))

  ;; Move lines first
  (when (/= arg 1)
    (let ((line-move-visual nil))
      (forward-line (1- arg))))

  (let ((orig-point (point)))
    (back-to-indentation)
    (when (= orig-point (point))
      (move-beginning-of-line 1))))

(global-set-key [remap move-beginning-of-line]
                'prelude-move-beginning-of-line)

(defun open-emacs-init-file()
  "Opens the init.el file"
 (interactive)
  (find-file (expand-file-name "init.el" user-emacs-directory)))
                                          
(global-set-key (kbd "C-h C-m") 'discover-my-major)
(global-set-key (kbd "<f2>") 'open-emacs-init-file)
(global-set-key (kbd "<escape>") 'keyboard-escape-quit)
;; (global-unset-key (kbd "C-c C-x"))
;; (global-set-key (kbd "C-c C-x") 'execute-extended-command)
;; (global-set-key (kbd "C-c C-a") 'ack-and-a-half)
;; (global-set-key (kbd "C-x b") 'bs-show) 
;; (global-set-key (kbd "C-c j") 'dired-jump)
;; (global-set-key (kbd "C-c d") 'duplicate-line)
;; (global-set-key (kbd "C-c g") 'magit-status)
;; (global-set-key (kbd "C-x k") 'kill-this-buffer)
;; (global-set-key (kbd "C-c K") 'kill-buffer-and-window)
;; (global-set-key (kbd "C-c o") 'vi-open-line-below)
;; (global-set-key (kbd "C-=") 'er/expand-region)
;; (global-set-key (kbd "C-c O") 'vi-open-line-above)
;; (global-set-key (kbd "C-c r") 'rspec-verify-single)
;; (global-set-key (kbd "C-c a w") 'ace-jump-word-mode)
;; (global-set-key (kbd "C-c a l") 'ace-jump-line-mode)
;; (global-set-key (kbd "C-c a c") 'ace-jump-char-mode)
;; (global-set-key (kbd "M-/") 'hippie-expand)
;; (global-set-key [(control ?.)] 'goto-last-change)
;; (global-set-key [(control ?,)] 'goto-last-change-reverse)
(global-set-key (kbd "<down>") (ignore-error-wrapper 'windmove-down))
(global-set-key (kbd "<up>") (ignore-error-wrapper 'windmove-up))
(global-set-key (kbd "<left>") (ignore-error-wrapper 'windmove-left))
(global-set-key (kbd "<right>") (ignore-error-wrapper 'windmove-right))

;; Load a personal.el file if it exists
;; to be able to override stuff in here
(if (file-exists-p "~/.emacs.d/personal.el")
    (load "personal"))

(server-start)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   (quote
    ("af9761c65a81bd14ee3f32bc2ffc966000f57e0c9d31e392bc011504674c07d6" "a4f8d45297894ffdd98738551505a336a7b3096605b467da83fae00f53b13f01" "1affe85e8ae2667fb571fc8331e1e12840746dae5c46112d5abb0c3a973f5f5a" "8aebf25556399b58091e533e455dd50a6a9cba958cc4ebb0aab175863c25b9a4" "de2c46ed1752b0d0423cde9b6401062b67a6a1300c068d5d7f67725adc6c3afb" "405fda54905200f202dd2e6ccbf94c1b7cc1312671894bc8eca7e6ec9e8a41a2" "41b6698b5f9ab241ad6c30aea8c9f53d539e23ad4e3963abff4b57c0f8bf6730" "b47a3e837ae97400c43661368be754599ef3b7c33a39fd55da03a6ad489aafee" default)))
 '(feature-cucumber-command "bundle exec cucumber {options} {feature}")
 '(magit-emacsclient-executable "/usr/local/bin/emacsclient")
 '(magit-restore-window-configuration t)
 '(magit-server-window-for-commit nil)
 '(scss-compile-at-save nil))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(diff-added ((t (:inherit diff-changed :foreground "#00cc33"))))
 '(diff-context ((t (:background "#3c3c35" :foreground "#666666"))))
 '(diff-removed ((t (:inherit diff-changed :foreground "#ff0000"))))
 '(erb-face ((t nil)))
 '(erb-out-delim-face ((t (:foreground "#aaffff"))))
 '(error ((t (:foreground "pink2" :underline nil :weight normal))))
 '(magit-diff-add ((t (:inherit diff-added :background "#3c3c35"))))
 '(magit-diff-del ((t (:inherit diff-removed :background "#3c3c35"))))
 '(magit-item-highlight ((t (:background "#3c3c35"))))
 '(web-mode-html-attr-name-face ((t (:foreground "dark gray" :underline nil :weight normal))))
 '(web-mode-html-tag-bracket-face ((t (:foreground "gray58" :underline nil :weight normal))))
 '(web-mode-html-tag-face ((t (:foreground "dark cyan" :underline nil :weight normal)))))
(put 'downcase-region 'disabled nil)
(put 'dired-find-alternate-file 'disabled nil)
