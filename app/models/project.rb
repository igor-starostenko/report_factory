# frozen_string_literal: true

# DB model that represents a Project under test
class Project < ActiveRecord::Base
  has_many :reports, dependent: :destroy
  validates :project_name,
            presence: true,
            uniqueness: { case_sensitive: false },
            length: { minimum: 3, maximum: 11 }
  before_save do
    project_name.tr('_', ' ').downcase.capitalize
  end
end
