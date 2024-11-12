class TeamSerializer < ActiveModel::Serializer
  attributes :id, :team_name, :description, :max_member
  
  belongs_to :employee

  has_many :employee_teams

  attribute :team_members do |object|
    object&.object.employees
  end


end
