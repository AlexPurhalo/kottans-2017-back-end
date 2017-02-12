Sequel.migration do
  up do
    add_column :posts, :with_voting, :boolean, default: false
  end

  down do
    drop_column :posts, :with_voting
  end
end