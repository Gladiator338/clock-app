# Assets and open source credits

All assets used in this project are open source or built-in. Document any new assets here with source URL and license.

## Sounds

- **Alarm / timer**: The app uses system ringtones via `flutter_ringtone_player` by default. Custom sounds are in `assets/sounds/` (alarm.wav, timer_end.wav). To play them in code, add a package like `audioplayers` or `just_audio` and use the asset path (e.g. `AssetSource('sounds/alarm.wav')`).
- Prefer sources with permissive licenses (e.g. [Freesound](https://freesound.org) with CC0 or CC-BY). List each file below with source and license.

| File | Purpose | Source | License |
|------|---------|--------|---------|
| `sounds/alarm.wav` | Alarm ringtone | [Freesound: metrostock99 – office building alarm](https://freesound.org/people/metrostock99/sounds/345061/) | CC (check Freesound page) |
| `sounds/timer_end.wav` | Timer completion sound | [Freesound: benhager67 – annoying alarm](https://freesound.org/people/benhager67/sounds/350601/) | CC (check Freesound page) |

## Icons

- **In-app**: Material Icons (via `Icons.*`) and Cupertino Icons from Flutter SDK.
- **App icon**: Default Flutter app icon unless replaced. If replaced, use an open source icon (e.g. [Lucide](https://lucide.dev), [Phosphor](https://phosphoricons.com) – MIT) and document here.

## Fonts

- System fonts only (no custom font files); see [SCOPE.md](SCOPE.md) and [NOTATION.md](NOTATION.md).
