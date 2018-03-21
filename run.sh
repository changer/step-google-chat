#!/bin/bash
#source build-esen.sh

# check if google chat webhook url is present
if [ -z "$WERCKER_GOOGLE_CHAT_NOTIFIER_URL" ]; then
  fail "Please provide a Google Chat webhook URL"
fi

# check if this event is a build or deploy
if [ -n "$DEPLOY" ]; then
  # its a deploy!
  export ACTION="deploy ($WERCKER_DEPLOYTARGET_NAME)"
  export ACTION_URL=$WERCKER_DEPLOY_URL
else
  # its a build!
  export ACTION="build"
  export ACTION_URL=$WERCKER_BUILD_URL
fi

export MESSAGE="<$ACTION_URL|$ACTION> for $WERCKER_APPLICATION_NAME by $WERCKER_STARTED_BY has $WERCKER_RESULT on branch $WERCKER_GIT_BRANCH"
export FALLBACK="$ACTION for $WERCKER_APPLICATION_NAME by $WERCKER_STARTED_BY has $WERCKER_RESULT on branch $WERCKER_GIT_BRANCH"
export COLOR="good"

if [ "$WERCKER_RESULT" = "failed" ]; then
  export MESSAGE="$MESSAGE at step: $WERCKER_FAILED_STEP_DISPLAY_NAME"
  export FALLBACK="$FALLBACK at step: $WERCKER_FAILED_STEP_DISPLAY_NAME"
  export COLOR="danger"
fi

# skip notifications if not interested in passed builds or deploys
if [ "$WERCKER_GOOGLE_CHAT_NOTIFIER_NOTIFY_ON" = "failed" ]; then
  if [ "$WERCKER_RESULT" = "passed" ]; then
    return 0
  fi
fi

# skip notifications if not on the right branch
if [ -n "$WERCKER_GOOGLE_CHAT_NOTIFIER_BRANCH" ]; then
    if [ "$WERCKER_GOOGLE_CHAT_NOTIFIER_BRANCH" != "$WERCKER_GIT_BRANCH" ]; then
        return 0
    fi
fi

# post the result to the google chat webhook
RESULT=$(curl -H "Content-Type: application/json" -X POST -d "{\"text\":\"$MESSAGE\"}" -s "$WERCKER_GOOGLE_CHAT_NOTIFIER_URL" --output "$WERCKER_STEP_TEMP"/result.txt -w "%{http_code}")
cat "$WERCKER_STEP_TEMP/result.txt"

if [ "$RESULT" = "403" ]; then
  fail "The caller does not have permission"
fi
