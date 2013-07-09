#!/usr/bin/env ruby
#encoding: utf-8

def list_his
    cmds ={}
    open("/Users/liubin/.command_log") do |file|
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
        puts "#{cmd[0]}:#{cmd[1]}次，"
    end
end

def list_git_log(dir)
    today = Time.now.strftime("%Y-%m-%d")
    name = `git config --global --get user.name`.strip
    git_cmd = "git log --stat --since='1 day ago' --author='#{name}'"
    puts git_cmd
    out = ""
    Dir.foreach(dir) do |d|
        next if d == "." or d == ".."
        t = dir + '/' + d
        next if not File.directory?(t)
        if File.exists?(t + '/.git') and File.directory?(t + '/.git') then
            puts "Got #{t}"

            c = ""
            Dir.chdir(t) do |r|
                ci = `#{git_cmd}`
                next if ci.empty?
                puts ci
                ci.each_line do |l|
                    #puts l
                    c = "#{l[0..10]}... > " if l.start_with?("commit")

                    out = out + c + l if l.include?("files changed")
                end
            end
        end
    end
    out
end

# print git commit info
BASE_DIR =['/Users/liubin/bitbucket','/Users/liubin/github']
#BASE_DIR =['/Users/liubin/github']
BASE_DIR.each do |dir|
    puts list_git_log(dir)
end

# print shell history
list_his

