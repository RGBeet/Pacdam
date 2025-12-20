Pacdam.Funcs.spawn_lich_joker = function(card)
    local jokers = {}
    for _, key in pairs(get_current_pool("Joker")) do
        local center = G.P_CENTERS[key]
        if 
            key ~= "j_rgpd_lich" 
            and key ~= "UNAVAILABLE"
        then
            jokers[#jokers+1] = center
        end
    end
    local joker_center = pseudorandom_element(jokers, pseudoseed('lich'))
    local joker = create_card('Joker', G.jokers, nil, nil, true, nil, joker_center.key, 'lich')
    joker:set_edition('e_negative', true)
    SMODS.Stickers['rgpd_tethered']:apply(joker, true)
    joker.ability.lich_id = card.ability.extra.lich_id
    card.area:emplace(joker)
    return joker
end

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
                key = "rgpd_tethered",
                set = "Other",
                vars = {  colours = { G.C.TETHERED } }
            }
            return {
                vars = {  colours = { G.C.TETHERED } }
            }
        end,
        calculate = function(self, card, context)
            if 
                not context.blueprint 
                and context.end_of_round 
                and context.cardarea == G.jokers 
                and G.GAME.blind.boss 
            then
                play_sound("timpani")
                Pacdam.Funcs.spawn_lich_joker(card)
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
                        SMODS.debuff_card(v, true, "lich")
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
