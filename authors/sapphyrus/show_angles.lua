--local variables for API. Automatically generated by https://github.com/simpleavaster/gslua/blob/master/authors/sapphyrus/generate_api.lua 
local client_latency, client_log, client_draw_rectangle, client_draw_circle_outline, client_userid_to_entindex, client_draw_gradient, client_set_event_callback, client_screen_size, client_draw_text, client_visible = client.latency, client.log, client.draw_rectangle, client.draw_circle_outline, client.userid_to_entindex, client.draw_gradient, client.set_event_callback, client.screen_size, client.draw_text, client.visible 
local client_visible, client_exec, client_draw_circle, client_delay_call, client_world_to_screen, client_draw_hitboxes, client_get_cvar, client_draw_line, client_camera_angles, client_draw_debug_text, client_random_int, client_random_float = client.visible, client.exec, client.draw_circle, client.delay_call, client.world_to_screen, client.draw_hitboxes, client.get_cvar, client.draw_line, client.camera_angles, client.draw_debug_text, client.random_int, client.random_float 
local entity_get_local_player, entity_is_enemy, entity_get_player_name, entity_get_all, entity_set_prop, entity_get_player_weapon, entity_hitbox_position, entity_get_prop, entity_get_players, entity_get_classname = entity.get_local_player, entity.is_enemy, entity.get_player_name, entity.get_all, entity.set_prop, entity.get_player_weapon, entity.hitbox_position, entity.get_prop, entity.get_players, entity.get_classname 
local globals_mapname, globals_tickcount, globals_realtime, globals_absoluteframetime, globals_tickinterval, globals_curtime, globals_frametime, globals_maxplayers = globals.mapname, globals.tickcount, globals.realtime, globals.absoluteframetime, globals.tickinterval, globals.curtime, globals.frametime, globals.maxplayers 
local ui_new_slider, ui_new_combobox, ui_reference, ui_set_visible, ui_set_callback, ui_set, ui_new_checkbox, ui_new_hotkey, ui_new_button, ui_new_multiselect, ui_get = ui.new_slider, ui.new_combobox, ui.reference, ui.set_visible, ui.set_callback, ui.set, ui.new_checkbox, ui.new_hotkey, ui.new_button, ui.new_multiselect, ui.get 
--end of local variables 

local show_angles_reference = ui.new_multiselect("VISUALS", "Other ESP", "Show Anti-aimbot angles", "Real", "Fake", "LBY", "Camera")

local boxSize = 30
local length = 40

local Math = require "math"
local math_floor = Math.floor

local fake_r, fake_g, fake_b, fake_a = 28, 132, 255, 255
local lby_r, lby_g, lby_b, lby_a = 255, 0, 0, 255
local camera_r, camera_g, camera_b, camera_a = 255, 255, 255, 255

local function contains(table, val)
	for i=1,#table do
		if table[i] == val then 
			return true
		end
	end
	return false
end

local function on_paint(ctx)
	local value = ui_get(show_angles_reference)

	if value == {} then
		return
	end

	local locationX, locationY, locationZ = entity_get_prop(entity_get_local_player(), "m_vecOrigin")

	if locationX then

		local worldX, worldY = client_world_to_screen(ctx, locationX, locationY, locationZ)

		if worldX == nil or worldY == nil then return end

		if contains(value, "Fake") then
			local _, fakeYaw, _ = entity_get_prop(entity_get_local_player(), "m_angEyeAngles")
			locationXFake = locationX + cos(math.rad(fakeYaw)) * length
			locationYFake = locationY + sin(math.rad(fakeYaw)) * length
			locationXFakeText = locationX + cos(math.rad(fakeYaw)) * length+1
			locationYFakeText = locationY + sin(math.rad(fakeYaw)) * length+1

			local worldXFake, worldYFake = client_world_to_screen(ctx, locationXFake, locationYFake, locationZ)
			local worldXFakeText, worldYFakeText = client_world_to_screen(ctx, locationXFake, locationYFake, locationZ)

			if worldXFake ~= nil then
				client_draw_line(ctx, worldX, worldY, worldXFake, worldYFake, fake_r, fake_g, fake_b, fake_a)
				client_draw_text(ctx, worldXFakeText, worldYFakeText, fake_r, fake_g, fake_b, fake_a, "c-", 0, "FAKE")
			end
		end

		if contains(value, "LBY") then
			local lbyYaw = entity_get_prop(entity_get_local_player(), "m_flLowerBodyYawTarget")
			locationXLBY = locationX + cos(math.rad(lbyYaw)) * length-2
			locationYLBY = locationY + sin(math.rad(lbyYaw)) * length-2
			locationXLBYText = locationX + cos(math.rad(lbyYaw)) * length-2+1
			locationYLBYText = locationY + sin(math.rad(lbyYaw)) * length-2+1

			local worldXLBY, worldYLBY = client_world_to_screen(ctx, locationXLBY, locationYLBY, locationZ)
			local worldXLBYText, worldYLBYText = client_world_to_screen(ctx, locationXLBYText, locationYLBYText, locationZ)

			if worldXLBY ~= nil then
				client_draw_line(ctx, worldX, worldY, worldXLBY, worldYLBY, lby_r, lby_g, lby_b, lby_a)
				client_draw_text(ctx, worldXLBYText, worldYLBYText, lby_r, lby_g, lby_b, lby_a, "c-", 0, "LBY")
			end
		end

		if contains(value, "Camera") then
			local _, cameraYaw = client_camera_angles()
			locationXCamera = locationX + cos(math.rad(cameraYaw)) * length-2
			locationYCamera = locationY + sin(math.rad(cameraYaw)) * length-2
			locationXCameraText = locationX + cos(math.rad(cameraYaw)) * length-2+1
			locationYCameraText = locationY + sin(math.rad(cameraYaw)) * length-2+1

			local worldXCamera, worldYCamera = client_world_to_screen(ctx, locationXCamera, locationYCamera, locationZ)
			local worldXCameraText, worldYCameraText = client_world_to_screen(ctx, locationXCameraText, locationYCameraText, locationZ)

			if worldXCamera ~= nil then
				client_draw_line(ctx, worldX, worldY, worldXCamera, worldYCamera, camera_r, camera_g, camera_b, camera_a)
				client_draw_text(ctx, worldXCameraText, worldYCameraText, camera_r, camera_g, camera_b, camera_a, "c-", 0, "CAM")
			end
		end



	end
end

client.set_event_callback("paint", on_paint)