local get_pos = function(_y,_x)
    return { x = _x, y = _y }
end

local power_of_two = {
    key     = 'power_of_two',
    pos     = get_pos(0,0),
    rarity  = 2,
    cost    = 7,
    demicoloncompat = true,
    config =  {
        extra = { pow = 0.05 }
    },
    loc_vars = function(self, info_queue, card)
        return MadLib.collect_vars(number_format(card.ability.extra.pow))
    end,
    calculate = function(self, card, context)
        if 
            (context.joker_main and next(context.poker_hands['Pair'])) 
            or context.forcetrigger    
        then
            return { pow = card.ability.extra.pow }
        end
    end
}

local power_of_three = {
    key     = 'power_of_three',
    pos     = get_pos(0,1),
    rarity  = 2,
    cost    = 7,
    demicoloncompat = true,
    config =  {
        extra = { pow = 0.10 }
    },
    loc_vars = function(self, info_queue, card)
        return MadLib.collect_vars(number_format(card.ability.extra.pow))
    end,
    calculate = function(self, card, context)
        if 
            (context.joker_main and next(context.poker_hands['Three of a Kind'])) 
            or context.forcetrigger    
        then
            return { pow = card.ability.extra.pow }
        end
    end
}

local power_of_four = {
    key     = 'power_of_four',
    pos     = get_pos(0,2),
    rarity  = 3,
    cost    = 10,
    demicoloncompat = true,
    config =  {
        extra = { pow = 0.10 }
    },
    loc_vars = function(self, info_queue, card)
        return MadLib.collect_vars(number_format(card.ability.extra.pow))
    end,
    calculate = function(self, card, context)
        if 
            (context.joker_main and next(context.poker_hands['Four of a Kind'])) 
            or context.forcetrigger    
        then
            return { pow = card.ability.extra.pow }
        end
    end
}

local power_series = {
    key     = 'power_series',
    pos     = get_pos(0,3),
    rarity  = 2,
    cost    = 7,
    demicoloncompat = true,
    config =  {
        extra = { pow = 0.07 }
    },
    loc_vars = function(self, info_queue, card)
        return MadLib.collect_vars(number_format(card.ability.extra.pow))
    end,
    calculate = function(self, card, context)
        if 
            (context.joker_main and next(context.poker_hands['Straight'])) 
            or context.forcetrigger    
        then
            return { pow = card.ability.extra.pow }
        end
    end
}

local power_set = {
    key     = 'power_set',
    pos     = get_pos(0,4),
    rarity  = 2,
    cost    = 7,
    demicoloncompat = true,
    config =  {
        extra = { pow = 0.05 }
    },
    loc_vars = function(self, info_queue, card)
        return MadLib.collect_vars(number_format(card.ability.extra.pow))
    end,
    calculate = function(self, card, context)
        if 
            (context.joker_main and next(context.poker_hands['Flush'])) 
            or context.forcetrigger    
        then
            return { pow = card.ability.extra.pow }
        end
    end
}

local biker = {
    key     = "biker",
    rarity  = 2,
    pos     = get_pos(1,6),
    cost    = 8,
    demicoloncompat = true,
    config      = { extra = { pow = 0.01, mult = -1 } },
    loc_vars    = function(self, info_queue, card)
        return MadLib.collect_vars(number_format(card.ability.extra.pow), number_format(card.ability.extra.mult))
    end,

    calculate   = function(self, card, context)
        if 
            (context.individual and context.cardarea == G.play)
            or (context.forcetrigger and context.scoring_hand)
        then
            local target = not context.forcetrigger and context.other_card.ability or pseudorandom_element(context.scoring_hand,pseudoseed('biker'))
            if target then 
                target.perma_pow    = target.perma_pow or 0
                target.perma_mult   = target.perma_mult or 0
                target.perma_pow    = target.perma_pow + card.ability.extra.pow
                target.perma_mult   = target.perma_mult - card.ability.extra.mult
                return {
                    extra = {message = localize('k_upgrade_ex'), colour = G.C.POW},
                    colour = G.C.POW,
                    card = card
                }
            end
        end
    end
}

