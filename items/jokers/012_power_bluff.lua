return {
    data = {
        object_type = "Joker",
        key     = 'power_bluff',
        atlas   = 'jokers',
        pos     = MLIB.coords(1,5),
        rarity  = 2,
        cost    = 7,
        config =  { extra = { pow = 0.05, mult = 15 } },
        loc_vars = function(self, info_queue, card)
            return MadLib.collect_vars(number_format(card.ability.extra.pow), number_format(card.ability.extra.mult))
        end,
        calculate = function(self, card, context)
            if context.setting_blind then
                ease_hands_played(1 - G.GAME.current_round.hands_left)
                return {
                    message = localize('k_active_ex'),
                    color   = G.C.POW,
                    card    = card
                }
            end
            if context.joker_main or context.forcetrigger then
                return { 
                    pow     = card.ability.extra.pow,
                    mult    = -card.ability.extra.mult,
                }
            end
        end,
        demicoloncompat = true,
    }
}
