# `revealing` - A Workflow for reveal.js Presentations

[![Build Status](https://app.travis-ci.com/suhlig/revealing.svg?branch=master)](https://app.travis-ci.com/suhlig/revealing)

This gem provides a set of [`Rake`](https://github.com/ruby/rake) tasks to create [`reveal.js`](https://revealjs.com) presentations from markdown files. It uses [`pandoc`](https://pandoc.org/) to create the final presentation. The output is a self-contained set of static HTML files that can be viewed locally uploaded to a web server.

Unique features:

1. `revealing` assumes that your presentation is built using `Rake`. Additional, custom steps (like deployment) can easily be added to the Rakefile that was generated for you.
1. Efficiency - by carefully modeling the dependencies between source files (your markdown), intermediate build products (processed include statements), and the final output (HTML and resized images), build steps are only run when necessary (e.g. when a corresponding source file was changed).

# Examples

* [Zero to CF in Kube-Cluster in 30 Seconds with Concourse, Helm, Fissile and Eirini](https://suhlig.github.io/zero-to-cf-in-30-seconds) (source: [suhlig/zero-to-cf-in-30-seconds](https://github.com/suhlig/zero-to-cf-in-30-seconds)) is built using `revealing`.

# Development

* Create a test project using `revealing init`
* Test by referring to the changed tasks:
  ```console
  rake -f ~/workspace/revealing/lib/revealing/tasks.rb -T
  ```

# Releasing

* Make the changes
* Run tests
* From a test project, install the updated gem locally and invoke it:
  ```console
  $ (cd ../revealing; git add .; bake install) && bundle update && bake clobber default
  ```
  Verify that everything works.
* Bump the version in `lib/revealing/version.rb`
* git commit
* `gem signin` to rubygems.org
* `bundle exec rake release`

# TODO

1. Pandoc >= 2.9.3 is [required for reveal.js >= 4.0](https://github.com/jgm/pandoc/issues/6451#issuecomment-642470350)
1. Expose customization of
   * highlight-style
   * theme
   * slideNumber
   * history
1. Provide a docker image so that we can run without installing everything
1. Add guard-livereload to the generated project
1. Performance: pandoc-ditaa-inline filter could write files to cache dir and read it from there via SHA
   - still keep the SVG inline, but do not call ditaa again if unchanged
1. Consider [mermaid-filter](https://github.com/raghur/mermaid-filter)
1. Allow self-hosted mathjax (copy to target)
1. Charts using [vega-lite](https://vega.github.io/vega-lite/usage/embed.html)
1. Make the initial set of files more meaningful (e.g. add the project name, `git config user.name` etc.)
1. Web interface for live editing
