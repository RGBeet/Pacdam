return {
    data = {
        object_type = "Joker",
        key     = 'powitch',
        atlas   = 'jokers',
        pos     = MLIB.coords(2,2),
        rarity  = 1,
        cost    = 6,
        config  = { extra = { pow = 0.08, pow_decay = 0.01, hands_current = 0, hands_max = 3 } },
        loc_vars = function(self, info_queue, card)
            return MadLib.collect_vars(number_format(card.ability.extra.pow), number_format(card.ability.extra.pow_decay), number_format(card.ability.extra.hands_current), number_format(card.ability.extra.hands_max))
        end,
        calculate = function(self, card, context)

            if context.after and context.main_eval and not context.blueprint then
                if card.ability.extra.hands_current + 1 < card.ability.extra.hands_max then
                    card.ability.extra.hands_current = card.ability.extra.hands_current + 1
                else
                    card.ability.extra.hands_current = 0
                    if card.ability.extra.pow - card.ability.extra.pow_decay > 0 then
                        card.ability.extra.pow = card.ability.extra.pow - card.ability.extra.pow_decay
                        return {
                            message = localize { type = 'variable', key = 'a_pow_minus', vars = { card.ability.extra.chip_mod } },
                            colour = G.C.POW
                        }
                    else
                        MadLib.event({
                            func = function()
                                play_sound('tarot1')
                                card.T.r = -0.2
                                card:juice_up(0.3, 0.4)
                                card.states.drag.is = true
                                card.children.center.pinch.x = true
                                MadLib.event({
                                    trigger = 'after',
                                    delay = 0.3,
                                    blockable = false,
                                    func = function() card:remove() return true end
                                })
                                return true
                            end
                        })
                        return {
                            message = localize('k_eaten_ex'),
                            colour = G.C.POW
                        }
                    end
                end
            end
            if context.joker_main then
                return {
                    pow     = card.ability.extra.pow,
                    card    = card
                }
            end
        end,
        demicoloncompat = true,
    }
}
