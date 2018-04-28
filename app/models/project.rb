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

  scope :scenarios, lambda { |project_name|
    where(project_name: project_name)
      .includes(:rspec_examples)
      .pluck('rspec_examples.full_description')
      .uniq.reject { |d| d.nil? }
  }

  private

  def set_formatted_project_name
    self.project_name = format_project_name
  end

  def format_project_name
    project_name&.tr(' ', '-')
  end
end
