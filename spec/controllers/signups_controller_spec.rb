require 'rails_helper'

RSpec.describe SignupsController, type: :controller do
  let(:skill1){FactoryBot.create(:skill)}
  let(:skill2){FactoryBot.create(:skill, name: 'PostgreSQL')}
  let!(:employee){FactoryBot.create(:employee)}
  let(:valid_params) do
    {
      first_name: 'Test',
      last_name: 'Employee',
      email: Faker::Internet.unique.email,
      phone_number: Faker::Alphanumeric.alpha(number: 10),
      password: 'Password',
      password_confirmation: 'Password',
      role: 'QA',
      skill_ids: [skill1.id, skill2.id],
      experience: rand(2..5)
    }
  end
  describe "POST /create" do
    context 'when valid params are passed' do
      it 'must create the employee and signup' do
        post :create, params: valid_params
        expect(response).to have_http_status(200)
        expect(JSON.parse(response.body)['employee']['email']).to eq(valid_params[:email])
      end
    end

    context 'when invalid params are passed' do
      before do
        valid_params[:email] = nil
      end
      it 'gives validation errors' do
        post :create, params: valid_params
        expect(response).to have_http_status(422)
        expect(JSON.parse(response.body)['employee']['email']).to include("can't be blank")
      end
    end
    
    context 'when email is already used' do
      before do
        valid_params[:email] = employee.email
      end
      it 'must give authorize employee error' do
        post :create, params: valid_params
        expect(response).to have_http_status(422)
        expect(JSON.parse(response.body)['error']).to eq('Employee with this email already present.')
      end
    end

    context 'when some unwanted error comes' do
      it 'must throw error' do
        expect_any_instance_of(Employee).to receive(:save).and_raise(ArgumentError, 'This is random error')
        post :create, params: valid_params
        expect(response).to have_http_status(422)
        expect(JSON.parse(response.body)).to eq('This is random error')
      end
    end
  end
end
