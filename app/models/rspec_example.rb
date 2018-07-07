# frozen_string_literal: true

# DB model that represents an RSpec example.
# An executed test case.
class RspecExample < ActiveRecord::Base
  belongs_to :rspec_report
  has_one :report, through: :rspec_report
  has_one :exception, class_name: 'RspecException'
  validates :status, presence: true
  default_scope { order(id: :asc) }
  accepts_nested_attributes_for :exception,
                                reject_if: :no_exception?

  SCENARIO_FIELDS = %i[id spec_id description full_description status
                       line_number].map { |f| "rspec_examples.#{f}" }.join(', ')

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

  scope :scenarios, -> {
    find_by_sql('SELECT DISTINCT ON (full_description)'\
                ' full_description, status FROM rspec_examples')
      .sort_by { |scenario| -scenario.id }
  }

  scope :project_scenarios, -> (project_id) {
    find_by_sql('SELECT DISTINCT ON (rspec_examples.full_description)'\
                " #{SCENARIO_FIELDS} FROM rspec_examples"\
                ' INNER JOIN rspec_reports ON'\
                ' rspec_examples.rspec_report_id = rspec_reports.id'\
                ' INNER JOIN reports ON'\
                ' rspec_reports.id = reports.reportable_id WHERE'\
                " reports.project_id = #{project_id}")
      .sort_by { |scenario| -scenario.id }
  }
end
