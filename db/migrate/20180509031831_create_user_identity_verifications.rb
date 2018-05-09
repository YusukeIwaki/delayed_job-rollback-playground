class CreateUserIdentityVerifications < ActiveRecord::Migration[5.2]
  def change
    create_table :user_identity_verifications do |t|
      t.references :user, foreign_key: true, null: false
      t.string :memo, null: true

      t.timestamps
    end
  end
end
