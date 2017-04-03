require 'rails_helper'

# These tests are auto-generated from Rails scaffolding, so they're not the best
# tests you'll ever run into. Still, this is a useful stub of a test for our
# application.

RSpec.describe LocationsController, type: :controller, vcr: true do
  render_views

  let(:user) { User.create!(email: "test@test.com", password: "abcd1234") }

  let(:valid_attributes) {
    { title: "The Bean", description: "Technically it's called Cloud Gate", address: "Millennium Park, Chicago" }
  }

  let(:invalid_attributes) {
    { title: "", description: "There's nothing really here.", address: "Millennium Park, Chicago" }
  }

  before { sign_in(user) }

  describe "GET #index" do
    it "assigns all locations as @locations" do
      location = Location.create! valid_attributes
      get :index, params: {}
      expect(assigns(:locations)).to eq([location])
    end

    it "completes a search" do
      allow(SearchesLocations).to receive(:new).and_call_original

      get :index, params: { q: 'Eiffel Tower' }

      expect(SearchesLocations).to have_received(:new).with(query: "Eiffel Tower")
    end
  end

  describe "GET #show" do
    it "assigns the requested location as @location" do
      location = Location.create! valid_attributes
      get :show, params: {id: location.to_param}
      expect(assigns(:location)).to eq(location)
    end

    it "shows a Google Maps embedded map on the page" do
      location = Location.create! valid_attributes

      get :show, params: {id: location.to_param}

      expect(response.body).to include("google.com/maps/embed")
      expect(response.body).to include("q=#{location.latitude.floor(5)},#{location.longitude.floor(5)}")
      expect(response.body).to include(Rails.application.secrets.google_api_key)
    end
  end

  describe "GET #new" do
    it "assigns a new location as @location" do
      get :new, params: {}
      expect(assigns(:location)).to be_a_new(Location)
    end
  end

  describe "GET #edit" do
    it "assigns the requested location as @location" do
      location = Location.create! valid_attributes
      get :edit, params: {id: location.to_param}
      expect(assigns(:location)).to eq(location)
    end
  end

  describe "POST #create" do
    let(:location) { Location.new }
    let(:service) { instance_double(CreatesLocation, call: nil, success?: true, location: location) }

    it "calls the CreatesLocation service" do
      allow(CreatesLocation).to receive(:new) { service }

      post :create, params: { location: valid_attributes }

      expect(CreatesLocation).to have_received(:new).with(valid_attributes)
      expect(service).to have_received(:call)
    end

    it "assigns @location" do
      allow(CreatesLocation).to receive(:new) { service }

      post :create, params: { location: valid_attributes }

      expect(assigns(:location)).to eq(location)
    end

    it "redirects to the location" do
      allow(CreatesLocation).to receive(:new) { service }

      post :create, params: { location: valid_attributes }

      expect(response).to redirect_to(location)
    end

    context "with invalid params" do
      let(:service) { instance_double(CreatesLocation, call: nil, success?: false, location: location) }

      it "re-renders the 'new' template" do
        allow(CreatesLocation).to receive(:new) { service }

        post :create, params: { location: valid_attributes }

        expect(response).to render_template("new")
      end
    end
  end

  describe "PUT #update" do
    context "with valid params" do
      let(:new_attributes) {
        { title: "This is a different title" }
      }

      it "updates the requested location" do
        location = Location.create! valid_attributes

        expect {
          put :update, params: {id: location.to_param, location: new_attributes}
        }.to change {
          location.reload.title
        }
      end

      it "assigns the requested location as @location" do
        location = Location.create! valid_attributes
        put :update, params: {id: location.to_param, location: valid_attributes}
        expect(assigns(:location)).to eq(location)
      end

      it "redirects to the location" do
        location = Location.create! valid_attributes
        put :update, params: {id: location.to_param, location: valid_attributes}
        expect(response).to redirect_to(location)
      end
    end

    context "with invalid params" do
      it "assigns the location as @location" do
        location = Location.create! valid_attributes
        put :update, params: {id: location.to_param, location: invalid_attributes}
        expect(assigns(:location)).to eq(location)
      end

      it "re-renders the 'edit' template" do
        location = Location.create! valid_attributes
        put :update, params: {id: location.to_param, location: invalid_attributes}
        expect(response).to render_template("edit")
      end
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested location" do
      location = Location.create! valid_attributes
      expect {
        delete :destroy, params: {id: location.to_param}
      }.to change(Location, :count).by(-1)
    end

    it "redirects to the locations list" do
      location = Location.create! valid_attributes
      delete :destroy, params: {id: location.to_param}
      expect(response).to redirect_to(locations_url)
    end
  end

end
