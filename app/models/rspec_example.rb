# frozen_string_literal: true

# DB model that represents an RSpec example.
# An executed test case.
class RspecExample < ActiveRecord::Base
  belongs_to :rspec_report
  has_one :exception, class_name: 'RspecException'
  validates :rspec_report_id, presence: true
  validates :status, presence: true
end
