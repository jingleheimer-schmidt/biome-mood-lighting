
---@param h number [0-1]
---@param s number [0-1]
---@param l number [0-1]
---@return number [0-1]
---@return number [0-1]
---@return number [0-1]
local function hsl_to_rgb(h, s, l)
    if s == 0 then return l, l, l end
    local function to(p, q, t)
        if t < 0 then t = t + 1 end
        if t > 1 then t = t - 1 end
        if t < 1 / 6 then return p + (q - p) * 6 * t end
        if t < 0.5 then return q end
        if t < 2 / 3 then return p + (q - p) * (2 / 3 - t) * 6 end
        return p
    end
    local q = l < 0.5 and l * (1 + s) or l + s - l * s
    local p = 2 * l - q
    return to(p, q, h + 1 / 3), to(p, q, h), to(p, q, h - 1 / 3)
end

---@param r number [0-1]
---@param g number [0-1]
---@param b number [0-1]
---@return number [0-1]
---@return number [0-1]
---@return number [0-1]
local function rgb_to_hsl(r, g, b)
    local max, min = math.max(r, g, b), math.min(r, g, b)
    local l = (max + min) / 2
    if max == min then return 0, 0, l end
    local d = max - min
    local s = l > 0.5 and d / (2 - max - min) or d / (max + min)
    local h
    if max == r then
        h = (g - b) / d + (g < b and 6 or 0)
    elseif max == g then
        h = (b - r) / d + 2
    else
        h = (r - g) / d + 4
    end
    return h / 6, s, l
end

---@param value number
---@param min number
---@param max number
---@return number
local function clamp(value, min, max)
    return math.max(math.min(value, max), min)
end

---@param color Color
---@return Color
local function normalize_color(color)
    local r, g, b = color.r / 255, color.g / 255, color.b / 255
    local h, s, l = rgb_to_hsl(r, g, b)
    local l_min, l_max, l_target = 0.33, 0.66, 0.5
    local s_min, s_max, s_target = 0.25, 0.75, 0.5
    local blend_factor = 0.4 -- how much to blend towards the target values
    l = clamp(l + (l_target - l) * blend_factor, l_min, l_max)
    s = clamp(s + (s_target - s) * blend_factor, s_min, s_max)
    local final_r, final_g, final_b = hsl_to_rgb(h, s, l)
    return { r = final_r * 255, g = final_g * 255, b = final_b * 255 }
end

---@param tiles LuaTile[]
---@return LuaTilePrototype
local function get_dominant_tile(tiles)
    local tile_counts = {}
    for _, tile in pairs(tiles) do
        if tile.valid then
            local tile_name = tile.double_hidden_tile or tile.hidden_tile or tile.name
            tile_counts[tile_name] = tile_counts[tile_name] or 0
            tile_counts[tile_name] = tile_counts[tile_name] + 1
        end
    end
    local dominant_tile_name, max_count = "", 0
    for tile_name, count in pairs(tile_counts) do
        if count > max_count then
            dominant_tile_name, max_count = tile_name, count
        end
    end
    return prototypes["tile"][dominant_tile_name]
end

---@param entity LuaEntity
---@return Color
local function get_biome_color(entity)
    local tiles = entity.surface.find_tiles_filtered { position = entity.position, radius = 2 }
    local dominant_tile = get_dominant_tile(tiles)
    if not dominant_tile then dominant_tile = entity.surface.get_tile(entity.position.x, entity.position.y).prototype end
    local map_color = dominant_tile.map_color
    local tile_color = { r = map_color.r, g = map_color.g, b = map_color.b }
    final_color = normalize_color(tile_color)
    return final_color
end

---@param combinator LuaEntity
local function set_biome_combinator_color_signals(combinator)
    local control_behavior = combinator.get_or_create_control_behavior() --[[@as LuaConstantCombinatorControlBehavior]]
    if not control_behavior then return end
    local biome_color_section = control_behavior.get_section(1)
    if not biome_color_section then return end
    local biome_color = get_biome_color(combinator)
    local function set_slot(index, signal_name, value)
        biome_color_section.set_slot(index, {
            value = {
                type = "virtual", name = signal_name, comparator = "=", quality = "normal"
            },
            min = value
        })
    end
    set_slot(1, "signal-red", biome_color.r)
    set_slot(2, "signal-green", biome_color.g)
    set_slot(3, "signal-blue", biome_color.b)
end

---@param event EventData.on_script_trigger_effect
local function on_script_trigger_event(event)
    local effect_id = event.effect_id
    if effect_id == "biome-color-combinator" then
        local combinator = event.source_entity
        if not (combinator and combinator.valid) then return end
        set_biome_combinator_color_signals(combinator)
    elseif effect_id == "biome-color-lamp" then
        local lamp = event.source_entity
        if not (lamp and lamp.valid) then return end
        local color = get_biome_color(lamp)
        lamp.color = color
    end
end

---@param event EventData.on_gui_opened
local function on_gui_opened(event)
    if event.gui_type ~= defines.gui_type.entity then return end
    local entity = event.entity
    if not (entity and entity.valid) then return end
    local entity_name = entity.name
    if entity.name == "biome-color-combinator" then
        set_biome_combinator_color_signals(entity)
    elseif entity_name == "biome-color-lamp" then
        local color = get_biome_color(entity)
        entity.color = color
    end
end

script.on_event(defines.events.on_script_trigger_effect, on_script_trigger_event)
script.on_event(defines.events.on_gui_opened, on_gui_opened)
