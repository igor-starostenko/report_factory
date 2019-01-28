# frozen_string_literal: true

# DB model that represents an RSpec example.
# An executed test case.
class RspecExample < ActiveRecord::Base
  belongs_to :rspec_report
  has_one :report, through: :rspec_report
  has_one :exception, class_name: 'RspecException'
  validates :status, presence: true
  accepts_nested_attributes_for :exception,
                                reject_if: :no_exception?

  def no_exception?(attributes)
    attributes['classname'].nil?
  end

  def name
    full_description
  end

  def passed?
    status.casecmp?('passed')
  end

  def failed?
    status.casecmp?('failed')
  end

  def pending?
    status.casecmp?('pending')
  end

  def self.cached_scenarios
    old_scenarios = Rails.cache.fetch('all_scenarios') { scenarios }
    last_updated = old_scenarios.first&.report&.updated_at
    new_scenarios = joins(:report).updated_since(last_updated)
    return old_scenarios if new_scenarios.empty?

    all_scenarios = (new_scenarios + old_scenarios).uniq(&:full_description)
    Rails.cache.write('all_scenarios', all_scenarios)
    all_scenarios
  end

  scope :updated_since, lambda { |date|
    where('updated_at > ?', date || Time.at(0))
  }

  scope :project_scenarios, lambda {
    select('DISTINCT ON (full_description) rspec_examples.*')
      .order(full_description: :asc, id: :desc)
      .sort_by { |scenario| -scenario.id }
  }

  scope :scenarios, lambda {
    joins(report: :project)
      .select('DISTINCT ON ('\
              'projects.project_name, rspec_examples.full_description'\
              ') rspec_examples.*')
      .order('projects.project_name asc', full_description: :asc, id: :desc)
      .sort_by { |scenario| -scenario.id }
  }
end
