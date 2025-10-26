return {
    data = {
        object_type = "Joker",
        key     = 'gokusen',
        atlas   = 'placeholder',
        pos     = MLIB.coords(0,0),
        rarity  = 1,
        cost    = 5,
        config = {
            extra = { pow = 0.25, money_mod = 5 },
        },
        yes_pool_flag = "gros_michel_extinct",
        loc_vars = function(self, info_queue, card)
            return MadLib.collect_vars(
                    number_format(card.ability.extra.pow),
                    number_format(math.abs(card.ability.extra.money_mod))
            )
        end,
        calculate = function(self, card, context)
            if context.joker_main then
                return {
                    pow = card.ability.extra.pow
                }
            end
        end,
        calc_dollar_bonus = function(self, card)
            return lenient_bignum(-card.ability.extra.money_mod)
        end,
    }
}
