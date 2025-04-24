----------------------------------------------
------------MOD CODE -------------------------

G.C.FISH = HEX("308fe3")
G.C.TETHERED = HEX('248571')

-- local f = modsCollectionTally
-- modsCollectionTally = function(pool, set)
--     if pool == G.P_CENTER_POOLS["Fish"] or set == "Fish" then
--         return {tally = 0, of = 0}
--     else
--         return f(pool, set)
--     end
-- end

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

----------------------------------------
-------------- FISHERMAN ---------------
----------------------------------------
SMODS.Joker{
    key = "Fisherman",
    rarity = 2,
    atlas = "Jokers",
    pos = {x = 0, y = 0},
    cost = 6,
    blueprint_compat = true,

    loc_vars = function(self, info_queue, card)
		info_queue[#info_queue + 1] = G.P_CENTERS.c_pow_Fish
	end,

    calculate = function(self, card, context)
        if context.pre_discard then
            local fish
            local fishes = SMODS.find_card("c_pow_Fish")
            for _,f in pairs(fishes) do
                if f.ability.extra.num_fish < 5 then fish = f end
            end
            if fish then
                local num_fish = fish.ability.extra.num_fish
                num_fish = num_fish + 1
                fish.ability.extra.num_fish = num_fish

                fish.sell_cost = num_fish - 1

                fish.children.center:set_sprite_pos({ x = num_fish-1, y = 0 })
                fish:juice_up()

                card_eval_status_text(card, 'extra', nil, nil, nil, { message = "Caught one!", colour = G.C.attention })
            elseif #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
                G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
                
                fish = SMODS.add_card({area = G.consumeables, key = "c_pow_Fish"})
                fish.ability.extra.num_fish = 1
                fish.sell_cost = 0

                G.E_MANAGER:add_event(Event({
                    trigger = "before",
                    delay = 0.0,
                    func = (function()
                        -- fish = SMODS.add_card({area = G.consumeables, key = "c_pow_Fish"})
                        G.GAME.consumeable_buffer = 0
                        -- fish.ability.extra.num_fish = 1
                        -- fish.sell_cost = 0
                        return true
                    end)}))

                card_eval_status_text(card, 'extra', nil, nil, nil, { message = "Caught one!", colour = G.C.attention })
            end
        end
    end
}

SMODS.ConsumableType{
    key = "Fish",
    primary_colour = G.C.FISH,
    secondary_colour = G.C.FISH,
}

SMODS.Consumable{
    key = "Fish",
    set = "Fish",
    atlas = "Extras",
    pos = {x = 0, y = 0},
    no_collection = true,
    config = { extra = { num_fish = 1 } },

    add_to_deck = function (self, card, from_debuff)
        if not from_debuff then
            self.pos = { x = 0, y = 0 }
            card.children.center:set_sprite_pos({ x = 0, y = 0 })
        end
    end,

    can_use = function(self, card)
        if G.hand and G.hand.cards and (#G.hand.cards > 0) then
            return true
        end
    end,

    use = function(self, card)
        if card.ability.extra.num_fish > 1 then
            card.ability.extra.num_fish = card.ability.extra.num_fish - 1

            card.sell_cost = card.ability.extra.num_fish - 1

            card.children.center:set_sprite_pos({ x = card.ability.extra.num_fish-1, y = 0 })
        end
        card_eval_status_text(card, 'extra', nil, nil, nil, { message = "Go Fish!", colour = G.C.attention })
        G.FUNCS.draw_from_deck_to_hand(1)
    end,

    keep_on_use = function (self, card)
        return card.ability.extra.num_fish > 1
    end,

    load = function (self, card, card_table, other_card)
        self.pos = { x = card_table.ability.extra.num_fish-1, y = 0 }
        self.sell_cost = card_table.ability.extra.num_fish - 1
        -- card:set_sprites(self)
    end
}

-- local tempRemove = function(f, ...)
--     local buff = SMODS.ConsumableType.ctype_buffer
--     local index
--     for k, v in pairs(buff) do
--         if v == "Fish" then
--            index = k 
--            break
--         end
--     end

--     SMODS.ConsumableType.ctype_buffer[index] = nil
--     local t = G.P_CENTER_POOLS["Fish"]
--     G.P_CENTER_POOLS["Fish"] = nil

--     local ret = f(...)

--     SMODS.ConsumableType.ctype_buffer[index] = "Fish"
--     G.P_CENTER_POOLS["Fish"] = t

--     return ret
-- end

-- local consumable_collection_page_ref = G.UIDEF.consumable_collection_page
-- G.UIDEF.consumable_collection_page = function(page)
--     return tempRemove(consumable_collection_page_ref, page)
-- end

----------------------------------------
----------------- LICH -----------------
----------------------------------------

SMODS.Joker{
    key = "Lich",
    rarity = 3,
    atlas = "Jokers",
    pos = {x = 1, y = 0},
    cost = 8,
    config = { extra = { lich_id = -1 } },

    loc_vars = function(self, info_queue, card)
		info_queue[#info_queue + 1] = G.P_CENTERS.e_negative
		info_queue[#info_queue + 1] = { 
            key = "pow_tethered", 
            set = "Other", 
            vars = { 
                colours = {
                    G.C.TETHERED
                }
            }
        }
        return {
            vars = { 
                colours = {
                    G.C.TETHERED
                }
            }
        }
	end,

    calculate = function(self, card, context)
        if not context.blueprint and context.end_of_round and context.cardarea == G.jokers and G.GAME.blind.boss then
            play_sound("timpani")
            local pool, pool_key = get_current_pool("Joker", nil, nil, nil)
            local joker_key
            repeat
                joker_key = pseudorandom_element(pool, pseudoseed(pool_key))
            until G.P_CENTERS[joker_key].eternal_compat and joker_key ~= "j_pow_Lich"

            local new_card = SMODS.add_card({ key = joker_key })
            new_card:set_edition('e_negative', true)
            SMODS.Stickers['pow_tethered']:apply(new_card, true)

            new_card.ability.lich_id = card.ability.extra.lich_id
        end
    end,

    add_to_deck = function (self, card, from_debuff)
        if not from_debuff then
            if not G.Num_Liches then
                G.Num_Liches = 0
            end
            card.ability.extra.lich_id = G.Num_Liches
            G.Num_Liches = G.Num_Liches + 1
        end
    end,

    remove_from_deck = function(self, card, from_debuff)
        if not from_debuff then
            for k, v in pairs(G.jokers.cards) do
                if v.ability.lich_id and v.ability.lich_id == card.ability.extra.lich_id then
                    v:remove_sticker("pow_tethered")
                    SMODS.debuff_card(v, true, "Lich")
                end
            end
        end
    end,

    update = function(self, card, dt)
        if G.jokers then
            for k, v in pairs(G.jokers.cards) do
                if v.ability.lich_id and v.ability.lich_id == card.ability.extra.lich_id then
                    if card.states.hover.is then
                        v.ability.lit_sticker = true
                    else
                        v.ability.lit_sticker = nil
                    end
                end
            end
        end
    end
}

SMODS.Sticker{
    key = "tethered",
    badge_colour = G.C.TETHERED,
    atlas = "Extras",
    pos = {x = 0, y = 1},

    loc_vars = function(self, info_queue, card)
        return {
            vars = { 
                colours = {
                    G.C.TETHERED
                }
            }
        }
    end,

    apply = function(self, card, val)
        card.ability[self.key] = val
        card.ability.eternal = val
    end,

    draw = function (self, card, layer)
        G.shared_stickers[self.key].role.draw_major = card
        if card.ability.lit_sticker then
            G.shared_stickers[self.key]:set_sprite_pos{x = 1, y = 1}
            G.shared_stickers[self.key]:draw_shader('dissolve', nil, nil, nil, card.children.center)
        else
            G.shared_stickers[self.key]:set_sprite_pos{x = 0, y = 1}
            G.shared_stickers[self.key]:draw_shader('dissolve', nil, nil, nil, card.children.center)
            G.shared_stickers[self.key]:draw_shader('voucher', nil, card.ARGS.send_to_shader, nil, card.children.center)
        end
    end
}

SMODS.Sticker:take_ownership("eternal",
    {
        draw = function(self, card, layer)
            if card.ability.pow_tethered then return end
            G.shared_stickers[self.key].role.draw_major = card
            G.shared_stickers[self.key]:draw_shader('dissolve', nil, nil, nil, card.children.center)
            G.shared_stickers[self.key]:draw_shader('voucher', nil, card.ARGS.send_to_shader, nil, card.children.center)
        end
    },
    true
)

local generate_UIBox_ability_table_ref = Card.generate_UIBox_ability_table
function Card:generate_UIBox_ability_table(...)
    local eternal_state = self.ability.eternal
    if self.ability.eternal and self.ability.pow_tethered then
        self.ability.eternal = false
    end

    local ret = generate_UIBox_ability_table_ref(self, ...)
    self.ability.eternal = eternal_state
    return ret;
end

----------------------------------------
----------------- FROG -----------------
----------------------------------------

SMODS.Joker{
    key = "Frog",
    rarity = 2,
    atlas = "Jokers",
    pos = {x = 2, y = 0},
    cost = 6,
    config = { extra = { ribbit = "Ribbit.", cardarea_behind = true } },

    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                card.ability.extra.ribbit
            }
        }
    end,

    calculate = function(self, card, context)
        if not context.blueprint and context.before and context.cardarea == G.jokers then
            local unscored_cards = {}
            for i=1, #context.full_hand do
                if not tableContains(context.scoring_hand, context.full_hand[i]) then
                    unscored_cards[i] = context.full_hand[i]
                end
            end
            if #unscored_cards > 0 then
                local v, k = pseudorandom_element(unscored_cards, pseudoseed("Frog"))

                local _card = copy_card(v, nil, nil, G.playing_card)
                v.can_calculate = function () return false end
                v.states.visible = false
                v.destroyed = true

                _card.states.pos_freeze = true
                card.ability.extra.cardarea:emplace(_card)

                G.E_MANAGER:add_event(Event({
                    func = function()
                        _card.states.pos_freeze = nil
                        v:remove()
                        return true
                    end
                }))
                card_eval_status_text(card, 'extra', nil, nil, nil, { message = "Ribbit", colour = G.C.green })
            end
        end
        if context.joker_main then
            local frogarea = card.ability.extra.cardarea
            if #frogarea.cards > 0 then
                G.E_MANAGER:add_event(Event({
                    func = function()
                        frogarea.alignment.offset = {x=2, y=0.2}
                        return true
                    end
                }))
                G.E_MANAGER:add_event(Event({
                    trigger = "after",
                    delay = 0.2,
                    func = function()
                        card.ability.extra.cardarea_behind = false
                        return true
                    end
                }))
                G.E_MANAGER:add_event(Event({
                    func = function()
                        frogarea.alignment.offset = {x=0, y=0.2}
                        return true
                    end
                }))

                for i=1,#frogarea.cards do
                    local c = frogarea.cards[i]
                    SMODS.score_card(c, {cardarea = G.play})

                    if i ~= #frogarea.cards then
                        G.E_MANAGER:add_event(Event({
                            trigger = "after",
                            delay = 0.1,
                            func = function()
                                c.states.riffle = true
                                return true
                            end
                        }))
                        G.E_MANAGER:add_event(Event({
                            trigger = "after",
                            delay = 0.1,
                            func = function()
                                c.states.riffle = nil
                                table.remove(frogarea.cards, 1)
                                table.insert(frogarea.cards, c)
                                return true
                            end
                        }))
                    end
                end

                G.E_MANAGER:add_event(Event({
                    func = function()
                        frogarea.alignment.offset = {x=2, y=0.2}
                        return true
                    end
                }))
                G.E_MANAGER:add_event(Event({
                    trigger = "after",
                    delay = 0.2,
                    func = function()
                        card.ability.extra.cardarea_behind = true
                        return true
                    end
                }))
                G.E_MANAGER:add_event(Event({
                    func = function()
                        frogarea.alignment.offset = {x=0, y=0.2}
                        return true
                    end
                }))
            end
        end
    end,

    add_to_deck = function (self, card, from_debuff)
        if not from_debuff then
            if math.random() < 0.25 then
                card.ability.extra.ribbit = "...Ribbit?"
            end
            
            if not G.Num_Frogs then
                G.Num_Frogs = 0
            end
            card.ability.extra.frog_id = G.Num_Frogs
            G.Num_Frogs = G.Num_Frogs + 1

            local area = FrogCardArea(
                0, 0, 
                G.CARD_W, G.CARD_H, 
                {card_limit = 0, type = 'frog', highlight_limit = 0, frog_id = G.Num_Frogs})

            card.ability.extra.cardarea = area
            card.children.cardarea = area
            area.parent = card
            area:set_alignment{major = card, type = "cm", offset = {x=0, y=0.2}}
            
            local card_draw_ref = card.draw
            card.draw = function(self, layer)
                self.ability.extra.cardarea.states.visible = true
                if self.ability.extra.cardarea and self.ability.extra.cardarea_behind then
                    self.ability.extra.cardarea:draw()
                    self.ability.extra.cardarea.states.visible = false
                end
                card_draw_ref(self, layer)
            end
        end
    end
}

FrogCardArea = CardArea:extend()
function FrogCardArea:draw()
    if self.states.visible then
        self:draw_boundingrect()
        add_to_drawhash(self)
    
        self.ARGS.draw_layers = self.ARGS.draw_layers or self.config.draw_layers or {'shadow', 'card'}
        for k, v in ipairs(self.ARGS.draw_layers) do
            for i = #self.cards, 1, -1 do 
                if self.cards[i] ~= G.CONTROLLER.focused.target or self == G.hand then
                    if G.CONTROLLER.dragging.target ~= self.cards[i] then self.cards[i]:draw(v) end
                end
            end
        end
    end
end
function FrogCardArea:align_cards()
    if not (G.STATE == G.STATES.TAROT_PACK or G.STATE == G.STATES.SPECTRAL_PACK  or G.STATE == G.STATES.PLANET_PACK) then
        for k, card in ipairs(self.cards) do
            if not card.states.drag.is then 
                card.T.r = 0.2*(-#self.cards/2 - 0.5 + k)/(#self.cards)+ (G.SETTINGS.reduced_motion and 0 or 1)*0.02*math.sin(2*G.TIMERS.REAL+card.T.x)

                if not card.states.pos_freeze then
                    local max_cards = math.max(#self.cards, self.config.temp_limit)
                    card.T.x = self.T.x + (self.T.w-self.card_w)*((k-1)/math.max(max_cards-1, 1) - 0.5*(#self.cards-max_cards)/math.max(max_cards-1, 1)) + 0.5*(self.card_w - card.T.w)

                    if card.states.riffle then
                        card.T.x = card.T.x + 2
                    end

                    local highlight_height = G.HIGHLIGHT_H
                    if not card.highlighted then highlight_height = 0 end
                    card.T.y = self.T.y + self.T.h/2 - card.T.h/2 - highlight_height + (G.SETTINGS.reduced_motion and 0 or 1)*0.03*math.sin(0.666*G.TIMERS.REAL+card.T.x) + math.abs(0.5*(-#self.cards/2 + k-0.5)/(#self.cards))-0.2
                    card.T.x = card.T.x + card.shadow_parrallax.x/30
                end
            end
        end
        -- table.sort(self.cards, function (a, b) return a.T.x + a.T.w/2 < b.T.x + b.T.w/2 end)
    end  
end

function tableContains(table, value)
    for i = 1,#table do
      if (table[i] == value) then
        return true
      end
    end
    return false
end

----------------------------------------------
------------MOD CODE END----------------------