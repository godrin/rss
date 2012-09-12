class CreateAssigns < ActiveRecord::Migration
  def self.up
    create_table :assigns do |t|
      t.string :type
      t.integer :parent_id
      t.integer :child_id
      t.string :author
      t.integer :value
      t.boolean :read
      t.boolean :done
      t.integer :subscribe_threshold
      t.index :parent_id
      t.index :child_id
      t.timestamps
    end
  end

  def self.down
    drop_table :assigns
  end
end
