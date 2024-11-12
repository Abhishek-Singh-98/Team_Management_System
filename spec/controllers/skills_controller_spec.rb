require 'rails_helper'

RSpec.describe SkillsController, type: :controller do
  let!(:skill){FactoryBot.create(:skill)}
  let(:valid_params) do
    {
      name: 'Ruby'
    }
  end
  describe "POST /Create" do
    context 'when valid params is present' do
      it 'must create the skill' do
        post :create, params: valid_params
        expect(response).to have_http_status(200)
        expect(JSON.parse(response.body)['name']).to eq(valid_params[:name])
      end
    end

    context 'when invalid params is present' do
      before do
        valid_params[:name] = nil
      end
      it 'must give error for the skill' do
        post :create, params: valid_params
        expect(response).to have_http_status(422)
        expect(JSON.parse(response.body)['error']).to include("parameter missing for skill")
      end
    end

    context 'when same name params is passed' do
      before do
        valid_params[:name] = skill.name
      end
      it 'must give error for the skill' do
        post :create, params: valid_params
        expect(response).to have_http_status(422)
        expect(JSON.parse(response.body)['skill']['name']).to include("has already been taken")
      end
    end
  end

  describe 'GET /index' do
    context 'when skills are present' do
      it 'must list all the skills' do
        get :index
        expect(response).to have_http_status(200)
        expect(JSON.parse(response.body).count).to eq(Skill.count)
      end
    end
  end
end
