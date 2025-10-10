
---@class OverlayOpts
---@field corner?        "bottom-left"|"bottom-right"|"top-left"|"top-right"  -- Which corner to place overlay (default: "bottom-left")
---@field inset_fraction? number  -- Fraction of the icon size to inset the overlay (default: 1/6)
---@field inset_px?       number  -- Explicit inset in pixels (overrides inset_fraction if set)
---@field scale_divisor?  number  -- Divisor for scaling the overlay sprite relative to its base scale (default: 4)
---@field sprite?         data.Sprite   -- A utility-sprite-like table with filename/width/height/scale

--- Adds an overlay sprite to an item prototype (icons[]), defaulting to bottom-left.
--- Mutates and returns the item.
--- @param item table   -- Item prototype (e.g. data.raw.item["foo"])
--- @param opts OverlayOpts? -- Options to control placement and appearance
--- @return table       -- The modified item prototype
local function add_overlay_to_item(item, opts)
    opts = opts or {}

    -- pick the overlay sprite (defaults to the tile editor icon)
    local util = data.raw["utility-sprites"] and data.raw["utility-sprites"]["default"] or nil
    local sprite = opts.sprite or (util and util.tile_editor_icon)
    if not sprite then return item end

    -- base icon size
    local base_icon_size = item.icon_size
    if not base_icon_size and item.icons and item.icons[1] then
        base_icon_size = item.icons[1].icon_size
    end
    base_icon_size = base_icon_size or 64

    -- corner selection
    local corner = (opts.corner or "top-right")
    local corner_mul = {
        ["bottom-left"]  = { -1, 1 },
        ["bottom-right"] = { 1, 1 },
        ["top-left"]     = { -1, -1 },
        ["top-right"]    = { 1, -1 },
    }
    local mul = corner_mul[corner] or corner_mul["bottom-left"]

    -- how far to shift
    local inset_px = opts.inset_px
    if not inset_px then
        local inset_fraction = opts.inset_fraction or (1 / 6)
        inset_px = base_icon_size * inset_fraction
    end

    -- overlay scale
    local scale_divisor = opts.scale_divisor or 4
    local overlay_scale = (sprite.scale or 1) / scale_divisor

    local overlay_icon_size = math.max(sprite.width or base_icon_size, sprite.height or base_icon_size)

    local overlay = {
        icon      = sprite.filename,
        icon_size = overlay_icon_size,
        scale     = overlay_scale,
        floating  = true,
        shift     = { x = mul[1] * inset_px, y = mul[2] * inset_px },
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
-- add_overlay_to_item(biome_combinator_item, { sprite = data.raw["utility-sprites"]["default"]["color_effect"] })
add_overlay_to_item(biome_combinator_item, { sprite = data.raw["utility-sprites"]["default"]["tile_editor_icon"] })

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
-- add_overlay_to_item(biome_lamp_item, { sprite = data.raw["utility-sprites"]["default"]["color_effect"] })
add_overlay_to_item(biome_lamp_item, { sprite = data.raw["utility-sprites"]["default"]["tile_editor_icon"] })


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
