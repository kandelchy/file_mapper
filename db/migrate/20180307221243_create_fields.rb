class CreateFields < ActiveRecord::Migration[5.1]
  def change
    create_table :fields do |t|
      t.string :head1
      t.string :reg_exp
      t.string :head2
      t.integer :seq
      t.timestamps
    end
  end
end
