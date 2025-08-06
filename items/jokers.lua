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

                fish.children.center:set_sprite_pos({ x = num_fish-1, y = 0 })
                fish:juice_up()

                card_eval_status_text(card, 'extra', nil, nil, nil, { message = "Caught one!", colour = G.C.FILTER })
            elseif 
                #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit 
            then
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

                card_eval_status_text(card, 'extra', nil, nil, nil, { message = "Caught one!", colour = G.C.FILTER })
            end
        end
    end
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
    fisherman
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
