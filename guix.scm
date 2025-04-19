(use-modules (guix)
             (gnu packages base)
             (guix build-system guile)
             (guix git-download)
             (gnu packages guile)
             (guix licenses))

(let [(tag "0.1.1")]
  (package
    (name "guile-slugify")
    (version "0.1.1")
    (source (origin (method git-fetch)
                    (uri (git-reference
                          (url
                           "https://github.com/ayys/slugify")
                          (commit version)))
                    (file-name (git-file-name name version))
                    (sha256
                     (base32
                      "1yiagi55ncq1x7s9n7salzywjm4l96y3n7y3s47a9anvz87mrmim"))))

    (build-system guile-build-system)
    (native-inputs (list guile-3.0 glibc-locales))
    (synopsis "A slugify liibrary for Guile inspired by Django's slugify function")
    (description "A simple Guile Scheme implementation of `slugify`, inspired by
Django’s `slugify`.
Converts human-readable text into clean, lowercase, URL-safe identifiers.
")
    (home-page "http://github.com/ayys/slugify.scm")
    (license gpl3+)))
