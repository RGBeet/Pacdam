return {
    categories = {
        'Editions',
    },
    data = {
        object_type = "Edition",
        key     = "glow",
        shader  = "glow",
        weight  = 1,
        extra_cost = 4,
        config  = { pow = 0.2 },
        sound = { sound = "rgpd_e_glow", per = 1, vol = 0.2, },
        get_weight = function(self)
            return G.GAME.edition_rate * self.weight
        end,
        loc_vars = function (self, info_queue, card)
            return MadLib.collect_vars(self.config.pow)
        end,
        calculate = function(self, card, context)
            if context.post_joker or (context.main_scoring and context.cardarea == G.play) then
                local card_pow = self.config.pow
                return {
                    func = function()
                        pow = pow + card_pow
                        update_hand_text({delay = 0}, {pow = card_pow})
                        card_eval_status_text(card, 'pow', card_pow)
                    end
                }
            end
        end,
    }
}
