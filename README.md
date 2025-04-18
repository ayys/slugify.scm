# slugify.scm 🐌

A simple Guile Scheme implementation of `slugify`, inspired by
Django’s
[`slugify`](https://github.com/django/django/blob/main/django/utils/text.py).


Converts human-readable text into clean, lowercase, URL-safe identifiers.


## ✨ Features

- Converts Unicode or ASCII strings into slugs
- Optionally removes non-ASCII characters (NFKD + ASCII fallback)
- Collapses whitespace and separators into a single character
- Supports custom separator characters
- Trims leading/trailing dashes or underscores

## 📦 Installation

Just copy `slugify.scm` into your project and `(use-modules (slugify))`.

If using as a library, ensure it's in your `GUILE_LOAD_PATH`:

```bash
export GUILE_LOAD_PATH="$GUILE_LOAD_PATH:$PWD"
```

## API

```scheme
(slugify str #:optional allow-unicode replacement)
```


| Argument      | description                                        |
|---------------|----------------------------------------------------|
| str           | Input string to slugify                            |
| allow-unicode | If `#f`, normalize to ASCII (NFKD + strip accents) |
| replacement   | Char to use instead of `-` for word separation     |


## Usage

```scheme
(use-modules (slugify))

(slugify "Hello, World!")             ;; "hello-world"
(slugify "Café Déjà Vu" #f)           ;; "cafe-deja-vu"
(slugify "Café Déjà Vu" #t)           ;; "café-déjà-vu"
(slugify "foo bar" #t #\_)            ;; "foo_bar"
(slugify "你好")                       ;; "你好"

```

## Running tests

```bash
guile -L . test-slugify.scm
```
