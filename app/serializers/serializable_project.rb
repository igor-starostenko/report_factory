# frozen_string_literal: true

# Formats Projects JSON API
class SerializableProject < JSONAPI::Serializable::Resource
  type 'project'

  attributes :project_name

  attribute :date do
    {
      created_at: @object.created_at,
      updated_at: @object.updated_at
    }
  end

  attribute :scenarios do
    examples = @object.rspec_examples
    scenario_names = examples&.map(&:name).uniq
    format_scenarios(scenario_names, examples)
  end

  def format_scenarios(names, examples)
    {
      total_count: names&.size || 0,
      # total_passed: count_status(examples, 'passed'),
      # total_failed: count_status(examples, 'failed'),
      examples: format_examples(names, examples)
    }
  end

  def format_examples(names, examples)
    names&.map { |name| format_scenario(name, examples) } || []
  end

  def format_scenario(name, examples)
    matched_examples = examples.select { |example| example.name == name }
    {
      name: name,
      last_status: matched_examples.last.status,
      last_run: matched_examples.last.report.created_at,
      # last_run: @object.reports.detect { |report| report.reportable.examples.any? { |e| e.name == name } },
      count: matched_examples&.size || 0,
      passed: count_status(matched_examples, 'passed'),
      failed: count_status(matched_examples, 'failed'),
      pending: count_status(matched_examples, 'pending')
    }
  end

  def count_status(examples, status)
    examples&.count { |example| example.__send__("#{status}?") } || 0
  end
end
