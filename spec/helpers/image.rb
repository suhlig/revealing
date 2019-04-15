require 'pathname'
require 'open3'

class Image
  Error = Class.new(StandardError)

  def initialize(path)
    @path = Pathname(path)
  end

  def width
    identify('%w')
  end

  def height
    identify('%h')
  end

  private

  def identify(format)
    out, err, status = Open3.capture3("gm identify -format '#{format}' #{@path}")
    raise Error.new(err) unless status.success?
    out.to_i
  end
end
