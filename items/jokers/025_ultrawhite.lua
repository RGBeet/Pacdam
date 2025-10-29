function Pacdam.Funcs.hand_is_light(cards)
    return not MadLib.list_matches_one(cards, function(v)
        return v:has_dark_suit()
    end)
end

return {
    data = {
        object_type = "Joker",
        key     = 'ultrawhite',
        atlas   = 'placeholder',
        pos     = MLIB.coords(0,0),
        rarity  = 2,
        cost    = 6,
        config =  {
            extra = { pow = 0.1 },
        },
        loc_vars = function(self, info_queue, card)
            return MadLib.collect_vars(card.ability.extra.pow)
        end,
        calculate = function(self, card, context)
            if 
                (context.joker_main 
                and Pacdam.Funcs.hand_is_light(G.hand.cards))
                or context.forcetrigger
            then
                return { pow = card.ability.extra.pow }
            end
        end,
        demicoloncompat = true,
    }
}
