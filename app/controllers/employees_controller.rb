class EmployeesController < ApplicationController
  before_action :authenticate
  before_action :check_authorized_employee, only: [:list_available_employees]

  def index
    @employees = Employee.where.not(id: @current_employee.id).order(:id).page(params[:page]).per(15)
    render json: @employees
  end

  def list_available_employees
    return render json: {error: 'Missing role'} unless params[:role].present?
    if params[:role] == 'Team_Lead'
      @lists = Employee.where(role: params[:role]).select{|emp| !emp.employee_teams.present?}
    else
      @lists = Employee.employee_only.select{ |emp| !emp.employee_teams.present? }
    end
    @lists = filter_employee
    render json: @lists
  end

  private

  def check_authorized_employee
    unless (@current_employee.Manager? || @current_employee.Team_Lead?) && @current_employee.id == params[:employee_id].to_i
      render json: {error: 'Unauthorized to see the list'}, status: 401
    end
  end

  def filter_employee
    return @lists unless params[:case].present?
    query = params[:query].downcase
    case params[:case]
    when 'last_name'
      @lists = @lists.select{|employee| employee.last_name.downcase.include?(query)}
    when 'first_name'
      @lists = @lists.select{|employee| employee.first_name.downcase.include?(query)}
    when 'email'
      @lists = @lists.select{|employee| employee.email.downcase.include?(query)}
    when 'skill'
      #this is left one enhanced search, if i get time then will do this
    end
    @lists
  end
end
