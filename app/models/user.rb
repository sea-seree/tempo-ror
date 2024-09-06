class User < ApplicationRecord
  validates :first_name, presence: true
  validates :first_name, format: { with: /\A[a-zA-Z]+\z/, message: "is not allowed to contain numbers or special characters" }, if: -> { first_name.present? }

  validates :last_name, presence: true
  validates :last_name, format: { with: /\A[a-zA-Z]+\z/, message: "is not allowed to contain numbers or special characters" }, if: -> { last_name.present? }
  validates :last_name, length: { maximum: 50, message: "must be less than or equal to 50 characters" }

  validates :birthday, presence: true
  validate :validate_birthday_format, if: -> { birthday.present? }

  validates :gender, presence: true
  validates :gender, inclusion: { in: %w(male female), message: "%{value} is not a valid gender" }, if: -> { gender.present? }

  validates :email, presence: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP, message: "is invalid" }, uniqueness: { case_sensitive: false, message: "has already been taken" }

  validates :phone, presence: true
  validates :phone, format: { with: /\A[0-9]{10}\z/, message: "must be 10 digits" }

  validates :subject, presence: true, exclusion: { in: ['none'], message: "must be selected" }


  private

  def validate_birthday_format
    unless birthday.is_a?(Date)
      errors.add(:birthday, "is invalid")
    end
  end
end
