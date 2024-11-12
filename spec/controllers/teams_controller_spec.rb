require 'rails_helper'

RSpec.describe TeamsController, type: :controller do
  let(:employee1){FactoryBot.create(:employee)}
  let(:employee2){FactoryBot.create(:employee)}
  let(:employee3){FactoryBot.create(:employee)}
  let(:employee4){FactoryBot.create(:employee)}
  let(:employee5){FactoryBot.create(:employee)}
  let(:team_lead1){FactoryBot.create(:employee, role: 'Team_Lead', experience: 7)}
  let(:team_lead2){FactoryBot.create(:employee, role: 'Team_Lead', experience: 10)}
  let(:manager1){FactoryBot.create(:employee, role: 'Manager', experience: 15)}
  let(:manager2){FactoryBot.create(:employee, role: 'Manager', experience: 18)}
  let!(:team){FactoryBot.create(:team, manager_id: manager1.id, team_owner_id: team_lead1.id,
      employee_teams_attributes:[{employee_id: employee5.id, _destroy: false}], max_member: 3)}

  let!(:tl_token){JwtAuthentication.encode(id: team_lead1.id)}
  let!(:manager_token){JwtAuthentication.encode(id: manager2.id)}

  let(:valid_params) do
    {
      team_name: "Team #{Faker::Team.name}",
      team_owner_id: team_lead2.id,
      description: 'This Is a Dynamic Team Of Backend Developers',
      max_member: 7,
      employee_teams_attributes: [
        {
          employee_id: employee1.id,
          _destroy: false
        },
        {
          employee_id: employee2.id,
          _destroy: false
        },
        {
          employee_id: employee3.id,
          _destroy: false
        }
      ],
      token: manager_token,
      employee_id: manager2.id
    }
  end

  describe "POST /create" do
    context 'when invalid user try to create team' do
      it 'must give unauthorized error' do
        post :create, params: {token: tl_token, employee_id: team_lead1.id}
        expect(response).to have_http_status(401)
        expect(JSON.parse(response.body)['error']).to eq("You are not authorized to create Team.")
      end
    end

    context 'For valid user trying to create team' do
      it 'must give error for team owner absent' do
        post :create, params: {token: manager_token, employee_id: manager2.id}
        expect(response).to have_http_status(422)
        expect(JSON.parse(response.body)['error']).to eq('Team leader must be present.')
      end

      it 'must give error for token manipulation' do
        post :create, params: {token: manager_token, employee_id: team_lead1.id}
        expect(response).to have_http_status(401)
        expect(JSON.parse(response.body)['error']).to eq("You are not authorized to create Team.")
      end

      it 'must give error for invalid team owner' do
        post :create, params: {token: manager_token, employee_id: manager2.id, team_owner_id: employee2.id}
        expect(response).to have_http_status(422)
        expect(JSON.parse(response.body)['error']).to eq('Team owner can only be a Team Lead.')
      end

      it 'must give error for already assigned team owner' do
        EmployeeTeam.create(employee: team_lead1, team: team)
        post :create, params: {token: manager_token, employee_id: manager2.id, team_owner_id: team_lead1.id}
        expect(response).to have_http_status(422)
        expect(JSON.parse(response.body)['error']).to eq('Team owner is already assigned a team to Lead.')
      end

      it 'must give error for exceeding max members' do
        post :create, params: {token: manager_token, employee_id: manager2.id, team_owner_id: team_lead2.id,
              employee_teams_attributes: [{employee_id: employee2.id, _destroy: false},
                                              {employee_id: employee3.id, _destroy: false}], max_member: 2}
        expect(response).to have_http_status(422)
        expect(JSON.parse(response.body)['team']).to eq('Team is already full.')
      end

      it 'must create the Team for fully valid data' do
        post :create, params: valid_params
        expect(response).to have_http_status(200)
        expect(JSON.parse(response.body)["team_name"]).to eq(valid_params[:team_name])
      end

      it 'must give validation error' do
        valid_params[:team_name] = nil
        post :create, params: valid_params
        expect(response).to have_http_status(422)
        expect(JSON.parse(response.body)["team_name"]).to include("can't be blank")
      end
    end
  end

  describe 'PUT /update' do
    before do
      @employee5_team = EmployeeTeam.find_by(employee_id: employee5.id)
    end
    context 'when invalid user try to update team' do
      let(:emp_token){JwtAuthentication.encode(id: employee1.id)}
      it 'must give unauthorized error' do
        put :update, params: {token: emp_token, employee_id: team.team_owner_id, id: team.id}
        expect(response).to have_http_status(401)
        expect(JSON.parse(response.body)['error']).to eq("You are not authorized to create Team.")
      end
    end

    context 'For valid user trying to create team' do
      it 'must give error for team owner absent' do
        put :update, params: {token: tl_token, employee_id: team.team_owner_id, id: team.id}
        expect(response).to have_http_status(422)
        expect(JSON.parse(response.body)['error']).to eq('Team leader must be present.')
      end

      it 'must give error for invalid team owner' do
        put :update, params: {token: tl_token, employee_id: team.team_owner_id,
                                  team_owner_id: employee2.id, id:team.id}
        expect(response).to have_http_status(422)
        expect(JSON.parse(response.body)['error']).to eq('Team owner can only be a Team Lead.')
      end

      it 'must give error for already assigned team owner' do
        team2 = FactoryBot.create(:team, manager_id: manager2.id)
        EmployeeTeam.create(employee: team_lead2, team: team2)
        put :update, params: {token: tl_token, employee_id: team.team_owner_id,
                                          team_owner_id: team_lead2.id, id: team.id}
        expect(response).to have_http_status(422)
        expect(JSON.parse(response.body)['error']).to eq('Team owner is already assigned a team to Lead.')
      end

      it 'must give error for exceeding max members' do
        put :update, params: {token: tl_token, employee_id: team.team_owner_id, team_owner_id: team_lead1.id,
              employee_teams_attributes: [{id: @employee5_team&.id,employee_id: employee5.id, _destroy: false},
              {employee_id: employee2.id, _destroy: false}, {employee_id: employee3.id, _destroy: false}],
                        max_member: 3, id: team.id}
        expect(response).to have_http_status(422)
        expect(JSON.parse(response.body)['team']).to eq('Team is already full.')
      end

      it 'must update the Team for fully valid data' do
        put :update, params: {token: tl_token, employee_id: team.team_owner_id, team_owner_id: team_lead1.id,
              employee_teams_attributes: [{id: @employee5_team&.id,employee_id: employee5.id, _destroy: true},
              {employee_id: employee2.id, _destroy: false}, {employee_id: employee3.id, _destroy: false}],
                        max_member: 3, id: team.id}
        expect(response).to have_http_status(200)
        expect(JSON.parse(response.body)["team_name"]).to eq(team.team_name)
      end

      it 'must give validation error' do
        put :update, params: {token: tl_token, employee_id: team.team_owner_id, team_owner_id: team_lead1.id,
              employee_teams_attributes: [{id: @employee5_team&.id,employee_id: employee5.id, _destroy: false},
              {employee_id: employee2.id, _destroy: false}], max_member: 3, id: team.id, team_name: nil}
        expect(response).to have_http_status(422)
        expect(JSON.parse(response.body)["team_name"]).to include("can't be blank")
      end
    end
  end

  describe "GET /show" do
    context 'when valid user checks the team details' do
      it 'must show the details' do
        get :show, params: {id: team.id, token: manager_token, employee_id: manager2.id}
        expect(response).to have_http_status(200)
        expect(JSON.parse(response.body)['team_name']).to eq(team.team_name)
      end

      it 'must give error for wrong id passed' do
        get :show, params: {id: '', token: manager_token, employee_id: manager2.id}
        expect(response).to have_http_status(404)
        expect(JSON.parse(response.body)['error']).to eq("Something wrong happened.")
      end
    end
  end

  describe 'DELETE /destroy' do
    context 'when valid user try to destroy the team' do
      it 'must destroy the team' do
        delete :destroy, params: {id: team.id, token: manager_token, employee_id: manager2.id}
        expect(response).to have_http_status(200)
        expect(JSON.parse(response.body)['success']).to eq("Team Deleted Successfully.")
      end
    end

    context 'when invalid user try to destroy team' do
      it 'must not allow to destroy the team' do
        emp_token = JwtAuthentication.encode(id: employee1.id)
        delete :destroy, params: {id: team.id, token: emp_token, employee_id: employee1.id}
        expect(response).to have_http_status(401)
        expect(JSON.parse(response.body)['error']).to eq("You are not authorized to create Team.")
      end
    end
  end

  describe 'GET /team_members_list' do
    context 'when valid user checks the list' do
      it 'must show the list' do
        get :team_members_list, params: {token: tl_token, employee_id: team_lead1.id, team_id: team.id}
        expect(response).to have_http_status(200)
        expect(JSON.parse(response.body).pluck("id")).to include(team_lead1.id)
      end
    end

    context 'when user is not in the team' do
      it 'still can see the team members of any team' do
        tl2_token = JwtAuthentication.encode(id: team_lead2.id)
        get :team_members_list, params: {token: tl2_token, employee_id: team_lead2.id, team_id: team.id}
        expect(response).to have_http_status(200)
        expect(JSON.parse(response.body).pluck("id")).to include(team_lead1.id)
      end
    end
  end

  describe "GET /show_team_member_details" do
    context 'when valid employee checks the team' do
      it 'must show the team member detail' do
        get :show_team_member_details, params: {token: tl_token, employee_id: team_lead1.id, team_id: team.id, team_member_id: employee4.id}
        expect(response).to have_http_status(200)
        expect(JSON.parse(response.body)['first_name']).to include(employee4.first_name)
      end

      it 'must give team details for team member id missing' do
        get :show_team_member_details, params: {token: tl_token, employee_id: team_lead1.id, team_id: team.id, team_member_id: nil}
        expect(response).to have_http_status(200)
        expect(JSON.parse(response.body)['team_name']).to include(team.team_name)
      end
    end

    context 'when invalid member is searched' do
      it 'must give error' do
        get :show_team_member_details, params: {token: tl_token, employee_id: team_lead1.id, team_id: team.id, team_member_id: 0}
        expect(response).to have_http_status(422)
        expect(JSON.parse(response.body)['error']).to include('Invalid Member') 
      end
    end
  end

  describe 'GET /index' do
    context 'when valid user want to check the team list' do
      it 'must be able to see the list' do
        get :index, params: {token: tl_token, employee_id: team_lead1.id}
        expect(response).to have_http_status(200)
        expect(JSON.parse(response.body).pluck('id')).to include(team.id)
      end
    end

    context 'when expired token is passed' do
      it 'must give jwt error' do
        allow(JwtAuthentication).to receive(:decode).and_return({'id': 0})
        get :index, params: {token: tl_token, employee_id: team_lead1.id}
        expect(response).to have_http_status(404)
        expect(JSON.parse(response.body)['error']).to eq('Employee not found')
      end
    end
  end
end
