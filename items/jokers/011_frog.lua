-- frog
local start_run_ref = Game.start_run
function Game:start_run(args)
    args = args or {}
    local saveTable = args.savetext or nil
    if saveTable and saveTable.GAME and saveTable.GAME.pow_frog then
        for i=1, saveTable.GAME.pow_frog do
            G["pow_frogarea_"..i] = FrogCardArea(
                0, 0,
                G.CARD_W, G.CARD_H,
                {card_limit = 3, type = 'frog', highlight_limit = 0})
        end
    end
    return start_run_ref(self, args)
end

FrogCardArea = CardArea:extend()
function FrogCardArea:update(dt)
    if self.states.animation then
        self.states.expand = false
        self.states.was_expand = false
        self.T.w = G.CARD_W
    else
        local expand = self.states.expand
        for k, card in ipairs(self.cards) do
            if card.states.hover.is or card.states.drag.is then
                expand = true
                break
            end
        end
        expand = expand
        for k, card in ipairs(self.cards) do
            card.states.hover.can = expand or self.states.was_expand
        end
        if expand then
            local num_cards = self.config.temp_limit
            self.alignment.offset = {x = -0.5*G.CARD_W*(num_cards+1), y=0}
            self.T.w = G.CARD_W * num_cards
        elseif not self.states.was_expand then
            self.alignment.offset = {x=0, y=0.2}
            self.T.w = G.CARD_W
        end
        self.states.was_expand = expand
    end

    CardArea.update(self, dt)
