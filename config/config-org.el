(setq org-export-time-stamp-file nil)
(setq org-html-validation-link nil)
(setq-default org-export-with-author nil)
(setq-default org-export-with-toc nil)
(setq-default org-use-sub-superscripts '{})
(setq-default org-export-with-sub-superscripts '{})

(org-babel-do-load-languages
 'org-babel-load-languages
 '((emacs-lisp . t)
   (shell . t)))

;; https://emacs.stackexchange.com/a/2247
(defun org-time-stamp-custom-formats-safep (value)
  "Return t if VALUE is safe for `org-time-stamp-custom-formats' as a
file-local variable."
  (and (consp value)
       (stringp (car value))
       (stringp (cdr value))))

(put 'org-time-stamp-custom-formats 'safe-local-variable
     #'org-time-stamp-custom-formats-safep)

(defun org-mode-setup ()
  "Setup Org mode."
  (visual-line-mode t)
  (setq truncate-lines nil)
  (if (executable-find ispell-program-name)
      (flyspell-mode))
  (electric-indent-local-mode 0))

(add-hook 'org-mode-hook #'org-mode-setup)

(defun org-mode-evil-setup ()
  "Setup Evil in Org mode."
  (setq evil-auto-indent nil))

(with-eval-after-load 'evil
  (add-hook 'org-mode-hook #'org-mode-evil-setup))

;; https://stackoverflow.com/a/37132338/2856535
(defun org-inline-css (exporter)
  "Insert custom inline css."
  (when (eq exporter 'html)
    (let* ((dir (ignore-errors (file-name-directory (buffer-file-name))))
           (filename (concat (file-name-base (buffer-file-name)) ".css"))
           (path (expand-file-name filename dir))
           (default (or (null dir) (null (file-exists-p path))))
           (default-file (expand-file-name "org-style.css" user-emacs-directory))
           (final (if default default-file path)))
      (setq org-html-head-include-default-style nil)
      (setq org-html-head "")
      (if (file-exists-p final)
        (setq org-html-head (concat
                              "<style type=\"text/css\">\n"
                              "<!--/*--><![CDATA[/*><!--*/\n"
                              (with-temp-buffer
                                (insert-file-contents final)
                                (buffer-string))
                              "/*]]>*/-->\n"
                              "</style>\n"))))))

(add-hook 'org-export-before-processing-hook #'org-inline-css)

;; Org related packages

    ;; ox.el --- Export Framework for Org Mode
(with-eval-after-load 'org
  (require 'ox))

    ;; MELPA
        ;; ox-reveal
(setq org-reveal-title-slide "<h1> %t </h1>  <br> %a <br> %e")
(require 'ox-reveal)
