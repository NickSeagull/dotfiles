on run argv
  if (count of argv) is not 1 then
    error "Expected one built nix-darwin system path under /nix/store/." number 64
  end if

  set systemPath to item 1 of argv
  if systemPath does not start with "/nix/store/" or systemPath contains "/../" then
    error "Use the resolved /nix/store/ path of the built system." number 64
  end if

  set rebuildPath to systemPath & "/sw/bin/darwin-rebuild"
  do shell script "test -x " & quoted form of rebuildPath & " && test -x " & quoted form of (systemPath & "/activate")

  -- Match darwin-rebuild switch's profile update, then activate that exact build.
  -- Building the user's Git worktree as root fails libgit2's ownership checks.
  set activationCommand to "set -e" & linefeed & "/nix/var/nix/profiles/default/bin/nix-env --profile /nix/var/nix/profiles/system --set " & quoted form of systemPath & " 2>&1" & linefeed & quoted form of rebuildPath & " activate 2>&1"
  return do shell script activationCommand with administrator privileges without altering line endings
end run
