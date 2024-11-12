class TeamsController < ApplicationController
  include TeamsConcern

  before_action :authenticate
  before_action :verify_valid_creator, except: [:team_members_list, :show, :show_team_member_details, :index]
  before_action :check_for_valid_team_owner, except: [:destroy, :team_members_list, :show, :show_team_member_details, :index]
  before_action :find_team, except: [:create, :index]
  before_action :max_member_check, only: [:create, :update]

  def index
    @teams = params[:page].present? ? Team.order(:id).page(params[:page]).per(10) : Team.all
    render json: @teams
  end
  
  def create
    team = Team.new(team_params)
    team.employee = @current_employee
    if team.save
      render json: team
    else
      render json: team.errors.messages, status: 422
    end
  end

  def update
    if @team.update(team_params)
      render json: @team
    else
      render json: @team.errors.messages, status: 422
    end
  end

  def show
    render json: @team
  end

  def destroy
    if @team.destroy
      render json: {success: 'Team Deleted Successfully.'}
    end
  end

  def team_members_list
    members = @team.employees
    render json: members
  end

  def show_team_member_details
    return render json: @team unless params[:team_member_id].present?
    team_member = Employee.find_by(id: params[:team_member_id])
    if team_member.present?
      render json: team_member
    else
      render json: {error: "Invalid Member"}, status: 422
    end
  end

  private
  def team_params
    params.permit(:team_name, :description,
                  :team_owner_id, :max_member,
                  employee_teams_attributes: [:id, :employee_id, :joining_date, :_destroy])
  end

  def find_team
    team_id = params[:id].presence ? params[:id] : params[:team_id]
    @team = Team.find_by_id(team_id)
    unless @team.present?
      render json: {error: 'Something wrong happened.'}, status: :not_found
    end
  end
end
