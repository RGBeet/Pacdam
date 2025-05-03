SMODS.Joker{
    key = "Uranium",
    rarity = 2,
    atlas = "Jokers",
    pos = {x = 4, y = 0},
    cost = 6,
    config = { extra = { pow = 0.1 } },

    loc_vars = function(self, info_queue, card)
        return {
            vars = { card.ability.extra.pow }
        }
    end,

    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play and SMODS.has_enhancement(context.other_card, 'm_stone') then
            return {
                pow = card.ability.extra.pow
            }
        end
    end,
}