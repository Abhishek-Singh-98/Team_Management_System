FactoryBot.define do
  factory :team do
    team_name { "Team #{Faker::Team.name}" }
    description { Faker::Lorem.sentence }
    team_owner_id { create(:employee, role: 'Team_Lead').id }
    max_member {5}
    employee_teams_attributes {[
      {employee_id: FactoryBot.create(:employee).id, _destroy: false},
      {employee_id: FactoryBot.create(:employee).id, _destroy: false}
    ]}
  end
end
