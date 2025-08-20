return {
    data = {
        object_type = "Joker",
        key     = 'power_set',
        atlas   = 'jokers',
        pos     = MLIB.coords(0,4),
        rarity  = 2,
        cost    = 8,
        config =  { extra = { pow = 0.06 } },
        loc_vars = function(self, info_queue, card)
            return MadLib.collect_vars(number_format(card.ability.extra.pow))
        end,
        calculate = function(self, card, context)
            if
                (context.joker_main and next(context.poker_hands['Flush']))
                or context.forcetrigger
            then
                return MadLib.get_simple_score_data(MadLib.ScoreKeys.AddPow,card,card.ability.extra.pow)
            end
        end,
        demicoloncompat = true,
    }
}
