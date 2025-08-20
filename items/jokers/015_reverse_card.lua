return {
    data = {
        object_type = "Joker",
        key     = 'reverse_card',
        atlas   = 'jokers',
        pos     = MLIB.coords(1,0),
        rarity  = 2,
        cost    = 5,
        calculate = function(self, card, context)
            if context.joker_main or context.forcetrigger then
                return {
                    swap    = true,
                    message = "Reversed!",
                    colour  = G.C.attention,
                    card    = card,
                }
            end
        end,
        demicoloncompat = true,
    }
}
