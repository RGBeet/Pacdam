return {
    data = {
        object_type = "Joker",
        key     = 'pow_block',
        atlas   = 'jokers',
        pos     = MLIB.coords(2,1),
        rarity  = 1,
        cost    = 6,
        config  = { extra = { pow = 0.50, active = false } },
        loc_vars = function(self, info_queue, card)
            return MadLib.collect_vars(number_format(card.ability.extra.pow))
        end,
        calculate = function(self, card, context)
            if
                (context.final_scoring_step
                and G.GAME.current_round.hands_left == 0
                and to_big(G.GAME.chips) < to_big(G.GAME.blind.chips))
                or context.forcetrigger
            then
                card.ability.active = not context.forcetrigger -- false means you can keep using it, woo!
                return {
                    pow     = card.ability.extra.pow,
                    card    = card,
                }
            end

            if context.after and card.ability.active then
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
                            func = function()
                                card:remove()
                                return true
                            end
                        })
                        return true
                    end
                })
            end
        end,
        demicoloncompat = true,
    }
}
