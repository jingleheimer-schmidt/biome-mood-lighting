
---@type data.ModBoolSettingPrototype
local zombie_mode = {
    type = "bool-setting",
    setting_type = "startup",
    name = "biome-lighting-zombie-mode",
    default_value = false,
    order = "a",
}

---@type data.ModBoolSettingPrototype
local hide_lamp = {
    type = "bool-setting",
    setting_type = "startup",
    name = "biome-lighting-hide-lamp",
    default_value = false,
    order = "b",
}

---@type data.ModBoolSettingPrototype
local hide_combinator = {
    type = "bool-setting",
    setting_type = "startup",
    name = "biome-lighting-hide-combinator",
    default_value = false,
    order = "c",
}

data:extend { zombie_mode, hide_lamp, hide_combinator }
