return {
    categories = {
        'Editions'
    },
    data = {
        object_type = 'Consumable',
        set     = "Spectral",
        key     = "geist",
        atlas   = "extras",
        pos     = MLIB.get_coords(1,2),
        cost    = 4,
        config = { edition = 'e_rgpd_glow', max_highlighted = 1 },
        loc_vars = function(self, info_queue, card)
            MadLib.add_to_queue(G.P_CENTERS[card.ability.edition])
            return MadLib.collect_vars("glow", number_format(card.ability.max_highlighted or 1))
        end,
        can_use = function(self, card)
            return G.hand and #G.hand.highlighted > 0 and #G.hand.highlighted <= card.ability.max_highlighted
        end,
        use = function(self, card, area, copier) --Good enough
            MadLib.loop_func(G.hand.highlighted, function(v)
                MadLib.simple_event(function()
                    v:set_edition(card.ability.edition, true)
                    card:juice_up(0.3, 0.5)
                    return true
                end, 0.4, 'after')
            end)
        end,
    }
}
