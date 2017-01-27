Sequel.migration do
  up do
    create_table :parties_users do
      primary_key :id
      foreign_key :user_id, :users
      foreign_key :party_id, :parties
    end
  end

  down do
    drop_table :parties_users
  end
end