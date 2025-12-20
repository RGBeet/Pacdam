--[[
"Held {V:1}#1#{} have a ",
                    "{C:green}#6# in #7#{} chance",
                    "to give {C:mult}+#4#{} Mult/{C:chips}+#5#{} Chips",
                    "per held {V:2}#2#{}/{V:3}#3#{}"
]]

return {
    data = {
        object_type = "Joker",
        key     = 'erythrite',
        atlas   = 'placeholder',
        pos     = MLIB.coords(0,0),
        rarity  = 3,
        cost    = 9,
        config =  {
            active = false,
            extra = { mult = 7, chips = 35, odds = 2, suits = { "Diamonds", "Clubs", "Spades" } }
        },
        loc_vars = function(self, info_queue, card)
            local _numer, _denom = SMODS.get_probability_vars(card, 1, card.ability.extra.odds, 'erythrite')
            return MadLib.collect_vars_colours(
                localize(card.ability.extra.suits[1], 'suits_plural'),
                localize(card.ability.extra.suits[2], 'suits_plural'),
                localize(card.ability.extra.suits[3], 'suits_plural'),
                number_format(card.ability.extra.mult),
                number_format(card.ability.extra.chips),
                number_format(_numer),
                number_format(_denom),
            {
                G.C.SUITS[card.ability.extra.suits[1]],
                G.C.SUITS[card.ability.extra.suits[2]],
                G.C.SUITS[card.ability.extra.suits[3]]
            })
        end,
        calculate = function(self, card, context)
            if
                context.cardarea == G.hand
                and context.other_card
                and not context.after
                and not context.before
                and not context.blueprint
            then
                if -- clubs or spades activates
                    context.other_card:is_suit(card.ability.extra.suits[1]) -- Diamonds
                then
                    local active = nil -- needs a diamond suit to activate
                    for i=1,#context.scoring_hand do
                    -- if club or spade suit
                        if context.scoring_hand[i] == context.other_card then
                            break -- bruh it's the same damn card
                        else
                            active = (context.scoring_hand[i]:is_suit(card.ability.extra.suits[2])
                                    and card.ability.extra.suits[2])
                                    or (context.scoring_hand[i]:is_suit(card.ability.extra.suits[3])
                                    and card.ability.extra.suits[3])
                            if active then
                                break -- we are done here
                            end
                        end
                    end
                    if active == card.ability.extra.suits[2] then
                        return { mult = card.ability.extra.mult, card = card }
                    elseif active == card.ability.extra.suits[3] then
                        return { chips = card.ability.extra.chips, card = card }
                    end
                end
            end

            if context.forcetrigger then
                return {
                    chips   = card.ability.extra.chips,
                    mult    = card.ability.extra.mult,
                    card    = card
                }
            end
        end,
        demicoloncompat = true,
    }
}
