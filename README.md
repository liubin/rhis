# rhis

record all command history to a file and post to twitter.

also with git commit datas.

## How to use

### 1. install gem
    gem install twitter
    gem install weibo_2

It's **weibo_2** ,not weibo2 !!

### 1. setup twitter info and log all command to history file

**setup twitter account**

    # for twitter
    export TWITTER_APP_KEY=...
    export TWITTER_APP_SECRET=...
    export TWITTER_TOKEN=...
    export TWITTER_TOKEN_SECRET=...
    # for weibo
    export WEIBO_APP_KEY=...
    export WEIBO_APP_SECRET=...
    export WEIBO_ACCESS_TOKEN=...

**log file path**

    export HIS_FILE=~/.command_log

**log all command to ~/.command_log**

    if [ -n "${BASH_VERSION}" ]; then
        trap "caller >/dev/null || \
    printf '%s\\n' \"\$(date '+%Y-%m-%dT%H:%M:%S%z')\
     \$(tty) \${BASH_COMMAND}\" 2>/dev/null >> ${HIS_FILE}" DEBUG
    fi

### run script

    ./rhis [t]

if **t** is given, status will be posted to twitter


### run it at system shutdown

create it if not exist:

    sudo touch /etc/rc.local.shutdown

edit it **rc.local.shutdown** will like this:

    #!/bin/sh -e
    /Users/liubin/github/rhis/rhis.rb t
    mv /Users/liubin/.command_log /Users/liubin/his_log/command_log`date +%Y%m%d%H%M%S`
    sleep 5

*his_log* is backup folder for command history.create it if not exist.

make it executable:

    sudo chmod a+x  /etc/rc.local.shutdown



