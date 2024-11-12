class Team < ApplicationRecord
  belongs_to :employee, class_name: 'Employee', foreign_key: 'manager_id'
  has_many :employee_teams, dependent: :destroy
  has_many :employees, class_name: 'Employee', through: :employee_teams
  validates :team_name, presence: true, uniqueness: true
  validates_presence_of :max_member, :team_owner_id

  accepts_nested_attributes_for :employee_teams, allow_destroy: true

  before_commit :add_team_lead_to_team, on: [:create]

  private

  def add_team_lead_to_team
    team_lead = Employee.find(self.team_owner_id)
    begin
      self.employee_teams.create!(employee: team_lead)
      puts "Team Owner succesfully Added"
    rescue => e
      Rails.logger.error "Failed to add team lead to employee_teams: #{e.message}"
      raise ActiveRecord::Rollback
    end
  end

end
