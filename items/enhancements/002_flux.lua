return {
    categories = {
        'Enhancements',
    },
    data = {
        object_type = "Enhancement",
        key     = 'flux',
        atlas   = 'enhancements',
        pos     = MLIB.coords(0,1),
        config  = { extra = { pow = 0.10, odds = 12 } },
        loc_vars = function(self, info_queue, card)
            local _numer, _denom = SMODS.get_probability_vars(card, 1, card.ability.extra.odds, 'flux')
            return MadLib.collect_vars(number_format(card.ability.extra.pow), number_format(_numer), number_format(_denom))
        end,
        calculate = function(self, card, context)
            if context.destroy_card and context.cardarea == G.hand and context.destroy_card == card and
                SMODS.pseudorandom_probability(card, 'flux', 1, card.ability.extra.odds) then
                card.glass_trigger = true -- SMODS addition
                return { remove = true }
            end

            if context.main_scoring and context.cardarea == G.hand then
                return {
                    pow     = card.ability.extra.pow,
                    card    = card
                }
            end
        end,
    }
}
