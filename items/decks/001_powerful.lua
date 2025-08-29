return {
    categories = {
        'Decks',
    },
    data = {
        object_type = "Back",
        key     = "powerful",
        atlas   = 'decks',
        pos     = MLIB.coords(0,0),
        config = {
            ante_scaling = 1.25,
            pow = 0.15,
            x_mult = 0.75
        },
        loc_vars = function(self)
            return MadLib.collect_vars(self.config.pow, self.config.x_mult, self.config.ante_scaling)
        end,
        calculate = function(self, card, context)
            if context.final_scoring_step then
                pow = pow + self.config.pow
                mult = mod_mult(mult * self.config.x_mult)
                update_hand_text({delay = 0}, {
                    pow = pow,
                    mult = mult
                })
                MadLib.event({
                    delay   =  1.5,
                    func    = (function()
                        -- scored_card:juice_up()
                        play_sound('rgpd_pow_hit', 0.94, 0.3)
                        play_sound('rgpd_pow_hit', 0.94*1.5, 0.2)
                        play_sound('rgpd_e_glow', 1.5)

                        local colour = {0,0,0,0}
                        MadLib.loop_func({ G.C.UI_POW, G.C.UI_MULT }, function(x)
                            MadLib.loop_func(x, function(v,i)
                                colour[i] = colour[i]+v
                            end)
                        end)
                        MadLib.loop_func(colour, function(v,i)
                            colour[i] = v/2
                        end)
                        ease_colour(G.C.UI_POW, colour)
                        ease_colour(G.C.UI_MULT, colour)
                        MadLib.event({
                            trigger = 'after',
                            blockable = false,
                            blocking = false,
                            delay =  1.0,
                            func = (function()
                                    ease_colour(G.C.UI_POW, G.C.POW, 0.8)
                                    ease_colour(G.C.UI_MULT, G.C.RED, 0.8)
                                return true
                            end)
                        })
                        MadLib.event({
                            trigger = 'after',
                            blockable = false,
                            blocking = false,
                            no_delete = true,
                            delay =  1.5,
                            func = (function()
                                G.C.UI_POW[1], G.C.UI_POW[2], G.C.UI_POW[3], G.C.UI_POW[4] = G.C.POW[1], G.C.POW[2], G.C.POW[3], G.C.POW[4]
                                G.C.UI_MULT[1], G.C.UI_MULT[2], G.C.UI_MULT[3], G.C.UI_MULT[4] = G.C.RED[1], G.C.RED[2], G.C.RED[3], G.C.RED[4]
                                return true
                            end)
                        })
                        return true
                    end)
                })
            end
        end
    }
}
