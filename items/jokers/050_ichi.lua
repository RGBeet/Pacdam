return {
    mods = { 'RGMadcap' },
    data = {
        object_type = "Joker",
        key     = 'ichi',
        atlas   = 'placeholder',
        pos     = MLIB.coords(0,0),
        rarity  = 4,
        cost    = 12,
        config = { extra = { ranks = { 'Ace', MadLib.RankIds['1'] or '2' }, x_pow = 1.5 } },
        loc_vars = function(self, info_queue, card)
            return MadLib.collect_vars(localize(card.ability.extra.ranks[1], 'ranks'), localize(card.ability.extra.ranks[2], 'ranks'), card.ability.extra.x_pow)
        end,
        calculate = function(self, card, context)
            if 
                (context.cardarea == G.play and context.other_card) 
                or context.forcetrigger
            then
                if
                    context.forcetrigger
                    or MadLib.is_rank(context.other_card, SMODS.Ranks[card.ability.extra.ranks[1]].id)
                    or MadLib.is_rank(context.other_card, SMODS.Ranks[card.ability.extra.ranks[2]].id)
                then
                    return { pow = MadLib.multiply(MadLib.subtract(1, pow), card.ability.extra.x_pow) }
                end
            end
        end
    }
}
