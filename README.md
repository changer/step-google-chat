# step-google-chat

A google-chat notifier written in `bash` and `curl`. Make sure you create a Google Chat
webhook first (see the Google Chat integrations page to set one up).

[![wercker status](https://app.wercker.com/status/94f767fe85199d1f7f2dd064f36802bb/s "wercker status")](https://app.wercker.com/project/bykey/94f767fe85199d1f7f2dd064f36802bb)

# Options

- `url` The Google Chat webhook url
- `notify_on` (optional) If set to `failed`, it will only notify on failed
builds or deploys.
- `branch` (optional) If set, it will only notify on the given branch

# Example

```yaml
build:
    after-steps:
        - google-chat-notifier:
            url: $GOOGLE_CHAT_URL
            channel: notifications
            username: myamazingbotname
            branch: master
```

The `url` parameter is the [google chat webhook](https://developers.google.com/hangouts/chat/how-tos/webhooks) that wercker should post to.
You can create an *incoming webhook* on your google chat integration page.
This url is then exposed as an environment variable (in this case
`$WERCKER_GOOGLE_CHAT_NOTIFIER_URL`) that you create through the wercker web interface as *deploy pipeline variable*.

# License

The MIT License (MIT)

# Changelog

## 1.0.0

- Initial release
