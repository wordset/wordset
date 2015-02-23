# Set the host name for URL creation
SitemapGenerator::Sitemap.default_host = "https://www.wordset.org"
SitemapGenerator::Sitemap.public_path = 'tmp/'
SitemapGenerator::Sitemap.adapter = SitemapGenerator::S3Adapter.new
SitemapGenerator::Sitemap.sitemaps_host = "http://#{ENV['FOG_DIRECTORY']}.s3.amazonaws.com/"

SitemapGenerator::Sitemap.create do
  # Put links creation logic here.
  #
  # The root path '/' and sitemap index file are added automatically for you.
  # Links are added to the Sitemap in the order they are specified.
  #
  # Usage: add(path, options={})
  #        (default options are used if you don't specify)
  #
  # Defaults: :priority => 0.5, :changefreq => 'weekly',
  #           :lastmod => Time.now, :host => default_host
  #
  # Examples:
  #
  # Add '/articles'
  #
  Word.each do |word|
    add '/word/#{word.name}', :priority => 0.9, :changefreq => 'weekly'
  end

  add '/users', :priority => 0.5, :changefreq => 'daily'
  add '/proposals', :priority => 0.7, :changefreq => 'hourly'

  User.each do |user|
    add '/user/#{user.username}', :lastmod => user.updated_at
  end
  #
  # Add all articles:
  #
  #   Article.find_each do |article|
  #     add article_path(article), :lastmod => article.updated_at
  #   end
end
