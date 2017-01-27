Sequel.migration do
  up do
    create_table :parties do
      primary_key :id
      foreign_key :post_id
    end
  end

  down do
    drop_table :parties
  end
end