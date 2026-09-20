# ansible-ops-workstation — Agent Guide

Ansible automation for provisioning Fedora workstations, macOS, WSL Ubuntu, and
home-lab servers. 88+ roles across 6 custom collections under
`collections/ansible_collections/mikeeq/`.

> `ANSIBLE_CONFIG` is set to `playbooks/ansible.cfg` by `mise.toml`.
> **Always run commands from the project root.**

## Golden Rules

- **Dry-run first**: `ansible-playbook … --check --diff` before any real run.
- **`.yaml` only** — a pre-commit hook renames `.yml` → `.yaml` automatically.
- **Never run as root** — `playbooks/vars.yaml` hard-fails if you do.
- **Prefer modules over `command`/`shell`** (linted by `command-instead-of-module`).
- **Double-quote** strings; line length 80 (code) / 300 (YAML, per yamlfix).
- Private inventory/secrets live in the sibling `../ansible-ops-private` repo.

## Setup (once)

```bash
mise install    # installs toolchain + runs ansible-galaxy install (postinstall hook)
```

Manual collection reinstall:
`ansible-galaxy collection install -r playbooks/requirements.yaml`

### Toolchain (via mise)

| Tool | Version |
|---|---|
| Python | 3.14.4 |
| ansible-core | 2.20.5 (pipx; +passlib, pywinrm, bcrypt) |
| ansible-lint | 26.4.0 |
| yamllint | 1.38.0 |
| molecule (+docker) | 26.4.0 |
| trivy | v0.70.0 |
| pre-commit / shellcheck / shfmt / hadolint | latest |

## Structure

```
playbooks/            # 28 playbooks; ansible.cfg (forks=50, pipelining=True)
  requirements.yaml   # 7 external collections
  vars.yaml           # imported by all main playbooks; sets user facts, fails if root
  group_vars/         # architecture-specific vars ({{ arch }}.yaml), loaded dynamically
collections/ansible_collections/mikeeq/
  apps/               # 39 roles: docker, kubectl, helm, terraform, claude_code, …
  apps_desktop/       # 13 roles: vscode, chrome, zed, nvidia, …
  apps_server/        # 23 roles: jenkins, home_assistant, coredns, adguard_home, zabbix, …
  machines/           # 8 roles: fedora, gnome, macos, wsl, clevo_p170sm, …
  servers/            # 9 roles: libvirt, network_bridge, network_static_dns, openwrt_setup, …
  utils/              # 5 roles: dnf, flatpak, pip, brew, snap
inventory/            # hosts.yaml (static), vagrant.yaml
scripts/              # run_ansible_in_docker.sh, run_on_fedora.sh, convert_yml_to_yaml.sh
tests/                # run_tests.sh smoke test; per-role molecule/ dirs
docs/                 # install / migration notes
```

## Key Playbooks

| Playbook | Target | Purpose |
|---|---|---|
| `fedora.yaml` | `pc` / `localhost` | Full Fedora workstation |
| `generic.yaml` | `generic` | DevOps CLI stack (kubectl, helm, terraform, …) |
| `generic-core.yaml` | `generic` | Core tools (zsh, mise, ctop, docker_compose) |
| `mac.yaml` | `localhost` (macOS) | Homebrew bootstrap |
| `wsl-ubuntu.yaml` | `localhost` (WSL) | WSL Ubuntu setup |
| `openwrt.yaml` | `openwrt` | Router provisioning (needs private inventory) |
| `hypervisor.yaml` | `mikeeClevo` | KVM/libvirt setup |
| `vms.yaml` | `clevo` + VMs | Hypervisor + VM/container provisioning (incl. DNS) |
| `ha.yaml` / `jenkins.yaml` | `mikeeClevo` | Home Assistant / Jenkins |
| `zabbix.yaml` | multi-host | Monitoring (server + agents) |

## Inventory

```
all → generic
  ├── routers → openwrt (4× routers)
  ├── desktop → local (localhost)
  └── baremetal → pc (mikeePC 192.168.1.10)
                  clevo (mikeeClevo 192.168.1.110, hypervisor)
                  vms (vpngateway, openvpn, …)
```

**DNS services** run directly on `mikeeClevo` as Docker **macvlan** containers,
each with its own LAN IP (coredns `192.168.1.121`, adguard_home `192.168.1.122`).
The macvlan parent is the VM bridge `br-vm-enp0s20u2`; a host macvlan shim lets
the host reach those IPs. The old `dns1`/`dns2` VMs are retired.

## Running

```bash
# Dry-run (do this first):
ansible-playbook -i inventory/hosts.yaml playbooks/fedora.yaml --check --diff

# Local run with sudo prompt / limit / tags:
ansible-playbook -i inventory/hosts.yaml playbooks/fedora.yaml -K
ansible-playbook -i inventory/hosts.yaml playbooks/fedora.yaml -l localhost
ansible-playbook -i inventory/hosts.yaml playbooks/fedora.yaml --tags "git,vscode"

# Merge private inventory (home-lab hosts):
ansible-playbook \
  -i inventory/hosts.yaml \
  -i ../ansible-ops-private/inventory/hosts.yaml \
  playbooks/fedora.yaml

# Inside Docker (Fedora):
docker build -t fedora_systemd:latest .
scripts/run_ansible_in_docker.sh   # override via ANSIBLE_PLAYBOOK / DOCKER_IMAGE
```

## Lint & Test

```bash
pre-commit run --all-files          # yamllint, ansible-lint, shellcheck, ruff, actionlint
ansible-lint
yamllint .
cd tests && bash run_tests.sh       # smoke test: install collection + run playbook
molecule test                       # from a role dir that has molecule/
```

## External Collections (`playbooks/requirements.yaml`)

`community.general` 12.6.0 · `community.crypto` 3.2.0 · `community.libvirt` 2.2.0 ·
`community.zabbix` 4.2.0 · `ansible.posix` 2.1.0 · `ansible.utils` 6.0.2 ·
`ansible.netcommon` 8.5.1

## Config Facts

- Collections path: `../.ansible/collections:../collections` (relative to `playbooks/`).
- Roles path: `../.ansible/roles:../roles`.
- `pipelining` enabled — managed hosts must have `requiretty` disabled.
- Architecture vars auto-loaded from `group_vars/{{ ansible_facts['architecture'] }}.yaml`.

## CI (`.github/workflows/ci.yaml`)

7 jobs: `static-analysis` → `molecule`, `playbook-tests`, `build-fedora`,
`build-fedora-arm64`, `build-ubuntu`, `build-macos`. Triggers: push/PR to `main`.
