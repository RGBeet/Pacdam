return {
    data = {
        object_type = "Joker",
        key     = 'lich',
        atlas   = 'jokers',
        pos     = MLIB.coords(0,6),
        rarity  = 3,
        cost    = 8,
        config  = { extra = { lich_id = -1 } },
        loc_vars = function(self, info_queue, card)
            info_queue[#info_queue + 1] = G.P_CENTERS.e_negative
            info_queue[#info_queue + 1] = {
                key = "pow_tethered",
                set = "Other",
                vars = {  colours = { G.C.TETHERED } }
            }
            return {
                vars = {  colours = { G.C.TETHERED } }
            }
        end,
        calculate = function(self, card, context)
            if not context.blueprint and context.end_of_round and context.cardarea == G.jokers and G.GAME.blind.boss then
                play_sound("timpani")
                local pool, pool_key = get_current_pool("Joker", nil, nil, nil)
                local joker_key
                repeat joker_key = pseudorandom_element(pool, pseudoseed(pool_key))
                until G.P_CENTERS[joker_key].eternal_compat and joker_key ~= "j_rgpd_lich"
                local new_card = SMODS.add_card({ key = joker_key })
                new_card:set_edition('e_negative', true)
                SMODS.Stickers['pow_tethered']:apply(new_card, true)
                new_card.ability.lich_id = card.ability.extra.lich_id
            end
        end,
        add_to_deck = function (self, card, from_debuff)
            if not from_debuff then
                G.GAME.pow_lich = (G.GAME.pow_lich or 0) + 1
                card.ability.extra.lich_id = G.GAME.pow_lich
            end
        end,
        remove_from_deck = function(self, card, from_debuff)
            if not from_debuff then
                MadLib.loop_func(G.jokers.cards, function(v)
                    if v.ability.lich_id and v.ability.lich_id == card.ability.extra.lich_id then
                        v:remove_sticker("rgpd_tethered")
                        SMODS.debuff_card(v, true, "Countess")
                    end
                end)
            end
        end,
        update = function(self, card, dt)
            if G.jokers then
                MadLib.loop_func(G.jokers.cards, function(v)
                    if v.ability.lich_id and v.ability.lich_id == card.ability.extra.lich_id then
                        v.ability.lit_sticker = card.states.hover.is and true or nil
                    end
                end)
            end
        end,
        demicoloncompat = true,
    }
}
