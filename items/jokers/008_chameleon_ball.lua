return {
    data = {
        object_type = "Joker",
        key     = 'broker',
        atlas   = 'jokers',
        pos     = MLIB.coords(1,7),
        rarity  = 3,
        cost    = 7,
        config  = { extra = { pow = 0.08 } },
        loc_vars = function(self, info_queue, card)
            info_queue[#info_queue + 1] = G.P_CENTERS.m_wild
            return MadLib.collect_vars(number_format(card.ability.extra.pow))
        end,
        calculate = function(self, card, context)
            if
                (context.individual
                and context.cardarea == G.hand
                and not context.end_of_round
                and not context.other_card.debuff
                and SMODS.has_enhancement(context.other_card, "m_wild"))
                or context.forcetrigger
            then
                return { pow = card.ability.extra.pow }
            end
        end,
        demicoloncompat = true,
    }
}
