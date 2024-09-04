class User < ApplicationRecord
  validates :first_name, presence: true, length: { maximum: 50 }
  validates :last_name, presence: true, length: { maximum: 50 }
  validates :birthday, presence: true
  validates :gender, presence: true, inclusion: { in: %w(male female), message: "%{value} is not a valid gender" }
  validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }, uniqueness: true
  validates :phone, presence: true, format: { with: /\A[0-9]{10}\z/, message: "must be 10 digits" }
  validates :subject, presence: true, inclusion: { in: %w(html css js ts), message: "%{value} is not a valid subject" }
end
