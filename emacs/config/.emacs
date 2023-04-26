(package-initialize)

(load "~/.emacs.rc/rc.el")
(load "~/.emacs.rc/misc-rc.el")
(load "~/.emacs.rc/org-mode-rc.el")
(load "~/.emacs.rc/autocommit-rc.el")

;; Appearance
(defun rc/get-default-font ()
  (cond
   ((eq system-type 'windows-nt) "Consolas-13")
   ((eq system-type 'gnu/linux) "Iosevka-20")))

(add-to-list 'default-frame-alist `(font . ,(rc/get-default-font)))

(tool-bar-mode 0)
(menu-bar-mode 0)
(scroll-bar-mode 0)
(column-number-mode 1)
(show-paren-mode 1)
(electric-pair-mode t)
(setq isearch-allow-scroll t)
(setq isearch-wrap-function (lambda () (goto-char (point-min))))

;; Install use-package if it's not already installed
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

;; Install doom-themes if it's not already installed
(unless (package-installed-p 'doom-themes)
  (package-refresh-contents)
  (package-install 'doom-themes))

;; Configure the theme
;;(use-package doom-themes
;;  :config
;;  (load-theme 'doom-one t))

(rc/require-theme 'gruber-darker)
;;(rc/require-theme 'zenburn)

;; Ido
(rc/require 'smex 'ido-completing-read+)

(require 'ido-completing-read+)

(ido-mode 1)
(ido-everywhere 1)
(ido-ubiquitous-mode 1)

(global-set-key (kbd "M-x") 'smex)
(global-set-key (kbd "C-c C-c M-x") 'execute-extended-command)

;; C-mode
(setq-default c-basic-offset 4
              c-default-style '((java-mode . "java")
                                (awk-mode . "awk")
                                (other . "bsd")))

(add-hook 'c-mode-hook (lambda ()
                         (interactive)
                         (c-toggle-comment-style -1)))

;; Tab settings
(setq-default indent-tabs-mode nil)
(setq-default tab-width 8)

;; Relative line numbers
(setq display-line-numbers-type 'relative)
(global-display-line-numbers-mode)

;; Remap up and down arrow keys to go up a down one line at a time when holding control
(global-set-key (kbd "<C-up>") 'previous-line)
(global-set-key (kbd "<C-down>") 'next-line)

;; Remap up and down arrow keys to have normal 1 line accordingly functionality, and left and right arrow keys to go to beginning and end of line when held with alt/meta while maintaining normal up and down functionality
(global-set-key (kbd "<M-up>") 'previous-line)
(global-set-key (kbd "<M-left>") 'move-beginning-of-line)
(global-set-key (kbd "<M-down>") 'next-line)
(global-set-key (kbd "<M-right>") 'move-end-of-line)

;; Remap control + shift + s to go back a search instead of forward, and control + s with still go forward
(defun my-isearch-backward ()
  (interactive)
  (isearch-repeat-backward))

(define-key isearch-mode-map (kbd "C-S-s") 'my-isearch-backward)

;; Remap directory editor to control + x and control + d
(define-key global-map (kbd "C-x C-d") 'dired)

;; Remap list directory to control + x and control + l
(defun my-list-directory ()
  "List the contents of the directory of the current buffer."
  (interactive)
  (list-directory default-directory))

(define-key global-map (kbd "C-x C-l") 'my-list-directory)

;; Remap up and down arrow keys to go up or down an inputted amount of lines accordingly after pressing control + x
(defun move-cursor-lines (lines direction)
  "Move cursor up or down LINES lines in DIRECTION."
  (interactive (list (read-number "Number of lines to move: ")
                     (read-char "Cursor direction (u/d): ")))
  (if (equal direction ?u)
      (previous-line lines)
    (next-line lines))
  (message "Moved %d line%s %s." lines (if (= lines 1) "" "s") (if (equal direction ?u) "up" "down")))

(global-set-key (kbd "C-x <up>") (lambda () (interactive) (move-cursor-lines (read-number "Number of lines to move: ") ?u)))
(global-set-key (kbd "C-x <down>") (lambda () (interactive) (move-cursor-lines (read-number "Number of lines to move: ") ?d)))

;; Remap control + x and control + t to open a shell
(defun open-terminal ()
  "Open a new shell on top of the current buffer."
  (interactive)
  (shell))

(global-set-key (kbd "C-x C-t") 'open-terminal)

;; Remap C-x C-; to comment lines normally, but when the commented is completed, it wont push your cursor down by one line
(defun comment-or-uncomment-line-or-region ()
  "Comments or uncomments the current line or region."
  (interactive)
  (let ((beg (line-beginning-position))
        (end (line-end-position)))
    (if (region-active-p)
        (comment-or-uncomment-region (region-beginning) (region-end))
      (progn
        (comment-or-uncomment-region beg end)
        (when (and (= beg (line-beginning-position))
                   (= end (line-end-position)))
          (forward-line))))))

(global-set-key (kbd "C-x C-;") 'comment-or-uncomment-line-or-region)

;; TODO: Find a way to make this downcase region work without being overwritten by dired

;; Paredit
(rc/require 'paredit)

(defun rc/turn-on-paredit ()
  (interactive)
  (paredit-mode 1))

(add-hook 'emacs-lisp-mode-hook  'rc/turn-on-paredit)
(add-hook 'clojure-mode-hook     'rc/turn-on-paredit)
(add-hook 'lisp-mode-hook        'rc/turn-on-paredit)
(add-hook 'common-lisp-mode-hook 'rc/turn-on-paredit)
(add-hook 'scheme-mode-hook      'rc/turn-on-paredit)
(add-hook 'before-save-hook      'delete-trailing-whitespace)

;; Install and require magit if not already installed
(unless (package-installed-p 'magit)
  (package-refresh-contents)
  (package-install 'magit))
  (require 'magit)

(setq magit-auto-revert-mode nil)

;; Install and require ivy if not already installed
;; (unless (package-installed-p 'ivy)
;; (package-refresh-contents)
;; (package-install 'ivy))
;; (require 'ivy)

;; Install and require counsel if not already installed
;; (unless (package-installed-p 'counsel)
;; (package-refresh-contents)
;; (package-install 'counsel))
;; (require 'counsel)

;; Install and require evil if not already installed
(unless (package-installed-p 'evil)
  (package-refresh-contents)
  (package-install 'evil))
  (require 'evil)

;; Enable evil mode
(evil-mode 1)
(setq evil-ex-visual-char-range t)

;; Emacs lisp
(add-hook 'emacs-lisp-mode-hook
          '(lambda ()
             (local-set-key (kbd "C-c C-j")
                            (quote eval-print-last-sexp))))
(add-to-list 'auto-mode-alist '("Cask" . emacs-lisp-mode))

;; Make sure package archives are loaded
(require 'package)

;; Add Melpa repository
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)

;; Install async if not already installed
(unless (package-installed-p 'async)
  (package-refresh-contents)
  (package-install 'async))

;; Make background tasks asynchronous to improve performance
(async-bytecomp-package-mode 1)

;; Optimized garabge collector
(setq gc-cons-threshold (* 100 1024 1024)) ;; set threshold to 100 MB
(setq gc-cons-percentage 0.1) ;; use 10% of threshold before garbage collecting

;; Disable auto backup and auto save options
(setq backup-inhibited t)
(setq auto-save-default nil)

;; Compile settings (G++ is used by default for c++)
(setq-default compile-command "g++ -o ")

;; Haskell mode
(rc/require 'haskell-mode)

(setq haskell-process-type 'cabal-new-repl)
(setq haskell-process-log t)

(add-hook 'haskell-mode-hook 'haskell-indent-mode)
(add-hook 'haskell-mode-hook 'interactive-haskell-mode)
(add-hook 'haskell-mode-hook 'haskell-doc-mode)
(add-hook 'haskell-mode-hook 'hindent-mode)

;; Whitespace mode
(defun rc/set-up-whitespace-handling ()
  (interactive)
  (whitespace-mode 0)
  (add-to-list 'write-file-functions 'delete-trailing-whitespace))

(add-hook 'tuareg-mode-hook 'rc/set-up-whitespace-handling)
(add-hook 'c++-mode-hook 'rc/set-up-whitespace-handling)
(add-hook 'c-mode-hook 'rc/set-up-whitespace-handling)
(add-hook 'simpc-mode-hook 'rc/set-up-whitespace-handling)
(add-hook 'emacs-lisp-mode 'rc/set-up-whitespace-handling)
(add-hook 'java-mode-hook 'rc/set-up-whitespace-handling)
(add-hook 'lua-mode-hook 'rc/set-up-whitespace-handling)
(add-hook 'rust-mode-hook 'rc/set-up-whitespace-handling)
(add-hook 'scala-mode-hook 'rc/set-up-whitespace-handling)
(add-hook 'markdown-mode-hook 'rc/set-up-whitespace-handling)
(add-hook 'haskell-mode-hook 'rc/set-up-whitespace-handling)
(add-hook 'python-mode-hook 'rc/set-up-whitespace-handling)
(add-hook 'erlang-mode-hook 'rc/set-up-whitespace-handling)
(add-hook 'asm-mode-hook 'rc/set-up-whitespace-handling)
(add-hook 'nasm-mode-hook 'rc/set-up-whitespace-handling)
(add-hook 'go-mode-hook 'rc/set-up-whitespace-handling)
(add-hook 'nim-mode-hook 'rc/set-up-whitespace-handling)
(add-hook 'yaml-mode-hook 'rc/set-up-whitespace-handling)
(add-hook 'porth-mode-hook 'rc/set-up-whitespace-handling)

;; display-line-numbers-mode
(when (version<= "26.0.50" emacs-version)
  (global-display-line-numbers-mode))

(global-set-key (kbd "C-c m s") 'magit-status)
(global-set-key (kbd "C-c m l") 'magit-log)

;; multiple cursors
(rc/require 'multiple-cursors)

(global-set-key (kbd "C-S-c C-S-c") 'mc/edit-lines)
(global-set-key (kbd "C->")         'mc/mark-next-like-this)
(global-set-key (kbd "C-<")         'mc/mark-previous-like-this)
(global-set-key (kbd "C-c C-<")     'mc/mark-all-like-this)
(global-set-key (kbd "C-\"")        'mc/skip-to-next-like-this)
(global-set-key (kbd "C-:")         'mc/skip-to-previous-like-this)

;; dired
(require 'dired-x)
(setq dired-omit-files
      (concat dired-omit-files "\\|^\\..+$"))
(setq-default dired-dwim-target t)
(setq dired-listing-switches "-alh")

;; yasnippet
(rc/require 'yasnippet)

(require 'yasnippet)

(setq yas/triggers-in-field nil)
(setq yas-snippet-dirs '("~/.emacs.snippets/"))

(yas-global-mode 1)

;; word-wrap
(defun rc/enable-word-wrap ()
  (interactive)
  (toggle-word-wrap 1))

(add-hook 'markdown-mode-hook 'rc/enable-word-wrap)

;; nxml
(add-to-list 'auto-mode-alist '("\\.html\\'" . nxml-mode))
(add-to-list 'auto-mode-alist '("\\.xsd\\'" . nxml-mode))
(add-to-list 'auto-mode-alist '("\\.ant\\'" . nxml-mode))

;; tramp
;; http://stackoverflow.com/questions/13794433/how-to-disable-autosave-for-tramp-buffers-in-emacs
(setq tramp-auto-save-directory "/tmp")

;; powershell
(rc/require 'powershell)
(add-to-list 'auto-mode-alist '("\\.ps1\\'" . powershell-mode))
(add-to-list 'auto-mode-alist '("\\.psm1\\'" . powershell-mode))

;; eldoc mode
(defun rc/turn-on-eldoc-mode ()
  (interactive)
  (eldoc-mode 1))

(add-hook 'emacs-lisp-mode-hook 'rc/turn-on-eldoc-mode)

;; Company
(rc/require 'company)
(require 'company)

(global-company-mode)

(add-hook 'tuareg-mode-hook
          (lambda ()
            (interactive)
            (company-mode 0)))

;; Tide
(rc/require 'tide)

(defun rc/turn-on-tide ()
  (interactive)
  (tide-setup))

(add-hook 'typescript-mode-hook 'rc/turn-on-tide)

;; Proof general
(rc/require 'proof-general)
(add-hook 'coq-mode-hook
          '(lambda ()
             (local-set-key (kbd "C-c C-q C-n")
                            (quote proof-assert-until-point-interactive))))

;; Nasm Mode
(rc/require 'nasm-mode)
(add-to-list 'auto-mode-alist '("\\.asm\\'" . nasm-mode))

;; LaTeX mode
(add-hook 'tex-mode-hook
          (lambda ()
            (interactive)
            (add-to-list 'tex-verbatim-environments "code")))

(setq font-latex-fontify-sectioning 'color)

;; Move Text
(rc/require 'move-text)
(global-set-key (kbd "M-p") 'move-text-up)
(global-set-key (kbd "M-n") 'move-text-down)

;; Ebisp
(add-to-list 'auto-mode-alist '("\\.ebi\\'" . lisp-mode))

;; Packages that don't require configuration
(rc/require
 'scala-mode
 'd-mode
 'yaml-mode
 'glsl-mode
 'tuareg
 'lua-mode
 'less-css-mode
 'graphviz-dot-mode
 'clojure-mode
 'cmake-mode
 'rust-mode
 'csharp-mode
 'nim-mode
 'jinja2-mode
 'markdown-mode
 'purescript-mode
 'nix-mode
 'dockerfile-mode
 'toml-mode
 'nginx-mode
 'kotlin-mode
 'go-mode
 'php-mode
 'racket-mode
 'qml-mode
 'ag
 'hindent
 'elpy
 'typescript-mode
 'rfc-mode
 'sml-mode
 )

(load "~/.emacs.shadow/shadow-rc.el" t)

(add-to-list 'load-path "~/.emacs.local/")
(require 'basm-mode)
(require 'porth-mode)
(require 'noq-mode)
(require 'jai-mode)

(require 'simpc-mode)
(add-to-list 'auto-mode-alist '("\\.[hc]\\(pp\\)?\\'" . simpc-mode))

(defun astyle-buffer (&optional justify)
  (interactive)
  (let ((saved-line-number (line-number-at-pos)))
    (shell-command-on-region
     (point-min)
     (point-max)
     "astyle --style=kr"
     nil
     t)
    (goto-line saved-line-number)))

(add-hook 'simpc-mode-hook
          (lambda ()
            (interactive)
            (setq-local fill-paragraph-function 'astyle-buffer)))

(require 'compile)

;; pascalik.pas(24,44) Error: Can't evaluate constant expression

compilation-error-regexp-alist-alist

(add-to-list 'compilation-error-regexp-alist
             '("\\([a-zA-Z0-9\\.]+\\)(\\([0-9]+\\)\\(,\\([0-9]+\\)\\)?) \\(Warning:\\)?"
               1 2 (4) (5)))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(display-line-numbers-type (quote relative))
 '(org-agenda-dim-blocked-tasks nil)
 '(org-agenda-exporter-settings (quote ((org-agenda-tag-filter-preset (list "+personal")))))
 '(org-cliplink-transport-implementation (quote url-el))
 '(org-enforce-todo-dependencies nil)
 '(org-modules
   (quote
    (org-bbdb org-bibtex org-docview org-gnus org-habit org-info org-irc org-mhe org-rmail org-w3m)))
 '(org-refile-useoutline-path (quote file))
 '(package-selected-packages
   (quote
    (rainbow-mode proof-general elpy hindent ag qml-mode racket-mode php-mode go-mode kotlin-mode nginx-mode toml-mode dockerfile-mode nix-mode purescript-mode markdown-mode jinja2-mode nim-mode csharp-mode rust-mode cmake-mode clojure-mode graphviz-dot-mode lua-mode tuareg glsl-mode yaml-mode d-mode scala-mode move-text nasm-mode editorconfig tide company powershell js2-mode yasnippet helm-ls-git helm-git-grep helm-cmd-t helm multiple-cursors magit haskell-mode paredit ido-completing-read+ smex gruber-darker-theme org-cliplink dash-functional dash)))
 '(safe-local-variable-values
   (quote
    ((eval progn
           (auto-revert-mode 1)
           (rc/autopull-changes)
           (add-hook
            (quote after-save-hook)
            (quote rc/autocommit-changes)
            nil
            (quote make-it-local))))))
 '(whitespace-style
   (quote
    (face tabs spaces trailing space-before-tab newline indentation empty space-after-tab space-mark tab-mark))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
