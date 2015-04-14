# Set the host name for URL creation
SitemapGenerator::Sitemap.default_host = "https://www.wordset.org"
SitemapGenerator::Sitemap.public_path = 'tmp/'
SitemapGenerator::Sitemap.adapter = SitemapGenerator::S3Adapter.new
SitemapGenerator::Sitemap.sitemaps_host = "https://www.wordset.org/__/proxy/data/"

SitemapGenerator::Sitemap.create do

  Wordseteach do |word|
    add '/word/#{word.name}', :priority => 0.5, :changefreq => 'weekly'
    #add '/word/#{word.name}/proposals', :priority => 0.2, :changefreq => 'weekly'
  end

  Post.published.each do |post|
    add '/post/#{post.slug}', :priority => 1.0, :changefreq => 'weekly'
  end

  #add '/users', :priority => 0.5, :changefreq => 'daily'
  #add '/proposals', :priority => 0.3, :changefreq => 'hourly'

  #User.each do |user|
  #  add '/user/#{user.username}', :priority => 0.0, :lastmod => user.updated_at
  #end
end
