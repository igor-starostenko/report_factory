# frozen_string_literal: true

# Formats Project Scenario JSON API
class SerializableScenario < JSONAPI::Serializable::Resource
  type 'project_scenarios'

  attribute :project_name
  attribute :project_id do
    @object.id
  end

  attribute :scenarios do
    examples = @object.rspec_examples
    scenario_names = examples&.map(&:name).uniq
    format_scenarios(scenario_names, examples)
  end

  private

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
      last_passed: last_status(matched_examples, 'passed'),
      last_failed: last_status(matched_examples, 'failed'),
      total_runs: matched_examples&.size || 0,
      total_passed: count_status(matched_examples, 'passed'),
      total_failed: count_status(matched_examples, 'failed'),
      total_pending: count_status(matched_examples, 'pending')
    }
  end

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
