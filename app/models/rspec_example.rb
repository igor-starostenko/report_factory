# frozen_string_literal: true

# DB model that represents an RSpec example.
# An executed test case.
class RspecExample < ActiveRecord::Base
  belongs_to :rspec_report
  has_one :exception, class_name: 'RspecException'
  validates :status, presence: true
  default_scope { order(id: :asc) }
  accepts_nested_attributes_for :exception,
                                reject_if: :no_exception?

  def no_exception?(attributes)
    attributes['classname'].nil?
  end

  scope :scenarios, -> { pluck(:full_description).uniq }
end
