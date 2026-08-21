# Repository Report — `/etc/nixos`

**Author:** Antoine Rivoire (`antoine` / personal, `a.rivoire` / work)
**Type:** Personal multi-host infrastructure-as-code repo — NixOS + Home Manager + Darwin
**Size:** ~3,426 lines of `.nix` across ~80 files · Git: 5 recent commits (branch `main`)
**Theme:** Catppuccin *Macchiato/Lavender* · Desktop: **Hyprland** · Workload: **audio production** + AI/developer tooling

---

## 1. High-level summary

This is a well-structured, modern Nix **flake** configuration for one person's two machines:

| Host | OS | User | Purpose |
| --- | --- | --- | --- |
| `rocinante` | NixOS (x86_64, AMD/AVX2) | `antoine` | Primary desktop — music production + dev |
| `MACMNPV9WL3V7` | macOS (aarch64, Apple Silicon) | `a.rivoire` | Work machine, managed via nix-darwin |

It is deliberately **layered**: the OS-level audio/realtime tuning lives in NixOS modules, while apps, dotfiles, and the desktop shell live in Home Manager. The whole thing is themed around the *Expanse* "Roci" aesthetic (lock screen, wallpaper) and Catppuccin.

---

## 2. Architecture & layout

```
.
├── flake.nix              # Root flake: flake-parts + import-tree (dendritic subflake)
├── flake.lock
├── plan.md                # Research plan: "Music Production Environment with devenv" (NOT yet implemented)
├── hosts/                 # Per-host system configs
│   ├── rocinante/         #   NixOS hardware-configuration.nix
│   └── MACMNPV9WL3V7/     #   Darwin system config (dock, finder, homebrew, key remap, TouchID)
├── modules/               # Reusable, host-agnostic modules
│   ├── nixos/             #   system-level modules (boot, networking, audio, users, services...)
│   ├── home-manager/      #   user-level modules (programs, services, desktop, misc)
│   └── overlays/          #   vcv-rack overlay
├── dendritic/             # import-tree subflake: re-exports modules as flake outputs
│   ├── flake/             #   rocinante.nix, darwin.nix, home-configurations.nix, options.nix
│   ├── nixos/             #   registry of nixosModules (audio, users, services, ...)
│   └── home/registry.nix  #   registry of homeModules (programs, core, scripts)
├── overlays/              # root-level stable-packages overlay (currently unused/commented)
├── files/                 # avatar image, waybar-restart script
└── .claude/settings.local.json   # sandboxed permission allowlist for the claude-code agent
```

### How the flakes fit together

- **Root `flake.nix`** uses `flake-parts.lib.mkFlake` and simply imports the `dendritic` subflake via `import-tree`. It pins nixpkgs to `nixos-unstable` and declares all external inputs.
- **`dendritic`** (github:vic/import-tree) is the real engine. It:
  - Builds `flake.nixosConfigurations.rocinante` (the desktop).
  - Builds `flake.darwinConfigurations.MACMNPV9WL3V7` (the Mac, reusing the legacy host config verbatim).
  - Builds `flake.homeConfigurations` for **two** users: `antoine` (Linux) and `a.rivoire` (Darwin).
  - Exposes `nixosModules` and `homeModules` attrsets that the `modules/` tree contributes.

The `dendritic/home/registry.nix` is the key wiring: it maps each file under `modules/home-manager/<area>/<name>/` to a `homeModules` entry, and `flake/rocinante.nix` / `home-configurations.nix` then import exactly the modules each user needs. Linux-only desktop modules are added explicitly per-host so the darwin user never pulls them in.

---

## 3. External inputs (flake inputs)

