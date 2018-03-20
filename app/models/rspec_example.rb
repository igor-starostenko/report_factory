# frozen_string_literal: true

# DB model that represents an RSpec example.
# An executed test case.
class RspecExample < ActiveRecord::Base
  belongs_to :rspec_report
  has_one :exception, class_name: 'RspecException'
  validates :status, presence: true
  accepts_nested_attributes_for :exception,
                                reject_if: :no_exception?

  def no_exception?(attributes)
    attributes['exception'].nil?
  end
end
