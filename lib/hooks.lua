local scale_down = 0.8
local rcc = reset_castle_card
function reset_castle_card()
	rcc()

	G.GAME.current_round.rgpd_wanted_poster     = { rank = "8", suit = "Spades" }
	G.GAME.current_round.rgpd_number_cruncher   = { rank = nil, order = {} }

	local valid_castle_cards = MadLib.get_list_matches(G.playing_cards, function(v)
        return not SMODS.has_no_rank(v) and not SMODS.has_no_suit(v)
    end) or {}

    local castle_card = nil
	if valid_castle_cards[1] then -- there are cards with ranks and suits
		-- Neighborhood Watch (Edwin)
		castle_card = pseudorandom_element(valid_castle_cards, pseudoseed("rgpd_wanted_poster" .. G.GAME.round_resets.ante))
		G.GAME.current_round.rgpd_wanted_poster = G.GAME.current_round.rgpd_wanted_poster or {}
		G.GAME.current_round.rgpd_wanted_poster.suit  = castle_card.base.suit
		G.GAME.current_round.rgpd_wanted_poster.rank  = castle_card.base.value
		G.GAME.current_round.rgpd_wanted_poster.id    = castle_card.base.id
	end

	-- This is for the Barbershop Joker
	G.GAME.current_round.rgpd_number_cruncher.changed   = false
    G.GAME.current_round.rgpd_number_cruncher.index     = G.GAME.current_round.rgpd_number_cruncher.index or 1

    local rank_set = {}
    MadLib.loop_func(G.playing_cards, function(v)
        if SMODS.has_no_rank(v) then return end
            rank_set[v.base.value] = true
    end)

    local ranks = {}
    for rank, _ in pairs(rank_set) do table.insert(ranks, rank) end

    --table.sort(ranks)
    local seed = pseudoseed('rgpd_number_cruncher'..tostring(G.GAME.round_resets.ante)..tostring(G.GAME.round_resets.ante))
    pseudoshuffle(ranks,seed)
    G.GAME.current_round.rgpd_number_cruncher.order = ranks

    -- Ensure rgmc_barbershop.index is valid before accessing suits
    local index = G.GAME.current_round.rgpd_number_cruncher.index or 1
    if index < 1 or index > #ranks then index = 1 end  -- Default to 1 if out of bounds

    G.GAME.current_round.rgpd_number_cruncher.rank = G.GAME.current_round.rgpd_number_cruncher.order[index]
end

-- hook for jokers to apply decay
local calculate_joker_ref = Card.calculate_joker
function Card:calculate_joker(context)
    local effect = calculate_joker_ref(self, context)
    if context.joker_main and self.ability.pow_decay then
        effect = effect or {}
        effect.pow_decay = -math.abs(self.ability.pow_decay)
    end
    return effect
end

-- hook for decay to show up on joker ui
local generate_card_ui_ref = generate_card_ui
generate_card_ui = function(_c, full_UI_table, specific_vars, card_type, badges, hide_desc, main_start, main_end, card)
    local ret = generate_card_ui_ref(_c, full_UI_table, specific_vars, card_type, badges, hide_desc, main_start, main_end, card)
    if _c and _c.set and _c.set == "Joker" and card and card.ability and card.ability.pow_decay and ret then
        localize{type = 'other', key = 'card_decay', nodes = ret.main, vars = {math.abs(card.ability.pow_decay)}}
    end
    return ret
end

SMODS.Sticker:take_ownership("eternal", {
    draw = function(self, card, layer)
        if card.ability.pow_tethered then return end
        G.shared_stickers[self.key].role.draw_major = card
        G.shared_stickers[self.key]:draw_shader('dissolve', nil, nil, nil, card.children.center)
        G.shared_stickers[self.key]:draw_shader('voucher', nil, card.ARGS.send_to_shader, nil, card.children.center)
    end
}, true)

local generate_UIBox_ability_table_ref = Card.generate_UIBox_ability_table
function Card:generate_UIBox_ability_table(...)
    local eternal_state = self.ability.eternal
    if self.ability.eternal and self.ability.pow_tethered then self.ability.eternal = false end
    local ret = generate_UIBox_ability_table_ref(self, ...)
    self.ability.eternal = eternal_state
    return ret
end

-- Used to get the final score (before post-scoring shenanigans!)
local calc_round_score_ref = SMODS.calculate_round_score
function SMODS.calculate_round_score(flames)
    local ret = calc_round_score_ref(flames)
    return ret
