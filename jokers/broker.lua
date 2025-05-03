local pow_calc = function(card)
    return math.floor(G.GAME.dollars/card.ability.extra.dollarrate)*card.ability.extra.powrate
end

SMODS.Joker{
    key = "Broker",
    rarity = 2,
    atlas = "Jokers",
    pos = {x = 3, y = 0},
    cost = 6,
    config = { extra = { powrate = 0.02, dollarrate = 5 } },

    loc_vars = function(self, info_queue, card)
        return {
            vars = { card.ability.extra.powrate, card.ability.extra.dollarrate, pow_calc(card)}
        }
    end,

    calculate = function(self, card, context)
        if context.joker_main then
            return {
                pow = pow_calc(card)
            }
        end
    end,
}