require 'rails_helper'

RSpec.describe UsersHelper, type: :helper do
  describe "#format_date_in_thai" do
    it "returns an empty string if the date is nil" do
      expect(helper.format_date_in_thai(nil)).to eq('')
    end

    it "returns an empty string if the date is not a valid date object" do
      expect(helper.format_date_in_thai("invalid_date")).to eq('')
    end

    it "formats date in Thai format and converts year to B.E. (พ.ศ.)" do
      date = Date.new(2024, 9, 17)
      expect(helper.format_date_in_thai(date)).to eq('17/09/2567')
    end
  end
end
