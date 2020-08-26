local function replace_recipe_unlock(tech, old, new)
    if not data.raw.recipe[old] then
        log("Recipe " .. recipe .. " does not exist.")
    end
    bobmods.lib.tech.remove_recipe_unlock(tech, old)
    bobmods.lib.tech.add_recipe_unlock(tech, new)
end

-- define furnaces
furnaces = {"stone-furnace", "steel-furnace", "fluid-furnace", "electric-furnace", "electric-furnace-2", "electric-furnace-3"}
chem_furnaces = {"stone-chemical-furnace", "steel-chemical-furnace", "fluid-chemical-furnace", "chemical-furnace", "electric-stone-chemical-furnace", "electric-stone-chemical-furnace-2"}

for i = 1, #furnaces do
    if not data.raw["assembling-machine"][chem_furnaces[i]] then
        log("Unknown machine: "..chem_furnaces[i])
    else
      -- make chem furnaces multipurpose
      data.raw["assembling-machine"][chem_furnaces[i]].crafting_categories = {"smelting", "chemical-furnace", "mixing-furnace"}

      -- override icon, ShinyBobGFX may or may not use icons instead of icon, I
      -- don't actually know so I will replace both
      data.raw["item"][chem_furnaces[i]].icons = data.raw["item"][furnaces[i]].icons
      data.raw["item"][chem_furnaces[i]].icon = data.raw["item"][furnaces[i]].icon
      data.raw["item"][chem_furnaces[i]].icon_size = data.raw["item"][furnaces[i]].icon_size

      -- change health/appearance of chem furnaces to match regular furnaces. skip
      -- stone chem furnace, will be handled separately.
      data.raw["assembling-machine"][chem_furnaces[i]].health = data.raw["furnace"][furnaces[i]].icon
      if i ~= 1 then
          data.raw["assembling-machine"][chem_furnaces[i]].animation = data.raw["furnace"][furnaces[i]].animation
          data.raw["assembling-machine"][chem_furnaces[i]].working_visualisations = data.raw["furnace"][furnaces[i]].working_visualisations
      end
  end
end

-- manually change stone chemical furnace to look like stone furnace with fluid
-- slot
for _, dir in pairs({"north", "south", "east", "west"}) do
    data.raw["assembling-machine"]["stone-chemical-furnace"].animation[dir].filename = "__Bob_Furnaces_Multipurpose__/graphics/entity/stone-chemical-furnace.png"
end

-- change chem furnace recipe to be stone furnace recipe
data.raw.recipe["stone-chemical-furnace"].ingredients = {
    {"stone", 5}
}

-- replace tech unlocks with chem furnaces
furnace_techs = {nil, "advanced-material-processing", "fluid-furnace", "advanced-material-processing-2", "advanced-material-processing-3", "advanced-material-processing-4"}
for i = 2, #furnaces do
    replace_recipe_unlock(furnace_techs[i], furnaces[i], chem_furnaces[i])
end

-- replace stone furnace with chem furnace
bobmods.lib.recipe.enabled("stone-furnace", false)
bobmods.lib.recipe.enabled("stone-chemical-furnace", true)

-- disable metal mixing furnaces
bobmods.lib.tech.remove_recipe_unlock("alloy-processing-1", "mixing-furnace")
data.raw.technology["electric-mixing-furnace"].enabled = false
if mods["MoreScience-BobAngelsExtension"] then
    -- more science adds dependencies to these techs
    for _, tech in pairs(data.raw.technology) do
        if tech.prerequisites then
            bobmods.lib.tech.replace_prerequisite(tech.name, "alloy-processing-1", "advanced-material-processing")
            bobmods.lib.tech.replace_prerequisite(tech.name, "electric-mixing-furnace", "advanced-material-processing-2")
        end
    end
end

data.raw.technology["steel-mixing-furnace"].enabled = false
data.raw.technology["fluid-mixing-furnace"].enabled = false

-- disable chem furnaces
if mods["angelspetrochem"] then
    -- Angel's petrochem removes all recipes but the furnaces from these techs,
    -- so remove them completely
    data.raw.technology["chemical-processing-1"].enabled = false
    data.raw.technology["chemical-processing-2"].enabled = false
    bobmods.lib.tech.add_recipe_unlock("basic-chemistry-2", "calcium-chloride")

    -- if momotweak is present, it adds unlocks to alloy processing 2 and chemical processing 1
    if mods["MomoTweak"] then
        bobmods.lib.tech.add_recipe_unlock("water-washing-1", "momo-glass-N1")
        bobmods.lib.tech.add_recipe_unlock("advanced-material-processing", "momo-bronze-pack-N1")
        -- remove mixing furnace unlock
        bobmods.lib.tech.remove_recipe_unlock("optics", "mixing-furnace")
    end

    for _, tech in pairs(data.raw.technology) do
        if tech.prerequisites then
            bobmods.lib.tech.remove_prerequisite(tech.name, "chemical-processing-1")
            bobmods.lib.tech.replace_prerequisite(tech.name, "chemical-processing-2", "chemical-plant")
        end
    end
else
    -- otherwise, just remove chem furnaces from these techs
    bobmods.lib.tech.remove_recipe_unlock("chemical-processing-1", "stone-chemical-furnace")
    bobmods.lib.tech.remove_recipe_unlock("chemical-processing-2", "steel-chemical-furnace")
end
data.raw.technology["electric-chemical-furnace"].enabled = false

-- disable multi purpose furnaces
data.raw.technology["multi-purpose-furnace-1"].enabled = false
data.raw.technology["multi-purpose-furnace-2"].enabled = false

-- fix recipes that use furnaces
bobmods.lib.recipe.replace_ingredient_in_all("stone-furnace", "stone-chemical-furnace")
bobmods.lib.recipe.replace_ingredient_in_all("mixing-furnace", "stone-chemical-furnace")
bobmods.lib.recipe.replace_ingredient_in_all("steel-furnace", "steel-chemical-furnace")
bobmods.lib.recipe.replace_ingredient_in_all("steel-mixing-furnace", "steel-chemical-furnace")
bobmods.lib.recipe.replace_ingredient_in_all("electric-furnace", "electric-chemical-furnace")
bobmods.lib.recipe.replace_ingredient_in_all("electric-mixing-furnace", "electric-chemical-mixing-furnace")
bobmods.lib.recipe.replace_ingredient_in_all("fluid-furnace", "fluid-steel-furnace")
bobmods.lib.recipe.replace_ingredient_in_all("fluid-mixing-furnace", "stone-chemical-furnace")
