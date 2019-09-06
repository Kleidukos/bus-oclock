# bus-oclock

A very simple CLI tool that queries Pierre Grimaud's [RATP API][] and can
display a notification telling you when is your next bus.

## System Dependencies

- Fedora: 
  - libxml2-devel
- Nix:
  -  `$ nix-shell shell.nix`


## Build

`$ stack install` in the project root

## Usage

`$ Usage: bus-oclock CONFIG_PATH [-n|--notify-send]`

## Configuration example

```dhall
let Direction = <A | R>
let default = { direction = Direction.A
              , line = 31
              , stop = "wagram+++prony"
              }

in default
```

## TODO

- [ ] Handle aliases from config file

[RATP API](https://api-ratp.pierre-grimaud.fr/v3/documentation) for bus times.
