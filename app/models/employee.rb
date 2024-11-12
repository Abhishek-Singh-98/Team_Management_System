class Employee < ApplicationRecord
  has_secure_password
  has_and_belongs_to_many :skills
  has_many :teams, foreign_key: 'manager_id', class_name: 'Team'
  has_many :employee_teams
  has_many :teams, class_name: 'Team', through: :employee_teams

  validates :first_name, :last_name, :experience, :role, presence: true
  validates :email, :phone_number, presence: true, uniqueness: true

  enum role: {"Manager": 0, "Team_Lead": 1, "HR": 3, "Software_Engineer_1": 4,
                "Software_Engineer_2": 5, "QA": 6}

  scope :employee_only, -> {where.not(role: 'Team_Lead').where.not(role: 'HR').where.not(role: 'Manager')}

  before_commit :downcase_email, on: [:create, :update]

  private
  def downcase_email
    self.email = self.email.downcase
  end
end
