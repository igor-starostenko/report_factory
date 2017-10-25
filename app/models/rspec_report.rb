# frozen_string_literal: true

# DB model that represents an RSpec tests
# report submitted for a project
class RspecReport < ActiveRecord::Base
  has_one :report, as: :reported
  has_many :rspec_examples
  has_one :rspec_summary
end
