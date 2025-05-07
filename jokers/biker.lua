SMODS.Joker{
    key = "Biker",
    rarity = 2,
    atlas = "Jokers",
    pos = {x = 6, y = 1},
    cost = 6,
    config = { extra = { pow = 0.01, mult = 1 } },

    loc_vars = function(self, info_queue, card)
        return {
            vars = { card.ability.extra.pow, card.ability.extra.mult }
        }
    end,

    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play then
            context.other_card.ability.perma_pow = context.other_card.ability.perma_pow or 0
            context.other_card.ability.perma_mult = context.other_card.ability.perma_mult or 0
            context.other_card.ability.perma_pow = context.other_card.ability.perma_pow + card.ability.extra.pow
            context.other_card.ability.perma_mult = context.other_card.ability.perma_mult - card.ability.extra.mult
            return {
                extra = {message = localize('k_upgrade_ex'), colour = G.C.GREEN},
                colour = G.C.GREEN,
                card = card
            }
        end
    end,
}