;;; slugify.scm --- A simple slugification module for Guile Scheme -*- scheme -*-

(define-module (slugify)
  #:use-module ((srfi srfi-64))
  #:use-module ((ice-9 i18n))
  #:use-module ((srfi srfi-14))
  #:export (slugify))

;;; Commentary:
;; This module provides a `slugify` function that converts arbitrary strings
;; into slugs, useful for URLs or identifiers. Inspired by Django's implementation.
;;
;; The slugify function:
;; - Normalizes Unicode (NFKC or NFKD based on `allow-unicode`)
;; - Converts to lowercase
;; - Replaces non-word characters (e.g., whitespace) with a single replacement char
;; - Removes special characters (punctuation, symbols)
;; - Collapses multiple separators into one
;; - Trims leading/trailing separators

;;; Code:

(define word-char-set
  (char-set-union char-set:letter char-set:digit (char-set #\_)))

(define non-word-char-set
  (char-set-union char-set:whitespace (char-set #\-)))

(define* (non-word-action c #:optional (replacement #\-))
  replacement)

(define (word-action c)
  (char-downcase c))

(define* (process-char c #:optional (replacement #\-))
  (cond
   ((char-set-contains? word-char-set c) (word-action c))
   ((char-set-contains? non-word-char-set c) (non-word-action c replacement))
   (else #f)))

(define* (action c p #:optional (replacement #\-))
  (let ((processed-char (process-char c replacement)))
    (if (and (eq? p replacement) (eq? processed-char replacement)) #f processed-char)))

(define* (normalize str #:optional  (allow-unicode #t))
  (if allow-unicode (string-normalize-nfkc str) (string-normalize-nfkd str)))

(define* (process lst #:optional (replacement #\-))
  (let loop [(rest lst) (first #f) (acc '())]
    (cond
     [(null? rest) (reverse acc)]
     [else (let [(curr (action (car rest) first replacement))]
             (if (not curr)
                 (loop (cdr rest) first acc)
                 (loop (cdr rest) curr (cons curr acc))))])))

(define* (slugify str #:optional  (allow-unicode #t) (replacement #\-))
  (let* ((normalized-str (normalize str allow-unicode))
         (input-list (string->list normalized-str)))
    (let ((processed-arr (process input-list replacement)))
      (string-trim-both (list->string processed-arr) (char-set replacement #\_)))))