- **nixpkgs** (`nixos-unstable`) — core, shared by most.
- **flake-parts** (hercules-ci) — build framework.
- **import-tree** (vic) — subflake re-export.
- **nixos-hardware** (nixos) — AMD CPU/GPU + SSD common profiles.
- **home-manager** (nix-community).
- **catppuccin** (github:catppuccin/nix) — theming (macchiato/lavender).
- **nix-darwin** (LnL7) + **nix-homebrew** (zhaofengli-wip) — macOS.
- **nvf** (notashelf) — the Neovim config framework.
- **claude-code-nix** (sadjow) — Claude Code package + overlay + cachix.
- **llm-agents.nix** (numtide) — provides `pkgs.llm-agents.pi` (the "pi" agent).
- **mcp-nixos** (utensils) — the NixOS MCP overlay.
- **audio.nix** (polygon) — audio overlays.
- **sops-nix** (Mic92) — decrypts `secrets/*.age` into the Nix store at build time.
- **devshell, fenix, bun2nix, base16-schemes** — transitive.

Caches: `claude-code.cachix.org` is a configured substituter.

---

## 4. NixOS system modules (`modules/nixos/`)

Small, composable modules each exposing a `flake.nixosModules.<name>`:

| Module | What it does |
| --- | --- |
| `boot` | systemd-boot EFI, `v4l2loopback` virtual camera (`exclusive_caps=1`, "Virtual Camera"), quiet/splash |
| `networking` | NetworkManager + firewall |
| `users` | User `antoine` in groups plugdev/networkmanager/wheel/camera/dialout/libvirtd/storage/audio/jackaudio; passwordless sudo; activation script that installs the AccountsService avatar |
| `services` | OpenSSH, gvfs/udisks2/devmon (device automount), updatedb; CUPS disabled |
| `virtualisation` | libvirtd + Spice USB redirection (VMs) |
| `audio` | **Pipewire** (JACK + ALSA 32-bit + Pulse emulation), RTKit — PulseAudio disabled |
| `fonts` | JetBrains Mono + Meslo LG (Nerd Fonts) + Roboto; `fontDir.enable` |
| `locale` | `Europe/Dublin`, `en_GB` default, **all LC_* forced to Irish (`en_IE`)**, GB `mac_intl` keyboard, libinput |
| `udev-teensy` | udev rules for Teensy/MIDI boards (idVendor `16c0`) |
| `nix` | allowUnfree, nix path registry, auto-optimise-store, trusted users, claude-code cachix |
| `programs` | nvf (Vim, Catppuccin "dark") at system level |
| `desktop/hyprland` | Hyprland + uwsm, greetd+tuigreet, Bluetooth/blueman, gnome-keyring, polkit, Chromium Ozone env vars, a set of GNOME/Wayland apps |
| `services/ollama` | AMD ROCm acceleration (disabled by default, `enable=false`) |
| `services/tftpd` | atftpd (disabled) bound to `192.168.0.66` |
| `music` | **Musnix** (RT kernel + rtirq), plus a full duplicated copy of most system settings — see §6 concerns |

---

## 5. Home Manager modules (`modules/home-manager/`)

### Desktop shell

- **Hyprland** (`desktop/hyprland`) — the WM. Sources a committed `hyprland.conf`, imports a large set of service/misc modules, sets Bibata cursor + Catppuccin GTK theme + Roboto font, and a big `dconf` settings blob (Nautilus, calculator, blueman, file-chooser).

### Services (Wayland-focused)

- `waybar` — fully themed taskbar (workspaces, CPU/temp/memory/battery/bluetooth/pulseaudio, calendar, power via wlogout).
- `wlogout`, `hyprlock` (**Expanse "ROCINANTE" tactical lock screen** — cyan/amber on navy, "ACCESS DENIED — ATTEMPT N"), `hypridle`, `hyprpaper` (Expanse wallpaper on HDMI-A-1), `kanshi` (docked/undocked profiles), `cliphist` (clipboard), `ulauncher` (launcher + custom shortcuts, writes a writable shortcuts file via activation), `dunst` (notifications, Papirus-dark), `easyeffects` (**mic preset**: RNNoise → compressor → limiter).

### Programs

