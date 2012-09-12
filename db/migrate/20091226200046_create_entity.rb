class CreateEntity < ActiveRecord::Migration
  def self.up
    create_table :entities do |t|
      t.string :url
      t.string :urlrss
      t.string :name  # or title
      t.string :description # or body
      t.string :type
      t.string :state
      t.timestamp :publication
      t.timestamps
      t.index :url
      t.index :type
      t.index :name
    end
  end

  def self.down
    drop_table :entities
  end
end
