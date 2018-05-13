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
    scenario_names = examples&.map(&:name)&.uniq
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
    order_scenarios_by_runs(format_scenarios_by_names(names, examples))
  end

  def format_scenarios_by_names(names, examples)
    return [] unless names
    names.map do |name|
      format_scenario(name, match_examples_by_name(name, examples))
    end
  end

  def match_examples_by_name(name, examples)
    examples.select { |example| example.name == name }
  end

  def order_scenarios_by_runs(scenarios)
    scenarios.sort_by { |scenario| scenario[:total_runs] }.reverse
  end

  def format_scenario(name, examples)
    { name: name,
      last_status: examples.last.status,
      last_run: examples.last.report.created_at,
      last_passed: last_status(examples, 'passed'),
      last_failed: last_status(examples, 'failed'),
      total_runs: examples&.size || 0,
      total_passed: count_status(examples, 'passed'),
      total_failed: count_status(examples, 'failed'),
      total_pending: count_status(examples, 'pending') }
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
