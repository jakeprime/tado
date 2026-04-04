class CreateTadoToken < ActiveRecord::Migration[8.1]
  def change
    create_table :tado_tokens do |t|
      t.datetime :expires_at
      t.string :access_token
      t.string :refresh_token

      t.timestamps
    end
  end
end
