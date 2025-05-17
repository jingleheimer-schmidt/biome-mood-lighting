
if settings.startup["biome-lighting-zombie-mode"].value == false then return end

for _, lamp in pairs(data.raw["lamp"]) do
    local created_effect = lamp.created_effect or {}
    created_effect.type = created_effect.type or "direct"
    created_effect.action_delivery = type(created_effect.action_delivery) == "table" and created_effect.action_delivery or {}
    local action_delivery = {}
    if created_effect.action_delivery.type then
        table.insert(action_delivery, created_effect.action_delivery)
    else
        for _, delivery in pairs(created_effect.action_delivery) do
            table.insert(action_delivery, delivery)
        end
    end
    local already_has_effect = false
    for _, delivery in ipairs(action_delivery) do
        if delivery.source_effects and delivery.source_effects.effect_id == "biome-color-lamp" then
            already_has_effect = true
            break
        end
    end
    if not already_has_effect then
        table.insert(action_delivery, {
            type = "instant",
            source_effects = {
                type = "script",
                effect_id = "biome-color-lamp"
            }
        })
    end
    created_effect.action_delivery = action_delivery
    lamp.created_effect = created_effect
end
