# frozen_string_literal: true

# DB model that represents an RSpec example.
# An executed test case.
class RspecExample < ActiveRecord::Base
  belongs_to :rspec_report
  validates :rspec_report_id, presence: true
  validates :status, presence: true
end
