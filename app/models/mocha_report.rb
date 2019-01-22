# frozen_string_literal: true

# DB model that represents a Mocha test report
class MochaReport < ActiveRecord::Base
  has_one :report, as: :reportable
  has_one :project, through: :report
  has_many :tests, class_name: 'MochaTest', dependent: :destroy
  validates :total, presence: true
  validates :passes, presence: true
  validates :pending, presence: true
  validates :failures, presence: true
  validates :duration, presence: true
  accepts_nested_attributes_for :tests

  scope :all_details, lambda {
    eager_load(:tests).includes(:project, :report).order(id: :desc)
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
    pluck('mocha_tests.full_title').uniq
  }
  scope :scenarios_by_project, lambda { |project|
    by_project(project).pluck('mocha_tests.full_title').uniq
  }

  def status
    failures.zero? ? 'passed' : 'failed'
  end
end
