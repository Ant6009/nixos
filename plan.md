# Music Production Environment with devenv - Research & Plan

## Research Findings

### Current NixOS Audio Setup (already in place)

Your system (`rocinante`) is already well-configured for audio:

- **Musnix enabled** with real-time kernel and rtirq (`modules/nixos/common/default.nix:25-27`)
- **PipeWire** with JACK, ALSA (32-bit), and PulseAudio emulation (`common/default.nix:94-103`)
- **RTKit** enabled for real-time scheduling
- **User `antoine`** in `audio` and `jackaudio` groups
- **Existing audio tools**: Ardour, Cardinal, qjackctl, sox, ffmpeg, pavucontrol
- **EasyEffects** configured with RNNoise + compressor + limiter for mic input
- A stub `modules/nixos/music/default.nix` exists (placeholder)

### Musnix - What It Does

Musnix is a **system-level NixOS module** that optimizes the OS for real-time audio. It handles things devenv **cannot**:

| What musnix sets | Effect |
|---|---|
| `kernel.realtime` | Applies `CONFIG_PREEMPT_RT` patch for low-latency kernel |
| `kernel.packages` | Selects RT kernel version (6.1, 6.6, 6.8, 6.11) |
| `alsaSeq.enable` | Loads `snd_seq` and `snd_rawmidi` kernel modules |
| `rtirq.*` | Prioritizes audio device interrupts (IRQ threading) |
| `ffado.enable` | FireWire audio driver support |
| `das_watchdog.enable` | Prevents RT processes from hanging the machine |
| `soundcardPciId` | PCI latency timer optimization for onboard audio |
| `rtcqs.enable` | Installs diagnostic tool for audio config analysis |
| Auto-applied | CPU governor → "performance", vm.swappiness → 10, PAM limits (memlock unlimited, rtprio 99), plugin env vars (VST_PATH, LV2_PATH, CLAP_PATH, etc.) |

**Key takeaway**: Musnix is strictly a NixOS module. It cannot run inside devenv. Your system already has it enabled.

### Bitwig Studio 6 Beta

- **Latest beta**: Beta 9 (as of Feb 2026); Beta 6 was released Nov 7, 2025
- **Requirements**: 64-bit x86 with SSE4.1 + **AVX2**, Vulkan or GL driver, 4GB RAM, 12GB disk
- **Audio**: PipeWire (preferred), JACK, or ALSA
- **Bundled JRE**: No separate Java needed
- **NixOS status**: Not in nixpkgs yet. Existing derivations cover Bitwig 4 and 5 (`pkgs/applications/audio/bitwig-studio/`). A custom derivation based on `bitwig-studio5.nix` would be needed.
- **Known issues on NixOS**: AMDVLK can cause segfaults (use mesa Vulkan instead), wrapper may not respect overrides

### devenv Assessment for Music Production

**What devenv CAN do** (user-space, per-project):
- Install packages: Bitwig, plugins, audio tools (anything in nixpkgs or custom derivations)
- Set environment variables: `VST_PATH`, `LV2_PATH`, `CLAP_PATH`, `DSSI_PATH`, `LADSPA_PATH`
- Shell hooks: auto-setup scripts on `devenv shell` entry
- Project isolation: different plugin sets per project
- Custom scripts/commands

**What devenv CANNOT do** (system-level - handled by musnix/NixOS):
- Kernel configuration (RT kernel, boot params)
- PAM limits (rtprio, memlock)
- System services (PipeWire, JACK daemon)
- CPU frequency governor
- udev rules for audio devices
- User group membership (audio, jackaudio)

## Assessment: Is devenv a good fit?

**Yes, as a complement to the existing NixOS config.** The layered approach:

1. **NixOS system level** (already done): musnix, PipeWire/JACK, RT kernel, PAM limits, user groups
2. **devenv project level** (to build): Bitwig + plugins, plugin paths, per-project audio tool sets

devenv adds value by:
- Keeping music production packages out of the system config (cleaner separation)
- Making plugin paths declarative and reproducible
- Allowing different setups per project (e.g., one for mixing, one for synthesis)
- Easy `devenv shell` entry to get the full environment

## Implementation Plan

### Step 1: Create the devenv project structure
- Create `/etc/nixos/music-production/` (or a separate repo) with `devenv.nix` and `devenv.yaml`
- Configure devenv inputs (nixpkgs, potentially a Bitwig overlay)

### Step 2: Package Bitwig 6 Beta
- Create a custom derivation based on the existing `bitwig-studio5.nix` from nixpkgs
- Fetch the Bitwig 6 beta `.deb` and adapt the build
- Add as a local overlay or flake input

### Step 3: Declare packages in devenv.nix
- Bitwig 6 beta (custom derivation)
- Audio plugins (LV2, VST3, CLAP packages from nixpkgs)
- Supporting tools (carla, yabridge for Windows VSTs if needed, etc.)

### Step 4: Declare plugin paths
```nix
env.VST_PATH = "...";
env.VST3_PATH = "...";
env.LV2_PATH = "...";
env.CLAP_PATH = "...";
env.LADSPA_PATH = "...";
env.DSSI_PATH = "...";
```

### Step 5: Shell hooks and scripts
- `enterShell` hook to verify audio setup (check PipeWire running, RT limits available)
- Custom scripts for common tasks (launch Bitwig with correct env, scan plugins, etc.)

### Open Questions
1. Should this live inside `/etc/nixos/` or as a separate repo?
2. Which specific plugins/instruments to include initially?
3. Do you want yabridge for Windows VST compatibility?
4. Should we also clean up the existing audio packages from the NixOS system config (move Ardour, Cardinal, etc. into devenv)?
