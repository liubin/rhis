rhis
====

How to user
----

1. setup twitter info and log all command to history file

# for twitter

    export TWITTER_APP_KEY=...
    export TWITTER_APP_SECRET=...
    export TWITTER_TOKEN=...
    export TWITTER_TOKEN_SECRET=...

# log all command to ~/.command_log

    if [ -n "${BASH_VERSION}" ]; then
        trap "caller >/dev/null || \
    printf '%s\\n' \"\$(date '+%Y-%m-%dT%H:%M:%S%z')\
     \$(tty) \${BASH_COMMAND}\" 2>/dev/null >>~/.command_log" DEBUG
    fi

