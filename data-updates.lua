
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
