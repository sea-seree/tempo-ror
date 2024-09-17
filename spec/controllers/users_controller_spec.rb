require "rails_helper"

RSpec.describe UsersController, type: :controller do
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
      email: "invalid_email"
    }
  }

  let(:user) { User.create!(valid_attributes) }

  describe "GET #index" do
    it "returns a successful response" do
      get :index
      expect(response).to be_successful
      expect(assigns(:users)).to include(user)
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
          post :create, params: { user: { first_name: invalid_attributes } }
        }.to change(User, :count).by(0)
      end

      it "renders the new template" do
        post :create, params: { user: invalid_attributes }
        expect(response).to render_template("new")
        expect(response.status).to eq(422)
      end
    end
  end

  describe "GET #edit" do
    it "returns a successful response" do
      get :edit, params: { id: user.id }
      expect(response).to be_successful
      expect(assigns(:user)).to eq(user)
    end
  end

    describe "PATCH/PUT #update" do
      context "with valid parameters" do
        let(:new_attributes) {
          { first_name: "Jane", last_name: "Doe", email: "jane@example.com" }
        }

        it "updates the requested user" do
          put :update, params: { id: user.id, user: new_attributes }
          user.reload
          expect(user.first_name).to eq("Jane")
          expect(user.email).to eq("jane@example.com")
        end

        it "redirects to the user" do
          put :update, params: { id: user.id, user: new_attributes }
          expect(response).to redirect_to(user)
        end
      end

      context "with invalid parameters" do
        it "renders the edit template" do
          put :update, params: { id: user.id, user: invalid_attributes }
          expect(response).to render_template("edit")
          expect(response.status).to eq(422)
        end
      end
    end

    describe "DELETE #destroy" do
    it "deletes the user" do
      user = User.create!(valid_attributes)
      expect {
        delete :destroy, params: { id: user.id }
      }.to change(User, :count).by(-1)
    end

    it "redirects to the users list" do
      delete :destroy, params: { id: user.id }
      expect(response).to redirect_to(users_path)
    end
  end
end
