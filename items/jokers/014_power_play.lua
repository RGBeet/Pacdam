return {
    data = {
        object_type = "Joker",
        key     = 'power_play',
        atlas   = 'jokers',
        pos     = MLIB.coords(1,1),
        rarity  = 2,
        cost    = 7,
        config =  { extra = { pow = 0.05 } },
        loc_vars = function(self, info_queue, card)
            return MadLib.collect_vars(number_format(card.ability.extra.pow))
        end,
        calculate = function(self, card, context)
            if
                (context.joker_main
                and context.cardarea == G.jokers )
                or context.forcetrigger
            then
                local valid = true
                if not context.forcetrigger then
                    local sum = 0
                    MadLib.loop_func(G.play.cards, function(v)
                        sum = sum + (not SMODS.has_no_rank(v) and (sum + v.base.nominal) or 0)
                    end)
                    valid = (sum == 21)
                end
                if valid then
                    return MadLib.get_simple_score_data(MadLib.ScoreKeys.AddPow,card,card.ability.extra.pow)
                end
            end
        end,
        demicoloncompat = true,
    }
}
