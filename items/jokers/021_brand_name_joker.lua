return {
    data = {
        object_type = "Joker",
        key     = 'brand_name_joker',
        atlas   = 'jokers',
        pos     = MLIB.coords(2,3),
        rarity  = 2,
        cost    = 2,
        config  = {
            extra = { odds = 4, pow = 0.05 }
        },
        loc_vars = function(self, info_queue, card)
            local _numer, _denom = SMODS.get_probability_vars(card, 1, card.ability.extra.odds, 'brand_name_joker')
            return MadLib.collect_vars(number_format(_numer), -- X in
                number_format(_denom), -- Y chance
                number_format(card.ability.extra.pow))
        end,
        calculate = function(self, card, context)   
            if context.joker_main then
                return { pow = -card.ability.extra.pow }    
            end 
                
            if 
                context.retrigger_joker_check
                and SMODS.pseudorandom_probability(card, 'brand_name_joker', 1, card.ability.extra.odds)
            then
                local joker_list = MadLib.get_list_matches(G.jokers.cards, function(v)
                    return v.config.center.blueprint_compat == true and v ~= card
                end)
                local pick = nil
                if #joker_list > 0 then pick = pseudorandom_element(joker_list, pseudoseed('brand_name_joker')) end
                if pick ~= nil and context.other_card then
                    return {
                        repetitions = 1,
                        card = card,
                        message = localize('k_again_ex')
                    }
                end
            end
        end,
        demicoloncompat = true,
    }
}
