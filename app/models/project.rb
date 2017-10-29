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
  before_save do
    words = project_name.downcase.split(' ')
    new_name = words.map(&:capitalize).join(' ')
    self.project_name = new_name
  end
end
