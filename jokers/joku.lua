local default_sprite_pos = { x = 2, y = 1 }
local animation_frames = {{ x = 3, y = 1 }, { x = 4, y = 1 }}

SMODS.Joker{
    key = "Joku",
    rarity = 2,
    atlas = "Jokers",
    pos = default_sprite_pos,
    cost = 6,
    config = { extra = { pow_bonus = 0, pow_rate = 0.1, animate = false } },

    update = function(self, card, dt)
        if not G.jokers then return end

        local should_animate = not card.ability.extra.animate and G.ARGS.score_intensity.earned_score >= G.ARGS.score_intensity.required_score and G.ARGS.score_intensity.required_score > 0
        if should_animate then
            card.ability.extra.animate = true
            juice_card_until(card, function () return card.ability.extra.animate end)
        end

		if not card.ability.extra.animate then 
            card.children.center:set_sprite_pos(default_sprite_pos)
            return 
        end

		local timer = (G.TIMERS.REAL * 8) 
		local frame_amount = #animation_frames
		local wrapped_value = (math.floor(timer) - 1) % frame_amount + 1
		card.children.center:set_sprite_pos(animation_frames[wrapped_value])
	end,

    loc_vars = function(self, info_queue, card)
        return {
            vars = { card.ability.extra.pow_rate, card.ability.extra.pow_bonus }
        }
    end,

    calculate = function(self, card, context)
        if context.joker_main then
            return { pow = card.ability.extra.pow_bonus }
        end
        if context.after and context.cardarea == G.jokers then
            if hand_chips^pow*mult > G.GAME.blind.chips then
                card.ability.extra.pow_bonus = card.ability.extra.pow_bonus + card.ability.extra.pow_rate
                card_eval_status_text(card, 'extra', nil, nil, nil, { message = "Power Up!", colour = G.C.GREEN })
                G.E_MANAGER:add_event(Event({
                    func = function()
                        card.ability.extra.animate = false
                        return true
                    end
                }))
            else
                card.ability.extra.pow_bonus = 0
                card_eval_status_text(card, 'extra', nil, nil, nil, { message = "Reset!", colour = G.C.GREEN })
            end
        end
    end,
}