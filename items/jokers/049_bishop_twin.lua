return {
    data = {
        object_type = "Joker",
        key     = 'bishop_twin',
        atlas   = 'placeholder',
        pos     = MLIB.coords(0,0),
        rarity  = 4,
        cost    = 12,
        config =  {
            immutable = { pair_list = {0,0,0} },
            extra = { pow = 0.05, poker_hand = 'Pair' },
        },
        loc_vars = function(self, info_queue, card)
            local pairs_made = 0
            MadLib.loop_func(card.ability.immutable.pair_list, function(v)
                pairs_made = pairs_made + v
            end)
            return MadLib.collect_vars(number_format(card.ability.extra.pow), number_format(pairs_made * card.ability.extra.pow))
        end,
        calculate = function(self, card, context)
            
            if 
                context.cardarea == G.jokers 
                and context.before and 
                not context.blueprint 
            then
                if context.scoring_name == card.ability.extra.poker_hand then
                    card.ability.immutable.pair_list[1] = card.ability.immutable.pair_list[1] + 1
                    return nil, true
                end
            end

            if 
                context.joker_main 
                or context.forcetrigger
            then
                local pairs_made = 0
                MadLib.loop_func(card.ability.immutable.pair_list, function(v)
                    pairs_made = pairs_made + v
                end)
                return { pow = MadLib.multiply(card.ability.extra.pow, pairs_made) }
            end
            
		    if  
                context.end_of_round 
                and not context.game_over
                and context.cardarea == G.jokers  
            then
                --print(card.ability.immutable.pair_list)
                card.ability.immutable.pair_list[3] = card.ability.immutable.pair_list[2]
                card.ability.immutable.pair_list[2] = card.ability.immutable.pair_list[1]
                card.ability.immutable.pair_list[1] = 0
            end
        end,
    }
}
