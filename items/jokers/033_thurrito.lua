return {
    data = {
        object_type = "Joker",
        key     = 'thurrito',
        atlas   = 'placeholder',
        pos     = MLIB.coords(0,0),
        rarity  = 1,
        cost    = 5,
        config = {
            extra = { x_mult = 0.6, x_chips = 0.4, pow = 0.4, rounds_remaining = 8 },
            immutable = { max_rounds = 8 }
        },
        loc_vars = function(self, info_queue, card)
            return MadLib.collect_vars_colours(
                number_format(card.ability.extra.x_mult),
                number_format(card.ability.extra.x_chips),
                number_format(card.ability.extra.rounds_remaining),
                { MadLib.get_warning_colour(card.ability.extra.rounds_remaining / card.ability.immutable.max_rounds) })
        end,
        calculate = function(self, card, context)
            if 
                context.joker_main 
                or context.forcetrigger 
            then  
                return {
                    xchips  = card.ability.extra.x_chips,
                    xmult   = card.ability.extra.x_mult,
                    pow     = card.ability.extra.pow
                }
            end
        end,
    }
}
