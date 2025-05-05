G.C.FISH = HEX("308fe3")
G.C.TETHERED = HEX('248571')

function calc_chips_pow(chips, mult, pow)
    local sign = function (number)
        return number > 0 and 1 or (number == 0 and 0 or -1)
    end
    return sign(chips)*(math.abs(chips)^pow)*mult
end

SMODS.Atlas{
    key = "Jokers",
    path = "Jokers.png",
    px = 71,
    py = 95
}

SMODS.Atlas{
    key = "Extras",
    path = "Extras.png",
    px = 71,
    py = 95
}

SMODS.Sound{
    key = "pow_hit",
    path = "pow_hit.ogg"
}

local function requireFolder(path)
    local files = NFS.getDirectoryItemsInfo(SMODS.current_mod.path .. "/" .. path)
    for i = 1, #files do
        local file_name = files[i].name
        if file_name:sub(-4) == ".lua" then
            assert(SMODS.load_file(path .. file_name))()
        end
    end
end

requireFolder("jokers/")

-------------------------------------
--------------- POW -----------------
-------------------------------------

-- hook for setting pow to 1 when a hand is being evaluated
local evaluate_play_ref = G.FUNCS.evaluate_play
G.FUNCS.evaluate_play = function(e)
    pow = 1
    evaluate_play_ref(e)
end

-- hook for setting the pow text value to 1 when there is no pow key
local update_hand_text_ref = update_hand_text
function update_hand_text(config, vals)
    if not vals.pow then
        if pow then
            vals.pow = pow
        else
            vals.pow = 1
        end
    end
    update_hand_text_ref(config, vals)
end

-- hook for allowing jokers to return pow in their calculate functions
local calculate_individual_effect_ref = SMODS.calculate_individual_effect
SMODS.calculate_individual_effect = function(effect, scored_card, key, amount, from_edition)
    if (key == 'pow' or key == 'h_pow' or key == 'pow_mod') and amount then
        if effect.card and effect.card ~= scored_card then juice_card(effect.card) end
        pow = pow + amount
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
    calculate_individual_effect_ref(effect, scored_card, key, amount, from_edition)
end

-- inserts the keys required to allow jokers to return pow in their calculate functions
table.insert(SMODS.calculation_keys, "pow")
table.insert(SMODS.calculation_keys, "h_pow")
table.insert(SMODS.calculation_keys, "pow_mod")


-- function for updating the pow text
G.FUNCS.hand_pow_UI_set = function(e)
    local new_pow_text = number_format(G.GAME.current_round.current_hand.pow)
    if new_pow_text ~= G.GAME.current_round.current_hand.pow_text then 
        G.GAME.current_round.current_hand.pow_text = new_pow_text
        e.config.object.scale = scale_number(G.GAME.current_round.current_hand.pow, 0.55, 1000)
        e.config.object:update_text()
        if not G.TAROT_INTERRUPT_PULSE then G.FUNCS.text_super_juice(e, math.max(0,math.floor(math.log10(type(G.GAME.current_round.current_hand.pow) == 'number' and G.GAME.current_round.current_hand.pow or 1)))) end
    end
end

-- hook for the flames on the pow box
local flame_handler_ref = G.FUNCS.flame_handler
G.FUNCS.flame_handler = function(e)
  G.C.UI_POWLICK = G.C.UI_POWLICK or {1, 1, 1, 1}
  for i=1, 3 do
    G.C.UI_POWLICK[i] = math.min(math.max(((G.C.GREEN[i]*0.5+G.C.YELLOW[i]*0.5) + 0.1)^2, 0.1), 1)
  end
  return flame_handler_ref(e)
end

-- hook to fix scaling for negative numbers
local scale_number_ref = scale_number
scale_number = function(number, scale, max, e_switch_point)
  if(number < 0) then
    number = math.abs(number) * 10
  end
  return scale_number_ref(number, scale, max, e_switch_point)
end