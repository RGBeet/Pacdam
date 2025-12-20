return {
    data = {
        object_type = "Joker",
        key     = 'odd_one_out',
        atlas   = 'jokers',
        pos     = MLIB.coords(2,5),
        rarity  = 1,
        cost    = 6,
        config =  {
            extra = {
                cards_to_debuff = 1,
                pow = 0.1,
                success = false
            },
        },
        loc_vars = function(self, info_queue, card)
            if (card.ability.extra.cards_to_debuff or 1) > 1 then
                return { vars = { card.ability.extra.cards_to_debuff, card.ability.extra.pow } }
            else
                return { vars = { card.ability.extra.pow } }
            end
        end,
        calculate = function(self, card, context)

            if context.before then
                local to_debuff = {}
                local to_reset  = {}

                -- Add debuffs
                for i=1,#card.area.cards do
                    local v = card.area.cards[i]
                    if v == card or v.config.center.key == card.config.center.key then -- cannot debuff other odd one outs
                        break
                    elseif #to_debuff < (card.ability.extra.cards_to_debuff or 1) then
                        to_debuff[#to_debuff+1] = v
                    end
                end

                -- Remove debuffs
                for i = #to_debuff, #card.area.cards do
                    local v = card.area.cards[i]
                    if 
                        v and (not (v == card or v.config.center.key == card.config.center.key)) 
                        and v.ability.debuff_sources and v.ability.debuff_sources['rgpd_odd_man_out'] 
                    then
                        to_reset[#to_reset+1] = v
                    end
                end

                local success = #to_debuff >= (card.ability.extra.cards_to_debuff or 1)

                if success then
                    MadLib.loop_func(to_debuff, function(v)
                        MadLib.event({
                            func = function()
                                SMODS.debuff_card(v, true, 'rgpd_odd_man_out')
                                v:juice_up(0.7, 0.5)
                                play_sound(Madcap and 'rgmc_laser' or 'holo1', 1, 0.6)
                                return true
                        end})
                    end)
                    MadLib.loop_func(to_reset, function(v)
                        MadLib.event({ 
                            func = function()
                                SMODS.debuff_card(v, false, 'rgpd_odd_man_out')
                                v:juice_up(0.7, 0.5)
                                play_sound(Madcap and 'rgmc_revert' or 'holo1', 1, 0.6)
                                return true
                        end})
                    end)
                    return {
                        pow = card.ability.extra.pow
                    }
                else
                    return {
                        message = '...',
                        colour  = G.C.FILTER
                    }
                end
            end

            if context.round_eval then
                for i = 1, #card.area.cards do
                    local v = card.area.cards[i]
                    if 
                        (not (v == card or v.config.center.key == card.config.center.key)) 
                        and v.ability.debuff_sources and v.ability.debuff_sources['rgpd_odd_man_out'] 
                    then
                        MadLib.simple_event(function()
                            SMODS.debuff_card(v, false, 'rgpd_odd_man_out')
                            v:juice_up(0.7, 0.5)
                            play_sound(Madcap and 'rgmc_revert' or 'holo1', 1, 0.6)
                            return true
                        end, 0.3, 'before')
                    end
                end
            end

            if(context.end_of_round and context.cardarea == G.jokers) then
                MadLib.loop_func(G.jokers.cards, function(v) v.rgmc_nullified = nil end)
            end
        end,
        perishable_compat   = false,
        blueprint_compat    = false,
        demicoloncompat     = false,
    }
}
