# Chest Inspector

A Minetest Client Side Modding [CSM] demonstration.

![Inspecting Locked Chest Contents](/screenshot.png?raw=true "Inspecting Locked Chest Contents")

# Usage

Punch the following supported nodes to see their contents:

- `default:locked_chest`
  - from https://github.com/minetest/minetest_game
- `protector:chest`
  - from https://github.com/tenplus1/protector
- `xdecor:mailbox`
  - from https://github.com/minetest-mods/xdecor
- `inbox:empty`
  - from https://github.com/bas080/inbox

## Installation

A recent build of Minetest supporting client side modding is required. See [Paths in the documentation](https://github.com/minetest/minetest/blob/master/doc/client_lua_api.md#paths) to find out where the files need to go on your system.

Enable the mod by setting `load_mod_csm_chest_inspector = true` in `/clientmods/mods.conf`. Also check that `enable_client_modding` is set in `minetest.conf` or the Advanced Settings screen of your Minetest client.

## License

MIT License. See the included `LICESNE.md` for details.

# About

## Motivation

This mod was originally created to experiment with the new CSM (or "client side modding") features that have recently landed in Minetest. The original plan was to simply use a client side formspec to display node metadata from locked chests -- a sort of "x-ray" -- and it worked!

## Mod Vulnerability

Although I expected to be able to display node inventory within a formspec, I was surprised to find that the inventory of certain mods could be moved! After adding a formspec to display my own inventory, it became possible to not only view the contents of other players' mailboxes and protected chests, but also to *take their items*.

This functionality is disabled by default. Set `show_player_inventory = true` to enable.

## The Fix

Mod creators should know that players now have the ability create (or "re-create") a formspec client-side and use it to view a node's metadata. Therefore, the following node definitions need to be considered when calling `minetest.register_node()` -- if not the node is likely vulnerable to inventory manipulation.

  - `allow_metadata_inventory_move`
  - `allow_metadata_inventory_put`
  - `allow_metadata_inventory_take`

For reference, here's the [pull request](https://github.com/minetest-mods/xdecor/pull/78/files) submitted to xdecor that fixed this issue with the mailbox node.

### The Better Fix

This [pull request](https://github.com/minetest/minetest/pull/5702) to Minetest (now merged) added the ability to designate metadata as "private" meaning it is not sent to the client automatically. "Hiding stuff from cilent side mods" is noted as a potential use. See `mark_as_private()` in the Class Reference documentation for details.

## Release

The release of this mod was delayed while makers of the affected mods were contacted about the issue. Happily, each project responded quickly and fixes are merged.

With problems fixed in the affected mods, I am releasing this client mod. I hope that CSM will be a driver of better security practices as all of this was already possible before, but is now more approachable with the addition of the client lua API. Client side modding is a cool feature and makes for some exciting possibilities. Thanks to the devs of Minetest for this awesome functionality.

This mod may not be useful in the future once inventory meta can be kept from clients. I would be very interested to see a mod that defeats this one!

## Contributing

Pull requests welcome, especially if they add support for more nodes!
