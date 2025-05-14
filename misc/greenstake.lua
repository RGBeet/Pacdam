SMODS.Stake:take_ownership("stake_green",
    {
        modifiers = function ()
            G.GAME.modifiers.pow_decay_rate = 0.001
        end
    }
)

-- local end_round_ref = end_round
-- end_round = function ()
--     local ret = end_round_ref()
--     if G.GAME.modifiers.pow_decay_rate then
--         for i,v in ipairs(G.jokers) do
--             G.E_MANAGER:add_event(Event{
--                 func = function ()
--                     local decay = G.GAME.modifiers.pow_decay_rate
--                     v.ability.pow_decay = (v.ability.pow_decay or 0) + decay
--                     play_sound("cancel")
--                     card_eval_status_text(v, 'extra', nil, nil, nil, {message = localize('k_decay'), colour = G.C.GREEN, vars = {decay}})
--                 end
--             })
--         end
--     end
--     return ret
-- end

local calculate_context_ref = SMODS.calculate_context
SMODS.calculate_context = function (context, return_table)
    local return_table = calculate_context_ref(context, return_table)
    if context.end_of_round and G.GAME.modifiers.pow_decay_rate then
        for i,v in ipairs(G.jokers.cards) do
            G.E_MANAGER:add_event(Event{
                func = function ()
                    local decay = G.GAME.modifiers.pow_decay_rate
                    v.ability.pow_decay = (v.ability.pow_decay or 0) + decay
                    card_eval_status_text(v, "extra", nil, nil, nil, {message = localize{type = "variable", key = "a_decay", vars = {decay}}, colour = G.C.GREEN, sound = "cancel"})
                    return true
                end
            })
        end
    end
    return return_table
end