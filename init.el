(progn
  (defvar bootstrap-version)
  (let ((bootstrap-file
         (expand-file-name "straight/repos/straight.el/bootstrap.el" user-emacs-directory))
        (bootstrap-version 5))
    (unless (file-exists-p bootstrap-file)
      (with-current-buffer
          (url-retrieve-synchronously
           "https://raw.githubusercontent.com/raxod502/straight.el/develop/install.el"
           'silent 'inhibit-cookies)
        (goto-char (point-max))
        (eval-print-last-sexp)))
    (load bootstrap-file nil 'nomessage)))

(progn
  (straight-use-package 'use-package)
  (setq straight-use-package-by-default t))



(progn
  (setq blue "#217dd9") (setq light-blue "#a6d2ff")
  (setq cyan "cyan") (setq light-cyan "lightcyan")
  (setq green "#24b353") (setq light-green "lightgreen")
  (setq magenta "magenta") (setq light-magenta "lightmagenta")
  (setq red "#b33024") (setq light-red "lightred")
  (setq yellow "#d9b500") (setq light-yellow "lightyellow"))




(progn
  (tool-bar-mode -1)
  (menu-bar-mode -1)

  (use-package git-gutter-fringe
    :config
    (setq-default fringes-outside-margins t)
    (progn
      (define-fringe-bitmap 'git-gutter-fr:added [224] nil nil '(center repeated))
      (define-fringe-bitmap 'git-gutter-fr:modified [224] nil nil '(center repeated))
      (define-fringe-bitmap 'git-gutter-fr:deleted [128 192 224 240] nil nil 'bottom)))

  (with-eval-after-load "evil"
    (setq evil-normal-state-cursor `(,red (box . 3)))
    (setq evil-visual-state-cursor `(,green (bar . 3)))
    (setq evil-insert-state-cursor `(,blue (bar . 3))))

  (use-package pretty-mode
    :config
    (global-pretty-mode t))

  (setq-default mode-line-format '("%e "
                                   mode-line-modified
                                   " "
                                   mode-line-buffer-identification))
  (use-package nav-flash
    :config
    (add-hook 'evil-jumps-post-jump-hook 'nav-flash-show)
    (dolist (fn '(evil-window-top evil-window-middle evil-window-bottom))
      (advice-add fn :after 'nav-flash-show)))

  (fringe-mode '(4 . 0))

  ;; M-x
  (use-package smex
    :config
    (smex-initialize)
    (global-set-key (kbd "M-x") 'smex)))


(progn
  (use-package evil
    :init
    (setq evil-want-keybinding nil)
    :config
    (evil-mode t)

    (evil-define-key nil evil-normal-state-map
      "\C-h" 'evil-window-left
      "\C-j" 'evil-window-down
      "\C-k" 'evil-window-up
      "\C-l" 'evil-window-right)

    (global-set-key (kbd "C-x C-g") 'evil-show-file-info))


  (use-package evil-collection
    :after evil
    :config
    (evil-collection-init))

  (use-package evil-commentary
    :config
    (evil-commentary-mode 1))

  (use-package evil-leader
    :init (global-evil-leader-mode)
    :config
    (evil-leader/set-leader "<SPC>")

    (evil-leader/set-key-for-mode 'clojure-mode
      "e" 'cider-eval-sexp-at-point)
    (evil-leader/set-key-for-mode 'emacs-lisp-mode
      "e" 'eval-last-sexp)))


(progn
  (use-package clojure-mode)

  (use-package cider
    ;; :hook (clojure-mode . cider-mode)
    :init
    (setq cider-allow-jack-in-without-project t)
    (setq cider-repl-pop-to-buffer-on-connect nil)
    (setq cljr-suppress-no-project-warning t)
    (setq cider-repl-display-help-banner nil))

  ;; sayid
  ;; clj-refactor

  (progn
    ; TODO: delete char should delete entire word
    (defun clojure/fancify-symbols (mode)
      (font-lock-add-keywords
        mode
        `(("(\\(fn\\)[\[[:space:]]" (0 (progn (compose-region (match-beginning 1) (match-end 1) "λ"))))
          ("(\\(partial\\)[\[[:space:]]" (0 (progn (compose-region (match-beginning 1) (match-end 1) "Ƥ"))))
          ("(\\(comp\\)[\[[:space:]]" (0 (progn (compose-region (match-beginning 1) (match-end 1) "∘"))))
          ("\\(#\\)(" (0 (progn (compose-region (match-beginning 1) (match-end 1) "ƒ"))))
          ("\\(#\\){" (0 (progn (compose-region (match-beginning 1) (match-end 1) "∈")))))))
    (clojure/fancify-symbols 'clojure-mode)))





(progn
  (use-package parinfer
    :init
    (add-hook 'emacs-lisp-mode-hook #'parinfer-mode)
    (add-hook 'clojure-mode-hook #'parinfer-mode)))
    ;; (setq parinfer-extensions '(defaults)
    ;;                            pretty-parens
    ;;                            ;; evil
    ;;                            smart-tab
    ;;                            smart-yank)))


(progn

  (progn
    (set-face-attribute 'default nil
       :font "JetBrainsMono Nerd Font Mono"
       :height 58
       :weight 'thin
       :foreground "white" :background "black")
    
    (progn
      (set-face-attribute 'mode-line-inactive nil
        :background "#111" :foreground "white"
        :box `(:line-width 3 :color "#111"))

      (set-face-attribute 'mode-line nil
        :background "#3c3c3c" :foreground "white"
        :box `(:line-width 3 :color "#222")))))


(defalias 'yes-or-no-p 'y-or-n-p)
;; (fset #'yes-or-no-p #'y-or-n-p)


(add-hook 'clojure-mode-hook #'subword-mode)





(progn
  (require 'color)
  (defun hsl-to-hex (&rest args)
    (apply 'color-rgb-to-hex (apply 'color-hsl-to-rgb args))))


(progn
  (use-package rainbow-delimiters
    :init
    ; TODO: not working
    (add-hook 'prog-mode-hook #'rainbow-delimiters-mode)
    :config
    (progn
      (let (value)
        (dotimes (number 9 value)
          (set-face-attribute (intern (concat "rainbow-delimiters-depth-"
                                              (number-to-string (+ 1 number))
                                              "-face")) nil
                              :weight 'bold
                              :foreground (hsl-to-hex (/ (* (/ 100 8) number) 85.0)
                                                      1
                                                      (+ 0.45 (/ (* number 4) 100.0)))))))))



(use-package cider-eval-sexp-fu)



(progn
  (setq-default tab-width 2
                indent-tabs-mode nil))



(progn
  ;; put backups in temp dir
  (setq backup-directory-alist `((".*" . ,temporary-file-directory)))
  (setq auto-save-file-name-transforms `((".*" ,temporary-file-directory t))))



;; auto-close delimiters
(use-package smartparens
  :config
  (require 'smartparens-config)
  (smartparens-global-mode +1))



