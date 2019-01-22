# frozen_string_literal: true

# DB model that defines relation between User and Report
class UserReport < ApplicationRecord
  belongs_to :user
  belongs_to :report

  scope :mocha, lambda {
    joins(:report).where('reports.reportable_type' => 'MochaReport')
  }

  scope :rspec, lambda {
    joins(:report).where('reports.reportable_type' => 'RspecReport')
  }

  scope :with_project, lambda {
    eager_load(report: :project)
  }

  scope :updated_since, lambda { |date|
    joins(:report).where('updated_at > ?', date || Time.at(0))
  }
end
