desc "listen on twitter for jobs"
task :listen => :environment do
  TwitterBot.process_new_mentions
end
