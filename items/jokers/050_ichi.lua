return {
    mods = { 'RGMadcap' },
    data = {
        object_type = "Joker",
        key     = 'ichi',
        atlas   = 'placeholder',
        pos     = MLIB.coords(0,0),
        rarity  = 4,
        cost    = 12,
        config = { extra = { ranks = { 'Ace', MadLib.RankIds['1'] or '2' }, x_pow = 2 } },
        loc_vars = function(self, info_queue, card)
            return MadLib.collect_vars(localize(card.ability.extra.ranks[1], 'ranks'), localize(card.ability.extra.ranks[2], 'ranks'), card.ability.extra.x_pow)
        end,
        calculate = function(self, card, context)
            if context.individual and context.cardarea == G.play then
                return MadLib.list_matches_one(card.ability.extra.ranks, function(v)
                    return MadLib.is_rank(context.other_card, SMODS.Ranks[v].id)
                end) and {
                    x_pow = card.ability.extra.x_pow
                } or {}
            end
        end
    }
}
