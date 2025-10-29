function Pacdam.Funcs.hand_is_dark(cards)
    return not MadLib.list_matches_one(cards, function(v)
        return v:has_light_suit()
    end)
end

return {
    data = {
        object_type = "Joker",
        key     = 'vanta_black',
        atlas   = 'placeholder',
        pos     = MLIB.coords(0,0),
        rarity  = 2,
        cost    = 5,
        config =  {
            extra = { pow = 0.06 },
        },
        loc_vars = function(self, info_queue, card)
            return MadLib.collect_vars(card.ability.extra.pow)
        end,
        calculate = function(self, card, context)
            if 
                (context.joker_main 
                and context.full_hand
                and Pacdam.Funcs.hand_is_dark(context.full_hand))
                or context.forcetrigger
            then
                return { pow = card.ability.extra.pow }
            end
        end,
        demicoloncompat = true,
    }
}
