# Kaset library visibility

Kaset is installed through `homebrew.casks` in `hosts/corthan/darwin.nix`. On
2026-10-28, the installed and latest release was 0.14.2.

In YouTube Music mode, saved playlists appear under **Library → Playlists**.
The sidebar's **Playlists** section shows only manually pinned items, so an
empty section does not mean the library is empty. Open a playlist and use its
**Add to Sidebar** button (sidebar icon) to pin it. Do not confuse this with
**Add to Favorites** in the card's context menu.

Kaset 0.14.2 requests only the initial page of the dedicated playlist browse
response in `YTMusicClient.fetchLibraryPlaylists`; unlike saved albums, it does
not follow continuation pages. Large libraries may therefore have missing
playlists even under **Library → Playlists**. Upstream issue
[`#490`](https://github.com/sozercan/kaset/issues/490) tracks this and was open
on 2026-10-28. Check the current release and issue status before diagnosing a
future report. Clearing local data or reauthenticating is not a justified fix
for this pagination limitation.

The selected Google profile is visible at the bottom of the sidebar. Verify
the account and Music/YouTube source before treating an empty Library as a
load failure. Keep cookies and account state outside the dotfiles repository.
