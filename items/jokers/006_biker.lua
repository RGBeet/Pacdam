return {
    data = {
        object_type = "Joker",
        key     = 'biker',
        atlas   = 'jokers',
        pos     = MLIB.coords(1,6),
        rarity  = 2,
        cost    = 8,
        config  = { extra = { pow = 0.01, mult = 1 } },
        loc_vars = function(self, info_queue, card)
            return MadLib.collect_vars(number_format(card.ability.extra.pow), number_format(-card.ability.extra.mult))
        end,
        calculate = function(self, card, context)
            if (context.individual and context.cardarea == G.play) or (context.forcetrigger and context.scoring_hand) then
                local target = not context.forcetrigger and context.other_card or pseudorandom_element(context.scoring_hand,pseudoseed('biker'))
                if target then
                    target.ability.perma_pow    = target.ability.perma_pow or 0
                    target.ability.perma_mult   = target.ability.perma_mult or 0
                    target.ability.perma_pow    = target.ability.perma_pow + card.ability.extra.pow
                    target.ability.perma_mult   = target.ability.perma_mult - card.ability.extra.mult
                    return {
                        extra   = {message = localize('k_upgrade_ex'), colour = G.C.POW},
                        colour  = G.C.POW,
                        card    = card
                    }
                end
            end
        end,
        demicoloncompat = true,
    }
}
