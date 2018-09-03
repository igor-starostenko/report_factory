# frozen_string_literal: true

# DB polymorphic model that may represent
# any type of report submitted for a project
class Report < ActiveRecord::Base
  has_one :user_report, dependent: :destroy
  has_one :user, through: :user_report
  belongs_to :project
  belongs_to :reportable, polymorphic: true, dependent: :destroy
  validates :project_id, presence: true
  validates :status, presence: true

  before_save { self.tags = tags&.map { |tag| tag.downcase } }

  scope :updated_since, lambda { |date|
    where('updated_at > ?', date || Time.at(0))
  }

  scope :tags, ->(tag) { where('tags @> ARRAY[?]', tag) }
end
