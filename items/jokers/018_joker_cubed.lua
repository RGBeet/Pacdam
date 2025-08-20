return {
    data = {
        object_type = "Joker",
        key     = 'joker_cubed',
        atlas   = 'jokers',
        pos     = MLIB.coords(2,0),
        rarity  = 1,
        cost    = 4,
        config  = { extra = { pow = 0.04 } },
        loc_vars = function(self, info_queue, card)
            return MadLib.collect_vars(number_format(card.ability.extra.pow))
        end,
        calculate = function(self, card, context)
            if (context.cardarea == G.play and context.other_card) or context.forcetrigger then
                local matches = MadLib.list_matches_one(MadLib.RankTypes['Square'], function(c)
                    return c == tostring(context.other_card:get_id())
                end)
                if matches then return MadLib.get_simple_score_data(MadLib.ScoreKeys.AddPow,card,card.ability.extra.pow) end
            end
        end,
        demicoloncompat = true,
    }
}
