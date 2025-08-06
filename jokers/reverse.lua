SMODS.Joker{
    key = "reverse_card",
    rarity = 1,
    atlas = "Jokers",
    pos = {x = 0, y = 1},
    cost = 4,
    blueprint_compat = true,

    calculate = function(self, card, context)
        if context.joker_main then
            return { 
                swap = true,
                message = "Reversed!", 
                colour = G.C.attention
            }
        end
    end
}