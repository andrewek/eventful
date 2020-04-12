class AddColumnsToEventfulEvents < ActiveRecord::Migration[6.0]
  def change
    add_column :eventful_events, :occurred_at, :datetime, index: true
    add_column :eventful_events, :root_id, :bigint, index: true
  end
end
