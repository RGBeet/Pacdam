return {
    data = {
        object_type = "Joker",
        key     = 'number_cruncher',
        atlas   = 'placeholder',
        pos     = MLIB.coords(0,0),
        rarity  = 1,
        cost    = 6,
        config =  {
            extra = { mult = 9, scored = false },
        },
        loc_vars = function(self, info_queue, card)
            local _rank = G.GAME.current_round
                and G.GAME.current_round.rgpd_number_cruncher
                and G.GAME.current_round.rgpd_number_cruncher.rank
                or '5'
            if type(_rank) == 'string' then
                return MadLib.collect_vars(localize(_rank, 'ranks'), number_format(card.ability.extra.mult))
            else
                return Madcap.BlankVar
            end
        end,
        calculate = function(self, card, context)
            if
                (context.individual
                and context.cardarea == G.play
                and MadLib.is_rank(context.other_card, SMODS.Ranks[G.GAME.current_round.rgpd_number_cruncher.rank].id))
                or context.forcetrigger
            then
                G.GAME.current_round.rgpd_number_cruncher.changed = false
                card.ability.extra.scored = true
                return { mult = card.ability.extra.mult }
            end

            if
                context.after
                and card.ability.extra.scored
                and not G.GAME.current_round.rgpd_number_cruncher.changed -- only switch it ONCE!
            then
                local data = G.GAME.current_round.rgpd_number_cruncher
                data.changed  = true
                data.index    = data.index + 1
                if data.index > #data.order then data.index = 1 end
                data.suit = data.order[data.index]
                card.ability.extra.scored = false
            end
        end,
        demicoloncompat = true,
    }
}
