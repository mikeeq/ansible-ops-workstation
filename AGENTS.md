# ansible-ops-workstation – Ansible Workstation Provisioning

## What This Is

Ansible playbooks for provisioning Fedora Workstations, macOS, WSL Ubuntu, and
home-lab servers. 88+ roles across 6 custom Ansible collections in
`collections/ansible_collections/mikeeq/`.

## Toolchain (managed by mise)

| Tool | Version | Notes |
|---|---|---|
| Python | 3.14.4 | via mise |
| ansible-core | 2.20.5 | via pipx; preinstalled: passlib, pywinrm, bcrypt |
| ansible-lint | 26.4.0 | |
| yamllint | 1.38.0 | |
| molecule | 26.4.0 | + docker plugin |
| trivy | v0.70.0 | container image scanner |
| pre-commit | latest | |
| shellcheck, shfmt, hadolint | latest | |

`ANSIBLE_CONFIG` is set to `playbooks/ansible.cfg` by `mise.toml` — always run
commands from the project root.

## Setup (run once)

```bash
mise install        # installs everything + runs ansible-galaxy install automatically
```

The mise postinstall hook runs:
```bash
cd playbooks && ansible-galaxy install -r requirements.yaml
```

If you need to reinstall collections manually:
```bash
ansible-galaxy collection install -r playbooks/requirements.yaml
```

## Project Structure

```
playbooks/          # 28 playbooks (fedora, generic, openwrt, ha, hypervisor, …)
  ansible.cfg       # main Ansible config (forks=50, pipelining=True, timer)
  requirements.yaml # 7 external collections (community.general, community.crypto, …)
  vars.yaml         # imported by all main playbooks: sets user facts, fails if root
  group_vars/       # architecture-specific vars loaded dynamically
collections/        # custom mikeeq.* collections (gitignored except mikeeq/)
  ansible_collections/mikeeq/
    apps/           # 39 roles: kubectl, helm, terraform, docker, claude_code, …
    apps_desktop/   # 13 roles: vscode, google_chrome, zed, nvidia, …
    apps_server/    # 23 roles: jenkins, home_assistant, coredns, zabbix, …
    machines/       # 8 roles: fedora, gnome, macos, wsl, clevo_p170sm, …
    servers/        # 9 roles: libvirt, network_bridge, openwrt_setup, …
    utils/          # 5 roles: dnf, flatpak, pip, brew, snap
inventory/
  hosts.yaml        # static inventory (localhost, mikeePC, mikeeClevo, openwrt, vms)
  vagrant.yaml      # Vagrant inventory (fedora 10.0.0.10)
scripts/
  run_ansible_in_docker.sh   # run playbook inside Docker container
  run_on_fedora.sh           # quick local bootstrap (mise install + ansible -K)
  convert_yml_to_yaml.sh     # pre-commit: rename .yml → .yaml
tests/
  playbook.yaml     # smoke test single role (github_copilot_cli)
  run_tests.sh      # install collection + run test playbook
docs/
  fresh_install.md  # Fedora on MacBook Pro 13" 2020 (T2 kernel, touchbar)
  mac20_win11_install.md
  migration_to_lfs.md
```

## Key Playbooks

| Playbook | Target | Purpose |
|---|---|---|
| `fedora.yaml` | `pc` / `localhost` | Full Fedora workstation (dnf, flatpak, chrome, docker, qemu, gnome, vscode) |
| `generic.yaml` | `generic` group | DevOps CLI stack (kubectl, helm, terraform, aws, claude_code, …) |
| `generic-core.yaml` | `generic` group | Core tools (zsh, mise, ctop, docker_compose) |
| `mac.yaml` | `localhost` (macOS) | macOS bootstrap via Homebrew |
| `wsl-ubuntu.yaml` | `localhost` (WSL) | WSL Ubuntu setup |
| `openwrt.yaml` | `openwrt` group | Router provisioning |
| `hypervisor.yaml` | `mikeeClevo` | KVM/libvirt setup |
| `ha.yaml` | `mikeeClevo` | Home Assistant server |
| `jenkins.yaml` | `mikeeClevo` | Jenkins CI/CD |
| `zabbix.yaml` | multi-host | Zabbix monitoring (server + agents) |
| `amdgpu-power-management.yaml` | `pc` | AMD GPU power tuning |
| `tasmota_firmware.yaml` | Tasmota hosts | Firmware update |

