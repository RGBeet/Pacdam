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
                pow = mod_pow(pow + self.config.pow)
                mult = mod_mult(mult * self.config.x_mult)
                update_hand_text({delay = 0}, {
                    pow = pow,
                    mult = mult
                })
                G.E_MANAGER:add_event(Event({
                    func = (function()
                        play_sound('gong', 0.94, 0.3)
                        play_sound('gong', 0.94*1.5, 0.2)
                        play_sound('tarot1', 1.5)
                        return true
                    end)
                }))
            end
        end
    }
}
