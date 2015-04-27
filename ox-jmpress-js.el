;;; ox-jmpress-js.el --- jmpress.js Back-End for Org Export Engine

;; Copyright (C) 2015 François-David Collin.

;; Author: François-David Collin <fradav at gmail dot org>
;; URL: https://github.com/fradav/org-jmpress-js.el
;; Version: 0.1
;; Package-Requires: ((org "8"))
;; Keywords: outlines, hypermedia, calendar, wp

;; This file is not part of GNU Emacs.

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:

;; This library implements a minimalist jmpress.js back-end for Org
;; generic exporter based on ox-html.el.

;; Original author: Carsten Dominik <carsten at orgmode dot org>
;;      Jambunathan K <kjambunathan at gmail dot com>

;;; Code:

;;; Dependencies

(require 'ox-html)

;;; Define Back-End

(org-export-define-derived-backend 'jmpress-js 'html
  :menu-entry
  '(?j "Export to jmpress.js HTML"
       ((?J "As jmpress.js HTML buffer" org-jmpress-js-export-as-html)
	(?j "As jmpress.js HTML file" org-jmpress-js-export-to-html)
	(?o "As jmpress.js HTML file and open"
	    (lambda (a s v b)
	      (if a (org-jmpress-js-export-to-html t s v b)
		(org-open-file (org-jmpress-js-export-to-html nil s v b)))))))
  :options-alist
  '((:html-jmpress-js-stylesheet "JMPRESSJS_STYLE" nil org-jmpress-js-stylesheet newline)
    (:html-jmpress-js-jquery "JMPRESSJQ_SRC" nil org-jmpress-js-jquery newline)
    (:html-jmpress-js-javascript "JMPRESSJS_SRC" nil org-jmpress-js-javascript newline)
    (:html-jmpress-js-user "JMPRESSUSER_SRC" nil org-jmpress-js-user newline)))



;;; Internal Variables


;;; User Configuration Variables

;;;; For jmpress.js.

