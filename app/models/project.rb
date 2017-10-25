# frozen_string_literal: true

# DB model that represents a Project under test
class Project < ActiveRecord::Base
  has_many :reports, dependent: :destroy
  validates :project_name,
            presence: true,
            uniqueness: { case_sensitive: false },
            length: { minimum: 3, maximum: 10 }
end
