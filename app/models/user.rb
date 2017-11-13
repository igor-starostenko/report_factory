# frozen_string_literal: true

require 'securerandom'

# Top level STI model for all types of users
class User < ApplicationRecord
  has_many :user_reports
  has_many :reports, through: :user_reports
  before_create :set_api_key
  validates :name,
            presence: true,
            uniqueness: { case_sensitive: false },
            length: { minimum: 3, maximum: 11 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email,
            uniqueness: { case_sensitive: false },
            length: { maximum: 105 },
            format: { with: VALID_EMAIL_REGEX }
  before_save { self.email = email.downcase }
  validates_presence_of :password_digest, :type
  has_secure_password

  def self.type_options
    descendants.map(&:to_s).sort
  end

  private

  def set_api_key
    self.api_key = generate_api_key
  end

  def generate_api_key
    SecureRandom.uuid
  end
end