- Editor: **nvf** (Neovim) — heavily configured: Catppuccin Macchiato, Lualine, Which-key, Telescope, Treesitter, Blink-CMP, Avante (via LiteLLM at `http://192.168.68.220:4000`), LSPs + Treesitter for ~13 languages (Nix, Rust, Python, C#, TS, SQL, Typst, Clojure, etc.). Note: `typescript-go` disabled due to upstream panics.
- Terminals/shell: `alacritty` (opaque, tmux-backed), `zsh` (aliases, Bitwarden CLI auto-unlock wrapper), `starship`, `tmux` (Vi keys, Ctrl-Q prefix, Catppuccin status), `fzf`, `bat`, `btop`/`bottom`, `lazygit`, `git` (OpenPGP signing, delta), `gpg`.
- AI/coding: `claude-code`, `opencode` (with MCP integration + microsoft-learn MCP), `nvf`'s Avante.
- Multimedia/work: `obs-studio`, `swappy` (screenshot editor), `zoom` (pinned to a **specific older nixpkgs** for working Wayland screen share — `zoom-us` 6.0.2.4680).

### Cross-platform (darwin-aware)

- `aerospace` (macOS tiler, `mkIf isDarwin`), `obs-studio`, `claude-code`, `gpg` (Darwin skips gpg-agent).

### Misc

- `gtk` (theme/cursor/font/bookmarks), `xdg` (MIME associations, user dirs), `wallpaper` (declares the `wallpaper` option).

---

## 6. Notable observations & concerns

1. **Duplicate system config (`music` vs. the other nixos modules).**
   `modules/nixos/music/default.nix` is a **full, monolithic** NixOS config (boot, networking, locale, users, packages, pipewire, udev, fonts, zsh, ssh, musnix…) that duplicates almost everything the granular modules (`boot`, `networking`, `users`, `services`, `audio`, `locale`, `fonts`, `udev-teensy`, `shell`) already provide. **It is not actually wired into `rocinante.nix`** — the active rocinante config uses the granular modules. It reads like the original single-file config before the refactor into `dendritic`. Treat it as legacy/dead or a migration target, not the live config.

2. **`plan.md` is an unimplemented research plan.** It documents a proposed **devenv**-based music-production layer (Bitwig 6 beta packaging, plugin paths). Nothing in the live config implements it — audio work is done via system packages (`bitwig-studio-latest`, `cardinal`, `ardour`, `vcv-rack`, `qjackctl`, `shotcut`). If you want the devenv layer, it's a fresh addition, not present here.

3. **Secrets hygiene (RESOLVED — see §9).** `smb-secrets` previously held a plaintext username/password (`homehassistant` / `myhassio`) for a Home Assistant SMB share. It has been migrated to SOPS/age: only the ciphertext `secrets/smb.json.age` is committed; the plaintext `smb-secrets` is gitignored and removed from the working tree. The age private key lives only on Roci (`~/.config/sops/age/keys.txt`, never committed). See §9 for the wiring and the open history/rotation question.

4. **Pinned Zoom tarball.** `programs/zoom` fetches a hardcoded nixpkgs commit for `zoom-us`. This is reproducible but will drift and needs manual updates; consider a maintained overlay instead.

5. **Hardware.** `rocinante` is an AMD CPU + AMD GPU (AVX2, ROCm gfx 11.0.0) machine, Dublin timezone, Irish locale, GB mac keyboard. `v4l2loopback` is built for virtual camera (OBS/Zoom). libvirtd VMs via Spice.

6. **AI/dev stack is prominent.** `pi`, `claude-code`, `opencode`, `llm-agents`, `ollama` (ROCm, disabled), and nvf's Avante all present — this is clearly an AI-assisted development + agent setup, and `.claude/settings.local.json` shows a sandboxed permission allowlist already in use.

7. **Two-user, two-OS design** is clean: `userConfig` records name/email/fullName/avatar/gitKey per identity, threaded through both Linux and Darwin configs. Git signing keys differ per identity.

8. **Small rough edges found while reading** (all low severity, informational):
   - `misc/xdg/default.nix` has typos in MIME keys: `audio/mp3`, `audio/*`, `video/*`, `video/mp4` point to `org.gnome.Totem.dekstop.desktop` (misspelled "dekstop") — these associations likely silently fail.
   - `hyprland.conf` is referenced but I only saw it imported; worth confirming it exists and matches the (commented-out) hyprlock design in the note.
   - `nixos/services/ollama` sets `rocmOverrideGfx = "11.0.0"` — pin to your actual GPU gfx level.

---

## 7. How to build / apply

```bash
# Build the desktop config (no reboot)
nix build .#rocinante --extra-experimental-features "nix-command flakes"

# Rebuild + switch the running system
sudo nixos-rebuild switch --flake .#rocinante

# Home Manager (user)
nh os switch --flake .#rocinante      # or: home-manager switch --flake .

# Darwin (Mac)
sudo nix-darwin switch --flake .#MACMNPV9WL3V7

# Evaluate only / diff
nix flake show
```

The `result` symlink currently points at a `nixos-system-rocinante` build dated `26.11.20260802`.

---

## 9. Secrets via SOPS + age (rocinante only)

Secrets are provisioned with **sops-nix** (`github:Mic92/sops-nix`, pinned in `flake.lock`), using **age** for encryption.

**Layout**

- `dendritic/nixos/sops.nix` — a flake-module exporter (`flake.nixosModules.sops`) that auto-imports into `rocinante` via `attrValues self.nixosModules` (see `dendritic/flake/rocinante.nix`). The Mac never imports `nixosModules`, so it stays Roci-only.
- `secrets/smb.json.age` — the encrypted secret, committed as **ciphertext only**.
- `~/.config/sops/age/keys.txt` — the age private key, on Roci only, **never committed**.

**How it works (in `dendritic/nixos/sops.nix`)**

```nix
imports = [ inputs.sops-nix.nixosModules.sops ];
sops = {
  age = { keyFile = "/home/antoine/.config/sops/age/keys.txt"; };
  secrets."smb.json" = {
    format = "json";   # emits the whole JSON doc (key = "")
    key = "";
    sopsFile = ../../secrets/smb.json.age;
  };
};
```

The decrypted file lands at **`config.sops.secrets."smb.json".path` → `/run/secrets/smb.json`**, ready for a consumer (e.g. the not-yet-built SMB automount) to read `username`/`password` from.

**Verification done**

- `config.sops.secrets."smb.json".path` resolves to `/run/secrets/smb.json`.
- `sops decrypt secrets/smb.json.age` with the Roci key round-trips to `{"smb":{"username":"homehassistant","password":"myhassio"}}`.
- The Mac config (`MACMNPV9WL3V7`) has no `sops` option — untouched.
- `sops-nix`'s `validateSopsFiles` (default `true`) checks the committed file at eval time.

**Important gotchas learned**

- This sops-nix version has **no `sops.enable` option** — the module is active simply by being imported.
- `sops` 3.13.3's `--age` flag is broken; use `SOPS_AGE_RECIPIENTS=age1…` (env var) to encrypt.
- `import-tree` (via the flake's git-based source filter) only discovers `.nix` files that are **git-tracked**, so new `dendritic/nixos/*.nix` modules must be committed to be picked up.
- Decrypting a `.age` with a `.json` body needs `--output-type json` (the suffix doesn't indicate the format).

**Open item — the plaintext is still in git history.**
The old plaintext (`ca78e54`) remains reachable in history. Two remediations, **neither done without your go-ahead**:

- **A. Rotate the password** (recommended). Change the Home Assistant SMB password externally; the old value then has no value. Cheapest, safest, reversible.
- **B. Rewrite git history** (`git filter-repo --replace-text` to scrub `myhassio`, then force-push). Removes the plaintext from history entirely, but is irreversible and rewrites every clone's history.

---

## 8. Verdict

A clean, thoughtfully organized, **flake-parts + import-tree** personal config. The modular split (`modules/` → `dendritic` registry → per-host imports) is the strong part and scales well for a second user/host. The main things worth acting on: **remove or repurpose the dead `music/default.nix` monolith**, **harden the committed SMB credentials**, and **decide whether to actually build the `plan.md` devenv audio layer** or delete the plan. Everything else is polished, themed, and coherent.
