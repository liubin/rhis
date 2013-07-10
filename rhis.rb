#!/usr/bin/env ruby
#encoding: utf-8
require 'twitter'
require 'weibo_2'

def list_his
    hl = ''
    cmds ={}
    open("#{ENV['HIS_FILE']}") do |file|
      while line = file.gets
        cmd = line.split(' ')
        next if cmd.size < 3
        next if cmd[2] == 'update_terminal_cwd'

        if not cmds[cmd[2]].nil? and cmds[cmd[2]] > 0 then
            cmds[cmd[2]] = cmds[cmd[2]] + 1
        else
            cmds[cmd[2]] = 1
        end
      end
    end

    cmds = cmds.sort_by {|k,v| v}.reverse
    cmds.each do |cmd|
        hl = hl + "#{cmd[0]}:#{cmd[1]}次,"
    end
    hl
end

def list_git_log(dir)
    today = Time.now.strftime("%Y-%m-%d")
    name = `git config --global --get user.name`.strip
    git_cmd = "git log --stat --since='1 day ago' --author='#{name}'"

    out = ""
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
                    c = "#{l[0..15]}... > " if l.start_with?("commit")

                    out = out + c + l if l.include?("files changed") or l.include?("file changed")
                end
            end
        end
    end
    out
end

def t(status)
    Twitter.configure do |config|
      config.consumer_key = ENV['TWITTER_APP_KEY']
      config.consumer_secret = ENV['TWITTER_APP_SECRET']
      config.oauth_token = ENV['TWITTER_TOKEN']
      config.oauth_token_secret = ENV['TWITTER_TOKEN_SECRET']
    end

    client = Twitter::Client.new

    begin
        client.update(status)
    rescue Exception => e
        puts e
    end

end

def w(status)
    WeiboOAuth2::Config.api_key = ENV['WEIBO_APP_KEY']
    WeiboOAuth2::Config.api_secret = ENV['WEIBO_APP_SECRET']
    client = WeiboOAuth2::Client.new
    client.get_token_from_hash({:access_token=>ENV['WEIBO_ACCESS_TOKEN'],:expires_at=>86400})
    begin
        client.statuses.update(status)
    rescue Exception => e
        puts e
    end
end

flag_t = false
flag_w = false
ARGV.each do |v|
    flag_t = true if v == 't'
    flag_w = true if v == 'w'
end

# print git commit info
GIT_BASE_DIR =['/Users/liubin/bitbucket','/Users/liubin/github']

git_log = ""
GIT_BASE_DIR.each do |dir|
    git_log = git_log + list_git_log(dir)
end
puts "git commit data:#{git_log}"
t git_log[0..139] if flag_t and not git_log.empty?
w git_log[0..139] if flag_w and not git_log.empty?

# print shell history

his_log = list_his
puts "\n\nshell command data:#{his_log}"

# sleep for sina weibo.fuck!
sleep(4)
t his_log[0..139] if flag_t and not his_log.empty?
w his_log[0..139] if flag_w and not his_log.empty?

