return {
    categories = {
        'Tags'
    },
    data = {
        object_type = "Tag",
        key     = "phish",
        atlas   = "tags",
        pos     = MLIB.coords(0,1),
        config = { fish = 1 },
        loc_vars = function(self, info_queue, tag)
            return MadLib.collect_vars(number_format(self.config.fish))
        end,
        in_pool = function()
            return true -- Always appears!
        end,
        apply = function(self, tag, context)
            if context.type == 'immediate' then
                local lock = tag.ID
                tag:yep("X", G.C.POW, function()
                    G.CONTROLLER.locks[lock] = nil
                    return true
                end)
                for i = 1, math.random(1,3) do
                    Pacdam.do_fish(nil)
                end
                tag.triggered = true
            return true
            end
        end
    }
}
