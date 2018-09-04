# frozen_string_literal: true

# DB model that represents an RSpec tests
# report submitted for a project
class RspecReport < ActiveRecord::Base
  has_one :report, as: :reportable
  has_one :project, through: :report
  has_many :examples, class_name: 'RspecExample', dependent: :destroy
  has_one :summary, class_name: 'RspecSummary', dependent: :destroy
  accepts_nested_attributes_for :summary, :examples

  scope :query_details, lambda {
    joins([{ examples: :exception }, :summary])
      .where.not('rspec_summaries.id is null')
      .order(id: :desc)
  }
  scope :all_details, lambda {
    eager_load([{ examples: :exception }, :summary])
      .where.not('rspec_summaries.id is null')
      .includes(:project, :report).order(id: :desc)
  }
  scope :by_project, lambda { |project|
    where('projects.project_name = ?', project)
  }
  scope :tags, lambda { |tag|
    where('reports.tags @> ARRAY[?]', tag)
  }
  scope :tags_by_project, lambda { |project, tag|
    by_project(project).where('reports.tags @> ARRAY[?]', tag)
  }
  scope :scenarios, lambda {
    pluck('rspec_examples.full_description').uniq
  }
  scope :scenarios_by_project, lambda { |project|
    by_project(project).pluck('rspec_examples.full_description').uniq
  }

  # Using summary for better performance
  def status
    # examples.any?(&:failed?) ? 'failed' : 'passed'
    summary.failure_count.zero? ? 'passed' : 'failed'
  end
end