## Inventory Groups

```
all
├── generic
│   ├── routers → openwrt (openwrt_bpir4garage, openwrt_salon, …)
│   ├── desktop → local (localhost)
│   └── baremetal → pc (mikeePC 192.168.1.10)
│                   clevo (mikeeClevo 192.168.1.110)
│                   vms (dns1, dns2, vpngateway, openvpn)
```

## Running Playbooks

```bash
# ALWAYS dry-run first:
ansible-playbook -i inventory/hosts.yaml playbooks/fedora.yaml --check --diff

# Run locally with sudo prompt:
ansible-playbook -i inventory/hosts.yaml playbooks/fedora.yaml -K

# Limit to one host:
ansible-playbook -i inventory/hosts.yaml playbooks/fedora.yaml -l localhost

# With private inventory merged:
ansible-playbook \
  -i inventory/hosts.yaml \
  -i ../ansible-ops-private/inventory/hosts.yaml \
  playbooks/fedora.yaml

# Use tags for granular scope:
ansible-playbook -i inventory/hosts.yaml playbooks/fedora.yaml --tags "git,vscode"

# Run inside Docker (Fedora):
docker build -t fedora_systemd:latest .
scripts/run_ansible_in_docker.sh
# Or override:
ANSIBLE_PLAYBOOK=generic.yaml DOCKER_IMAGE=fedora_systemd scripts/run_ansible_in_docker.sh

# macOS target:
ansible-playbook -i inventory/hosts.yaml playbooks/mac.yaml

# OpenWrt (needs private inventory):
ansible-playbook \
  -i ../ansible-ops-private/inventory/hosts.yaml \
  playbooks/openwrt.yaml
```

## Linting & Pre-commit

```bash
# Full pre-commit suite (yamllint, ansible-lint, shellcheck, ruff, actionlint):
pre-commit run --all-files

# Individual checks:
ansible-lint
yamllint .
```

## Tests

```bash
cd tests && bash run_tests.sh    # smoke test: installs collection, runs playbook
```

Molecule tests exist per-role (e.g., `collections/ansible_collections/mikeeq/apps/roles/github_cli/molecule/`). Run with `molecule test` from the role directory.

## External Collections (requirements.yaml)

| Collection | Version |
|---|---|
| community.general | 12.6.0 |
| community.crypto | 3.2.0 |
| community.libvirt | 2.2.0 |
| community.zabbix | 4.2.0 |
| ansible.posix | 2.1.0 |
| ansible.utils | 6.0.2 |
| ansible.netcommon | 8.5.1 |

## Conventions & Safety Rules

- **YAML extension**: `.yaml` only — pre-commit hook converts `.yml` automatically.
- **Never run as root**: `playbooks/vars.yaml` enforces this with a hard fail.
- **Quote style**: double-quotes (`"`).
- **Line length**: 80 chars for code, 300 for YAML (yamlfix.toml).
- **Modules over commands**: `command-instead-of-module` is linted (but skipped in .ansible-lint — still prefer modules).
- **Architecture vars**: loaded dynamically from `group_vars/{{ ansible_facts['architecture'] }}.yaml`.
- **pipelining**: enabled in ansible.cfg — ensure `requiretty` is disabled on managed hosts.
- **Collections path**: `../.ansible/collections:../collections` (relative to `playbooks/`).
- **Roles path**: `../.ansible/roles:../roles`.

## CI/CD (.github/workflows/ci.yaml)

7 jobs: `static-analysis` → `molecule`, `playbook-tests`, `build-fedora`,
`build-fedora-arm64`, `build-ubuntu`, `build-macos`.

Triggers: push to `main`, PRs to `main`.
