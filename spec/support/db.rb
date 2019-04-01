RSpec.configure do |c|
  c.before(:suite) do
    Sequel.extension :migration
    Sequel::Migrator.run(DB, 'db/migrations')
    DB[:bands].truncate
    DB[:girls].truncate
    DB[:lineups].truncate
  end

  c.around(:example, :db) do |example|
    DB.transaction(rollback: :always) {example.run}
  end


end



# RSpec.configure do |c|
#   c.before(:suite) do
#     Sequel.extension :migration
#     Sequel::Migrator.run(DB, 'db/migrations')
#     DB[:bands].truncate
#     #DB[:girls].truncate #????
#   end
#
#   c.around(:example, :db) do |example|
#     DB.transaction(rollback: :always) {example.run}
#   end
#
# end