function Pacdam.Funcs.calculate_broker_rate(pow_rate, dollar_rate)
    return math.floor(G.GAME.dollars / dollar_rate) * pow_rate
end

local broker = {
    key     = "broker",
    rarity  = 2,
    pos     = get_pos(0,8),
    cost    = 6,
    demicoloncompat = true,
    config  = { extra = { pow_mod = 0.02, money = 5 } },
    loc_vars = function(self, info_queue, card)
        return MadLib.collect_vars(number_format(card.ability.extra.pow_mod), number_format(card.ability.extra.money), number_format(Pacdam.Funcs.calculate_broker_rate(card.ability.extra.pow_mod, card.ability.extra.money)))
    end,
    calculate = function(self, card, context)
        if 
            context.joker_main
            or context.forcetrigger
        then
            return { pow = Pacdam.Funcs.calculate_broker_rate(card.ability.extra.pow_mod,card.ability.extra.money) }
        end
    end,
}

local chameleon_ball = {
    key     = "chameleon_ball",
    rarity  = 3,
    pos     = get_pos(1,7),
    cost    = 6,
    config  = { extra = { pow = 0.08 } },
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS.m_wild
        return MadLib.collect_vars(number_format(card.ability.extra.pow))
    end,

    calculate = function(self, card, context)
        if 
            (context.individual 
            and context.cardarea == G.hand 
            and not context.end_of_round 
            and not context.other_card.debuff 
            and SMODS.has_enhancement(context.other_card, "m_wild"))
            or context.forcetrigger
        then
            return {
                pow = card.ability.extra.pow,
                card = context.other_card,
                message = localize{"a_pow"}
            }
        end
    end,
}

local countess = {
    key     = "countess",
    rarity  = 3,
    pos     = get_pos(0,6),
    cost    = 8,
    config  = { extra = { countess_id = -1 } },

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
            repeat
                joker_key = pseudorandom_element(pool, pseudoseed(pool_key))
            until G.P_CENTERS[joker_key].eternal_compat and joker_key ~= "j_rgpd_countess"

            local new_card = SMODS.add_card({ key = joker_key })
            new_card:set_edition('e_negative', true)
            SMODS.Stickers['pow_tethered']:apply(new_card, true)

            new_card.ability.countess_id = card.ability.extra.countess_id
        end
    end,

    add_to_deck = function (self, card, from_debuff)
        if not from_debuff then
            G.GAME.pow_countess = (G.GAME.pow_countess or 0) + 1
            card.ability.extra.countess_id = G.GAME.pow_countess
        end
    end,

    remove_from_deck = function(self, card, from_debuff)
        if not from_debuff then
            MadLib.loop_func(G.jokers.cards, function(v)
                if v.ability.countess_id and v.ability.countess_id == card.ability.extra.countess_id then
                    v:remove_sticker("pow_tethered")
                    SMODS.debuff_card(v, true, "Countess")
                end
            end)
        end
    end,

    update = function(self, card, dt)
        if G.jokers then
            for _, v in pairs(G.jokers.cards) do
                if v.ability.countess_id and v.ability.countess_id == card.ability.extra.countess_id then
                    v.ability.lit_sticker = card.states.hover.is and true or nil
                end
            end
        end
    end
}

