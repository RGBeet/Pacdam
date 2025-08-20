SMODS.ConsumableType{
    key = "Fish",
    primary_colour = G.C.FISH,
    secondary_colour = G.C.FISH,
}

-- fuck it, just do it here if fisherman is enabled.
SMODS.Consumable({
    key         = "fish",
    set         = "Fish",
    atlas       = "extras",
    pos         = MLIB.coords(0,0),
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
})

return {
    data = {
        object_type = "Joker",
        key     = 'fisherman',
        atlas   = 'jokers',
        pos     = MLIB.coords(0,5),
        rarity  = 2,
        cost    = 6,
        loc_vars = function(self, info_queue, card)
            info_queue[#info_queue + 1] = G.P_CENTERS.c_rgpd_fish
        end,
        calculate = function(self, card, context)
            if context.pre_discard then
                local fish
                MadLib.loop_func(G.consumeables.cards, function(v)
                    if v.config.center.key == "c_rgpd_fish" and f.ability.extra.num_fish < 5 then fish = v end
                end)
                if fish then
                    local num_fish = fish.ability.extra.num_fish
                    num_fish = num_fish + 1
                    fish.ability.extra.num_fish = num_fish
                    fish.sell_cost = num_fish - 1
                    fish.children.center:set_sprite_pos({ x = num_fish - 1, y = 0 })
                    fish:juice_up()
                    card_eval_status_text(card, 'extra', nil, nil, nil, { message = "Caught one!", colour = G.C.FILTER })
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
                    card_eval_status_text(card, 'extra', nil, nil, nil, { message = "Caught one!", colour = G.C.FILTER })
                end
            end
        end,
        demicoloncompat = true,
    }
}
