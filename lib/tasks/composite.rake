desc "composite it"
task :composite => :environment do
  comp = CompositeImage.new("http://dl.dropbox.com/u/80061077/Screenshots/s.png", ["Wednesday","break my heart"])
  p comp.composite!
end