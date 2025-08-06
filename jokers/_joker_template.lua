-- SMODS.Joker{
--     key = "key",
--     rarity = ,
--     atlas = "Jokers",
--     pos = {x = , y = },
--     cost = ,
--     config = { extra = {  } },

--     loc_vars = function(self, info_queue, card)
--         return {
--             vars = { card.ability.extra.pow }
--         }
--     end,

--     calculate = function(self, card, context)
        
--     end,
-- }


--[[
-- 8. Penrose Stairs
local penrose_stairs = {
    key     = 'penrose_stairs',
    atlas   = sprites,
    pos     = get_pos(0,7),
    rarity  = 1,
    cost    = 4,
    unlocked            = true,
    discovered          = true,
    eternal_compat      = true,
    perishable_compat   = true,
    blueprint_compat    = true,
    demicoloncompat     = true,
    config = {
        extra = {  times = 1 },
        immutable = { odds = 6 }
    },
    loc_vars = function(self, info_queue, card)
        local _numer, _denom = SMODS.get_probability_vars(card, 1, card.ability.immutable.odds, 'penrose_stairs')
        return MadLib.collect_vars(_numer, _denom, card.ability.extra.times)
    end,
    calculate = function (self, card, context)
        if context.joker_main then
            local cards = {}
            for i, v in ipairs(G.play.cards) do
                if 
                    SMODS.pseudorandom_probability(card, 'penrose_stairs', 1, card.ability.immutable.odds)
                    and not v:is_rankless()
                then
                    cards[#cards+1]=v
                end
            end
            MadLib.flip_cards(cards, function(v)
                assert(SMODS.modify_rank(v, card.ability.extra.times))
            end)
        end
    end,
}

]]