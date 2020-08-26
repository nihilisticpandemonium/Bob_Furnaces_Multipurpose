script.on_init(function()
    local created_items = remote.call("freeplay", "get_created_items")
    created_items["stone-furnace"] = nil
    created_items["stone-chemical-furnace"] = 1
    remote.call("freeplay", "set_created_items", created_items)
end)