local fisherman = {
    key     = "fisherman",
    rarity  = 2,
    pos     = get_pos(0,5),
    cost    = 6,
    blueprint_compat = true,
    loc_vars = function(self, info_queue, card)
		info_queue[#info_queue + 1] = G.P_CENTERS.c_pow_Fish
	end,
    calculate = function(self, card, context)
        if context.pre_discard then
            local fish
            
            MadLib.loop_func(G.consumeables.cards, function(v)
                if v.config.center.key == "c_pow_fish" and f.ability.extra.num_fish < 5 then fish = v end
            end)
            
            if fish then
                local num_fish = fish.ability.extra.num_fish
                num_fish = num_fish + 1
                fish.ability.extra.num_fish = num_fish

                fish.sell_cost = num_fish - 1

                fish.children.center:set_sprite_pos({ x = num_fish - 1, y = 0 })
                fish:juice_up()

                card_eval_status_text(card, 'extra', nil, nil, nil, { message = "Caught one!", colour = G.C.FILTER })
            elseif 
                #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit 
            then
                G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
                
                fish = SMODS.add_card({area = G.consumeables, key = "c_pow_Fish"})
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
                card_eval_status_text(card, 'extra', nil, nil, nil, { message = "Caught one!", colour = G.C.FILTER })
            end
        end
    end
}

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

function MadLib.get_unscored_cards(context)
    if not context or type(context) ~= 'table' or (context.full_hand and context.scoring_hand) then return {} end
    return MadLib.get_list_matches(context.full_hand, function(v)
        return list_matches_all(context.scoring_hand, function(v2)
            return v ~= v2
        end)
    end)
end

local frog = {
    key     = "frog",
    rarity  = 2,
    pos     = get_pos(0,7),
    cost    = 6,
    config  = { 
        extra = { 
            ribbit = "Ribbit.", 
            odds = 4, 
            cardarea_behind = true 
        }
    },
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
        if 
            not context.blueprint 
            and context.before 
            and context.cardarea == G.jokers 
        then
            local override = false
            if 
                SMODS.pseudorandom_probability(card, 'frog', 1, card.ability.extra.odds) 
                or context.forcetrigger or override 
            then
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
        if 
            not context.blueprint 
            and context.joker_main 
        then
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
            if SMODS.pseudorandom_probability(card, 'frog', 1, card.ability.extra.odds) then
                card.ability.extra.ribbit = "...Ribbit?"
            end
            G.GAME.pow_frog = (G.GAME.pow_frog or 0) + 1 
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
        local area = G["pow_frogarea_"..card_table.ability.extra.frog_id]
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
    end
}

local power_bluff = {
    key     = "power_bluff",
    rarity  = 1,
    atlas   = "Jokers",
    pos     = {x = 5, y = 1},
    cost    = 4,
    demicoloncompat = true,
    config = { extra = { pow = 1, mult = -20 } },
    loc_vars = function(self, info_queue, card)
        return MadLib.collect_vars(number_format(card.ability.extra.pow), number_format(card.ability.extra.mult))
    end,
    calculate = function(self, card, context)
        if context.setting_blind then
            ease_hands_played(1 - G.GAME.current_round.hands_left)
        end
        if context.joker_main or context.forcetrigger then
            return {
                pow     = card.ability.extra.pow,
                mult    = card.ability.extra.mult
            }
        end
    end,
}

Pacdam.Joku = {
    default_sprite_pos  = get_pos(1,2)
    animation_frames    = { get_pos (1,3), get_pos(1,4) }
}

local joku = {
    key = "joku",
    rarity = 3,
    atlas = "Jokers",
    pos = Pacdam.Joku.default_sprite_pos,
    cost = 8,
    config = { extra = { pow_bonus = 0, pow_rate = 0.1, animate = false } },
    update = function(self, card, dt)
        if not G.jokers then return end

        local should_animate = not card.ability.extra.animate and G.ARGS.score_intensity.earned_score >= G.ARGS.score_intensity.required_score and G.ARGS.score_intensity.required_score > 0
        if should_animate then
            card.ability.extra.animate = true
            juice_card_until(card, function () return card.ability.extra.animate end)
        end

		if not card.ability.extra.animate then 
            card.children.center:set_sprite_pos(Pacdam.Joku.default_sprite_pos)
            return 
        end

		local timer = (G.TIMERS.REAL * 8) 
		local frame_amount = #Pacdam.Joku.animation_frames
		local wrapped_value = (math.floor(timer) - 1) % frame_amount + 1
		card.children.center:set_sprite_pos(Pacdam.Joku.animation_frames[wrapped_value])
	end,
    loc_vars = function(self, info_queue, card)
        return MadLib.collect_vars(number_format(card.ability.extra.pow_rate), number_format(card.ability.extra.pow_bonus))
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            return { pow = card.ability.extra.pow_bonus }
        end
        if 
            not context.blueprint 
            and context.after 
            and context.cardarea == G.jokers 
        then
            if hand_chips ^ pow * mult > G.GAME.blind.chips then
                card.ability.extra.pow_bonus = card.ability.extra.pow_bonus + card.ability.extra.pow_rate
                card_eval_status_text(card, 'extra', nil, nil, nil, { message = "Power Up!", colour = G.C.POW })
                MadLib.event({
                    func = function()
                        card.ability.extra.animate = false
                        return true
                    end
                })
            else
                card.ability.extra.pow_bonus = 0
                card_eval_status_text(card, 'extra', nil, nil, nil, { message = "Reset!", colour = G.C.POW })
            end
        end
    end,
}

local power_play = {
    key     = "power_play",
    rarity  = 3,
    pos     = get_pos(1,1)
    cost    = 7,
    config = { extra = { pow = 0.21 } },
    demicoloncompat = true,
    loc_vars = function(self, info_queue, card)
        return MadLib.collect_vars(number_format(card.ability.extra.pow))
    end,
    calculate = function(self, card, context)
        if context.joker_main and context.cardarea == G.jokers then
            local sum = 0
            MadLib.loop_func(G.play.cards, function(v)
                sum = sum + (not SMODS.has_no_rank(v) and (sum + v.base.nominal) or 0)
            end)
            if sum == 21 then
                return { pow = card.ability.extra.pow }
            end
        end
        if context.forcetrigger then
            return { pow = card.ability.extra.pow }
        end
    end,
}

local reverse_card = {
    key     = "reverse_card",
    rarity  = 1,
    atlas   = "Jokers",
    pos     = get_pos(1,0)
    cost    = 4,
    blueprint_compat    = true,
    demicoloncompat     = true,
    calculate = function(self, card, context)
        if context.joker_main or context.forcetrigger then
            return { 
                swap = true,
                message = "Reversed!", 
                colour = G.C.attention
            }
        end
    end
}

local hook_superhero = function (card)
    local flip_ref = card.flip
    function card:flip(super_flip)
        if super_flip then
            self.ability.extra.super_active = not self.ability.extra.super_active
            self.flipping = 'super'
            self.pinch.x = true
        else
            flip_ref(self)
        end
    end
end

local superhero = {
    key     = "superhero",
    rarity  = 2,
    pos     = get_pos(1,9),
    cost    = 6,
    config  = { 
        extra = { 
            pow = 0.5, 
            super_active = true, 
            queue_flip = false 
        } 
    },
    loc_vars = function(self, info_queue, card)
        if card.ability.extra.super_active then
            if not card.fake_card then
                info_queue[#info_queue+1] = { 
                    key = "j_rgpd_alter_ego", 
                    set = "Joker",
                    config = { 
                        extra = { 
                            pow = 0.5, 
                            super_active = false, 
                            queue_flip = false 
                        } 
                    },
                }
            end
            return {
                key = "j_rgpd_superhero",
                vars = { card.ability.extra.pow }
            }
        else
            if not card.fake_card then
                info_queue[#info_queue+1] = G.P_CENTERS.j_pow_Superhero
            end
            return {
                key = "j_rgpd_alter_ego"
            }
        end
    end,
    calculate = function(self, card, context)
        if not card.ability.extra.super_active and context.setting_blind and G.GAME.blind.boss and context.cardarea == G.jokers then
            MadLib.event({
                func = function ()
                    card:flip(true); play_sound('card1', percent); card:juice_up(0.3, 0.3); delay(0.3); return true
                end
            })
        end

        if card.ability.extra.super_active then
            if context.before and context.cardarea == G.jokers then
                card.ability.extra.queue_flip = context.scoring_name == MadLib.get_most_played_hand()
            end
            if context.joker_main or context.forcetrigger then
                return { pow = card.ability.extra.pow }
            end
        end

        if context.after and context.cardarea == G.jokers and card.ability.extra.queue_flip then
            card.ability.extra.queue_flip = false
            MadLib.event({
                func = function ()
                    card:flip(true)
                    play_sound('card1', percent)
                    card:juice_up(0.3, 0.3)
                    delay(0.3)
                    return true
                end
            })
        end
    end,
    --[[
    set_sprites = function (self, card, front)
        if card.children.back then card.children.back:remove() end
        card.children.back = Sprite(card.T.x, card.T.y, card.T.w, card.T.h, G.ASSET_ATLAS["pow_Jokers"], { x = 8, y = 1 })
        card.children.back.states.hover = card.states.hover
        card.children.back.states.click = card.states.click
        card.children.back.states.drag = card.states.drag
        card.children.back.states.collide.can = false
        card.children.back:set_role({ major = card, role_type = 'Glued', draw_major = card })
        if card.ability and not (card.ability.extra and card.ability.extra.super_active) then
            card.sprite_facing = card.facing == "front" and "back" or "front"
        end
    end,
    ]]
    update = function (self, card, dt)
        if card.VT.w <= 0 then
            if card.flipping == 'super' then
                card.pinch.x = false
            end
            if not card.ability.extra.super_active then
                card.sprite_facing = card.facing == "front" and "back" or "front"
            else
                card.sprite_facing = card.facing
            end
        end
    end,
    add_to_deck = function (self, card, from_debuff)
        if not from_debuff then
            hook_superhero(card)
            if not card.ability.extra.super_active then
                card.sprite_facing = card.facing == "front" and "back" or "front"
            end
        end
    end,
    load = function (self, card, card_table, other_card)
        hook_superhero(card)
        if not card_table.ability.extra.super_active then
            card.sprite_facing = card.facing == "front" and "back" or "front"
        end
    end
}

local uranium_glass = {
    key     = "uranium_glass",
    rarity  = 2,
    atlas   = "Jokers",
    pos     = {x = 9, y = 0},
    cost    = 6,
    config  = { extra = { pow = 0.06 } },
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS.m_stone
        return MadLib.collect_vars(number_format(card.ability.extra.pow))
    end,
    calculate = function(self, card, context)
        if 
            (context.individual 
            and context.cardarea == G.hand 
            and not context.end_of_round 
            and not context.other_card.debuff 
            and SMODS.has_enhancement(context.other_card, "m_stone"))
            or context.forcetrigger
        then
            return {
                pow = card.ability.extra.pow,
                card = context.other_card,
                message = localize{"a_pow"}
            }
        end
    end,
}

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

SMODS.ConsumableType{
    key = "Fish",
    primary_colour = G.C.FISH,
    secondary_colour = G.C.FISH,
}

locah fish = {
    object_type = Consumable,
    key         = "fish",
    set         = "Fish",
    atlas       = "Extras",
    pos         = get_pos(0,0)
    no_collection = true,
    config = { extra = { num_fish = 0, max_fish = 5 } },
    loc_vars = function (self, info_queue, card)
        return MadLib.collect_vars(number_format(card.ability.extra.num_fish), number_format(card.ability.extra.max_fish))
    end,
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

local list = {
    fish
}

local jokers = {
    power_of_two,
    power_of_three,
    power_of_four,
    power_series,
    power_set,
    biker,
    broker,
    chameleon_ball,
    countess,
    fisherman,
    frog,
    power_bluff,
    joku,
    power_play,
    reverse_card,
    superhero,
    uranium_glass
}

MadLib.loop_func(jokers, function(v,i)
    v.object_type           = 'Joker'
    v.atlas                 = 'jokers'
    v.unlocked              = v.unlocked or true
    v.discovered            = v.discovered or true
    v.eternal_compat        = v.eternal_compat or true
    v.perishable_compat     = v.perishable_compat or true
    v.blueprint_compat      = v.blueprint_compat or true
    v.order                 = i
    table.insert(list,v)
end)

return {
    name = "Jokers",
    init = function() 
        SMODS.Sticker{
            key = "tethered",
            badge_colour = G.C.TETHERED,
            atlas = "Extras",
            pos = {x = 0, y = 1},

            loc_vars = function(self, info_queue, card)
                return {
                    vars = { 
                        colours = { G.C.TETHERED }
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
    end,
    items = jokers,
}
