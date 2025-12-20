local scale_down = 0.8
SMODS.Scoring_Parameters.pow = {
    key = 'pow',
    default_value = 1,
    colour = G.C.UI_POW,
	lick = {1, 1, 1, 1},
    calculation_keys = {'pow', 'h_pow', 'pow_mod', 'xpow', 'x_pow', 'Xpow_mod',},
    calc_effect = function(self, effect, scored_card, key, amount, from_edition)
        if not SMODS.Calculation_Controls.pow then return end
        if (key == 'pow' or key == 'h_pow' or key == 'pow_mod') and amount then
            if effect.card and effect.card ~= scored_card then juice_card(effect.card) end
            self:modify(amount)
            if not effect.remove_default_message then
                if from_edition then
                    card_eval_status_text(scored_card, 'jokers', nil, percent, nil, {message = localize{type = 'variable', key = amount > 0 and 'a_pow' or 'a_pow_minus', vars = {amount}}, pow_mod = amount, colour = G.C.EDITION, edition = true})
                else
                    if key ~= 'pow_mod' then
                        if effect.chip_message then
                            card_eval_status_text(effect.message_card or effect.juice_card or scored_card or effect.card or effect.focus, 'extra', nil, percent, nil, effect.pow_message)
                        else
                            card_eval_status_text(effect.message_card or effect.juice_card or scored_card or effect.card or effect.focus, 'pow', amount, percent)
                        end
                    end
                end
            end
            return true
        end
        if (key == 'x_pow' or key == 'xpow' or key == 'Xpow_mod') and amount ~= 1 then
            if effect.card and effect.card ~= scored_card then juice_card(effect.card) end
            self:modify(pow * (amount - 1))
            if not effect.remove_default_message then
                if from_edition then
                    card_eval_status_text(scored_card, 'jokers', nil, percent, nil, {message = localize{type='variable',key= 'x_pow',vars={amount}}, Xpow_mod = amount, colour =  G.C.EDITION, edition = true})
                else
                    if key ~= 'Xchip_mod' then
                        if effect.xchip_message then
                            card_eval_status_text(effect.message_card or effect.juice_card or scored_card or effect.card or effect.focus, 'extra', nil, percent, nil, effect.xpow_message)
                        else
                            card_eval_status_text(effect.message_card or effect.juice_card or scored_card or effect.card or effect.focus, 'x_pow', amount, percent)
                        end
                    end
                end
            end
            return true
        end
    end,
	flame_handler = function(self)
		return {
			id = 'flame_'..self.key, 
			arg_tab = self.key..'_flames',
			colour = self.colour,
			accent = self.lick
		}
	end,
    modify = function(self, amount, skip)
        if not skip then pow = mod_pow(self.current + amount) end
        self.current = (pow or 1) + (skip or 0)
        update_hand_text({delay = 0}, {pow = self.current})
    end
}

SMODS.other_calculation_keys[#SMODS.other_calculation_keys + 1] = "pow"
SMODS.other_calculation_keys[#SMODS.other_calculation_keys + 1] = "pow_mod"
SMODS.other_calculation_keys[#SMODS.other_calculation_keys + 1] = "pow_decay"

SMODS.other_calculation_keys[#SMODS.other_calculation_keys + 1] = "xpow"
SMODS.other_calculation_keys[#SMODS.other_calculation_keys + 1] = "x_pow"
SMODS.other_calculation_keys[#SMODS.other_calculation_keys + 1] = "xpow_mod"
SMODS.other_calculation_keys[#SMODS.other_calculation_keys + 1] = "xpow_decay"

function Pacdam.Funcs.xpow(pow,amt)
    return MadLib.add(pow, MadLib.multiply(MadLib.subtract(pow, 1), amt))
end

function Pacdam.Funcs.epow(pow,amt)
    if MadLib.is_positive_number(MadLib.subtract(pow, 1)) then
        return MadLib.add(1, MadLib.divide(MadLib.exponent(MadLib.multiply(MadLib.subtract(pow, 1), 100), amt), 100))
    else
        return MadLib.exponent(pow, amt)
    end
    --return pow > 1 and (1+ (((pow-1)*100)^amt)/100) or (pow ^ amt)
end

function Pacdam.Funcs.convert_pow()
    -- Convert Pow
    if not MadLib.is_zero(MadLib.subtract(pow, 1)) then
        local new_chips = mod_chips(MadLib.exponent(hand_chips, pow))
        
        MadLib.event({
            trigger = 'before',
            delay = 2.0,
            func = function()
                play_sound('timpani', 1.2, 0.6)
                hand_chips = new_chips
                pow = 1
                return true
            end
        })
        update_hand_text({sound = 'rgpd_pow_reset', volume = 0.7, pitch = 0.8, delay = 2.0}, {
            chips 		= new_chips,
            mult 		= mult,
            pow         = 1
        })
    end
end

-- function to get perma_pow from playing_cards
Card.get_pow_bonus = function (self)
    return self.ability.perma_pow and self.ability.perma_pow or 0
end

Card.get_xpow_bonus = function (self)
    return self.ability.perma_xpow and self.ability.perma_xpow or 0
end

function SMODS.GUI.pow_operator(scale)
    return {n=G.UIT.C, config={align = "cm", id = 'hand_pow_operator_container'}, nodes={
        {n=G.UIT.T, config={text = "^", lang = G.LANGUAGES['en-us'], scale = scale * scale_down, colour = G.C.UI_POW, shadow = true}},
    }}
end

function SMODS.GUI.pow_container(scale)
    return {n =G.UIT.C, config={align = 'cm', id = 'hand_pow_container'}, nodes = {
        SMODS.GUI.score_container({
            type    = 'pow',
            colour  = G.C.UI_POW,
            align   = 'cm',
            scale = scale * scale_down / 2,
            h = 0.5,
            w = 1,
        })
    }}
end