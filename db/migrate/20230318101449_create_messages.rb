class CreateMessages < ActiveRecord::Migration[7.0]
  def change
    create_table :messages do |t|
      t.references :user

      t.string :message_id, null: false, index: { unique: true }
      t.string :subject
      t.string :sender
      t.string :recipient
      t.string :history_id
      t.string :thread_id
      t.text :body
      t.datetime :sent_at

      t.timestamps
    end
  end
end
