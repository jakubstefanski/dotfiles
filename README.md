# dotfiles

My environment configuration.

## Installation

Run `./install.sh`.
The installation script will prompt before replacing any existing files.

## Troubleshooting

### Gnome Keyring overriding `SSH_AUTH_SOCK`

Ensure that `gnome-keyring-daemon` does not start with ssh component.
In Ubuntu/Debian you can check the output of command:

```
grep gnome-keyring-daemon /etc/xdg/autostart/gnome-keyring-*
```

If you see an entry with `ssh` component then remove the file:

```
/etc/xdg/autostart/gnome-keyring-ssh.desktop:Exec=/usr/bin/gnome-keyring-daemon --start --components=ssh
```

or the component from the list.

```diff
-Exec=/usr/bin/gnome-keyring-daemon --start --components=pkcs11,secrets,ssh
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

Ensure that your GPG keygrip is included in `~/.gnupg/sshcontrol`.  To find
your GPG keygrip you can use command `gpg --with-keygrip -K` and copy your `A`
subkey keygrips into the `sshcontrol` file.
