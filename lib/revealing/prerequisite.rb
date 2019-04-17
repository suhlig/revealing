require 'rubygems/platform'

module Revealing
  class Prerequisite
    attr_reader :command
    alias :to_s :command

    def initialize(command, details = nil)
      @command = command

      case details
      when NilClass
        @package_info = same_as_command(command)
      when String
        @package_info = different_but_same_on_all_platforms(details)
      when Hash
        @package_info = different_for_each_platform(details)
      when Proc
        @package_info = callable(details)
      else
        raise "Don't know how to interpret '#{package_info.inspect}' as package info."
      end
    end

    def available?
      system("sh -c 'command -v #{command} > /dev/null'")
    end

    def install_hint
      @package_info[Gem::Platform.local.os.to_sym]
    end

    private

    def same_as_command(command)
      {
        darwin: "brew install #{command}",
        linux: "apt install #{command}",
      }
    end

    def different_but_same_on_all_platforms(details)
      {
        darwin: "brew install #{details}",
        linux: "apt install #{details}",
      }
    end

    def different_for_each_platform(details)
      {
        darwin: "brew install #{details[:darwin]}",
        linux: "apt install #{details[:linux]}",
      }
    end

    def callable(details)
      {
        darwin: details.call(:darwin),
        linux: details.call(:linux),
      }
    end
  end
end
