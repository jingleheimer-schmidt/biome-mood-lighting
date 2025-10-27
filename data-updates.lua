
---@alias Corner
---| "bottom-left"
---| "bottom-right"
---| "top-left"
---| "top-right"

--- Adds an overlay sprite to an item prototype.
--- Mutates and returns the item.
---@param item data.ItemPrototype|data.EntityPrototype
---@param sprite data.Sprite                # The sprite to use as overlay
---@param corner? Corner                    # Which corner to place overlay (default: "top-right")
---@param inset_fraction? number            # Fraction of icon size to inset (default: 1/8)
---@param inset_px? number                  # Explicit inset in pixels (overrides inset_fraction)
---@param scale_divisor? number             # Divisor for overlay sprite scale (default: 5)
---@return data.ItemPrototype|data.EntityPrototype
local function add_overlay_to_icon(item, sprite, corner, inset_fraction, inset_px, scale_divisor)

    -- base icon size
    local base_icon_size = item.icon_size
    if not base_icon_size and item.icons and item.icons[1] then
        base_icon_size = item.icons[1].icon_size
    end
    base_icon_size = base_icon_size or 64

    -- corner selection
    local c = corner or "top-right"
    local corner_mul = {
        ["bottom-left"]  = { -1, 1 },
        ["bottom-right"] = { 1, 1 },
        ["top-left"]     = { -1, -1 },
        ["top-right"]    = { 1, -1 },
    }
    local mul = corner_mul[c] or corner_mul["top-right"]

    -- inset
    local px = inset_px
    if not px then
        local frac = inset_fraction or (1 / 8)
        px = base_icon_size * frac
    end

    -- overlay scale
    local divisor = scale_divisor or 5
    local overlay_scale = (sprite.scale or 1) / divisor
    local overlay_icon_size
    if sprite.width and sprite.height then
        overlay_icon_size = math.max(sprite.width, sprite.height)
    elseif sprite.size then
        ---@type number
        overlay_icon_size = type(sprite.size) == "number" and sprite.size or math.max(sprite.size[1], sprite.size[2])
    else
        overlay_icon_size = base_icon_size
    end

    ---@type data.IconData overlay definition
    local overlay = {
        icon      = sprite.filename,
        icon_size = overlay_icon_size,
        scale     = overlay_scale,
        floating  = true,
        shift     = { mul[1] * px, mul[2] * px },
    }

    -- convert single icon → icons[] if necessary
    if item.icon then
        item.icons = { { icon = item.icon, icon_size = base_icon_size } }
        item.icon = nil
        item.icon_size = nil
    end
    item.icons = item.icons or {}
    table.insert(item.icons, overlay)

    return item
end
local tile_editor_icon = table.deepcopy(data.raw["utility-sprites"]["default"]["tile_editor_icon"])
local color_effect_icon = table.deepcopy(data.raw["utility-sprites"]["default"]["color_effect"])

local biome_combinator_entity = table.deepcopy(data.raw["constant-combinator"]["constant-combinator"])
biome_combinator_entity.name = "biome-color-combinator"
biome_combinator_entity.minable.result = "biome-color-combinator"
biome_combinator_entity.created_effect = {
    type = "direct",
    action_delivery = {
        type = "instant",
        source_effects = {
            type = "script",
            effect_id = "biome-color-combinator"
        }
    }
}

local biome_combinator_item = table.deepcopy(data.raw["item"]["constant-combinator"])
biome_combinator_item.name = "biome-color-combinator"
biome_combinator_item.place_result = "biome-color-combinator"
biome_combinator_item.order = biome_combinator_item.order .. "-[biome-color-combinator]"

add_overlay_to_icon(biome_combinator_entity, tile_editor_icon)
add_overlay_to_icon(biome_combinator_item, tile_editor_icon)

local biome_combinator_recipe = table.deepcopy(data.raw["recipe"]["constant-combinator"])
biome_combinator_recipe.name = "biome-color-combinator"
biome_combinator_recipe.results = { { type = "item", name = "biome-color-combinator", amount = 1 } }
biome_combinator_recipe.hidden = settings.startup["biome-lighting-hide-combinator"].value == true

data:extend { biome_combinator_entity, biome_combinator_item, biome_combinator_recipe }

local biome_lamp_entity = table.deepcopy(data.raw["lamp"]["small-lamp"])
biome_lamp_entity.name = "biome-color-lamp"
biome_lamp_entity.minable.result = "biome-color-lamp"
biome_lamp_entity.created_effect = {
    type = "direct",
    action_delivery = {
        type = "instant",
        source_effects = {
            type = "script",
            effect_id = "biome-color-lamp"
        }
    }
}

local biome_lamp_item = table.deepcopy(data.raw["item"]["small-lamp"])
biome_lamp_item.name = "biome-color-lamp"
biome_lamp_item.place_result = "biome-color-lamp"
biome_lamp_item.order = biome_lamp_item.order .. "-[biome-color-lamp]"

add_overlay_to_icon(biome_lamp_entity, tile_editor_icon)
add_overlay_to_icon(biome_lamp_item, tile_editor_icon)

local biome_lamp_recipe = table.deepcopy(data.raw["recipe"]["small-lamp"])
biome_lamp_recipe.name = "biome-color-lamp"
biome_lamp_recipe.results = { { type = "item", name = "biome-color-lamp", amount = 1 } }
biome_lamp_recipe.hidden = settings.startup["biome-lighting-hide-lamp"].value == true

data:extend { biome_lamp_entity, biome_lamp_item, biome_lamp_recipe }

for _, technology in pairs(data.raw["technology"]) do
    if technology.effects then
        for _, effect in pairs(technology.effects) do
            if effect.type == "unlock-recipe" and effect.recipe == "constant-combinator" then
                table.insert(technology.effects, { type = "unlock-recipe", recipe = "biome-color-combinator" })
            end
            if effect.type == "unlock-recipe" and effect.recipe == "small-lamp" then
                table.insert(technology.effects, { type = "unlock-recipe", recipe = "biome-color-lamp" })
            end
        end
    end
end
