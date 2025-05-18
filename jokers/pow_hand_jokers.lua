SMODS.Joker{
    key = "Twins",
    rarity = 1,
    atlas = "Jokers",
    pos = {x = 0, y = 0},
    cost = 4,
    config = { extra = { pow = 0.05 } },

    loc_vars = function(self, info_queue, card)
        return {
            vars = { card.ability.extra.pow }
        }
    end,

    calculate = function(self, card, context)
        if context.joker_main and next(context.poker_hands['Pair']) then
            return {
                pow = card.ability.extra.pow
            }
        end
    end,
}

SMODS.Joker{
    key = "Triplets",
    rarity = 1,
    atlas = "Jokers",
    pos = {x = 1, y = 0},
    cost = 4,
    config = { extra = { pow = 0.1 } },

    loc_vars = function(self, info_queue, card)
        return {
            vars = { card.ability.extra.pow }
        }
    end,

    calculate = function(self, card, context)
        if context.joker_main and next(context.poker_hands['Three of a Kind']) then
            return {
                pow = card.ability.extra.pow
            }
        end
    end,
}

SMODS.Joker{
    key = "Quadruplets",
    rarity = 1,
    atlas = "Jokers",
    pos = {x = 2, y = 0},
    cost = 4,
    config = { extra = { pow = 0.2 } },

    loc_vars = function(self, info_queue, card)
        return {
            vars = { card.ability.extra.pow }
        }
    end,

    calculate = function(self, card, context)
        if context.joker_main and next(context.poker_hands['Four of a Kind']) then
            return {
                pow = card.ability.extra.pow
            }
        end
    end,
}

SMODS.Joker{
    key = "Mob",
    rarity = 1,
    atlas = "Jokers",
    pos = {x = 3, y = 0},
    cost = 4,
    config = { extra = { pow = 0.1 } },

    loc_vars = function(self, info_queue, card)
        return {
            vars = { card.ability.extra.pow }
        }
    end,

    calculate = function(self, card, context)
        if context.joker_main and next(context.poker_hands['Straight']) then
            return {
                pow = card.ability.extra.pow
            }
        end
    end,
}

SMODS.Joker{
    key = "Squad",
    rarity = 1,
    atlas = "Jokers",
    pos = {x = 4, y = 0},
    cost = 4,
    config = { extra = { pow = 0.05 } },

    loc_vars = function(self, info_queue, card)
        return {
            vars = { card.ability.extra.pow }
        }
    end,

    calculate = function(self, card, context)
        if context.joker_main and next(context.poker_hands['Flush']) then
            return {
                pow = card.ability.extra.pow
            }
        end
    end,
}