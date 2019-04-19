# New Presentation

This is the source of New Presentation. It was generated with [`revealing`](https://github.com/suhlig/revealing).

# Features

* Images are resized for the web using [`graphicsmagick`](http://www.graphicsmagick.org/)
* `#include` and other [`gpp`](https://logological.org/gpp) features allow organizing the sources of complex presentations
* Files in the `headers` folder are included verbatim in the HTML `<head>` section
* MathJax is included and configured to render SVG. To use a specific version, set the environment variable `MATH_JAX_VERSION` to one of of the versions provided by [CDNJS](https://cdnjs.com/libraries/mathjax).
* reveal.js is downloaded and unzipped at build time. Set the environment variable `REVEAL_JS_VERSION` to customize which version to use (must be one of the [released versions](https://github.com/hakimel/reveal.js/releases)). If `REVEAL_JS_DIR` is set, the files from this directory are used.
* The environment variable `REVEAL_JS_SLIDE_LEVEL` can be set to [structure the slide show](https://pandoc.org/MANUAL.html#structuring-the-slide-show)
* The target directory is `public_html`. It can be customized by setting the environment variable `TARGET_DIR`.

# Setup

Do this once:

1. Get Ruby if not already present
1. `gem install bundler`
1. `bundle install`
1. Check that you have the required tools as reported by `revealing doctor`

# Generate the Presentation

1. Run `rake` in the project directory
1. Open `public_html/index.html` in a browser
