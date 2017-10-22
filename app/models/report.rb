class Report < ActiveRecord::Base
  belongs_to :project
  has_many :examples
  validates :project_id, presence: true
end
