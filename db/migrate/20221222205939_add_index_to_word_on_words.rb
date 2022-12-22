class AddIndexToWordOnWords < ActiveRecord::Migration[7.0]
  def change
    add_index :words, :word
  end
end
