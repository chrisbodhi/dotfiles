;; -*- no-byte-compile: t; -*-
;;; .doom.d/packages.el
;;;
;;; Run `doom reload' after adding a package here

;;; Examples:
;; (package! some-package)
;; (package! another-package :recipe (:host github :repo "username/repo"))
;; (package! builtin-package :disable t)
(package! alert)
(package! counsel-jq)
(package! dockerfile-mode)
(package! emojify)
(package! exec-path-from-shell)
(package! git-link)
(package! hydra) ;; for org-fc
(package! json-mode)
(package! olivetti)
(package! org-alert)
(package! org-auto-tangle)
(package! magit-section) ;; startup issues depend on this (2 jul 12021)
;; (package! realgud-node-inspect)
(package! restclient)
(package! sparql-mode)
(package! super-save)
(package! vterm)
(package! wakatime-mode)
(package! writeroom-mode)
(package! zetteldeft)

(package! flycheck-inline :recipe
  (:host github
  :repo "flycheck/flycheck-inline"
  :files ("flycheck-inline.el")))

(package! i-ching :recipe
  (:host github
   :repo "zzkt/i-ching"
   :branch "endless"))

(package! ob-restclient :recipe
  (:host github
   :repo "alf/ob-restclient.el"
   :files ("ob-restclient.el")))

(package! oblique :recipe
  (:host github
   :repo "zzkt/oblique-strategies"
   :branch "endless"))

(package! org-fc :recipe
  (:type git
   :repo "https://git.sr.ht/~l3kn/org-fc"
   :files (:defaults "awk")))

(package! ttl-mode :recipe
  (:host github
   :repo "jeeger/ttl-mode"))

(package! unison-mode :recipe
  (:host github
   :repo "dariooddenino/unison-mode-emacs"
   :branch "master"))

(package! wwg :recipe
  (:host github
   :repo "ag91/writer-word-goals"
   :branch "master"))
