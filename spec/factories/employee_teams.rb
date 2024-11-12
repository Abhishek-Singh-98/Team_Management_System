FactoryBot.define do
  factory :employee_team do
    employee_id {FactoryBot.create(:employee)}
    team_id {FactoryBot.create(:team)}
  end
end
