SMODS.Joker{
    key = "Lich",
    rarity = 3,
    atlas = "Jokers",
    pos = {x = 6, y = 0},
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
            if G.GAME.Num_Liches then
                G.GAME.Num_Liches = G.GAME.Num_Liches + 1
            else
                G.GAME.Num_Liches = 1
            end
            card.ability.extra.lich_id = G.GAME.Num_Liches
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