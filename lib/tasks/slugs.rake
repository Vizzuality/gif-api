namespace :slugs do
  desc 'Generate slugs'
  task generate: :environment do
    Project.all.each do |p|
      p.save!
    end
  end
end