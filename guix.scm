(use-modules (guix packages)
             (gnu packages base)
             (guix build-system guile)
             (guix git-download)
             (guix build utils)
             (gnu packages guile)
             (guix licenses))

(let [(tag "0.1.3")]
  (package
    (name "guile-slugify")
    (version tag)
    (source (origin
              (method git-fetch)
              (uri (git-reference
                    (url "https://github.com/ayys/slugify.scm")
                    (commit version)))
              (file-name (git-file-name name version))
              (sha256
               (base32 "1xg6dhcnd6m5z9d7yzsa2vzdhzgifyk92gkfb6md8rbc8dilp2rh"))
              (snippet '(begin
                          (for-each delete-file '("guix.scm" "test.scm" "LICENSE" "README.md"))))))

    (build-system guile-build-system)
    (native-inputs (list guile-3.0 glibc-locales))
    (synopsis "A slugify library for Guile inspired by Django's slugify function")
    (description
     "A simple Guile Scheme implementation of `slugify`, inspired by Django’s slugify.
Converts human-readable text into clean, lowercase, URL-safe identifiers.")
    (home-page "http://github.com/ayys/slugify.scm")
    (license gpl3+)))
