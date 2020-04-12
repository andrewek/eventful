class CreateEventfulEvents < ActiveRecord::Migration[6.0]
  def change
    create_table :eventful_events do |t|
      t.bigint :parent_id, null: true
      t.string :description, null: false, default: ""
      t.string :resource, null: false, default: ""
      t.string :action, null: false, default: ""
      t.jsonb :associations, default: "{}"
      t.jsonb :data, default: "{}"

      t.timestamps
    end
    add_index :eventful_events, :parent_id
    add_index :eventful_events, :resource
    add_index :eventful_events, :action
    add_index :eventful_events, :associations, using: :gin
    add_index :eventful_events, :data, using: :gin
  end
end
