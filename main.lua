Pacdam = {
    devmode = true,
    Funcs = { },
    JokerLists = { },
    object_buffer = {}
}
pmfuncs 	= Pacdam.Funcs
pmjokers	= Pacdam.JokerLists

-- enabled type stuff
local mod_path = "" .. SMODS.current_mod.path       -- save the mod path for future usage!
PacdamConfig = SMODS.current_mod.config          	-- loading configuration
Pacdam.enabled = copy_table(PacdamConfig)      		-- what is enabled?

-------------------------------------
--------- ATLASES & SOUNDS ----------
-------------------------------------

SMODS.Atlas{
    key = "jokers",
    path = "jokers.png",
    px = 71,
    py = 95
}

SMODS.Atlas{
    key = "modicon",
    path = "modicon.png",
    px = 34,
    py = 34
}

SMODS.Atlas{
    key = "extras",
    path = "extras.png",
    px = 71,
    py = 95
}

SMODS.Atlas{
    key = "enhancements",
    path = "enhancements.png",
    px = 71,
    py = 95
}

SMODS.Sound{
    key = "pow_hit",
    path = "pow_hit.ogg"
}

SMODS.Shader{ key = 'glow',  path = 'glow.fs' }
SMODS.Shader{ key = 'glowbloom',  path = 'glowbloom.fs' }

-------------------------------------
-------- HELPERS & CONSTANTS --------
-------------------------------------

G.C.POW         = HEX('57C185')
G.C.FISH        = HEX("308fe3")
G.C.TETHERED    = HEX('248571')
POW = Pacdam

-- rarity boosters
-- fire, air, earth, water blinds
-- sulphur, mercury, salt

function Pacdam.Funcs.calc_chips(chips, mult, pow)
    --print(" Chips = " .. tostring(chips) .. ", Mult = " .. tostring(mult) .. ", Pow = " .. tostring(pow) .. ".")
    return (math.abs(chips) ^ pow) * mult
end

--[[
function POW.get_most_played_poker_hand()
    local _handname, _played, _order = 'High Card', -1, 100
    for k, v in pairs(G.GAME.hands) do
        if v.played > _played or (v.played == _played and _order > v.order) then 
            _played = v.played
            _handname = k
        end
    end
    return _handname
end]]