end
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
                    card.T.y = self.T.y + self.T.h/2 - card.T.h/2 - highlight_height + (G.SETTINGS.reduced_motion and 0 or 1)*0.03*math.sin(0.666*G.TIMERS.REAL+card.T.x) --+ math.abs(0.5*(-#self.cards/2 + k-0.5)/(#self.cards))-0.2
                    card.T.x = card.T.x + card.shadow_parrallax.x/30
                end
            end
        end
        if not self.states.animation then
            table.sort(self.cards, function (a, b) return a.T.x + a.T.w/2 < b.T.x + b.T.w/2 end)
        end
    end
end

Pacdam.Funcs.hook_frog = function(card)
    local card_draw_ref = card.draw
    card.draw = function(self, layer)
        if self.ability.extra.cardarea.states then
            self.ability.extra.cardarea.states.visible = true
            if self.ability.extra.cardarea and self.ability.extra.cardarea_behind then
                self.ability.extra.cardarea:draw()
                self.ability.extra.cardarea.states.visible = false
            end
        end
        card_draw_ref(self, layer)
    end

    local dissolve_ref = card.start_dissolve
    card.start_dissolve = function (self, dissolve_colours, silent, dissolve_time_fac, no_juice)
        self.children.cardarea = nil
        if self.ability.extra.cardarea.cards then
            for _, c in ipairs(self.ability.extra.cardarea.cards) do
                c:start_dissolve(nil, true)
            end
            SMODS.calculate_context({remove_playing_cards = true, removed = self.ability.extra.cardarea.cards})
        end
        G.E_MANAGER:add_event(Event({
            func = function()
                self.ability.extra.cardarea:remove()
                return true
            end
        }))
        dissolve_ref(self, dissolve_colours, silent, dissolve_time_fac, no_juice)
    end
end

return {
    data = {
        object_type = "Joker",
        key     = 'frog',
        atlas   = 'jokers',
        pos     = MLIB.coords(0,7),
        rarity  = 2,
        cost    = 6,
        config  = {  extra = {  ribbit = "Ribbit.",  odds = 4,  cardarea_behind = true  } },
        loc_vars = function(self, info_queue, card)
            local _numer, _denom = SMODS.get_probability_vars(card, 1, card.ability.extra.odds, 'frog')
            return MadLib.collect_vars(card.ability.extra.ribbit, number_format(_numer), number_format(_denom))
        end,
        update = function (self, card, dt)
            if card.ability.extra.cardarea then
                card.ability.extra.cardarea.states.expand = card.states.hover.is
            end
        end,
        calculate = function(self, card, context)
            if  context.before and not context.blueprint and context.cardarea == G.jokers  then
                local override = false
                if  SMODS.pseudorandom_probability(card, 'frog', 1, card.ability.extra.odds) or context.forcetrigger or override then
                    -- c
                    local unscored_cards = MadLib.get_unscored_cards(context)
                    if next(unscored_cards) then
                        local v = pseudorandom_element(unscored_cards, pseudoseed("frog"))

                        local _card = copy_card(v, nil, nil, G.playing_card)
                        v.can_calculate = function () return false end
                        v.states.visible = false
                        v.destroyed = true

                        _card.states.pos_freeze = true
                        card.ability.extra.cardarea:emplace(_card)

                        MadLib.event({
                            func = function()
                                _card.states.pos_freeze = nil
                                v:remove()
                                return true
                            end
                        })
                        card_eval_status_text(card, 'extra', nil, nil, nil, { message = "Ribbit!", colour = G.C.POW })
                    end
                end
            end
            if context.joker_main and context.blueprint then
                local pocket = card.ability.extra.cardarea
                if #pocket.cards > 0 then
                    MadLib.event({
                        func = function()
                            pocket.states.animation = true
                            pocket.alignment.offset = {x=2, y=0.1}
                            return true
                        end
                    })
                    MadLib.event({
                        trigger = "after",
                        delay = 0.2,
                        func = function()
                            card.ability.extra.cardarea_behind = false
                            return true
                        end
                    })
                    MadLib.event({
                        func = function()
                            pocket.alignment.offset.x = 0
                            return true
                        end
                    })
                    MadLib.loop_func(pocket.cards, function(c,i)
                        SMODS.score_card(c, {cardarea = G.play})
                        if i ~= #pocket.cards then
                            MadLib.event({
                                trigger = "after",
                                delay = 0.1,
                                func = function()
                                    c.states.riffle = true
                                    return true
                                end
                            })
                            MadLib.event({
                                trigger = "after",
                                delay = 0.1,
                                func = function()
                                    c.states.riffle = nil
                                    table.remove(pocket.cards, 1)
                                    table.insert(pocket.cards, c)
                                    return true
                                end
                            })
                        end
                    end)
                    MadLib.event({
                        func = function()
                            pocket.alignment.offset.x = 2
                            return true
                        end
                    })
                    MadLib.event({
                        trigger = "after",
                        delay = 0.2,
                        func = function()
                            card.ability.extra.cardarea_behind = true
                            return true
                        end
                    })
                    MadLib.event({
                        func = function()
                            pocket.states.animation = false
                            pocket.alignment.offset.x = 0
                            return true
                        end
                    })
                    MadLib.event({
                        trigger = "after",
                        delay = 0.1,
                        func = function()
                            table.insert(pocket.cards, table.remove(pocket.cards, 1))
                            return true
                        end
                    })
                end
            end
        end,
        add_to_deck = function (self, card, from_debuff)
            if not from_debuff then
                G.GAME.Num_Frogs = (G.GAME.Num_Frogs or 0) + 1
                if SMODS.pseudorandom_probability(card, 'frog', 1, card.ability.extra.odds) then
                    card.ability.extra.ribbit = "...Ribbit?"
                end
                --G.GAME.pow_frog = (G.GAME.pow_frog or 0) + 1
                card.ability.extra.frog_id = G.GAME.pow_frog
                local area = FrogCardArea(
                    0, 0,
                    G.CARD_W, G.CARD_H,
                    {card_limit = 0, type = 'frog', highlight_limit = 0})
                card.ability.extra.cardarea = area
                card.children.cardarea = area
                G["pow_frogarea_"..G.GAME.Num_Frogs] = area
                area.parent = card
                area:set_alignment{major = card, type = "cm", offset = {x=0, y=0.1}}
                Pacdam.Funcs.hook_frog(card)
            end
        end,
        load = function (self, card, card_table, other_card)
            local id = card_table and card_table.ability and card_table.ability.extra and card_table.ability.extra.frog_id or 1
            local area = G["pow_frogarea_".. tostring(id)]
            if not area then return false end
            card_table.ability.extra.cardarea = area
            area.parent = card
            area:set_alignment{major = card, type = "cm", offset = {x=0, y=0.1}}
            area:hard_set_T(card.T.x, card.T.y)
            G.E_MANAGER:add_event(Event({
                func = function()
                    card.children.cardarea = area
                    return true
                end
            }))
            Pacdam.Funcs.hook_frog(card)
        end,
        demicoloncompat = true,
    }
}
