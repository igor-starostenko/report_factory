# frozen_string_literal: true

# Fetches data from Examples
module ScenarioSerializers
  module_function

  def last_created_at(examples)
    examples.last&.report&.created_at
  end

  def last_status(examples, status)
    last_created_at(select_examples(examples, status))
  end

  def select_examples(examples, status)
    examples.select { |example| example.__send__("#{status}?") }
  end

  def count_status(examples, status)
    examples&.count { |example| example.__send__("#{status}?") } || 0
  end
end