(defcustom org-jmpress-js-description
  "jmpress.js is a pure <html>, .css {} and function javascript() {} \
and use CSS3 transitions and transformations. It started as a \
a jQuery port of impress.js but have become much, much more."
  "jmpress.js description."
  :group 'org-export-jmpress-js
  :type 'string)

;;;; Template :: Styles

(defcustom org-jmpress-js-stylesheet "resources/css/jmpress-demo.css"
  "Path to the default CSS file for jmpress.js.

Use JMPRESSJS_STYLE option in your Org file is available too."
  :group 'org-export-jmpress-js
  :version "24.4"
  :package-version '(Org . "8.0")
  :type 'string)

(defcustom org-jmpress-js-jquery "bower_components/jquery/dist/jquery.js"
  "Path to the JavaScript file for jQuery.

Use JMPRESSJQ_SRC option in your Org file is available too."
  :group 'org-export-jmpress-js
  :version "24.4"
  :package-version '(Org . "8.0")
  :type 'string)

(defcustom org-jmpress-js-javascript "bower_components/jmpress/jmpress.js"
  "Path to the JavaScript file for jmpress.js.

Use JMPRESSJS_SRC option in your Org file is available too."
  :group 'org-export-jmpress-js
  :version "24.4"
  :package-version '(Org . "8.0")
  :type 'string)

(defcustom org-jmpress-js-user "jmpress-user.js"
  "Path to the user Javascript file.

Use JMPRESSUSER_SRC option in your Org file is available too."
  :group 'org-export-jmpress-js
  :version "24.4"
  :package-version '(Org . "8.0")
  :type 'string)



;;; Internal Functions

(defun org-jmpress-js-close-tag (tag attr info)
  (concat "<" tag " " attr " />"))

(defun org-jmpress-js-begin (property)
  "Initialize variables when exporting started.

This is called from org-export-before-processing-hook."
  (when (eq 'jmpress-js property)
    (advice-add 'org-html--build-head :around #'org-jmpress-js--build-jmpress-js-headers)
    (setq-local org-html-head-include-default-style nil)
    (setq-local org-html-head-include-scripts nil)
    ))


;;; Template


(defun org-jmpress-js--build-jmpress-js-headers (old-html-build-headers &rest args)
  "Return a link tag to load jmpress.js CSS file.
INFO is a plist used as a communication channel."
  (let ((info (car args)))
    (advice-remove 'org-html--build-head #'org-jmpress-js--build-jmpress-js-headers)
    (concat
     (apply old-html-build-headers args)
     (org-element-normalize-string
      (concat
       (when (plist-get info :html-jmpress-js-stylesheet)
	 (org-html-close-tag "link"
				   (format " rel=\"stylesheet\" href=\"%s\" type=\"text/css\""
					   (plist-get info :html-jmpress-js-stylesheet))
				   info))
       (when (plist-get info :html-jmpress-js-jquery)
	 (format "<script src=\"%s\"></script>\n"
		 (plist-get info :html-jmpress-js-jquery)))
       (when (plist-get info :html-jmpress-js-javascript)
	 (format "<script src=\"%s\"></script>\n"
		 (plist-get info :html-jmpress-js-javascript)))
       (when (plist-get info :html-jmpress-js-user)
	 (format "<script src=\"%s\"></script>\n"
		 (plist-get info :html-jmpress-js-user)))
       )))
    )
  )



;;;###autoload
(defun org-jmpress-js-export-as-html
  (&optional async subtreep visible-only body-only ext-plist)
  "Export current buffer to an HTML buffer.

If narrowing is active in the current buffer, only export its
narrowed part.

If a region is active, export that region.

A non-nil optional argument ASYNC means the process should happen
asynchronously.  The resulting buffer should be accessible
through the `org-export-stack' interface.

When optional argument SUBTREEP is non-nil, export the sub-tree
at point, extracting information from the headline properties
first.

When optional argument VISIBLE-ONLY is non-nil, don't export
contents of hidden elements.

When optional argument BODY-ONLY is non-nil, only write code
between \"<body>\" and \"</body>\" tags.

EXT-PLIST, when provided, is a property list with external
parameters overriding Org default settings, but still inferior to
file-local settings.

Export is done in a buffer named \"*Org HTML Export*\", which
will be displayed when `org-export-show-temporary-export-buffer'
is non-nil."
  (interactive)
  (org-export-to-buffer 'jmpress-js "*Org HTML Export*"
    async subtreep visible-only body-only ext-plist
    (lambda () (set-auto-mode t))))

;;;###autoload
(defun org-jmpress-js-convert-region-to-html ()
  "Assume the current region has org-mode syntax, and convert it to
jmpress.js HTML.
This can be used in any buffer.  For example, you can write an
itemized list in org-mode syntax in an HTML buffer and use this
command to convert it."
  (interactive)
  (org-export-replace-region-by 'jmpress-js))

;;;###autoload
(defun org-jmpress-js-export-to-html
  (&optional async subtreep visible-only body-only ext-plist)
  "Export current buffer to a jmpress.js HTML file.

If narrowing is active in the current buffer, only export its
narrowed part.

If a region is active, export that region.

A non-nil optional argument ASYNC means the process should happen
asynchronously.  The resulting file should be accessible through
the `org-export-stack' interface.

When optional argument SUBTREEP is non-nil, export the sub-tree
at point, extracting information from the headline properties
first.

When optional argument VISIBLE-ONLY is non-nil, don't export
contents of hidden elements.

When optional argument BODY-ONLY is non-nil, only write code
between \"<body>\" and \"</body>\" tags.

EXT-PLIST, when provided, is a property list with external
parameters overriding Org default settings, but still inferior to
file-local settings.

Return output file's name."
  (interactive)
  (let* ((extension (concat "." org-html-extension))
	 (file (org-export-output-file-name extension subtreep))
	 (org-export-coding-system org-html-coding-system))
    (org-export-to-file 'jmpress-js file
      async subtreep visible-only body-only ext-plist)))

;;;###autoload
(defun org-jmpress-js-publish-to-html (plist filename pub-dir)
  "Publish an org file to jmpress.js HTML.

FILENAME is the filename of the Org file to be published.  PLIST
is the property list for the given project.  PUB-DIR is the
publishing directory.

Return output file name."
  (org-publish-org-to 'jmpress-js filename
		      (concat "." (or (plist-get plist :html-extension)
				      org-html-extension "html"))
		      plist pub-dir))

(add-hook 'org-export-before-processing-hook 'org-jmpress-js-begin)

(provide 'ox-jmpress-js)
;;; ox-jmpress-js.el ends here
