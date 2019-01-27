# frozen_string_literal: true

# DB model that represents a Project under test
class Project < ActiveRecord::Base
  has_many :reports, dependent: :destroy
  has_many :rspec_reports, through: :reports,
                           source: :reportable,
                           class_name: 'RspecReport',
                           source_type: 'RspecReport',
                           dependent: :destroy
  has_many :rspec_examples, through: :rspec_reports,
                            source: :examples,
                            dependent: :destroy
  has_many :mocha_reports, through: :reports,
                           source: :reportable,
                           class_name: 'MochaReport',
                           source_type: 'MochaReport',
                           dependent: :destroy
  has_many :mocha_tests, through: :mocha_reports,
                         source: :tests,
                         dependent: :destroy
  VALID_PROJECT_REGEX = /\A[-a-zA-Z\d\s]*\z/
  validates :project_name,
            presence: true,
            uniqueness: { case_sensitive: false },
            length: { minimum: 3, maximum: 15 },
            format: { with: VALID_PROJECT_REGEX }
  before_validation :set_formatted_project_name

  REPORT_TYPES = %w[Rspec Mocha]

  scope :with_report_examples, lambda {
    eager_load(rspec_examples: :report)
  }

  scope :by_name, lambda { |project_name|
    find_by('lower(project_name) = ?', project_name.downcase)
  }

  def cached_reports
    old_reports = fetch_from_cache(:reports).sort_by(&:id)
    new_reports = reports.updated_since(old_reports.last&.updated_at)
    return old_reports if new_reports.empty?
    all_reports = (new_reports + old_reports).uniq
    Rails.cache.write("#{cache_key}/reports", all_reports)
    all_reports
  end

  def cached_scenarios
    old_scenarios = fetch_from_cache(:scenarios)
    new_scenarios = scenarios(old_scenarios.first&.report&.updated_at)
    return old_scenarios if new_scenarios.empty?
    all_scenarios = (new_scenarios + old_scenarios).uniq(&:full_description)
    Rails.cache.write("#{cache_key}/scenarios", all_scenarios)
    all_scenarios
  end

  def scenario(type, title)
    valid = REPORT_TYPES.any? { |report_type| report_type.casecmp?(type) }
    return [] unless valid

    __send__("#{type.downcase}_scenario", title)
  end

  def rspec_scenario(title)
    rspec_examples.where(full_description: title)
  end

  def mocha_scenario(title)
    mocha_tests.where(full_title: title)
  end

  def scenarios(date = nil)
    project_scenarios = REPORT_TYPES.map { |type| scenarios_by(type, date) }
    project_scenarios.flatten.sort_by(&:full_description)
  end

  private

  def set_formatted_project_name
    self.project_name = format_project_name
  end

  def scenarios_by(type, date = nil)
    tests = __send__("#{type.downcase}_tests")
    tests = tests.updated_since(date) if date
    tests.project_scenarios
  end

  def rspec_tests
    rspec_examples
  end

  def format_project_name
    project_name&.tr(' ', '-')
  end

  def fetch_from_cache(relative)
    Rails.cache.fetch("#{cache_key}/#{relative}") { __send__(relative) }
  end

  def cache_key
    @cache_key ||= "#{project_name}/#{created_at.to_s(:number)}"
  end
end
