require 'rails_helper'

RSpec.describe EmployeesController, type: :controller do

  let!(:employee1){FactoryBot.create(:employee)}
  let!(:employee2){FactoryBot.create(:employee)}
  let(:emp_token){JwtAuthentication.encode(id: employee1.id)}
  describe "GET /index" do
    context 'when valid user is present' do
      it 'must gives the list of employees' do
        get :index, params: {token: emp_token}
        expect(response).to have_http_status(200)
        expect(JSON.parse(response.body)&.count).to eq(Employee.count - 1)
      end
    end

    context 'when invalid user is present' do
      it 'must give authentication error' do
        get :index, params: {token: 'jafbeksosegosvosle'}
        expect(response).to have_http_status(400)
        expect(JSON.parse(response.body)['token']).to eq("Invalid Token")
      end
    end
  end

  describe 'GET /list_available_employees' do
    context 'when general employee try to fetch this list' do
      it 'must get unauthorized error' do
        get :list_available_employees, params:{token: emp_token, employee_id: employee1.id, role: 'Team_Lead'}
        expect(response).to have_http_status(401)
        expect(JSON.parse(response.body)['error']).to eq("Unauthorized to see the list")
      end
    end

    context 'when manager try to fetch the list' do
      let(:manager1){FactoryBot.create(:employee, role: 'Manager', experience: rand(12..20))}
      let!(:team_lead){FactoryBot.create(:employee, role: 'Team_Lead', experience: rand(6..12))}

      before do
        @man_token = JwtAuthentication.encode(id: manager1.id)
      end
      
      it 'must be able to see the list' do
        get :list_available_employees, params:{token: @man_token, employee_id: manager1.id, role: 'Employee'}
        expect(response).to have_http_status(200)
        expect(parsed_response(response)).to include(employee1.id)
      end

      it 'must be able to see the team owner list' do
        get :list_available_employees, params:{token: @man_token, employee_id: manager1.id, role: 'Team_Lead'}
        expect(response).to have_http_status(200)
        expect(parsed_response(response)).to include(team_lead.id)
      end

      it 'must give error for role missing params' do
        get :list_available_employees, params:{token: @man_token, employee_id: manager1.id, role: nil}
        expect(response).to have_http_status(200)
        expect(JSON.parse(response.body)['error']).to include('Missing role')
      end

      it 'must filter the employees according to last_name' do
        get :list_available_employees, params:{token: @man_token, employee_id: manager1.id,
                            role: 'Employee', case: 'last_name', query: employee1.last_name}
        expect(response).to have_http_status(200)
        expect(parsed_response(response)).to include(employee1.id)
      end

      it 'must filter the employees according to first_name' do
        get :list_available_employees, params:{token: @man_token, employee_id: manager1.id,
                            role: 'Employee', case: 'first_name', query: employee1.first_name}
        expect(response).to have_http_status(200)
        expect(parsed_response(response)).to include(employee1.id)
      end

      it 'must filter the employees according to email' do
        get :list_available_employees, params:{token: @man_token, employee_id: manager1.id,
                            role: 'Employee', case: 'email', query: employee2.email}
        expect(response).to have_http_status(200)
        expect(parsed_response(response)).to include(employee2.id)
      end

      it 'must give unfiltered list if case is not passed' do
        get :list_available_employees, params:{token: @man_token, employee_id: manager1.id,
                            role: 'Employee', query: employee2.email}
        expect(response).to have_http_status(200)
        expect(parsed_response(response)).to include(employee1.id)
      end
    end
  end


  def parsed_response(response)
    JSON.parse(response.body).pluck('id')
  end
end
