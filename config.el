;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets. It is optional.
;; (setq user-full-name "John Doe"
;;       user-mail-address "john@doe.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom:
;;
;; - `doom-font' -- the primary font to use
;; - `doom-variable-pitch-font' -- a non-monospace font (where applicable)
;; - `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;; - `doom-symbol-font' -- for symbols
;; - `doom-serif-font' -- for the `fixed-pitch-serif' face
;;
;; See 'C-h v doom-font' for documentation and more examples of what they
;; accept. For example:
;;
;;(setq doom-font (font-spec :family "Fira Code" :size 12 :weight 'semi-light)
;;      doom-variable-pitch-font (font-spec :family "Fira Sans" :size 13))
;;
;; If you or Emacs can't find your font, use 'M-x describe-font' to look them
;; up, `M-x eval-region' to execute elisp code, and 'M-x doom/reload-font' to
;; refresh your font settings. If Emacs still can't find your font, it likely
;; wasn't installed correctly. Font issues are rarely Doom issues!

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-one)

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")


;; Whenever you reconfigure a package, make sure to wrap your config in an
;; `after!' block, otherwise Doom's defaults may override your settings. E.g.
;;
;;   (after! PACKAGE
;;     (setq x y))
;;
;; The exceptions to this rule:
;;
;;   - Setting file/directory variables (like `org-directory')
;;   - Setting variables which explicitly tell you to set them before their
;;     package is loaded (see 'C-h v VARIABLE' to look up their documentation).
;;   - Setting doom variables (which start with 'doom-' or '+').
;;
;; Here are some additional functions/macros that will help you configure Doom.
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;; Alternatively, use `C-h o' to look up a symbol (functions, variables, faces,
;; etc).
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.

(setq lsp-rust-analyzer-server-command '("~/.local/bin/rust-analyzer" "rust-analyzer"))
(setq lsp-rust-analyzer-store-path "~/.local/bin/rust-analyzer")

;; (which-function-mode +1)
(setq completion-ignore-case t)
(setq undo-tree-enable-undo-in-region nil)


(use-package! copilot
  :hook (prog-mode . copilot-mode)
  :bind (:map copilot-completion-map
              ("<tab>" . 'copilot-accept-completion)
              ("TAB" . 'copilot-accept-completion)
              ("C-TAB" . 'copilot-accept-completion-by-word)
              ("C-<tab>" . 'copilot-accept-completion-by-word)))

(use-package! sequential-command)

(setq ein:worksheet-enable-undo t)
(setq ein:output-area-inlined-images t)

(setq confirm-nonexistent-file-or-buffer t)

;;(fset 'rainbow-delimiters-mode #'prism-mode)

(define-sequential-command seq-evil-visual-char
                           evil-visual-char er/expand-region seq-return)

(use-package! expand-region
  :bind (:map evil-motion-state-map
              ("v" . 'seq-evil-visual-char)))


(use-package! emmet-mode
  :hook (web-mode . emmet-mode)
  :hook (css-mode . emmet-mode)
  :hook (html-mode . emmet-mode)
  :hook (js-mode . emmet-mode)
  :hook (typescript-mode . emmet-mode))

(use-package! mistty
  :bind (("C-c s" . mistty)

         ;; bind here the shortcuts you'd like the
         ;; shell to handle instead of Emacs.
         :map mistty-prompt-map

         ;; fish: directory history
         ("M-<up>" . mistty-send-key)
         ("M-<down>" . mistty-send-key)
         ("M-<left>" . mistty-send-key)
         ("M-<right>" . mistty-send-key)))

(use-package! tramp
  :config
  ;; (tramp-default-method . "sshx")
  (add-to-list 'tramp-remote-path 'tramp-own-remote-path))

(use-package! llm
  :init
  (require 'llm-openai)
  (setq llm-refactoring-provider (make-llm-openai :key (getenv "EMACS_OPENAI_API_KEY") :chat-model "gpt-4o-mini" :embedding-model "text-embedding-3-small")))

(use-package! ellama
  :init
  (setopt ellama-keymap-prefix "C-c e")
  (setopt ellama-language "Japanese")
  (require 'llm-openai)
  (setopt ellama-provider (make-llm-openai :key (getenv "EMACS_OPENAI_API_KEY") :chat-model "gpt-4o-mini" :embedding-model "text-embedding-3-small")))

(use-package! ess
  :init
  (require 'ess-site))

(use-package! gptel
  :init
  (setq gptel-api-key (getenv "EMACS_ANTHROPIC_API_KEY"))
  :config
  (gptel-make-anthropic "Claude" :stream t :key gptel-api-key))

;; (use-package! transient)
;; (use-package! claude-code
;;   :bind ("C-c c" . claude-code-command-map)
;;   :hook ((claude-code--start . sm-setup-claude-faces))
;;   :config
;;   (setq claude-code-program "/usr/local/bin/claude"))
