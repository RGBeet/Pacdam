return {
    data = {
        object_type = "Joker",
        key     = 'erythrite',
        atlas   = 'placeholder',
        pos     = MLIB.coords(0,0),
        rarity  = 1,
        cost    = 5,
        config =  {
            active = false,
            extra = { mult = 6, chips = 30, suits = { "Diamonds", "Clubs", "Spades" } }
        },
        loc_vars = function(self, info_queue, card)
            local _numer, _denom = SMODS.get_probability_vars(card, 1, card.ability.extra.odds, 'erythrite')
            return MadLib.collect_vars_colours(
                localize(card.ability.extra.suits[1], 'suits_plural'),
                localize(card.ability.extra.suits[2], 'suits_plural'),
                localize(card.ability.extra.suits[3], 'suits_plural'),
                number_format(card.ability.extra.mult),
                number_format(card.ability.extra.chips),
                number_format(_numer),
                number_format(_denom),
            {
                G.C.SUITS[card.ability.extra.suits[1]],
                G.C.SUITS[card.ability.extra.suits[2]],
                G.C.SUITS[card.ability.extra.suits[3]]
            })
        end,
        calculate = function(self, card, context)
            
        end,
    }
}
