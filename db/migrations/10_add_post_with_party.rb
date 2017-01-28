Sequel.migration do
  up do
    add_column :posts, :with_party, :boolean, default: false
  end

  down do
    drop_column :posts, :with_party
  end
end