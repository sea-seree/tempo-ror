class User < ApplicationRecord
  # Validation for first_name
  validates :first_name, presence: true
  validates :first_name, format: { with: /\A[a-zA-Z]+\z/, message: "is not allowed to contain numbers or special characters" }, if: -> { first_name.present? }

  # Validation for last_name
  validates :last_name, presence: true
  validates :last_name, format: { with: /\A[a-zA-Z]+\z/, message: "is not allowed to contain numbers or special characters" }, if: -> { last_name.present? }
  validates :last_name, length: { maximum: 50, message: "must be less than or equal to 50 characters" }

  # Validation for birthday
  validates :birthday, presence: true
  validate :validate_birthday_format, if: -> { birthday.present? }

  # Validation for gender
  validates :gender, presence: true
  validates :gender, inclusion: { in: %w(male female), message: "%{value} is not a valid gender" }, if: -> { gender.present? }

  # Validation for email
  validates :email, presence: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP, message: "is invalid" }, uniqueness: { case_sensitive: false, message: "has already been taken" }

  # Validation for phone
  validates :phone, presence: true
  validates :phone, format: { with: /\A[0-9]{10}\z/, message: "must be 10 digits" }

  # Validation for subject
  validates :subject, presence: true

  private

  # Custom validation for birthday format (for example, ensuring a valid date)
  def validate_birthday_format
    unless birthday.is_a?(Date)
      errors.add(:birthday, "is invalid")
    end
  end
end
