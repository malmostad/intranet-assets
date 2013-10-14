namespace :build do
  desc "Convert masthead html to a javascript string variable"
  task masthead: :environment do

    # Convert erb template to html
    erb = File.read(File.expand_path('app/assets/content/masthead.html.erb'))
    html = ERB.new(erb).result(binding)

    # Make it a one line string and attach it to a js var
    html = html.gsub(/^\s+/, '').gsub(/\n/, '').gsub(/\s+/, ' ').gsub(/'/, '"').strip
    js_var = "var malmoMasthead = '#{html}';"

    File.open('app/assets/javascripts/masthead_content.js', 'w') do |f|
      f.puts("// Don't edit this file. Auto generated from masthead.html.erb with `rake build:masthead RAILS_ENV=#{Rails.env}`.")
      f.puts(js_var)
      f.close
    end
    puts "Generated new masthead for #{Rails.env}"
  end
end