function Pacdam.Funcs.flip_helper(source, targets, func)
    if source then
        MadLib.event({
            trigger = 'after',
            delay = 0.4,
            func = function()
                play_sound('tarot1')
                source:juice_up(0.3, 0.5)
                return true
            end
        })
    end
    for i = 1, #targets do
        local percent = 1.15 - (i - 0.999) / (#targets - 0.998) * 0.3
        MadLib.event({
            trigger = 'after',
            delay = 0.15,
            func = function()
                targets[i]:flip(); play_sound('card1', percent); targets[i]:juice_up(0.3, 0.3); return true
            end
        })
    end
    delay(0.2)
    for i = 1, #targets do
        MadLib.event({
            trigger = 'after',
            delay = 0.1,
            func = func
        })
    end
    for i = 1, #targets do
        local percent = 0.85 + (i - 0.999) / (#targets - 0.998) * 0.3
        MadLib.event({
            trigger = 'after',
            delay = 0.15,
            func = function()
                targets[i]:flip()
                play_sound('tarot2', percent, 0.6)
                targets[i]:juice_up(0.3, 0.3)
                return true
            end
        })
    end
    MadLib.event({
        trigger = 'after',
        delay = 0.2,
        func = function()
            G.hand:unhighlight_all()
            return true
        end
    })
    delay(0.5)
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

function Pacdam.Funcs.xpow(pow,amt)
    return 1 + ((pow - 1) * amt)
end

function Pacdam.Funcs.epow(pow,amt)
    return pow > 1 and (1+ (((pow-1)*100)^amt)/100) or (pow ^ amt)
end

-- hook for allowing jokers to return pow in their calculate functions
local calculate_individual_effect_ref = SMODS.calculate_individual_effect
SMODS.calculate_individual_effect = function(effect, scored_card, key, amount, from_edition)

    if (key == 'pow' or key == 'h_pow' or key == 'pow_mod' or key == 'pow_decay') and amount then
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
    return calculate_individual_effect_ref(effect, scored_card, key, amount, from_edition)
end

-- inserts the keys required to allow jokers to return pow in their calculate functions
table.insert(SMODS.calculation_keys, "pow")
table.insert(SMODS.calculation_keys, "h_pow")
table.insert(SMODS.calculation_keys, "pow_mod")
table.insert(SMODS.calculation_keys, "pow_decay")

-- custom number formatting for additional decimal places
local pow_number_format = function(num, e_switch_point)
    if type(num) ~= 'number' then return num end
    local sign = (num >= 0 and "") or "-"
    num = math.abs(num)
    G.E_SWITCH_POINT = G.E_SWITCH_POINT or 100000000000
    if not num or type(num) ~= 'number' then return num or '' end
    if num >= (e_switch_point or G.E_SWITCH_POINT) then
        if num == math.huge then return sign.."naneinf" end
        local x = string.format("%.4g", num)
        local fac = math.floor(math.log(tonumber(x), 10))
        local mantissa = round_number(x / (10 ^ fac), 3)
        if mantissa >= 10 then mantissa = mantissa / 10; fac = fac + 1 end
        return sign .. string.format(fac >= 100 and "%.1fe%i" or fac >= 10 and "%.2fe%i" or "%.3fe%i", mantissa, fac)
    end
    -- Format with 2 decimal places always
    local formatted = string.format("%.2f", num)
    -- Add commas if needed
    local int_part, dec_part = formatted:match("^(%d+)%p(%d%d)$")
    if int_part then int_part = int_part:reverse():gsub("(%d%d%d)", "%1,"):gsub(",$", ""):reverse(); formatted = int_part .. "." .. dec_part end
    return sign .. formatted
end

-- function for updating the pow text
G.FUNCS.hand_pow_UI_set = function(e)
    local new_pow_text = pow_number_format(G.GAME.current_round.current_hand.pow)
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
  if type(number) == "number" and number < 0 then number = math.abs(number) * 10 end
  return scale_number_ref(number, scale, max, e_switch_point)
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

-- function to get perma_pow from playing_cards
Card.get_pow_bonus = function (self)
    return self.ability.perma_pow and self.ability.perma_pow or 0
end

local uibox_ref = create_UIBox_HUD
function create_UIBox_HUD()
	local orig = uibox_ref()

    local hands_ui = orig.nodes[1].nodes[1].nodes[4]

    table.insert(hands_ui.nodes[1].nodes, 2, {n=G.UIT.R, config={align = "cm", minh = 0.5, draw_layer = 1}, nodes={
        {n=G.UIT.C, config={align = "cr", minw = 1.5, minh = 0.5, r = 0.1, colour = G.C.POW, id = 'hand_pow_area', emboss = 0.05, padding = 0.03}, nodes={
            {n=G.UIT.O, config={func = 'flame_handler',no_role = true, id = 'flame_pow', object = Moveable(0,0,0,0), w = 0, h = 0}},
            {n=G.UIT.O, config={id = 'hand_pow', func = 'hand_pow_UI_set',object = DynaText({string = {{ref_table = G.GAME.current_round.current_hand, ref_value = "pow_text"}}, colours = {G.C.UI.TEXT_LIGHT}, font = G.LANGUAGES['en-us'].font, shadow = true, float = true, scale = 0.5, r = 0.4*1.4})}},
            {n=G.UIT.B, config={w=0.1,h=0.1}},
        }},
        {n=G.UIT.C, config={align = "cm", minw = 1.5, minh = 0.5, r = 0.1, colour = G.C.CLEAR, id = 'hand_pow_empty', emboss = 0.05}},
    }})
    return orig
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

Pacdam.object_buffer['Jokers'] = Pacdam.object_buffer['Jokers'] or {}
local function load_items(path,func)
	local files = NFS.getDirectoryItems(mod_path..path)
	tell('File path is '.. path)
	MadLib.loop_func(files, function(file)
		tell('File is '..file)
		local f, err = SMODS.load_file(path..file)
		if err then
			tell_error(err)
			--errors[file] = err
			return false
		end

		local item = f()
		if not (item and item.data) then
			tell('Item could not load - improper data structure.')
			return false
		elseif item.devmode and item.devmode ~= Pacdam.Data.devmode then
			tell('Item could not load - devmode only!')
			return false
		end

		if item.categories and MadLib.list_matches_one(item.categories, function(c)
			return PacdamConfig[v] ~= nil and PacdamConfig[v] == false
		end) then
			tell('Item '..(item.data and item.data.key or 'UNKNOWN')..' could not load - configs turned off.')
			return false
		end

		local data = item.data
		if data.object_type then
			if func then func(item.data) end
			tell('Attempting to load item '..(item.data and item.data.key or 'UNKNOWN')..'.')
			SMODS[data.object_type](data)
		end
	end)
end

local function loop_directories(tbl, path)
    path = path or {}
    tell('Loading Directories')
	print(path)
	MadLib.loop_table(tbl, function(key,value)
        if type(value) ~= "table" then return false end
		if value.pass ~= nil and value.pass() == true then
			tell("Loading folder at: " .. table.concat(path, ".") .. (next(path) and "." or "") .. key)
			local final_path = 'items/'
			MadLib.loop_func(path, function(v,i)
				final_path = final_path .. v .. '/'
			end)
			load_items(final_path..key..'/',value.func)
		else
			table.insert(path, key)
			loop_directories(value, path)
			table.remove(path)
		end
	end)
end

Pacdam.JokerIds = {} -- joker ids
Pacdam.Directories = {
	['jokers'] = {
        pass = function()
            return true
        end,
        func = function(d) -- add joker id to joker ids
            d.pools = { ['MadcapJoker'] = true }
            d.blueprint_compat  = d.blueprint_compat or true
            d.eternal_compat    = d.eternal_compat or true
            d.perishable_compat = d.perishable_compat or true
            d.unlocked          = d.unlocked or true
            d.discovered        = d.discovered or true
        end
    },
	['consumeables'] = {
        ['tarot'] = {
            pass = function()
                return true
            end
        },
        ['spectral'] = {
            pass = function()
                return true
            end
        },
        ['planet'] = {
            pass = function()
                return true
            end
        }
	},
	['enhancements'] = {
        pass = function()
            return true
        end
	},
	['editions'] = {
		pass = function()
			return true
		end
	},
	['stickers']	= {
		pass = function()
			return true
		end
	},
	['tags'] = {
		pass = function()
			return true
		end
	},
	['blinds'] = {
		pass = function()
			return true
		end
	},
}
loop_directories(Pacdam.Directories)

local get_full_score_mod = MadLib.get_full_score

MadLib.get_full_score = function(hand_chips, mult, pow)
    tell(tostring(hand_chips) .. ' ^ ' .. tostring(pow) .. ' is ' .. tostring(hand_chips^pow) .. '.')
    return get_full_score_mod(hand_chips^pow, mult)
end
