module TeamsConcern
  extend ActiveSupport::Concern

  included do

    private
    def verify_valid_creator
      unless @current_employee.Manager? && @current_employee.id == params[:employee_id].to_i || (@current_employee.Team_Lead? && params[:action] == 'update')
        return render json: {error: 'You are not authorized to create Team.'}, status: 401
      end
    end
  
    def check_for_valid_team_owner
      return render json: {error: 'Team leader must be present.'}, status: 422 unless params[:team_owner_id].present?
      employee = Employee.find(params[:team_owner_id])
      unless employee.Team_Lead?
        render json: {error: 'Team owner can only be a Team Lead.'}, status: 422
      end
      unavailable_employee = employee.employee_teams
      if unavailable_employee.present?  && unavailable_employee.first.team_id != params[:id].to_i
        render json: {error: 'Team owner is already assigned a team to Lead.'}, status: 422
      end
    end

    def max_member_check
      if params[:action] == 'update' && params[:employee_teams_attributes].select{|attr| attr["_destroy"] == 'false' || attr["_destroy"] == false }&.size >= @team.max_member.to_i
        render json: {team: 'Team is already full.'}, status: 422
      end
      if params[:action] == 'create' && params[:employee_teams_attributes]&.size >= params[:max_member].to_i
        render json: {team: 'Team is already full.'}, status: 422
      end
    end
  end
end