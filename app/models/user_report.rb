# frozen_string_literal: true

# DB model that defines relation between User and Report
class UserReport < ApplicationRecord
  belongs_to :user
  belongs_to :report

  scope :rspec, lambda {
    joins(:report).where('reports.reportable_type' => 'RspecReport')
  }
end
