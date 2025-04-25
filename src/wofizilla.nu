#!/usr/bin/env nu

def profilesPath [
  type?: string = firefox
] {
  match $type {
    zen => "~/.zen/profiles.ini"
    firefox => "~/.mozilla/firefox/profiles.ini"
    thunderbird => "~/.thunderbird/profiles.ini"
  } | path expand
}

def apps [] { [ zen firefox thunderbird ] }

def main [
  cmd?: string@apps
] {
  mut cmd = $cmd
  if $cmd == null {
    $cmd = apps | input list
  }

  let path = profilesPath $cmd

  if ($path | path exists) {
    let choice = open $path
    | transpose title record
    | where title =~ '^Profile[0-9]+$'
    | each {|profile| $profile.record.Name }
    | to text
    | wofi --show dmenu
    nu -c $'($cmd) -p "($choice)"'
  } else {
    error make {
      msg: $"Couldn't find ($cmd | str title-case) profile"
      label: {
        text: $"no config found at ($path)"
        span: (metadata $cmd).span
      }
    }
  }
}
