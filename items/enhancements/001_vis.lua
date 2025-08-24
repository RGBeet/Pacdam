return {
    categories = {
        'Enhancements',
    },
    data = {
        object_type = "Enhancement",
        key     = 'vis',
        atlas   = 'enhancements',
        pos     = MLIB.coords(0,0),
        config  = { extra = { pow = 0.05 }, immutable = { mult = 1 } },
        loc_vars = function(self, info_queue, card)
            return MadLib.collect_vars(number_format(card.ability.extra.pow), number_format(card.ability.immutable.mult))
        end,
        calculate = function(self, card, context)
            if context.cardarea == G.play and context.main_scoring then
                return {
                    pow     = card.ability.extra.pow,
                    mult    = -card.ability.immutable.mult,
                    card    = card
                }
            end
        end,
    }
}
