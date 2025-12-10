function Pacdam.Funcs.calculate_broker_rate(pow_rate, dollar_rate)
    return math.floor(MadLib.multiply(MadLib.divide(G.GAME.dollars, dollar_rate), pow_rate))
end

return {
    data = {
        object_type = "Joker",
        key     = 'broker',
        atlas   = 'jokers',
        pos     = MLIB.coords(0,8),
        rarity  = 2,
        cost    = 6,
        config  = { extra = { pow_mod = 0.02, money = 5 } },
        loc_vars = function(self, info_queue, card)
            return MadLib.collect_vars(number_format(card.ability.extra.pow_mod), number_format(card.ability.extra.money), number_format(Pacdam.Funcs.calculate_broker_rate(card.ability.extra.pow_mod, card.ability.extra.money)))
        end,
        calculate = function(self, card, context)
            if context.joker_main or context.forcetrigger then
                return { pow = Pacdam.Funcs.calculate_broker_rate(card.ability.extra.pow_mod, card.ability.extra.money) }
            end
        end,
        demicoloncompat = true,
    }
}
