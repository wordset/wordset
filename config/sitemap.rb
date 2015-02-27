# Set the host name for URL creation
SitemapGenerator::Sitemap.default_host = "https://www.wordset.org"
SitemapGenerator::Sitemap.public_path = 'tmp/'
SitemapGenerator::Sitemap.adapter = SitemapGenerator::S3Adapter.new

SitemapGenerator::Sitemap.create do

  Word.each do |word|
    add '/word/#{word.name}', :priority => 0.9, :changefreq => 'weekly'
    add '/word/#{word.name}/proposals', :priority => 0.2, :changefreq => 'weekly'
  end

  add '/users', :priority => 0.5, :changefreq => 'daily'
  add '/proposals', :priority => 0.3, :changefreq => 'hourly'

  User.each do |user|
    add '/user/#{user.username}', :lastmod => user.updated_at
  end

  Proposal.each do |proposal|
    add '/proposal/#{proposal.id}', :lastmod => proposal.updated_at
  end
end
