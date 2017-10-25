# frozen_string_literal: true

# DB polymorphic model that may represent
# any type of report submitted for a project
class Report < ActiveRecord::Base
  belongs_to :project
  belongs_to :reportable, polymorphic: true
  validates :project_id, presence: true
end
