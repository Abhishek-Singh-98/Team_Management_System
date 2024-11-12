class ApplicationController < ActionController::Base
  protect_from_forgery with: :null_session
  include JwtAuthentication

  def authenticate
    @token = request.headers[:token] || params[:token]
    decoded_response = JwtAuthentication.decode(@token)
    if !decoded_response[:error].nil?
      render json: decoded_response[:error], status: decoded_response[:status]
    else
      @current_employee = Employee.find_by_id(decoded_response[:id])
      unless @current_employee
        render json: { error: 'Employee not found' }, status: :not_found
      end
    end
  end
end
