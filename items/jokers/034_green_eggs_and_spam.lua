return {
    data = {
        object_type = "Joker",
        key     = 'green_eggs_and_spam',
        atlas   = 'placeholder',
        pos     = MLIB.coords(0,0),
        rarity  = Madcap and 'rgmc_gimmick' or 2, -- Gimmick if Madcap is installed.
        cost    = 5,
        config =  {
            extra = { x_pow = 2, odds = 2.846, x_money = 2, max_money = 37 },
        },
        loc_vars = function(self, info_queue, card)
            local _numer, _denom = SMODS.get_probability_vars(card, 1, card.ability.extra.odds, 'green_eggs_and_spam')
            return MadLib.collect_vars(number_format(card.ability.extra.x_pow),
                number_format(_numer*13),
                number_format(_denom*13),
                number_format(card.ability.extra.x_money),
                number_format(card.ability.extra.max_money))
        end,
        calculate = function(self, card, context)
            if context.joker_main or context.forcetrigger then
                return { x_pow   = lenient_bignum(card.ability.extra.x_pow) }
            end
        end,
    }
}
