# frozen_string_literal: true

# DB model that represents an RSpec tests
# report submitted for a project
class RspecReport < ActiveRecord::Base
  # alias_attribute :tests, :examples

  has_one :report, as: :reportable
  has_one :project, through: :report
  has_many :examples, class_name: 'RspecExample', dependent: :destroy
  has_one :summary, class_name: 'RspecSummary', dependent: :destroy
  accepts_nested_attributes_for :summary, :examples

  scope :with_summary, lambda {
    eager_load([{ examples: :exception }, :summary])
      .where.not('rspec_summaries.id is null')
  }
  scope :by_project, lambda { |project|
    with_summary.includes(:project).where('projects.project_name = ?', project)
  }
  scope :tags, lambda { |tag|
    with_summary.includes(:report).where('reports.tags @> ARRAY[?]', tag)
  }
  scope :tags_by_project, lambda { |project, tag|
    by_project(project).includes(:report).where('reports.tags @> ARRAY[?]', tag)
  }
  scope :scenarios, lambda {
    with_summary.pluck('rspec_examples.full_description').uniq
  }
  scope :scenarios_by_project, lambda { |project|
    by_project(project).pluck('rspec_examples.full_description').uniq
  }
end
