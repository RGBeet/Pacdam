return {
    data = {
        object_type = "Joker",
        key     = 'wanted_poster',
        atlas   = 'placeholder',
        pos     = MLIB.coords(0,0),
        rarity  = 2,
        cost    = 5,
        config =  {
            extra = { money = 7 },
        },
        loc_vars = function(self, info_queue, card)
            local vars = MadLib.collect_vars_colours(
                    number_format(card.ability.extra.money),
                    localize(Madcap.Funcs.safe_get(G.GAME, "current_round", "rgpd_wanted_poster", "rank") or "5", "ranks"),
                    localize(G.GAME.current_round.rgpd_wanted_poster
                        and G.GAME.current_round.rgpd_wanted_poster.suit
                        or "Diamonds", "suits_plural"),
                    { G.C.SUITS[G.GAME.current_round.rgpd_wanted_poster and G.GAME.current_round.rgpd_wanted_poster.suit or "Diamonds"] })
            return vars
        end,
        calculate = function(self, card, context)
            if 
                context.destroy_card
                and context.other_card
                and not context.blueprint
                and MadLib.is_rank(context.other_card, G.GAME.current_round.rgpd_wanted_poster.id)
                and context.other_card:is_suit(G.GAME.current_round.rgpd_wanted_poster.suit)
            then -- has both suit and rank
                return { 
                    dollars = card.ability.extra.money, 
                    remove = true
                }
            end
        end,
    }
}
