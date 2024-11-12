class CreateTeams < ActiveRecord::Migration[7.0]
  def change
    create_table :teams do |t|
      t.string :team_name
      t.text :description
      t.integer :team_owner_id
      t.integer :max_member
      t.references :manager, foreign_key: {to_table: :employees}
      t.timestamps
    end
  end
end
