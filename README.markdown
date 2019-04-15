# `revealing` - A Workflow for reveal.js Presentations

[![Build Status](https://travis-ci.org/suhlig/revealing.svg?branch=master)](https://travis-ci.org/suhlig/revealing)

This gem provides a set of [`Rake`](https://github.com/ruby/rake) tasks to create [`reveal.js`](https://revealjs.com) presentations from markdown files. It uses [`pandoc`](https://pandoc.org/) to create the final presentation. The output is a self-contained set of static HTML files that can be viewed locally uploaded to a web server.

# Examples

* [Zero to CF in Kube-Cluster in 30 Seconds with Concourse, Helm, Fissile and Eirini](http://zero2cfin30s.eirini.cf/) (source: [suhlig/zero-to-cf-in-30-seconds](https://github.com/suhlig/zero-to-cf-in-30-seconds))

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

1. `revealing doctor` to analyze tools
1. Target folders mirror source, so that we don't risk duplicates
1. Read desired versions of dependencies from a YAML file (with sensible defaults coming from this project)
1. Add mathjax (copy to target if present, otherwise use CDN)
1. Expose customization of
   * highlight-style
   * slide-level
   * theme
   * slideNumber
   * history
1. Provide a docker image so that we can run without installing everything
1. PDF output
1. Make the initial set of files more meaningful (e.g. add the project name, `git config user.name` etc.)
1. Web interface for live editing
