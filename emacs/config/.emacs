;; Make sure package archives are loaded
(require 'package)

;; Initialize packages
(package-initialize)

;; Increase GC thresholds to improve performance
(setq gc-cons-threshold 402653184 gc-cons-percentage 0.6)

;; Sets the title bar window to 'emacs@<the-pc-user>'
(setq frame-title-format
      '("emacs@" (:eval (user-login-name))))

;; Add Melpa repository
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)

;; Set default font
(when (display-graphic-p)
  (let ((jetbrains-font "JetBrains Mono-14")
        (iosevka-font "Iosevka Term Extended-14")
        (consolas-font "Consolas-14")
        (default-font (face-attribute 'default :font)))
    (cond
     ((find-font (font-spec :name jetbrains-font))
      (set-frame-font jetbrains-font))
     ((find-font (font-spec :name iosevka-font))
      (set-frame-font iosevka-font))
     ((find-font (font-spec :name consolas-font))
      (set-frame-font consolas-font))
     (t
      (set-frame-font default-font)))))

(tool-bar-mode -1)
(menu-bar-mode -1)
(scroll-bar-mode -1)
(column-number-mode t)
(show-paren-mode t)
(electric-pair-mode t)
(savehist-mode t)
(set-fringe-mode 10)
(save-place-mode 1)
(global-auto-revert-mode 1)
(delete-selection-mode 1)
(icomplete-mode 1)
(visual-line-mode 1)
(setq use-dialog-box nil)
(setq native-comp-async-jobs-number 1)
(setq visible-bell t)
(setq frame-inhibit-implied-resize nil)
(setq backups-by-copying t)
(setq load-prefer-newer t)
(setq require-final-newline t)
(setq isearch-allow-scroll t)
(setq isearch-wrap-function (lambda () (goto-char (point-min))))

;; Line numbers
(setq display-line-numbers-type 'relative)
(global-display-line-numbers-mode)

;; Disable line numbers for some modes
(dolist (mode '(org-mode-hook
                term-mode-hook
                shell-mode-hook
                treemacs-mode-hook
                eshell-mode-hook))
  (add-hook mode (lambda () (display-line-numbers-mode 0))))

;; Disable auto backup and auto save options
(setq backup-inhibited t)
(setq auto-save-default nil)

;; Install use-package if it's not already installed
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(eval-when-compile
  (require 'use-package))

;; Install async if not already installed
(use-package async
  :ensure t
  :defer t)

;; Make background tasks asynchronous to improve performance
(async-bytecomp-package-mode 1)

;; Install doom-themes if it's not already installed
(use-package doom-themes
  :ensure t
  :defer t)

;; Install gruber-darker-theme if it's not already installed
(use-package gruber-darker-theme
  :ensure t
  :defer t)

;; Configure the theme
(load-theme 'gruber-darker t)

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
(setq-default tab-width 4)

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
  (isearch-repeat-backwardlist-directory default-directory))

(define-key global-map (kbd "C-x C-l") 'my-list-directory)

;; Remap up and down arrow keys to go up or down an inputted amount of lines accordingly after pressing control + x
(defun move-cursor-lines (lines direction)
  "Move cursor up or down LINES lines in DIRECTION."
  (interactive (list (read-number "Number of lines to move: ")
                     (completing-read "Cursor direction (u/d): "
                                      '(("u" . "up") ("d" . "down"))
                                      nil t)))
  (if (equal direction "u")
      (previous-line lines)
    (next-line lines)))

(global-set-key (kbd "C-x C-<up>") (lambda () (interactive) (move-cursor-lines (read-number "Number of lines to move: ") "u")))
(global-set-key (kbd "C-x C-<down>") (lambda () (interactive) (move-cursor-lines (read-number "Number of lines to move: ") "d")))

;; Remap control + x and control + t to open a shell
(defun open-terminal ()
  "Open a new shell on top of the current buffer."
  (interactive)
  (shell))

(global-set-key (kbd "C-x C-t") 'open-terminal)

;; Remap C-x C-/ to comment lines normally, but when the commented is completed, it wont push your cursor down by one line
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

(global-set-key (kbd "C-x C-/") 'comment-or-uncomment-line-or-region)

;; Remap C-x C-; to replace the inputted text using query-replace
(global-set-key (kbd "C-x C-;") 'query-replace)

;; Remap C-x C-' to delete the current function your cursor is in
(defun delete-current-function ()
  "Delete the entire function that point is in, including the function name."
  (interactive)
  (save-excursion
    (beginning-of-defun)
    (let* ((start (point))
           (name (progn
                   (re-search-forward "^\\s-*\\(\\S-+\\).*\\_<(" (line-end-position) t)
                   (match-string-no-properties 1)))
           (end (progn
                  (end-of-defun)
                  (line-end-position))))
      (delete-region start end)
      (message "Deleted function: %s" name))))

(global-set-key (kbd "C-x C-'") 'delete-current-function)

;; Install and require projectile if not already installed
(use-package projectile
  :ensure t
  :defer t)

(projectile-mode +1)

;; Remap C-x C-, to find the definition of a function
(global-set-key (kbd "C-x C-,") 'xref-find-definitions)

;; Remap C-x C-. to return to your previous location after finding the definition of a function
(global-set-key (kbd "C-x C-.") 'pop-global-mark)

(add-hook 'before-save-hook 'delete-trailing-whitespace)

;; Install and require evil if not already installed
;; (use-package evil
;;   :ensure t
;;   :defer t)

;; ;; Enable evil mode
;; (evil-mode 1)
;; (setq evil-ex-visual-char-range t)

;; Install and require dashboard if not already installed
(use-package dashboard
  :ensure t
  :defer t)

(setq dashboard-banner-logo-title (format "Hello %s, Welcome to the Emacs Dashboard!"
                                          (or (user-login-name) "unknown")))
(setq dashboard-startup-banner 'logo)
(setq dashboard-center-content t)
(setq dashboard-items '((recents  . 5)
                        (bookmarks . 5)
                        (projects . 5)))
(setq dashboard-footer-messages '("If there are any issues, contact me on Discord at 'i love her#9763'"))

(dashboard-setup-startup-hook)

;; Haskell mode
(use-package haskell-mode
  :ensure t
  :defer t)

(setq haskell-process-type 'cabal-new-repl)
(setq haskell-process-log t)

(add-hook 'haskell-mode-hook 'haskell-indent-mode)
(add-hook 'haskell-mode-hook 'interactive-haskell-mode)
(add-hook 'haskell-mode-hook 'haskell-doc-mode)
(add-hook 'haskell-mode-hook 'hindent-mode)

;; Yasnippet
(use-package yasnippet
  :ensure t
  :defer t)

(setq yas/triggers-in-field nil)
(setq yas-snippet-dirs '("~/.emacs.snippets/"))

(yas-global-mode 1)

;; Nxml
(add-to-list 'auto-mode-alist '("\\.html\\'" . nxml-mode))
(add-to-list 'auto-mode-alist '("\\.xsd\\'" . nxml-mode))
(add-to-list 'auto-mode-alist '("\\.ant\\'" . nxml-mode))

;; Powershell
(use-package powershell
  :ensure t
  :defer t)

(add-to-list 'auto-mode-alist '("\\.ps1\\'" . powershell-mode))
(add-to-list 'auto-mode-alist '("\\.psm1\\'" . powershell-mode))

;; Nasm Mode
(use-package nasm-mode
  :ensure t
  :defer t)

(add-to-list 'auto-mode-alist '("\\.asm\\'" . nasm-mode))

;; LaTeX mode
(add-hook 'tex-mode-hook
          (lambda ()
            (interactive)
            (add-to-list 'tex-verbatim-environments "code")))

(setq font-latex-fontify-sectioning 'color)

;; Move Text
(use-package move-text
  :ensure t
  :defer t)

(global-set-key (kbd "M-<up>") 'move-text-up)
(global-set-key (kbd "M-<down>") 'move-text-down)

;; Ido
(use-package ido-completing-read+
  :ensure t
  :defer t)

(ido-mode 1)
(ido-everywhere 1)
(ido-ubiquitous-mode 1)

;; Ebisp
(add-to-list 'auto-mode-alist '("\\.ebi\\'" . lisp-mode))

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
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   '(lsp-ui lsp-mode ido-completing-read+ async company-tabnine dashboard doom-themes evil git-commit gruber-darker-theme haskell-mode memoize move-text nasm-mode powershell projectile proof-general smartparens yasnippet)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
