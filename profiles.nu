#!/usr/bin/env nu

let path = "~/.mozilla/firefox/profiles.ini" | path expand

if ($path | path exists) {
  open $path
  | transpose title record
  | where title =~ '^Profile[0-9]+$'
} else {
  print "Profile config not found."
  exit 1
}