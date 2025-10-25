return {
    data = {
        object_type = "Joker",
        key     = 'kujenga',
        atlas   = 'jokers',
        pos     = MLIB.coords(2,4),
        rarity  = 2,
        cost    = 5,
        config = {
            immutable = { odds = 20, increase = 0 }, -- if this was mutable, it would ruin the card
            extra = {
                mult_mod    = 1,
                mult        = 0
            }
        },
        loc_vars = function(self, info_queue, card)
            local _numer, _denom = SMODS.get_probability_vars(card, card.ability.immutable.odds - (1 + card.ability.immutable.increase), card.ability.immutable.odds, 'kujenga')
            return MadLib.collect_vars(number_format(_numer), -- X in
                number_format(_denom), -- Y chance
                number_format(card.ability.extra.mult_mod),
                number_format(math.ceil(card.ability.extra.mult/2)),
                number_format(card.ability.extra.mult),
                number_format(1))
        end,
        calculate = function(self, card, context)

            if 
                (context.pre_discard and not context.hook) 
                or context.forcetrigger 
            then
                if not SMODS.pseudorandom_probability(card, 'kujenga', 1 + card.ability.immutable.increase, card.ability.immutable.odds) then
                    card.ability.extra.mult = card.ability.extra.mult + card.ability.extra.mult_mod
                    return {
                        message = localize('k_upgrade_ex'),
                        colour = G.C.MULT,
                        message_card = card
                    }
                else
                    local new_mult = math.floor(card.ability.extra.mult / 2)
                    card.ability.immutable.increase = 0
                    card.ability.extra.mult = new_mult
                    return {
                        message = number_format(new_mult),
                        colour = G.C.FILTER,
                        message_card = card
                    }
                end
            end

            -- Get the mult, but increase likelihood of toppling by 1
            if
                context.joker_main
                and to_big(card.ability.extra.mult) > to_big(0)
            then
                card.ability.immutable.increase = MadLib.clamp(card.ability.immutable.increase + 1, 0, card.ability.immutable.odds)
                return { mult = to_big(card.ability.extra.mult) }
            end
        end,
        perishable_compat   = false,
        demicoloncompat     = true,
    }
}
