# Manual window arrangement

**Agreed behavior:** keyboard-driven, user-triggered placement into halves, thirds, quarters and custom regions. Nick currently uses Raycast's window actions and wants something closer to PowerToys/FancyZones. Automatic tiling is explicitly excluded; opening or closing an application should not rearrange other windows.

The modern scarlet/teal visual direction and no-dock requirement remain agreed. Window placement is independent of the visual shell. No automatic tiler is required to create the selected look.

## Current recommendation

**Rectangle Pro is the leading candidate for keyboard-first placement plus custom snap targets.** This is a recommendation, not an accepted tool choice, purchase or installation. Current official documentation was inspected on 14 October 2026; no candidate has been exercised on this Mac.

| Candidate | Relevant documented capabilities | Fit for Nick |
| --- | --- | --- |
| Rectangle Pro | Stock keyboard actions for halves, thirds, fourths and more; custom fractional or pixel positions; repeated-shortcut cycles; custom snap targets and an optional snap panel | Strongest initial candidate for familiar direct shortcuts with custom regions. Its Pin Mode and other rearrangement features are outside this plan. |
| Moom | Custom actions and keyboard controller; keyboard grid; saved layouts for named apps or recent windows; layouts can supply visible drop zones | Strong alternative if saving and restoring complete arrangements or selecting among explicit zone outlines matters more. |
| Lasso | Visual grid; saved custom layouts; per-layout global shortcuts; layout import/export | Strong alternative if drawing placements on a grid is the desired interaction. |

Sources: [Rectangle Pro keyboard actions](https://rectangleapp.com/pro/docs/keyboard-shortcuts/), [custom sizes and positions](https://rectangleapp.com/pro/docs/custom-size-position/), [snap targets and panel](https://rectangleapp.com/pro/docs/snap-areas/), [Moom official features](https://manytricks.com/moom/), [Lasso official features](https://www.thelasso.app/).

## Proposed placement vocabulary

1. Half-screen placement and corner quarters.
2. Left, center and right thirds; left/right two-thirds.
3. Centered reading window and maximize/restore.
4. Custom zones for deliberately uneven arrangements.
5. Explicit movement between displays, preserving the intended size where supported.

These presets are proposals to validate. Exact keys, modifier choice, gaps, display behavior and switching/focus commands are still unspecified. Existing Raycast remains the baseline until a replacement earns its place. If another tool takes ownership of placement, duplicate placement shortcuts should be removed during the later configuration phase.

## Trial should establish

Manual shortcuts place only the requested window; opening and closing apps cause no unsolicited reflow; restore works; common apps respect their minimum sizes; laptop and any external-display layouts remain usable. The trial must also check collisions with existing Raycast shortcuts. These are future checks, not passing test results.
