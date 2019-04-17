# `revealing` - A Workflow for reveal.js Presentations

[![Build Status](https://travis-ci.org/suhlig/revealing.svg?branch=master)](https://travis-ci.org/suhlig/revealing)

This gem provides a set of [`Rake`](https://github.com/ruby/rake) tasks to create [`reveal.js`](https://revealjs.com) presentations from markdown files. It uses [`pandoc`](https://pandoc.org/) to create the final presentation. The output is a self-contained set of static HTML files that can be viewed locally uploaded to a web server.

Unique features:

1. `revealing` assumes that your presentation is built using `Rake`. Additional, custom steps (like deployment) can easily be added to the Rakefile that was generated for you.
1. Efficiency - by carefully modeling the dependencies between source files (your markdown), intermediate build products (processed include statements), and the final output (HTML and resized images), build steps are only run when necessary (e.g. when a corresponding source file was changed).

# Examples

* [Zero to CF in Kube-Cluster in 30 Seconds with Concourse, Helm, Fissile and Eirini](http://zero2cfin30s.eirini.cf/) (source: [suhlig/zero-to-cf-in-30-seconds](https://github.com/suhlig/zero-to-cf-in-30-seconds)) is built using `revealing` and published on IBM Cloud using a GitHub action after each `git push`.

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

1. BUG: Need to rebuild if a file in the headers folder changed
1. Expose customization of
   * highlight-style
   * theme
   * slideNumber
   * history
1. Provide a docker image so that we can run without installing everything
1. Consider [mermaid-filter](https://github.com/raghur/mermaid-filter)
1. Allow self-hosted mathjax (copy to target)
1. Charts using [vega-lite](https://vega.github.io/vega-lite/usage/embed.html)
1. Add guard-livereload to the generated project
1. PDF output
1. Make the initial set of files more meaningful (e.g. add the project name, `git config user.name` etc.)
1. Web interface for live editing
