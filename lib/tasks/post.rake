namespace :post do
  task :load => :environment do
    slug = ENV["NAME"]
    if slug.nil?
      throw "Must pass NAME=slug-name"
    end
    title, *lines = File.open(File.join(Rails.root, "app/assets/posts/#{slug}.html")).read.split("\n")
    html = lines.join("\n")
    Post.create(
      title: title,
      text: html,
      slug: slug
    )
  end

end
