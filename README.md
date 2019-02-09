# dotfiles

My environment configuration.

## Installation

Run `./install.sh`.
The installation script will prompt before replacing any existing files.

## Troubleshooting

### Gnome Keyring overriding `SSH_AUTH_SOCK`

Turn off SSH component in `/etc/xdg/autostart/gnome-keyring-ssh.desktop`

```diff
-Exec=/usr/bin/gnome-keyring-daemon --start --components=ssh
+Exec=/usr/bin/gnome-keyring-daemon --start --components=pkcs11,secrets
```

### GPG Key not recognized by SSH

In case of receiving permission denied error like this:
```
git@github.com: Permission denied (publickey).
fatal: Could not read from remote repository.

Please make sure you have the correct access rights
and the repository exists.
```

ensure that your GPG keygrip is included in `~/.gnupg/sshcontrol`.
To find your GPG keygrip you can use command `gpg --with-keygrip -K`
and copy your `A` subkey into the `sshcontrol` file.
