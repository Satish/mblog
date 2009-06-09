namespace :roles do

  desc 'Create default roles'
  task :create_defaults => :environment do
    Role.create(:name => "admin") unless Role.find_by_name("admin")
  end

end