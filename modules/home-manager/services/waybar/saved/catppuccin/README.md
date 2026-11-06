# waybar — previous theme (Catppuccin-ish), saved 2026-11-06

Kept so the old bar can be brought back. Nothing in this directory is evaluated:
home-manager imports only `services/waybar/default.nix`
(see `modules/home-manager/desktop/hyprland/default.nix`, `"${nhModules}/services/waybar"`).

## Files

| file | what it is |
|---|---|
| `default.nix` | verbatim copy of the waybar module as of git `0504d7f`, inline Catppuccin CSS included |
| `style.css` | the same CSS lifted out of the nix string, for reading and diffing |

## Restore

Copy the saved module back over the live one:

```bash
cp saved/catppuccin/default.nix ../default.nix
```

Or restore only the look, keeping the new module shape (ship label, `builtins.readFile ./style.css`):
replace `../style.css` with the contents of `saved/catppuccin/style.css`, and drop
`"custom/ship"` from `modules-left`.

Then rebuild.

## What changed in the live theme

- Plates are angular (`border-radius: 0`) with a cyan hairline and a lit top edge, replacing the rounded translucent black panels with `#b4befe` borders.
- Ship identity plate on the left: `custom/ship` runs `hostname | tr a-z A-Z`, so the bar shows `ROCINANTE` (host-derived, shows `DONNAGER` there).
- Clock moved to `HH:MM` and recoloured amber; calendar tooltip re-tuned to the ship palette.
- Workspaces read as console keys: dim cyan idle, cyan-on-dark lit key when active, amber underline when focused, alert red when urgent, dashed outline when persistent.
- Status inks from the Roci display frames in `~/Pictures/roci.jpg`: alert red `#de5255` (mid) / `#ff4d4d`, phosphor green `#7ccd75`, nominal green `#4fd6a0`, warm amber `#ffb454`.
- Battery critical now alarms between dark and alert red instead of fading to black text.
- Recorder plate is a solid alert-red block, temperature critical is a red alert panel with dark ink.
