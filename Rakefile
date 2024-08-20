# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require_relative "config/application"

Rails.application.load_tasks

namespace :db do
  desc "Create a PostgreSQL dump"
  task :backup, [:custom_filename] => :environment do |_t, args|
    timestamp = Time.now.strftime("%Y%m%d%H%M%S")
    dump_file = args[:custom_filename] ? "backup/#{args[:custom_filename]}.dump" : "backup/backup_#{timestamp}.dump"
    system("pg_dump -U ordil -h localhost -d urg_med_development -F c -b -v -f #{dump_file}")
    puts "Backup created: #{dump_file}"
  end
end
