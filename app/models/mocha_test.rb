# frozen_string_literal: true

# DB model that represents a Mocha test
class MochaTest < ActiveRecord::Base
  belongs_to :mocha_report
  has_one :report, through: :mocha_report
  validates :title, presence: true
  validates :full_title, presence: true
  validates :status, presence: true

  def spec_id
    file
  end

  def description
    title
  end

  def name
    full_title
  end
  alias_method :full_description, :name

  def line_number
    nil
  end

  def passed?
    status.casecmp?('passed')
  end

  def failed?
    status.casecmp?('failed')
  end

  def pending?
    pending == true
  end

  def self.cached_scenarios
    old_scenarios = Rails.cache.fetch('mocha_scenarios') { scenarios }
    last_updated = old_scenarios.first&.report&.updated_at
    new_scenarios = joins(:report).updated_since(last_updated)
    return old_scenarios if new_scenarios.empty?
    mocha_scenarios = (new_scenarios + old_scenarios).uniq(&:full_title)
    Rails.cache.write('mocha_scenarios', mocha_scenarios)
    mocha_scenarios
  end

  scope :updated_since, lambda { |date|
    where('updated_at > ?', date || Time.at(0))
  }

  scope :project_scenarios, lambda {
    select('DISTINCT ON (full_title) mocha_tests.*')
      .order(full_title: :asc, id: :desc)
      .sort_by { |scenario| -scenario.id }
  }

  scope :scenarios, lambda {
    joins(report: :project)
      .select('DISTINCT ON ('\
              'projects.project_name, mocha_tests.full_title'\
              ') mocha_tests.*')
      .order('projects.project_name asc', full_title: :asc, id: :desc)
      .sort_by { |scenario| -scenario.id }
  }
end
