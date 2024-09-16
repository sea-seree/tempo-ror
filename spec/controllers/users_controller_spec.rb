require "rails_helper"

RSpec.describe UsersController, type: :controller do
  let(:valid_attributes) {
    {
      first_name: "John",
      last_name: "Doe",
      birthday: "1990-01-01",
      gender: "male",
      email: "john@example.com",
      phone: "1234567890",
      subject: "HTML"
    }
  }

  let(:user) { User.create!(valid_attributes) }

  describe "GET #index" do
    it "returns a successful response" do
      get :index
      expect(response).to be_successful
      expect(assigns(:users)).to eq([user])
    end
  end

   describe "GET #show" do
    it "returns a successful response" do
      get :show, params: { id: user.id }
      expect(response).to be_successful
      expect(assigns(:user)).to eq(user)
    end
  end

    describe "GET #new" do
    it "returns a successful response" do
      get :new
      expect(response).to be_successful
      expect(assigns(:user)).to be_a_new(User)
    end
  end

  describe "POST #create" do
    context "with valid parameters" do
      it "creates a new User" do
        expect {
          post :create, params: { user: valid_attributes }
        }.to change(User, :count).by(1)
      end
    end

    context "with invalid parameters" do
      it "does not create a new User" do
        expect {
          post :create, params: { user: { first_name: nil } }
        }.to change(User, :count).by(0)
      end
    end
  end




end
