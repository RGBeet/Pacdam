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

return {
    data = {
        object_type = "Joker",
        key     = 'superhero',
        atlas   = 'jokers',
        pos     = MLIB.coords(1,9),
        rarity  = 3,
        cost    = 9,
        config  = { extra = { pow = 0.5, super_active = true, queue_flip = false } },
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
                    key     = "j_rgpd_superhero",
                    vars    = { card.ability.extra.pow },
                    card    = card
                }
            else
                if not card.fake_card then info_queue[#info_queue+1] = G.P_CENTERS.j_rgpd_superhero end
                return { key = "j_rgpd_alter_ego", card = card }
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
}
