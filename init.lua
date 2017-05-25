--[[

Minetest Client Mod: Chest Inspector

Copyright (C) 2017 tjnenrtn <tjnenrtn@protonmail.com>

MIT License

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

-------------------------------------------------------------------------------

	This client mod displays node metadata within a formspec.

	Mods that do not implement the following node definitions when calling
	'register_node()' may be vulnerable to inventory manipulation:

	- 'allow_metadata_inventory_move'
	- 'allow_metadata_inventory_put'
	- 'allow_metadata_inventory_take'

]]

local show_player_inventory = false

local function prepare_formspec()

	local formspec = ""
	local formspec_style = "bgcolor[#080808BB;true]" ..
		"background[5,5;1,1;gui_formbg.png;true]" ..
		"listcolors[#00000069;#5A5A5A;#141318;#30434C;#FFF]"

	if show_player_inventory then
		formspec = "size[8,9]" ..
			"list[current_player;main;0,4.85;8,1;]" ..
			"list[current_player;main;0,6.08;8,3;8]"
	else
		formspec = "size[8,4.5]"
	end

	return formspec .. formspec_style

end

local function show_node_inventory(params)

	local formspec = prepare_formspec()

	core.show_formspec("csm_chest_inspector:node",
		formspec ..
		"label[0,0;"..params["label"].."]" ..
		"list[nodemeta:"..params["spos"]..";main;0,0.55;8,4;]"
	)

end

local function show_xdecor_mailbox_inventory(params)

	local formspec = prepare_formspec()

	core.show_formspec("csm_chest_inspector:xdecor_mailbox",
		formspec ..
		"label[0,0;"..params["label"].."]" ..
		"list[nodemeta:"..params["spos"]..";mailbox;1,0.55;6,4;]"
	)

end

local function label_owner(meta, label)

	if meta:get_string("infotext") ~= nil then
		label = meta:get_string("infotext")
	elseif meta:get_string("owner") ~= nil then
		label = label.." (owned by: "..meta:get_string("owner")..")"
	end

	return label

end

core.register_on_punchnode(function(pos, node)

	local spos = pos["x"]..","..pos["y"]..","..pos["z"]
	local meta = core.get_meta(pos)
	local name = node["name"]

	if name == "default:chest_locked" then
		-- mod implements allow_metadata_inventory_take
		core.after(0.15, show_node_inventory, {spos=spos, label=label_owner(meta, "Locked Chest")})
	elseif name == "protector:chest" then
		-- mod fixed upstream:
		-- https://github.com/tenplus1/protector/commit/20c6d2b9b95d88cc50aea6541493076f11b2b148
		core.after(0.15, show_node_inventory, {spos=spos, label="Protector Chest"})
	elseif name == "xdecor:mailbox" then
		-- mod fixed upstream:
		-- https://github.com/minetest-mods/xdecor/commit/787ba258d201daec213e8be83e1b8f207410a8a6
		core.after(0.15, show_xdecor_mailbox_inventory, {spos=spos, label=label_owner(meta, "Mailbox")})
	elseif name == "inbox:empty" then
		-- mod fixed upstream:
		-- https://github.com/bas080/inbox/commit/097aee659386224e15bc498b8f012057ccb136b8
		core.after(0.15, show_node_inventory, {spos=spos, label=label_owner(meta, "Inbox")})
	end

	return false

end)

minetest.display_chat_message("[CSM] loaded Chest Inspector")
