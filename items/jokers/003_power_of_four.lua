return {
    data = {
        object_type = "Joker",
        key     = 'power_of_four',
        atlas   = 'jokers',
        pos     = MLIB.coords(0,2),
        rarity  = 3,
        cost    = 10,
        config =  { extra = { pow = 0.12, poker_hand = 'Four of a Kind' } },
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
