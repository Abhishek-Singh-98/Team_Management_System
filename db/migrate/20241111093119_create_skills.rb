class CreateSkills < ActiveRecord::Migration[7.0]
  def change
    create_table :skills do |t|
      t.string :name
      t.timestamps
    end

    create_table :employees_skills, id: false do |t|
      t.belongs_to :employee
      t.belongs_to :skill
    end
  end
end
