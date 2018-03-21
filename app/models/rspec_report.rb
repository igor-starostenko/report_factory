# frozen_string_literal: true

# DB model that represents an RSpec tests
# report submitted for a project
class RspecReport < ActiveRecord::Base
  has_one :report, as: :reportable
  has_one :project, through: :report
  has_many :examples, class_name: 'RspecExample', dependent: :destroy
  has_one :summary, class_name: 'RspecSummary', dependent: :destroy
  accepts_nested_attributes_for :summary, :examples

  scope :with_summary, lambda {
    left_outer_joins(:summary).where.not('rspec_summaries.id is null')
      .includes(examples: :exception)
  }
  scope :by_project, lambda { |project|
    with_summary.joins(:project).where('projects.project_name = ?', project)
  }
  scope :tags_by_project, lambda { |project, tag|
    by_project(project).joins(:report).where('reports.tags @> ARRAY[?]', tag)
  }
  scope :tags, lambda { |tag|
    with_summary.joins(:report).where('reports.tags @> ARRAY[?]', tag)
  }
end
