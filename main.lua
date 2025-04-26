G.C.FISH = HEX("308fe3")
G.C.TETHERED = HEX('248571')

SMODS.Atlas{
    key = "Jokers",
    path = "Jokers.png",
    px = 71,
    py = 95
}

SMODS.Atlas{
    key = "Extras",
    path = "Extras.png",
    px = 71,
    py = 95
}

local function requireFolder(path)
    local files = NFS.getDirectoryItemsInfo(SMODS.current_mod.path .. "/" .. path)
    for i = 1, #files do
        local file_name = files[i].name
        if file_name:sub(-4) == ".lua" then
            assert(SMODS.load_file(path .. file_name))()
        end
    end
end

requireFolder("jokers/")