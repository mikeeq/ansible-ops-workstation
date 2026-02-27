# Ansible Role: Chrome Install

This role installs Google Chrome browser on various Linux distributions.

## Supported Platforms

- Ubuntu/Debian
- CentOS/RHEL/Fedora
- Arch Linux
- openSUSE

## Requirements

None

## Role Variables

| Variable                        | Default                    | Description                             |
|-------------------------------|----------------------------|-----------------------------------------|
| `chrome_version`              | ""                         | Chrome version to install (empty for latest) |
| `chrome_force_reinstall`      | false                      | Whether to force reinstall Chrome       |
| `chrome_download_url`         | Google's download URL      | Chrome download URL for custom installations |

## Dependencies

None

## Example Playbook

```yaml
- hosts: all
  become: true
  roles:
    - chrome-install
```

## License

MIT

## Author Information

This role was created by [Your Name].
