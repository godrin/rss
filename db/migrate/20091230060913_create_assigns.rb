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
      t.timestamps
    end
    add_index :assigns,:parent_id
    add_index :assigns,:child_id
  end

  def self.down
    drop_table :assigns
  end
end
