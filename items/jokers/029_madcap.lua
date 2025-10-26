return {
    data = {
        object_type = "Joker",
        key     = 'madcap',
        atlas   = 'placeholder',
        pos     = MLIB.coords(0,0),
        rarity  = 3,
        cost    = 10,
        config =  {
            extra = { h_size = 2, pow = 0.25},
        },
        loc_vars = function(self, info_queue, card)
            return MadLib.collect_vars(number_format(card.ability.extra.pow), number_format(card.ability.extra.h_size))
        end,
        calculate = function(self, card, context)
            if context.joker_main then
                return {
                    pow = card.ability.extra.pow
                }
            end
        end,
        add_to_deck = function(self, card, from_debuff)
            G.hand:change_size(-card.ability.extra.h_size)
        end,
        remove_from_deck = function(self, card, from_debuff)
            G.hand:change_size(card.ability.extra.h_size)
        end,
    }
}
