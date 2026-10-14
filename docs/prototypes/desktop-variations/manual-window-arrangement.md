# Manual window arrangement

**Agreed behavior:** drag-and-drop zone placement into halves, thirds, quarters and custom regions. Nick prefers drop zones over placement shortcuts, currently uses Raycast's window actions, and wants something closer to PowerToys/FancyZones. Window switching/navigation remains keyboard-driven. Automatic tiling is explicitly excluded; opening or closing an application should not rearrange other windows.

The modern scarlet/teal visual direction and no-dock requirement remain agreed. Window placement is independent of the visual shell. No automatic tiler is required to create the selected look.

## Preferred tool

**Moom is Nick's provisional preference for saved-layout drop zones.** Nick explicitly asked to record Moom as the preference for now. This supersedes the earlier Rectangle Pro recommendation, which prioritized placement shortcuts. Moom can show a saved layout's zones while dragging, activated by an assigned modifier or by dragging to a configured screen edge. Different modifiers can expose different layout families, with no shortcut required for each individual zone. The preference remains subject to a later trial; purchase and installation have not been requested. Current official documentation was inspected on 14 October 2026; no candidate has been exercised on this Mac.

| Candidate | Relevant documented capabilities | Fit for Nick |
| --- | --- | --- |
| Rectangle Pro | Stock keyboard actions for halves, thirds, fourths and more; custom fractional or pixel positions; repeated-shortcut cycles; custom snap targets and an optional snap panel | Strongest initial candidate for familiar direct shortcuts with custom regions. Its Pin Mode and other rearrangement features are outside this plan. |
| Moom | Saved layouts provide visual drop zones; reveal them via a modifier while dragging or a configured screen edge; switch layout modifiers mid-drag | Nick's provisional preference: visually choose a zone from halves, thirds, quarters or a custom layout. |
| Lasso | Visual grid; saved custom layouts; per-layout global shortcuts; layout import/export | Strong alternative if drawing placements on a grid is the desired interaction. |

Sources: [Rectangle Pro keyboard actions](https://rectangleapp.com/pro/docs/keyboard-shortcuts/), [custom sizes and positions](https://rectangleapp.com/pro/docs/custom-size-position/), [snap targets and panel](https://rectangleapp.com/pro/docs/snap-areas/), [Moom official features](https://manytricks.com/moom/), [Moom drop-zone activation and options](https://manytricks.com/moom/help/snap.html), [Lasso official features](https://www.thelasso.app/).

## Proposed placement vocabulary

1. Half-screen placement and corner quarters.
2. Left, center and right thirds; left/right two-thirds.
3. Centered reading window and maximize/restore.
4. Custom zones for deliberately uneven arrangements.
5. Explicit movement between displays, preserving the intended size where supported.

These presets are proposals to validate as drop-zone layouts. Exact activation modifiers or edge triggers, gaps, display behavior and switching/focus commands are still unspecified. Existing Raycast remains the baseline until a replacement earns its place. If another tool takes ownership of placement, conflicting placement behavior should be removed during the later configuration phase.

## Trial should establish

Dropping into a zone places only the dragged window; layout changes are discoverable while dragging; opening and closing apps cause no unsolicited reflow; restore works; common apps respect their minimum sizes; laptop and any external-display layouts remain usable. The trial must also check conflicts with existing Raycast window actions and macOS snapping. These are future checks, not passing test results.
