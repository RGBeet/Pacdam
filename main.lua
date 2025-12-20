
local files = {
    'pre',
    'atlas',
    'pow',
    'hooks',
    'misc_functions',
    'joker_display',
    'load_content'
}

for i=1,#files do
    assert(SMODS.load_file("lib/" .. files[i] .. ".lua"))()
end







