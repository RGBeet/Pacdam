SMODS.Joker{
    key = "power_play",
    rarity = 1,
    atlas = "Jokers",
    pos = {x = 1, y = 1},
    cost = 4,
    config = { extra = { pow = 0.21 } },

    loc_vars = function(self, info_queue, card)
        return {
            vars = { card.ability.extra.pow }
        }
    end,

    calculate = function(self, card, context)
        if context.joker_main and context.cardarea == G.jokers then
            local sum = 0
            for i,v in ipairs(G.play.cards) do
                if not SMODS.has_no_rank(v) then
                    sum = sum + v.base.nominal
                end
            end
            if sum == 21 then
                return {
                    pow = card.ability.extra.pow
                }
            end
        end
    end,
}