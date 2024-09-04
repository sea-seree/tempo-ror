class User < ApplicationRecord
  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :birthday, presence: true
  validates :gender, presence: true
  validates :email, presence: true
  validates :phone, presence: true
  validates :subject, presence: true
end
