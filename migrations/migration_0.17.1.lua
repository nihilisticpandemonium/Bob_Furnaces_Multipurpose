for _, force in pairs(game.forces) do
    techs_to_unresearch = {
        "alloy-processing-2",
        "mixing-steel-furnace",
        "oil-mixing-steel-furnace",
        "oil-chemical-steel-furnace",
        "chemical-processing-3",
        "multi-purpose-furnace-1",
        "multi-purpose-furnace-2",
    }

    conditional_techs_to_unresearch = {
        "chemical-processing-1",
        "chemical-processing-2",
    }

    for _, tech in pairs(conditional_techs_to_unresearch) do
        if force.technologies[tech].enabled then
            table.insert(techs_to_unresearch, tech)
        end
    end

    for _, tech in pairs(techs_to_unresearch) do
        force.technologies[tech].researched = false
    end
end