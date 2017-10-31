# frozen_string_literal: true

# Abstract class to be inherited
class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true
end
