class CreateEmployeeTeams < ActiveRecord::Migration[7.0]
  def change
    create_table :employee_teams do |t|
      t.references :employee
      t.references :team
      t.timestamps
    end
  end
end
