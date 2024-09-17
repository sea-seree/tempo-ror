# spec/models/user_spec.rb
require 'rails_helper'

RSpec.describe User, type: :model do
  let(:valid_attributes) {
    {
      first_name: "John",
      last_name: "Doe",
      birthday: "2545-01-01",
      gender: "male",
      email: "john@example.com",
      phone: "1234567890",
      subject: "HTML"
    }
  }

  let(:invalid_attributes) {
    {
      first_name: "",
      last_name: "",
      birthday: nil,
      gender: "",
      email: "invalid_email",
      phone: "1234",
      subject: "none"
    }
  }

    context "validations" do
      it "is valid with valid attributes" do
        user = User.new(valid_attributes)
        expect(user).to be_valid
      end

    it "is invalid without a first name" do
      user = User.new(valid_attributes.merge(first_name: nil))
      expect(user).not_to be_valid
      expect(user.errors[:first_name]).to include("ไม่สามารถเว้นว่างได้")
    end

    it "is invalid without a last name" do
      user = User.new(valid_attributes.merge(last_name: nil))
      expect(user).not_to be_valid
      expect(user.errors[:last_name]).to include("ไม่สามารถเว้นว่างได้")
    end

    it "is invalid with non-alphabetic characters in first name" do
      user = User.new(valid_attributes.merge(first_name: "John123"))
      expect(user).not_to be_valid
      expect(user.errors[:first_name]).to include("ไม่ถูกต้อง")
    end

    it "is invalid with non-alphabetic characters in last name" do
      user = User.new(valid_attributes.merge(last_name: "Doe123"))
      expect(user).not_to be_valid
      expect(user.errors[:last_name]).to include("ไม่ถูกต้อง")
    end

    it "is invalid without a birthday" do
      user = User.new(valid_attributes.merge(birthday: nil))
      expect(user).not_to be_valid
      expect(user.errors[:birthday]).to include("ไม่สามารถเว้นว่างได้")
    end

    it "is invalid if the user is younger than 18 years old" do
      user = User.new(valid_attributes.merge(birthday: "2555-01-01"))
      expect(user).not_to be_valid
      expect(user.errors[:birthday]).to include("You must be at least 18 years old.")
    end

    it "is invalid without a gender" do
      user = User.new(valid_attributes.merge(gender: nil))
      expect(user).not_to be_valid
      expect(user.errors[:gender]).to include("ไม่สามารถเว้นว่างได้")
    end

    it "is invalid with a gender other than male or female" do
      user = User.new(valid_attributes.merge(gender: "unknown"))
      expect(user).not_to be_valid
      expect(user.errors[:gender]).to include("ไม่อยู่ในรายการที่กำหนด")
    end

    it "is invalid without an email" do
      user = User.new(valid_attributes.merge(email: nil))
      expect(user).not_to be_valid
      expect(user.errors[:email]).to include("ไม่สามารถเว้นว่างได้")
    end

    it "is invalid with an improperly formatted email" do
      user = User.new(valid_attributes.merge(email: "invalid_email"))
      expect(user).not_to be_valid
      expect(user.errors[:email]).to include("ไม่ถูกต้อง")
    end

    it "is invalid without a phone number" do
      user = User.new(valid_attributes.merge(phone: nil))
      expect(user).not_to be_valid
      expect(user.errors[:phone]).to include("ไม่สามารถเว้นว่างได้")
    end

    it "is invalid with an improperly formatted phone number" do
      user = User.new(valid_attributes.merge(phone: "12345"))
      expect(user).not_to be_valid
      expect(user.errors[:phone]).to include("ไม่ถูกต้อง")
    end

    it "is invalid with a subject of 'none'" do
      user = User.new(valid_attributes.merge(subject: "none"))
      expect(user).not_to be_valid
      expect(user.errors[:subject]).to include("ไม่สามารถเลือกได้")
    end
  end

  context "callbacks" do
    it "capitalizes first name and last name before saving" do
      user = User.new(valid_attributes.merge(first_name: "john", last_name: "doe"))
      user.save
      expect(user.first_name).to eq("John")
      expect(user.last_name).to eq("Doe")
    end
  end

end
