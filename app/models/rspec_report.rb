class RspecReport < ActiveRecord::Base
  has_one :report, as: :reported
  has_many :rspec_examples
  has_one :rspec_summary
end
