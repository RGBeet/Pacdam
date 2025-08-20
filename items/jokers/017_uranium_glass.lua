return {
    data = {
        object_type = "Joker",
        key     = 'uranium_glass',
        atlas   = 'jokers',
        pos     = MLIB.coords(0,9),
        rarity  = 2,
        cost    = 6,
        config  = { extra = { pow = 0.06 } },
        loc_vars = function(self, info_queue, card)
            info_queue[#info_queue + 1] = G.P_CENTERS.m_stone
            return MadLib.collect_vars(number_format(card.ability.extra.pow))
        end,
        calculate = function(self, card, context)
            if
                (context.individual
                and context.cardarea == G.hand
                and not context.end_of_round
                and not context.other_card.debuff
                and SMODS.has_enhancement(context.other_card, "m_stone"))
                or context.forcetrigger
            then
                return {
                    pow = card.ability.extra.pow,
                    card = context.other_card,
                    message = localize{"a_pow"}
                }
            end
        end,
        demicoloncompat = true,
    }
}
