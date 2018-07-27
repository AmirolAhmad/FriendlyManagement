class CreateSubscribes < ActiveRecord::Migration[5.2]
  def change
    create_table :subscribes do |t|
      t.references :user, foreign_key: true
      t.integer :target_id, index: true
      t.boolean :block, default: false

      t.timestamps
    end
    add_foreign_key :subscribes, :users, column: :target_id
  end
end
