#
# Synthesize a task that ensures that the given prerequisite tool is available
#
def prereq(name)
  desc "Assert that #{name} is available"
  task name do |task|
    unless system("type #{name} > /dev/null 2>&1")
      raise "#{task} is not available. Use `revealing doctor` to assist fixing."
    end
  end
end
