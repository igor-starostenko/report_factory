# frozen_string_literal: true

# DB model that represents a Project under test
class Project < ActiveRecord::Base
  has_many :reports, dependent: :destroy
  has_many :rspec_reports, through: :reports,
                           source: :reportable,
                           source_type: 'RspecReport',
                           dependent: :destroy
  VALID_PROJECT_REGEX = /\A[a-zA-Z\d\s]*\z/
  validates :project_name,
            presence: true,
            uniqueness: { case_sensitive: false },
            length: { minimum: 3, maximum: 11 },
            format: { with: VALID_PROJECT_REGEX }
  before_create :set_formatted_project_name
  before_update :set_formatted_project_name

  private

  def set_formatted_project_name
    self.project_name = format_project_name
  end

  def format_project_name
    words = project_name.downcase.split(' ')
    words.map(&:capitalize).join(' ')
  end
end
