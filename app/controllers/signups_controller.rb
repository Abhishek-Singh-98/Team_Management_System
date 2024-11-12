class SignupsController < ApplicationController
  before_action :authorize_employee, only: [:create]

  def create
    @employee = Employee.new(employee_params)
    if @employee.save
      @token = JwtAuthentication.encode(id: @employee.id)
      render json: { employee: @employee,
                        meta: { message: 'Employee successfully created.',token: @token} }
    else
      render json: { employee: @employee.errors.messages }, status: 422
    end
  rescue ArgumentError => error
    render json: error, status: 422
  end

  private

  def employee_params
    params.permit(:first_name, :last_name, :email, :phone_number, :experience, :role,
              :password_digest, :password, :password_confirmation, skill_ids: [])
  end

  def authorize_employee
    @employee = Employee.find_by(email: params[:email]&.downcase)
    if @employee.present?
      return render json: {error: 'Employee with this email already present.'}, status: 422
    end
  end
end
