class CreateQuestions < ActiveRecord::Migration[5.1]
  def change
    create_table :questions do |t|
      t.references :job
      t.text :name

      t.timestamps
    end
  end
end
