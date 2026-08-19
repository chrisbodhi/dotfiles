;;; .doom.d/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here

(require 'doom-themes)

(setq doom-themes-enable-bold t
      doom-themes-enable-italic t)

(load-theme 'doom-solarized-light t)

(doom-themes-visual-bell-config)

(doom-themes-neotree-config)

(doom-themes-org-config)

(setq doom-modeline-vcs-max-length 42)

;; Initialize elfeed-org
(elfeed-org)


;; Be able to set image sizes in org-mode
(setq org-image-actual-width nil)

;; Set up emojify
(add-hook 'after-init-hook #'global-emojify-mode)

;; Back to the future
(setq python-shell-interpreter "python3"
      flycheck-python-pycompile-executable "python3")

;; For plantuml and drawing entity relationship diagrams
;; installed with `nix-env i plantuml`
(setq org-plantuml-jar-path
      (expand-file-name "~/.nix-profile/lib/plantuml.jar"))

;; For org files with the following header at top, tangle on save
;; #+auto_tangle: t
(use-package! org-auto-tangle
  :defer t
  :hook (org-mode . org-auto-tangle-mode)
  :config
  (setq org-auto-tangle-default t))

;; For pasting images from the clipboard to an org file
;; https://zzamboni.org/post/how-to-insert-screenshots-in-org-documents-on-macos/
(use-package org-download
  :after org
  :defer nil
  :custom
  (org-download-method 'directory)
  (org-download-image-dir "images")
  (org-download-heading-lvl nil)
  (org-download-timestamp "%Y%m%d-%H%M%S_")
  (org-image-actual-width 300)
  (org-download-screenshot-method "/usr/local/bin/pngpaste %s")
  :bind
  ("s-p" . org-download-screenshot)
  :config
  (require 'org-download))

;; org-pomodoro config
(setq org-pomodoro-manual-break t)

;; Autosave on buffer lose focus
(super-save-mode +1)
(setq super-save-auto-save-when-idle t)
(setq auto-save-default nil)

;; add integration with ace-window
;; (add-to-list 'super-save-triggers 'ace-window)

;; save on find-file
;; (add-to-list 'super-save-hook-triggers 'find-file-hook 'focus-out-hook)




;; ...and the corresponding keybindings.
(evil-define-minor-mode-key '(normal insert emacs) 'org-fc-review-flip-mode
  (kbd "RET") 'org-fc-review-flip
  (kbd "n") 'org-fc-review-flip
  (kbd "s") 'org-fc-review-suspend-card
  (kbd "q") 'org-fc-review-quit)

(evil-define-minor-mode-key '(normal insert emacs) 'org-fc-review-rate-mode
  (kbd "a") 'org-fc-review-rate-again
  (kbd "h") 'org-fc-review-rate-hard
  (kbd "g") 'org-fc-review-rate-good
  (kbd "e") 'org-fc-review-rate-easy
  (kbd "s") 'org-fc-review-suspend-card
  (kbd "q") 'org-fc-review-quit)

;; Set up Golang LSP, gopls
;; https://github.com/golang/tools/blob/master/gopls/doc/emacs.md
;; -- start --
(use-package lsp-mode
  :commands (lsp lsp-deferred)
  :hook (go-mode . lsp-deferred))

;; Set up before-save hooks to add/delete imports.
;; Make sure you don't have other gofmt/goimports hooks enabled.
(defun lsp-go-install-save-hooks ()
  (add-hook 'before-save-hook #'lsp-organize-imports t t))
(add-hook 'go-mode-hook #'lsp-go-install-save-hooks)

;; Optional - provides fancier overlays.
(use-package lsp-ui
  :commands lsp-ui-mode)

;; lsp-mode configuration tweak
;; https://emacs-lsp.github.io/lsp-mode/page/performance/
(setq read-process-output-max (* 1024 1024))
;; set manually; unsure if worth keeping
;; (setq lsp-idle-delay 0.250)
;; (setq lsp-completion-provider :capf)

;; Company mode is a standard completion package that works well with lsp-mode.
(use-package company
  :config
  ;; Optionally enable completion-as-you-type behavior.
  (setq company-idle-delay 0)
  (setq company-minimum-prefix-length 1))

;; Optional - provides snippet support.
(use-package yasnippet
  :commands yas-minor-mode
  :hook (go-mode . yas-minor-mode))
;; -- end --

;; Configure goimports to add and remove imports as needed
(setq gofmt-command "goimports")
(add-hook 'before-save-hook 'gofmt-before-save)

;; get path from shell, as well as other env vars
(when (memq window-system '(mac ns x))
  (exec-path-from-shell-initialize))

;; Load up writer-word-goals, installed in packages.el
(require 'wwg)

;; Load up inline flycheck globally
;; Alternatively, one could enable for only certain modes
(with-eval-after-load 'flycheck
  (add-hook 'flycheck-mode-hook #'flycheck-inline-mode))

(use-package i-ching :config (setq i-ching-hexagram-size 48
  i-ching-hexagram-font "DejaVu Sans"
  i-ching-divination-method '3-coins
  i-ching-randomness-source 'pseudo))
