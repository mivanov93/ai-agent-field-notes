# Candidate skins

`assets/css/style.css` is `base.css` followed by one skin, concatenated in that
order — the skin must load second so it can override the base.

`base.css` is structure only: the sidebar shell, the drawer, the reading grid.
Each skin sets type, colour and density through the same custom properties, so
swapping one for another changes nothing structural.

| Skin | Look | Display / text / mono |
|------|------|------------------------|
| a | Manual — bone stock, near-black, signal red. **In use.** | Bricolage Grotesque / Source Serif 4 / JetBrains Mono |
| b | Ledger — dark instrument panel, amber | Archivo / IBM Plex Serif / IBM Plex Mono |
| c | Broadsheet — newsprint, plate blue, double rules | Fraunces / Newsreader / IBM Plex Mono |
| d | Blueprint — cool blue-grey, navy, plate blue | Schibsted Grotesk / Literata / DM Mono |
| e | Almanac — warm reference book, slab, deep green | Zilla Slab / Faustina / Space Mono |
| f | Press — near-white page against an inked rail, hot red | Familjen Grotesk / Crimson Pro / Fragment Mono |

To switch, rebuild the stylesheet and update `fonts:` in `_config.yml` to that
skin's Google Fonts URL:

```bash
cat assets/css/skins/base.css assets/css/skins/<skin>.css > assets/css/style.css
```

Every skin was measured: body text at or above 14.9:1, secondary text and
navigation at 7:1, nothing below the 4.5:1 AA requirement in either light or
dark mode.
