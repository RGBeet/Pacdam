SMODS.Joker{
    key = "PowFrog",
    rarity = 3,
    atlas = "Jokers",
    pos = {x = 2, y = 0},
    cost = 8,
    config = { extra = { pow = 1 } },

    loc_vars = function(self, info_queue, card)
        return {
            vars = { card.ability.extra.pow }
        }
    end,

    calculate = function(self, card, context)
        if not context.blueprint and context.joker_main then
            return {
                pow = 1
            }
        end
    end,

    
}