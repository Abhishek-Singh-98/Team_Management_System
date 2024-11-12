require 'rails_helper'

RSpec.describe LoginsController, type: :controller do
  let(:employee){FactoryBot.create(:employee, password: 'Pass@2024', password_confirmation: 'Pass@2024')}
  let(:valid_params) do
    {
      email: employee.email,
      password: 'Pass@2024'
    }
  end
  describe "POST /create" do
    context 'when valid password is passed' do
      it 'must login with a token in response' do
        post :create, params: valid_params
        expect(response).to have_http_status(200)
        expect(JSON.parse(response.body)['meta']['message']).to eq("Login Successfull.")
      end
    end

    context 'when invalid email is passed' do
      before do
        valid_params[:email] = 'wrong_user@wrong_mail.com'
      end
      it 'must give error for user not present' do
        post :create, params: valid_params
        expect(response).to have_http_status(422)
        expect(JSON.parse(response.body)['error']).to eq("Employee not present in the system.")
      end
    end

    context 'when valid email is passed with wrong password' do
      before do
        valid_params[:password] = 'wrong_password9912'
      end
      it 'must give error for unauthentication' do
        post :create, params: valid_params
        expect(response).to have_http_status(401)
        expect(JSON.parse(response.body)['error']).to eq("Invalid Password")
      end
    end
  end
end
