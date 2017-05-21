# Chest Inspector

A Minetest Client Side Modding [CSM] demonstration.

## Motivation

This mod was originally created to experiment with the new CSM (or "client side modding") features that have recently landed in Minetest. The original plan was to simply use a client side formspec to display node metadata from locked chests -- a sort of "x-ray" -- and it worked!

## The Vulnerability

Although I expected to be able to display node inventory within a formspec, I was surprised to find that the inventory of certain mods could be moved! After adding a formspec to display my own inventory, it became possible to not only view the contents of other players' mailboxes and protected chests, but also to *take their items*.

## The Fix

Mod creators should know that players now have the ability create (or "re-create") formspecs client-side and can use them to view a node's metadata. Therefore, the following node definitions need to be considered when calling
`minetest.register_node()` -- if not the node is likely vulnerable to inventory manipulation.

  - `allow_metadata_inventory_move`
  - `allow_metadata_inventory_put`
  - `allow_metadata_inventory_take`

Additionally, this [pull request](https://github.com/minetest/minetest/pull/5702) to Minetest added the ability to designate metadata as "private" meaning it is not sent to the client automatically. "Hiding stuff from cilent side mods" is noted as a potential use. See `mark_as_private()` in the Class Reference documentation for details.

The release of this mod was delayed while makers of the affected mods were contacted about the issue. Happily, all mod projects responded quickly and patches were merged.

Now that problems are fixed in the affected mods, I am releasing this client mod. I hope that CSM will be a driver of better security practices as all of this was already possible before, but is now more approachable with the addition of the client lua API. Despite FUD slinging by certain people on the forums, client side modding is a great feature and makes for some exciting possibilities. Thanks to the devs of Minetest for this awesome functionality.

# Usage

> **NOTE** By default, the player's inventory is not shown so items cannot be taken from vulnerable mods.

Left-click on the following supported nodes to see their contents:

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

Enable the mod by setting `load_mod_client_chest_inspector = true` in `/clientmods/mods.conf`. Also check that `enable_client_modding = true` in `minetest.conf` or in the Advanced Settings screen of your Minetest client.

## License

MIT License. See the included `LICESNE.md` for details.
