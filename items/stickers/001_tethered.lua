return {
    data = {
        object_type = 'Sticker',
        key = "tethered",
        badge_colour = G.C.TETHERED,
        atlas = "extras",
        pos = MLIB.coords(1,0),
        loc_vars = function(self, info_queue, card)
            return { vars = {  colours = { G.C.TETHERED } } }
        end,
        apply = function(self, card, val)
            card.ability[self.key]  = val
            card.ability.eternal    = val
        end,
        draw = function (self, card, layer)
            G.shared_stickers[self.key].role.draw_major = card
            if card.ability.lit_sticker then
                G.shared_stickers[self.key]:set_sprite_pos{x = 1, y = 1}
                G.shared_stickers[self.key]:draw_shader('dissolve', nil, nil, nil, card.children.center)
            else
                G.shared_stickers[self.key]:set_sprite_pos{x = 0, y = 1}
                G.shared_stickers[self.key]:draw_shader('dissolve', nil, nil, nil, card.children.center)
                G.shared_stickers[self.key]:draw_shader('voucher', nil, card.ARGS.send_to_shader, nil, card.children.center)
            end
        end
    }
}
