return {
    categories = {
        'Enhancements'
    },
    data = {
        object_type = 'Consumable',
        set     = "Tarot",
        key     = "deluge",
        atlas   = "extras",
        pos     = MLIB.get_coords(1,4),
        cost    = 5,
        config  = { max_highlighted = 1, mod_conv = 'm_rgpd_flux' },
        loc_vars = function(self, info_queue, card)
            MadLib.add_to_queue(G.P_CENTERS[card.ability.mod_conv])
            return MadLib.collect_vars(number_format(card.ability.max_highlighted), G.localization.descriptions.Enhanced[card.ability.mod_conv].name)
        end,
        can_use = function(self, card)
            return MadLib.can_use_transform_tarot(card)
        end,
    }
}
