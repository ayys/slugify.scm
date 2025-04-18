(use-modules (slugify)
             (srfi srfi-64))

(test-begin "slugify: tests from django source")
;; tests collected from django source
;; https://github.com/django/django/blob/ff3aaf036f0cb66cd8f404cd51c603e68aaa7676/tests/utils_tests/test_text.py#L376


(define test-cases
  `(("Hello, World!" "hello-world" #f)
    ("spam & eggs" "spam-eggs" #f)
    (" multiple---dash and  space " "multiple-dash-and-space" #f)
    ("\t whitespace-in-value \n" "whitespace-in-value" #f)
    ("underscore_in-value" "underscore_in-value" #f)
    ("__strip__underscore-value___" "strip__underscore-value" #f)
    ("--strip-dash-value---" "strip-dash-value" #f)
    ("__strip-mixed-value---" "strip-mixed-value" #f)
    ("_ -strip-mixed-value _-" "strip-mixed-value" #f)
    ("spam & ıçüş" "spam-ıçüş" #t)
    ("foo ıç bar" "foo-ıç-bar" #t)
    ("    foo ıç bar" "foo-ıç-bar" #t)
    ("你好" "你好" #t)
    ("İstanbul" "istanbul" #t)))

(for-each
 (lambda (case)
   (let ((input (list-ref case 0))
         (expected (list-ref case 1))
         (unicode (list-ref case 2)))
     (test-equal (string-append "slugify: " input)
                 expected
                 (slugify input unicode))))
 test-cases)


(test-end)



(test-begin "slugify: simple test cases")

(test-equal "Empty string" (slugify "") "")
(test-equal "Basic ASCII" (slugify "Hello World") "hello-world")
(test-equal "Underscores" (slugify "Foo_Bar") "foo_bar")
(test-equal "Multiple spaces" (slugify "  many   spaces here  ") "many-spaces-here")
(test-equal "Symbols removed" (slugify "Hi! What's up?") "hi-whats-up")
(test-equal "Trim separators" (slugify "--Trim--This--") "trim-this")
(test-equal "Unicode preserved" (slugify "Café Déjà Vu" #t) "café-déjà-vu")
(test-equal "Unicode removed" (slugify "Café Déjà Vu" #f) "cafe-deja-vu")
(test-equal "Custom replacement" (slugify "A B C" #t #\_) "a_b_c")


;; Empty and minimal cases
(test-equal "Only spaces" (slugify "     ") "")
(test-equal "Only dashes" (slugify "-----") "")
(test-equal "Only underscores" (slugify "_____") "")
(test-equal "Only mixed separators" (slugify "  - _ - _ -  ") "")
(test-equal "Single non-word char" (slugify "!") "")
(test-equal "Single underscore" (slugify "_") "")
(test-equal "Single dash" (slugify "-") "")

;; Custom replacement characters
(test-equal "Custom replacement: underscore" (slugify "a b c" #t #\_) "a_b_c")
(test-equal "Custom replacement: dot"        (slugify "a b c" #t #\.) "a.b.c")
(test-equal "Custom replacement: plus"       (slugify "a b c" #t #\+) "a+b+c")
(test-equal "Custom replacement: equals"     (slugify "a b c" #t #\=) "a=b=c")


;; Repeated separators reduced
(test-equal "Repeated separators reduced" (slugify "a   b  --  c" #t #\.) "a.b.c")


;; Unicode: disallowed but present
(test-equal "Disallowed unicode: accented" (slugify "Café" #f) "cafe")
(test-equal "Disallowed unicode: Turkish"  (slugify "İstanbul" #f) "istanbul")
(test-equal "Disallowed unicode: Chinese"  (slugify "你好" #f) "你好")

;; Edge: Unicode with emoji
(test-equal "Unicode with emoji (allowed)" (slugify "fire 🔥 ball" #t) "fire-ball")
(test-equal "Unicode with emoji (not allowed)" (slugify "fire 🔥 ball" #f) "fire-ball")

(test-end)