end

-- hook for setting pow to 1 when a hand is being evaluated
local evaluate_play_ref = G.FUNCS.evaluate_play
G.FUNCS.evaluate_play = function(e)
    pow = 1
    return evaluate_play_ref(e)
end

-- hook for setting the pow text value to 1 when there is no pow key
local update_hand_text_ref = update_hand_text
function update_hand_text(config, vals)
    vals.pow = vals.pow or (pow or 1)
    return update_hand_text_ref(config, vals)
end

local score_container_ref = SMODS.GUI.score_container
function SMODS.GUI.score_container(args)
    args.scale  = (args.scale or 0.4) * scale_down
    args.w      = (args.w or 2) * scale_down
    args.h      = (args.h or 1) * scale_down
    return score_container_ref(args)
end

local operator_ref = SMODS.GUI.operator
function SMODS.GUI.operator(scale)
    return operator_ref(scale * scale_down)
end

local mult_container_ref = SMODS.GUI.mult_container
function SMODS.GUI.mult_container(scale)
    return mult_container_ref(scale * scale_down)
end

local hand_chips_container_ref = SMODS.GUI.hand_chips_container
function SMODS.GUI.hand_chips_container(scale)
    local ret = hand_chips_container_ref(scale)
    -- After the chips container, place the the ^ operator and the pow?
    local index = nil
    for i=1,#ret.nodes do
        print(ret.nodes[i].config.id)
        if ret.nodes[i] and ret.nodes[i].config.id == 'hand_chips_container' then 
            index = i 
            break
        end
    end
    tell("UI Index is " .. tostring(index))
    if index ~= nil then
        table.insert(ret.nodes, index+1, SMODS.GUI.pow_container(scale))
        table.insert(ret.nodes, index+1, SMODS.GUI.pow_operator(scale))
    end
    return ret
end

-- hook for allowing jokers to return pow in their calculate functions
local calculate_individual_effect_ref = SMODS.calculate_individual_effect
SMODS.calculate_individual_effect = function(effect, scored_card, key, amount, from_edition)
    if (key == 'pow' or key == 'h_pow' or key == 'pow_mod' or key == 'pow_decay') and amount then
        if effect.card and effect.card ~= scored_card then juice_card(effect.card) end
        pow = MadLib.add(pow, amount)
        update_hand_text({delay = 0}, {chips = hand_chips, mult = mult, pow = pow})
        if not effect.remove_default_message then
            if from_edition then
                card_eval_status_text(scored_card, 'jokers', nil, percent, nil, {message = localize{type = 'variable', key = amount > 0 and 'a_pow' or 'a_pow_minus', vars = {amount}}, chip_mod = amount, colour = G.C.EDITION, edition = true})
            else
                if key ~= 'pow_mod' then
                    if effect.pow_message then
                        card_eval_status_text(effect.message_card or effect.juice_card or scored_card or effect.card or effect.focus, 'extra', nil, percent, nil, effect.pow_message)
                    else
                        card_eval_status_text(effect.message_card or effect.juice_card or scored_card or effect.card or effect.focus, 'pow', amount, percent)
                    end
                end
            end
        end
        return true
    end
    if (key == 'x_pow' or key == 'xpow' or key == 'h_xpow' or key == 'xpow_mod') and amount then
        if effect.card and effect.card ~= scored_card then juice_card(effect.card) end
        pow = Pacdam.Funcs.xpow(pow, amount)
        update_hand_text({delay = 0}, {chips = hand_chips, mult = mult, pow = SMODS.Scoring_Parameters.pow})
        if not effect.remove_default_message then
            if from_edition then
                card_eval_status_text(scored_card, 'jokers', nil, percent, nil, {message = localize{type = 'variable', key = amount > 0 and 'a_xpow' or 'a_xpow_minus', vars = {amount}}, chip_mod = amount, colour = G.C.EDITION, edition = true})
            else
                if key ~= 'xpow_mod' then
                    if effect.pow_message then
                        card_eval_status_text(effect.message_card or effect.juice_card or scored_card or effect.card or effect.focus, 'extra', nil, percent, nil, effect.pow_message)
                    else
                        card_eval_status_text(effect.message_card or effect.juice_card or scored_card or effect.card or effect.focus, 'x_pow', amount, percent)
                    end
                end
            end
        end
        return true
    end
    return calculate_individual_effect_ref(effect, scored_card, key, amount, from_edition)
end