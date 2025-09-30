return {
    data = {
        object_type = "Joker",
        key     = 'power_of_three',
        atlas   = 'jokers',
        pos     = MLIB.coords(0,1),
        rarity  = 2,
        cost    = 7,
        config =  { extra = { pow = 0.08 } },
        loc_vars = function(self, info_queue, card)
            return MadLib.collect_vars(number_format(card.ability.extra.pow))
        end,
        calculate = function(self, card, context)
            if
                (context.joker_main and next(context.poker_hands['Three of a Kind']))
                or context.forcetrigger
            then
                return { pow = card.ability.extra.pow }
            end
        end,
        demicoloncompat = true,
    }
}
