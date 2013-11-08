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

**git base directories**

    export GIT_BASE_PATH=/Users/liubin/bitbucket:/Users/liubin/github

**log all command to ~/.command_log**

    if [ -n "${BASH_VERSION}" ]; then
        trap "caller >/dev/null || \
    printf '%s\\n' \"\$(date '+%Y-%m-%dT%H:%M:%S%z')\
     \$(tty) \${BASH_COMMAND}\" 2>/dev/null >> ${HIS_FILE}" DEBUG
    fi

**setup backup path**

    export HIS_FILE_BAK_PATH=~/his_log

### run script

    ./rhis [t|w]

without arguments ,it will print out to console.if w is given ,will post weibo status.

if t is given ,will post twitter status.

if **t** is given, status will be posted to twitter


### run it at system shutdown

create it if not exist:

    sudo touch /etc/rc.local.shutdown

edit it **rc.local.shutdown** will like this:
or use the file in this repo.

    #!/bin/sh -e
    /Users/liubin/github/rhis/rhis.rb w t
    mv ${HIS_FILE} ${HIS_FILE_BAK_PATH}/command_log`date +%Y%m%d%H%M%S`

*his_log* is backup folder for command history.create it if not exist.

make it executable:

    sudo chmod a+x  /etc/rc.local.shutdown


### to run git_log_2_weibo.rb ,you need to install rmagick

  on my osx , the step will be:

  brew install imagemagick

  gem install rmagick

  wget ftp://ftp.imagemagick.org/pub/ImageMagick/delegates/ghostscript-fonts-std-8.11.tar.gz

  tar zxvf ghostscript-fonts-std-8.11.tar.gz

  sudo mkdir -p /usr/local/share/ghostscript/fonts

  sudo cp fonts/* /usr/local/share/ghostscript/fonts/

