#!/usr/bin/env ruby
#encoding: utf-8

require 'weibo_2'

require './jpeg.rb'

# get all git coomits for one day ago
def list_git_log(dir)

    name = `git config --global --get user.name`.strip
    git_cmd = "git log --stat --since='1 day ago' --author='#{name}'"

    out = []
    Dir.foreach(dir) do |d|
        next if d == "." or d == ".."
        t = dir + '/' + d
        next if not File.directory?(t)
        if File.exists?(t + '/.git') and File.directory?(t + '/.git') then

            c = ""
            Dir.chdir(t) do |r|
                ci = `#{git_cmd}`
                next if ci.empty?

                ci.each_line do |l|
                    #puts l
                    c = "#{l[0..12]}... " if l.start_with?("commit")

                    out << (c + l.delete("\n")) if l.include?("files changed") or l.include?("file changed")
                end
            end
        end
    end
    out
end

def w(file,text)
    WeiboOAuth2::Config.api_key = ENV['WEIBO_APP_KEY']
    WeiboOAuth2::Config.api_secret = ENV['WEIBO_APP_SECRET']
    client = WeiboOAuth2::Client.new
    client.get_token_from_hash({:access_token=>ENV['WEIBO_ACCESS_TOKEN'],:expires_at=>86400})
    begin
        client.statuses.upload(text, file, {})
    rescue Exception => e
        puts e
    end
end

# print git commit info

git_base = if ENV['GIT_BASE_PATH'] then ENV['GIT_BASE_PATH'].split(":")else [] end
git_log = []
git_base.each do |dir|
    git_log = git_log + list_git_log(dir)
end
git_log.unshift("").unshift("git log for last 24 hours")

# call to generate a jpeg file under /tmp
text = ARGV.shift || "无聊闲的"

fn = make_img(git_log)

# post status to weibo
w(File.new(fn), text)


