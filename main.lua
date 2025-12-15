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

function Pacdam.powerful_desc()
    return "{s:0.6,C:inactive}(Originally from {s:0.6,C:pow}Powerful{s:0.6,C:inactive}",
    "{s:0.6,C:inactive}by {E:1,C:green,s:0.6}chaseoqueso{s:0.6,C:inactive})"
end

SMODS.Atlas{
    key = "jokers",
    path = "jokers.png",
    px = 71,
    py = 95
}

SMODS.Atlas{
    key = "decks",
    path = "decks.png",
    px = 71,
    py = 95
}

SMODS.Atlas{
    key = "tags",
    path = "tags.png",
    px = 34,
    py = 34
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

SMODS.Atlas{
    key = "placeholder",
    path = "placeholder.png",
    px = 71,
    py = 95
}

SMODS.Sound{
    key = "pow_hit",
    path = "pow_hit.ogg"
}

SMODS.Sound{
    key = "pow_reset",
    path = "pow_reset.ogg"
}

SMODS.Sound{
    key = "xpow_hit",
    path = "xpow_hit.ogg"
}

SMODS.Sound{
    key = "e_glow",
    path = "e_glow.ogg"
}

SMODS.Shader{ key = 'glow',  path = 'glow.fs' }
SMODS.Shader{ key = 'glowbloom',  path = 'glowbloom.fs' }

-------------------------------------
-------- HELPERS & CONSTANTS --------
-------------------------------------

G.C.POW         = HEX('57C185')
G.C.FISH        = HEX("308fe3")
G.C.TETHERED    = HEX('248571')
G.C.UI_POW      = G.C.POW

POW = Pacdam

-- rarity boosters
-- fire, air, earth, water blinds
-- sulphur, mercury, salt

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


Pacdam.GUI = {}

function mod_pow(_pow)
  SMODS.Scoring_Parameters.pow:modify(nil, _pow - (pow or 1))
  return _pow
end

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
local scale_down = 0.8

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



function Pacdam.do_fish(card)
    local fish

    MadLib.loop_func(G.consumeables.cards, function(v)
        if v.config.center.key == "c_rgpd_fish" and v.ability.extra.num_fish < 5 then fish = v end
    end)

    if fish then
        local num_fish = fish.ability.extra.num_fish
        num_fish = num_fish + 1
        fish.ability.extra.num_fish = num_fish

        fish.sell_cost = num_fish - 1
        fish.children.center:set_sprite_pos({ x = num_fish - 1, y = 0 })
        fish:juice_up()
    elseif #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
        G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
        fish = SMODS.add_card({area = G.consumeables, key = "c_rgpd_fish"})
        fish.ability.extra.num_fish = 1
        fish.sell_cost = 0
        MadLib.event({
            trigger = "before",
            delay = 0.0,
            func = (function()
                -- fish = SMODS.add_card({area = G.consumeables, key = "c_pow_Fish"})
                G.GAME.consumeable_buffer = 0
                -- fish.ability.extra.num_fish = 1
                -- fish.sell_cost = 0
                return true
            end)
        })
    end
    if card then
        card_eval_status_text(card, 'extra', nil, nil, nil, { message = "Caught one!", colour = G.C.FILTER })
    end
end

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

-- This method of loading would work for jokers too but I'm picky about collection order
local function requireFolder(path)
    local files = NFS.getDirectoryItemsInfo(SMODS.current_mod.path .. "/" .. path)
    for i = 1, #files do
        local file_name = files[i].name
        if file_name:sub(-4) == ".lua" then
            assert(SMODS.load_file(path .. file_name))()
        end
    end
end

-- Load Misc
requireFolder("misc/")

-------------------------------------
--------------- POW -----------------
-------------------------------------
---
-- inserts the keys required to allow jokers to return pow in their calculate functions

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

Pacdam.object_buffer['Jokers'] = Pacdam.object_buffer['Jokers'] or {}
local function load_items(path,func)
	local files = NFS.getDirectoryItems(mod_path..path)
	--tell('File path is '.. path)
	MadLib.loop_func(files, function(file)
		--tell('File is '..file)
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
			--tell('Attempting to load item '..(item.data and item.data.key or 'UNKNOWN')..'.')
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
	['decks'] = {
        pass = function()
            return true
        end
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

--[[
local get_full_score_mod = MadLib.get_full_score

MadLib.get_full_score = function(hand_chips, mult, pow)
    tell(tostring(hand_chips) .. ' ^ ' .. tostring(pow) .. ' is ' .. tostring(hand_chips^pow) .. '.')
    return get_full_score_mod(hand_chips^pow, mult)
end
]]

-- Used to get the final score (before post-scoring shenanigans!)
local calc_round_score_ref = SMODS.calculate_round_score
function SMODS.calculate_round_score(flames)
    local ret = calc_round_score_ref(flames)
    return ret
end

SMODS.Scoring_Calculation({
    key = 'pow',
    func = function(self, chips, mult, flames)
        print('POW!!1')
        return (chips ^ pow) * mult
    end
})


--[[
    Because Pacdam doesn't have individual folders, we're adding
    JokerDisplay stuff here!
]]
if JokerDisplay then
local jod = JokerDisplay.Definitions
tell("LOADING JOKERDISPLAY VALUES FOR PACDAM")
