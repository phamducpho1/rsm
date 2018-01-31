class CreateAnswers < ActiveRecord::Migration[5.1]
  def change
    create_table :answers do |t|
      t.references :apply
      t.references :question
      t.text :name

      t.timestamps
    end
  end
end
