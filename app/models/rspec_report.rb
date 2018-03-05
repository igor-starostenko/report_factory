# frozen_string_literal: true

# DB model that represents an RSpec tests
# report submitted for a project
class RspecReport < ActiveRecord::Base
  has_one :report, as: :reportable
  has_one :project, through: :report
  has_many :examples, class_name: 'RspecExample', dependent: :destroy
  has_one :summary, class_name: 'RspecSummary', dependent: :destroy

  scope :tags, ->(tag) { joins(:report).where('reports.tags @> ARRAY[?]', tag) }
end
