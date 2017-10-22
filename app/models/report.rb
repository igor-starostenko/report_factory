class Report < ActiveRecord::Base
  belongs_to :project
  has_many :tests
  validates :project_id, presence: true
end
