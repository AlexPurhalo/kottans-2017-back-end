Sequel.migration do
  up do
    add_column :users, :access_token, String
  end

  down do
    drop_column :users, :access_token
  end
end