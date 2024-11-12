class LoginsController < ApplicationController
  before_action :find_employee

  def create
    if @employee&.authenticate(params[:password])
      @token = JwtAuthentication.encode(id: @employee.id)
      render json: {employee: @employee, meta: {message: 'Login Successfull.',token: @token}}
    else
      render json: {error: 'Invalid Password'}, status: 401
    end
  end

  private

  def find_employee
    @employee = Employee.find_by(email: params[:email]&.downcase)
    unless @employee.present?
      render json: {error: 'Employee not present in the system.'}, status: 422
    end
  end
end
