SMODS.Joker{
    key = "power_bluff",
    rarity = 1,
    atlas = "Jokers",
    pos = {x = 5, y = 1},
    cost = 4,
    config = { extra = { pow = 1, mult_pen = 20 } },

    loc_vars = function(self, info_queue, card)
        return {
            vars = { card.ability.extra.pow, card.ability.extra.mult_pen }
        }
    end,

    calculate = function(self, card, context)
        if context.setting_blind then
            ease_hands_played(1 - G.GAME.current_round.hands_left)
        end
        if context.joker_main then
            return {
                pow = card.ability.extra.pow,
                mult = -card.ability.extra.mult_pen
            }
        end
    end,
}