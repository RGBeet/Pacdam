-- SMODS.Shader({ key = 'glowdark', path = 'glowdark.fs' })
-- SMODS.Shader({ key = 'glowbloom', path = 'glowbloom.fs' })
SMODS.Shader({ key = 'glow', path = 'glow.fs' })

-- SMODS.DrawStep {
--     key = 'bloom',
--     order = 21,
--     func = function(self, layer)
--         if (self.edition and self.edition.pow_Glow) then
--             self.children.center:draw_shader('pow_glowbloom', nil, self.ARGS.send_to_shader)
--         end
--     end,
--     conditions = { vortex = false, facing = 'front' },
-- }

SMODS.Edition{
    key = "Glow",
    shader = "glow",
    config = { pow = 0.5 },

    loc_vars = function (self, info_queue, card)
        return {
            vars = { self.config.pow }
        }
    end,

    calculate = function(self, card, context)
        if context.post_joker or (context.main_scoring and context.cardarea == G.play) then
            return {
                func = function()
                    local _pow = G.P_CENTERS.e_pow_Glow.config.pow
                    pow = pow + _pow
                    update_hand_text({delay = 0}, {pow = pow})
                    card_eval_status_text(card, 'pow', _pow)
                end
            }
        end
    end,

    -- draw = function (self, card, layer)
    --     if (card.edition and card.edition.pow_Glow) then
    --         card.children.center:draw_shader("pow_glowdark", nil, card.ARGS.send_to_shader)
    --         card.children.center:draw_shader("pow_glowbloom", nil, card.ARGS.send_to_shader)
    --         if card.children.front and card.ability.effect ~= 'Stone Card' and not card.config.center.replace_base_card then
    --             card.children.front:draw_shader("pow_glowdark", nil, card.ARGS.send_to_shader)
    --             card.children.front:draw_shader("pow_glowbloom", nil, card.ARGS.send_to_shader)
    --         end
    --     end
    -- end
}