class Report < ActiveRecord::Base
  belongs_to :project
  belongs_to :reportable, polymorphic: true
  validates :project_id, presence: true
end
