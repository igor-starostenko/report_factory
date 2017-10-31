# frozen_string_literal: true

# DB model that represents an RSpec exception
# of an RSpec Example
class RspecException < ActiveRecord::Base
  belongs_to :rspec_example
  validates :classname, presence: true
  serialize :backtrace, Array
end
