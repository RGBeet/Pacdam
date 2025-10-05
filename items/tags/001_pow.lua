return {
    categories = {
        'Tags'
    },
    data = {
        object_type = "Tag",
        key     = "pow",
        atlas   = "tags",
        pos     = MLIB.coords(0,0),
        config = { pow = 0.10 },
        loc_vars = function(self, info_queue, tag)
            return MadLib.collect_vars(number_format(self.config.pow))
        end,
        in_pool = function()
            return true -- Always appears!
        end,
        apply = function(self, tag, context)
            if context.type == "final_scoring_step" then
                SMODS.calculate_effect({ pow = self.config.pow }, tag) -- add X2 Chips
            end
            if context.type == "eval" then -- Disappear at end of blind
                tag:yep("X", G.C.POW, function() return true end)
                tag.triggered = true
            end
        end
    }
}
