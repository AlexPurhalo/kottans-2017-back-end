Sequel.migration do
  up do
    alter_table :posts do
      add_index :id
    end
  end

  down do
    alter_table :posts do
      drop_index :id
    end
  end
end