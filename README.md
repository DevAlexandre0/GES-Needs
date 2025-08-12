# GES-Needs

GES-Needs is an advanced needs system for FiveM focused on survival gameplay.  It tracks player hunger, thirst, energy and stress while supporting extreme weather mechanics and optional status modules.

## Features

- **Configurable statuses** – Define hunger, thirst, energy and stress with custom decay, thresholds and effects in [`config.lua`](config.lua).
- **Blizzard mode** – Built‑in modifiers simulate harsh environments when temperature modules are absent.
- **Module integration** – Auto‑detects optional GES modules (Temperature, Wetness, Stamina, Injury, Sickness) and adjusts need decay accordingly.
- **Framework detection** – Works standalone and automatically hooks into ESX or QBCore when those resources are running.
- **Item consumption** – Register usable items through `ox_inventory` with animations or an ox_lib progress bar.
- **Persistence** – Saves needs using `oxmysql` when available or resource KVPs otherwise.
- **Exports & events** – Provides `GetStatus` (client) and `SvrGetStatus` (server) exports and emits events when thresholds are crossed or effects should play.

## Installation

1. Ensure `ox_lib` and `oxmysql` are installed.  For item usage install `ox_inventory`.
2. Place the resource in your server's resources folder and add `ensure GES-Needs` to your `server.cfg`.
3. Start optional GES modules before this resource if you want their effects applied.
4. Adjust settings in [`config.lua`](config.lua) to match your server's balance.

## Usage

- Use the client export:

  ```lua
  local status = exports['fivem-needs']:GetStatus('hunger')
  ```

- On the server:

  ```lua
  local status = exports['fivem-needs']:SvrGetStatus(source, 'stress')
  ```

- Events such as `advancedneeds:threshold:enter` or `fivem-needs:damage` allow other scripts to react to player state changes.

## License

This resource is open source and may be modified for your server.  Please retain attribution to the original authors.

