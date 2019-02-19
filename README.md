# dotfiles

My environment configuration.

## Installation

Run `./install.sh`. The script will prompt before replacing any existing
files. It is idempotent and can be used to ensure that all relevant files are
links to this repository.

It uses a simple convention to map all files in `home` directory as it would
be a user `${HOME}` directory. Notice that that it precedes all relative
paths with `.` (dot). For example:

- `home/bashrc` is mapped to `${HOME}/.bashrc`
- `home/config/Code/User/settings.json` is mapped to `${HOME}/.config/Code/User/settings.json`

## Troubleshooting

### Gnome Keyring overriding `SSH_AUTH_SOCK`

Ensure that `gnome-keyring-daemon` does not start with ssh component.
In Ubuntu/Debian you can check the output of command:

```bash
$ grep gnome-keyring-daemon /etc/xdg/autostart/gnome-keyring-*

/etc/xdg/autostart/gnome-keyring-pkcs11.desktop:Exec=/usr/bin/gnome-keyring-daemon --start --components=pkcs11
/etc/xdg/autostart/gnome-keyring-secrets.desktop:Exec=/usr/bin/gnome-keyring-daemon --start --components=secrets
/etc/xdg/autostart/gnome-keyring-ssh.desktop:Exec=/usr/bin/gnome-keyring-daemon --start --components=ssh
```

If you see an entry with `ssh` component then remove the file:

```bash
sudo rm /etc/xdg/autostart/gnome-keyring-ssh.desktop
```

or remove only the component `ssh` from the list:

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
