# frozen_string_literal: true

# DB model that represents a Project under test
class Project < ActiveRecord::Base
  has_many :reports, dependent: :destroy
  has_many :rspec_reports, through: :reports,
                           source: :reportable,
                           source_type: 'RspecReport',
                           dependent: :destroy
  has_many :rspec_examples, through: :rspec_reports,
                            source: :examples,
                            dependent: :destroy
  VALID_PROJECT_REGEX = /\A[-a-zA-Z\d\s]*\z/
  validates :project_name,
            presence: true,
            uniqueness: { case_sensitive: false },
            length: { minimum: 3, maximum: 15 },
            format: { with: VALID_PROJECT_REGEX }
  before_validation :set_formatted_project_name

  scope :with_report_examples, lambda {
    eager_load(rspec_examples: :report)
  }

  scope :by_name, lambda { |project_name|
    find_by('lower(project_name) = ?', project_name.downcase)
  }

  def cached_reports
    old_reports = Rails.cache.fetch("#{project_name}/reports") { reports }.sort_by(&:id)
    new_reports = reports.where('updated_at > ?', old_reports.last.updated_at)
    return old_reports if new_reports.empty?
    all_reports = (new_reports + old_reports)
    Rails.cache.write("#{project_name}/reports", all_reports)
    all_reports
  end

  def cached_scenarios
    old_scenarios = Rails.cache.fetch("#{project_name}/scenarios") { scenarios }
    new_scenarios = scenarios_from(old_scenarios.first.report.updated_at)
    return old_scenarios if new_scenarios.empty?
    all_scenarios = merge_scenarios(new_scenarios, old_scenarios)
    Rails.cache.write("#{project_name}/scenarios", all_scenarios)
    all_scenarios
  end

  def scenarios
    filter_scenarios(rspec_examples)
  end

  def scenarios_from(date)
    filter_scenarios(rspec_examples.where('updated_at > ?', date))
  end

  private

  def set_formatted_project_name
    self.project_name = format_project_name
  end

  def format_project_name
    project_name&.tr(' ', '-')
  end

  def filter_scenarios(examples)
    examples.select('DISTINCT ON (full_description) rspec_examples.*')
            .order(full_description: :asc, id: :desc)
            .sort_by { |scenario| -scenario.id }
  end

  def merge_scenarios(new_scenarios, old_scenarios)
    (new_scenarios + old_scenarios).uniq { |scenario| scenario.full_description }
  end
end
