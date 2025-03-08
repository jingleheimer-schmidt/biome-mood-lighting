
local entity = table.deepcopy(data.raw["constant-combinator"]["constant-combinator"])
entity.name = "biome-color-combinator"
entity.minable.result = "biome-color-combinator"
entity.created_effect = {
    type = "direct",
    action_delivery = {
        type = "instant",
        source_effects = {
            type = "script",
            effect_id = "biome-color-combinator"
        }
    }
}

local item = table.deepcopy(data.raw["item"]["constant-combinator"])
item.name = "biome-color-combinator"
item.place_result = "biome-color-combinator"
item.order = item.order .. "-[biome-color-combinator]"

local recipe = table.deepcopy(data.raw["recipe"]["constant-combinator"])
recipe.name = "biome-color-combinator"
recipe.results = {
    { type = "item", name = "biome-color-combinator", amount = 1 }
}

data:extend { entity, item, recipe }

for _, technology in pairs(data.raw["technology"]) do
    if technology.effects then
        for _, effect in pairs(technology.effects) do
            if effect.type == "unlock-recipe" and effect.recipe == "constant-combinator" then
                table.insert(technology.effects, { type = "unlock-recipe", recipe = "biome-color-combinator" })
            end
        end
    end
end
