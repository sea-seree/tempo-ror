class User < ApplicationRecord

  before_save :capitalize_name

  validates :first_name, presence: true
  validates :first_name, format: { with: /\A[a-zA-Z]+\z/}, if: -> { first_name.present? }

  validates :last_name, presence: true
  validates :last_name, format: { with: /\A[a-zA-Z]+\z/ }, if: -> { last_name.present? }

  validates :birthday, presence: true
  validate :validate_birthday_format, if: -> { birthday.present? }
  validate :least_18_years_old, if: -> { birthday.present? }


  validates :gender, presence: true
  validates :gender, inclusion: { in: %w(male female) }, if: -> { gender.present? }

  validates :email, presence: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }, uniqueness: { case_sensitive: false, message: "has already been taken" }

  validates :phone, presence: true
  validates :phone, format: { with: /\A[0-9]{10}\z/ }, if: -> { phone.present? }

  validates :subject, presence: true, exclusion: { in: ['none'] }


  private

  def validate_birthday_format
    unless birthday.is_a?(Date)
      errors.add(:birthday, "is invalid")
    end
  end

  def least_18_years_old
    if birthday.present?
      gregorian_birthday = birthday - 543.years # Convert Buddhist year (B.E.) to Gregorian year (A.D.)
      if gregorian_birthday > 18.years.ago.to_date
        errors.add(:birthday, "You must be at least 18 years old.")
      end
    end
  end

  def capitalize_name
    self.first_name = first_name.capitalize
    self.last_name = last_name.capitalize
  end

end
