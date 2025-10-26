return {
    data = {
        object_type = "Joker",
        key     = 'bishop_twin',
        atlas   = 'placeholder',
        pos     = MLIB.coords(0,0),
        rarity  = 4,
        cost    = 5,
        config =  {
            immutable = { pair_list = {0,0,0} },
            extra = { pow = 0.08 },
        },
        loc_vars = function(self, info_queue, card)
            local pairs_made = 0
            MadLib.loop_func(card.ability.immutable.pair_list, function(v)
                pairs_made = pairs_made + v
            end)
            return MadLib.collect_vars(number_format(card.ability.extra.pow), number_format(pairs_made * card.ability.extra.pow))
        end,
        calculate = function(self, card, context)
            
        end,
    }
}
