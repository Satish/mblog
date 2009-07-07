namespace :pages do

 desc 'Create default page'
  task :create_defaults => :environment do
    ['About Us', 'Contact Us', 'Privacy Policy', 'Terms', 'FAQs'].each do |title|
      Page.create(:title => title, :permalink => title, :description => title + ' ' + 'Description' )
    end
  end

end