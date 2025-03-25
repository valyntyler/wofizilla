#!/usr/bin/env nu

def profilesPath [
  type?: string = firefox
] {
  match $type {
    zen => { "~/.zen/profiles.ini" | path expand }
    firefox => { "~/.mozilla/firefox/profiles.ini" | path expand }
    thunderbird => { "~/.thunderbird/profiles.ini" | path expand }
  }
}

let path = profilesPath firefox

if ($path | path exists) {
  let choice = open $path
  | transpose title record
  | where title =~ '^Profile[0-9]+$'
  | each {|profile| $profile.record.Name }
  | to text
  | wofi --show dmenu
  firefox -p $choice
} else {
  print "Profile config not found."
  exit 1
}