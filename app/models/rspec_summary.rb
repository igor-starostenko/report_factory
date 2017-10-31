# frozen_string_literal: true

# DB model that represents an RSpec summary
# of an RSpec Report
class RspecSummary < ActiveRecord::Base
  belongs_to :rspec_report
  validates :rspec_report_id, presence: true, uniqueness: true
  validates :example_count, presence: true
  validates :failure_count, presence: true
  validates :pending_count, presence: true
end
