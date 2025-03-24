#!/usr/bin/env nu

def profilesPath [
  type?: string = firefox
] {
  match $type {
    firefox => { "~/.mozilla/firefox/profiles.ini" | path expand }
    thunderbird => { "~/.thunderbird/profiles.ini" | path expand }
  }
}

let path = profilesPath thunderbird

if ($path | path exists) {
  open $path
  | transpose title record
  | where title =~ '^Profile[0-9]+$'
} else {
  print "Profile config not found."
  exit 1
}