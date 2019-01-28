# frozen_string_literal: true

require 'securerandom'

# Top level STI model for all types of users
class User < ApplicationRecord
  has_many :user_reports, dependent: :destroy
  has_many :reports, through: :user_reports, dependent: :destroy
  before_create :set_api_key
  validates :name,
            presence: true,
            uniqueness: { case_sensitive: false },
            length: { minimum: 3, maximum: 11 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i.freeze
  validates :email,
            uniqueness: { case_sensitive: false },
            length: { maximum: 105 },
            format: { with: VALID_EMAIL_REGEX }
  before_save { self.email = email.downcase }
  VALID_PASSWORD_REGEX = /\A(?=.*[a-zA-Z])(?=.*[0-9]).{8,105}\z/.freeze
  validates :password,
            allow_nil: true,
            format: { with: VALID_PASSWORD_REGEX }
  validates_presence_of :password_digest, :type
  has_secure_password

  def self.type_options
    descendants.map(&:to_s).sort
  end

  def cached_reports
    old_reports = fetch_cached_reports.sort_by(&:id)
    new_reports = reports.updated_since(old_reports.last&.updated_at)
    return old_reports if new_reports.empty?

    all_reports = (new_reports + old_reports).uniq
    Rails.cache.write("#{cache_key}/reports", all_reports)
    all_reports
  end

  private

  def set_api_key
    self.api_key = generate_api_key
  end

  def generate_api_key
    SecureRandom.uuid
  end

  def fetch_cached_reports
    Rails.cache.fetch("#{cache_key}/reports") { reports }
  end

  def cache_key
    @cache_key ||= "#{name}/#{created_at.to_s(:number)}"
  end
end
