return {
    data = {
        object_type = "Joker",
        key     = 'power_of_two',
        atlas   = 'jokers',
        pos     = MLIB.coords(0,0),
        rarity  = 2,
        cost    = 7,
        config =  { extra = { pow = 0.05, poker_hand = 'Pair'  } },
        loc_vars = function(self, info_queue, card)
            return MadLib.collect_vars(number_format(card.ability.extra.pow))
        end,
        calculate = function(self, card, context)
            if
                (context.joker_main and next(context.poker_hands[card.ability.extra.poker_hand]))
                or context.forcetrigger
            then
                return { pow = card.ability.extra.pow }
            end
        end,
        demicoloncompat = true,
    }
}
