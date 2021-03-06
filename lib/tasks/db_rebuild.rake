namespace :db do

  desc 'Rebuild the db with sample data'
  task :rebuild => :environment do
    Rake::Task["db:insert_sample_data"].invoke
  end

  desc 'Insert sample data'
  task :insert_sample_data => :environment do
    Rake::Task["roles:create_defaults"].invoke
    Rake::Task["db:insert_admin_accounts"].invoke
    Rake::Task["pages:create_defaults"].invoke
  end

  desc 'Insert admin accounts'
  task :insert_admin_accounts => :environment do
    # Admin Accounts
    admin_role = Role.find_by_name('admin')
    admins = [ {:name => 'Admin', :email => 'email@example.com'}]
    
    admins.each do |admin_info|
      user = User.new
      user.login = admin_info[:name].split(' ').first.downcase
      user.email = admin_info[:email]
      user.name = admin_info[:name]
      user.password = 'changeme'
      user.password_confirmation = 'changeme'
      user.register!
      user.activate!
      user.roles << [admin_role]
    end
  end
 
  desc 'Insert sample(test) accounts'
  task :insert_sample_accounts => :environment do
    names = ['Satish Chauhan', 'Amit Solanki', 'Anurag Solanki', 'Ankur Gupta', 'Manik Juneja', 'Sur', 'Gaurav Sharma', 'Siddhaartha Verma', 'Rishav Dixit', 'Hemant', 'Kapil Bhatia', 'Ritu', 'Vibha Chaddha', 'Surat Pyari', 'Payal Gupta', 'Richa Bhardwas']
    names.each do |name|
      login = name.split(' ').first.downcase
      user = User.new(:name => name,
                      :login => login,
                      :email => login + '@vinsol.com',
                      :password => 'changeme',
                      :password_confirmation => 'changeme'
                      )
      user.register!
      user.activate!
    end
  end 

  desc 'Reset database and reload ALL sample data.'
  task :rebuild_from_scratch => :environment do
    exit unless Rails.env.development?
    Rake::Task["db:reset"].invoke
    Rake::Task["db:migrate"].invoke
    Rake::Task["db:rebuild"].invoke
  end

  desc 'A task for bootstrapping the db with initial data for development'
  task :build_for_development => :environment do
#    exit unless Rails.env.development? && !(ActiveRecord::Base.connection rescue nil)
    Rake::Task["db:rebuild_from_scratch"].invoke
    Rake::Task["db:insert_sample_accounts"].invoke
  end

  desc 'A task for bootstrapping the db with initial data on first deploy'
  task :build_for_production => :environment do
    exit unless Rails.env.production? && !(ActiveRecord::Base.connection rescue nil)
    Rake::Task["db:rebuild_from_scratch"].invoke
  end
  
end