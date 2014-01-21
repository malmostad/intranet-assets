namespace :assets do
  desc "Hack to remove digests"
  task remove_digests: :environment do
    assets = Dir.glob(File.join(Rails.root, 'public/assets/**/*'))
    regex = /(-{1}[a-z0-9]{32}*\.{1}){1}/
    assets.each do |file|
      next if File.directory?(file) || file !~ regex

      source = file.split('/')
      source.push(source.pop.gsub(regex, '.'))

      non_digested = File.join(source)
      FileUtils.mv(file, non_digested)
    end
    FileUtils.rm(File.join(Rails.root, 'public/assets/manifest.json'))
  end
end
