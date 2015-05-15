class CreateLogs < ActiveRecord::Migration
  def change
    create_table :logs do |t|
      t.json :data
      t.timestamps null: true
    end
  end
end
