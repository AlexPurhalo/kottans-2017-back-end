Sequel.migration do
  up do
    alter_table :users do
      add_column :github_id, Integer
      add_column :github_avatar, String
      add_column :email, String
      add_column :name, String
      set_column_allow_null :bcrypted_password
    end
  end

  down do
    alter_table :users do
      drop_column :github_id
      drop_column :github_avatar
      drop_column :email
      drop_column :name
      set_column_not_null :bcrypted_password
    end
  end
end