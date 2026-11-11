---
title: "Homelab platform"
summary: "One small server running Incus, managed entirely as code: VMs, networks, a k3s cluster, GitOps apps, tailnet ACLs and hardened app VMs."
status: "Live"
weight: 10
private: true
repo: ""
live: ""
setup:
  - "Ubuntu 26.04 LTS + Incus on an i3 / 32 GB mini PC"
  - "OpenTofu + Terragrunt: Incus project, sizing profiles, macvlan networks, VMs"
  - "Ansible: k3s, hardening, unattended upgrades, app VMs"
  - "Flux: Forgejo, Actual Budget, kured, system-upgrade-controller"
  - "Tailscale subnet router, ACL policy as code"
stack: ["Incus", "OpenTofu", "Terragrunt", "Ansible", "k3s", "FluxCD", "Helm", "cert-manager", "Tailscale", "nftables", "Renovate"]
---

## What it is

My personal infrastructure lab and the place I try out platform ideas end to end. It replaced a bare Ubuntu + k3s box with an Incus host where every VM, container, network and profile is declared in OpenTofu, and every in-cluster app is reconciled by Flux from the same repository. It also hosts my self-hosted Forgejo and its CI runners.

## How it is set up

- **Hierarchical Terragrunt config** (`root → provider → environment → region → service`), with small hand-written `for_each` modules for Incus projects, profiles, networks and instances. Stacks are numbered and depend on each other, so `run --all` applies them in order.
- **Network:** the host sits on a dedicated router VLAN. VMs attach with macvlan and get real addresses from the router. Remote access goes through one unprivileged container acting as a Tailscale subnet router; who can reach what is enforced by the tailnet ACL, which is also code.
- **k3s lab cluster** (control plane + worker VMs) bootstrapped with Ansible, then handed to Flux in three layers: controllers → configs → apps.
- **Day-2 operations are automated:** Renovate opens PRs for chart, image and version pins; system-upgrade-controller rolls k3s one node at a time; kured reboots nodes only inside a 04:00–05:00 window; non-cluster hosts get unattended upgrades.
- **Hardened app VMs** for Docker Compose workloads: an nftables egress allow-list Docker cannot bypass, an SSH user that can only run one validated deploy command (pull by digest, roll back on a failed healthcheck), and age-encrypted backups.

## Worth pointing out

The box is small on purpose. Sizing profiles carry the headroom maths, Longhorn runs one replica because there is one real worker, and nothing gets HA topology it does not need. Every change goes `plan` → review → `apply`; nobody `kubectl apply`s a Flux-managed object.
