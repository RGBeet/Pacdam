Pacdam.Joku = {
    default_sprite_pos  = MLIB.coords(1,2),
    animation_frames    = { MLIB.coords(1,3), MLIB.coords(1,4) }
}

return {
    data = {
        object_type = "Joker",
        key     = 'joku',
        atlas   = 'jokers',
        pos = Pacdam.Joku.default_sprite_pos,
        rarity  = 3,
        cost    = 8,
        config = { extra = { pow_bonus = 0, pow_rate = 0.1, animate = false } },
        update = function(self, card, dt)
            if not G.jokers then return end
            local should_animate = not card.ability.extra.animate
                and to_big(G.ARGS.score_intensity.earned_score) > to_big(G.ARGS.score_intensity.required_score)
                and to_big(G.ARGS.score_intensity.required_score) > to_big(0)
            if should_animate then
                card.ability.extra.animate = true
                juice_card_until(card, function () return card.ability.extra.animate end)
            end
            if not card.ability.extra.animate then
                card.children.center:set_sprite_pos(Pacdam.Joku.default_sprite_pos)
                return
            end
            -- oh shit animated joker?!
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
            if not context.blueprint and context.after and context.cardarea == G.jokers then
                if to_big(hand_chips ^ pow * mult) > to_big(G.GAME.blind.chips) then
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
        demicoloncompat = true,
    }
}
