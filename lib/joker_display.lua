if JokerDisplay then
    local jod = JokerDisplay.Definitions
    tell("LOADING JOKERDISPLAY VALUES FOR PACDAM")

    -- Use this for all
    local poker_hand_pow = {
        text = {
            {
                border_nodes = {
                    { text = "+" },
                    { ref_table = "card.joker_display_values", ref_value = "pow", retrigger_type = "mult" },
                    { text = " Pow" },
                },
                border_colour = G.C.POW
            }
        },
        reminder_text = {
            { text = "(" },
            { ref_table = "card.joker_display_values", ref_value = "localized_text", colour = G.C.ORANGE },
            { text = ")" },
        },
        calc_function = function(card)
            local pow = 0
            local _, poker_hands, _ = JokerDisplay.evaluate_hand()
            if poker_hands[card.ability.extra.poker_hand] and next(poker_hands[card.ability.extra.poker_hand]) then
                pow = card.ability.extra.pow
            end
            card.joker_display_values.pow = pow
            card.joker_display_values.localized_text = localize(card.ability.extra.poker_hand, 'poker_hands')
        end
    }

    jod['j_rgpd_power_of_two']      = poker_hand_pow
    jod['j_rgpd_power_of_three']    = poker_hand_pow
    jod['j_rgpd_power_of_four']     = poker_hand_pow 
    jod['j_rgpd_power_series']      = poker_hand_pow
    jod['j_rgpd_power_set']         = poker_hand_pow

    jod['j_rgpd_chameleon'] = {
        text = {
            {
                border_nodes = {
                    { text = "+" },
                    { ref_table = "card.joker_display_values", ref_value = "pow", retrigger_type = "mult" },
                    { text = " Pow" },
                },
                border_colour = G.C.POW
            }
        },
        calc_function = function(card)
            local pow = 0
            local _, _, scoring_hand = JokerDisplay.evaluate_hand()
            MadLib.loop_func(scoring_hand, function(v)
                if not v.debuff and SMODS.has_enhancement(v, "m_wild") then
                    pow = MadLib.add(pow, card.ability.extra.pow)
                end
            end)
            card.joker_display_values.pow = pow
        end
    }

    jod['j_rgpd_uranium_glass'] = {
        text = {
            {
                border_nodes = {
                    { text = "+" },
                    { ref_table = "card.joker_display_values", ref_value = "pow", retrigger_type = "mult" },
                    { text = " Pow" },
                },
                border_colour = G.C.POW
            }
        },
        calc_function = function(card)
            local pow = 0
            local _, _, scoring_hand = JokerDisplay.evaluate_hand()
            MadLib.loop_func(scoring_hand, function(v)
                if not v.debuff and SMODS.has_enhancement(v, "m_stone") then
                    pow = MadLib.add(pow, card.ability.extra.pow)
                end
            end)
            card.joker_display_values.pow = pow
        end
    }

    jod['j_rgpd_broker'] = {
        text = {
            {
                border_nodes = {
                    { text = "+" },
                    { ref_table = "card.joker_display_values", ref_value = "pow", retrigger_type = "mult" },
                    { text = " Pow" },
                },
                border_colour = G.C.POW
            }
        },
        calc_function = function(card)
            card.joker_display_values.pow = Pacdam.Funcs.calculate_broker_rate(card.ability.extra.pow_mod, card.ability.extra.money)
        end
    }

    jod['j_rgpd_power_bluff'] = {
        text = {
            {
                border_nodes = {
                    { text = "+" },
                    { ref_table = "card.ability.extra", ref_value = "pow", retrigger_type = "mult" },
                    { text = " Pow" },
                },
                border_colour = G.C.POW
            }
        }
    }

    jod['j_rgpd_joku'] = {
        text = {
            {
                border_nodes = {
                    { text = "+" },
                    { ref_table = "card.ability.extra", ref_value = "pow_bonus", retrigger_type = "mult" },
                    { text = " Pow" },
                },
                border_colour = G.C.POW
            }
        }
    }

    jod['j_rgpd_power_play'] = {
        text = {
            {
                border_nodes = {
                    { text = "+" },
                    { ref_table = "card.joker_display_values", ref_value = "pow", retrigger_type = "mult" },
                    { text = " Pow" },
                },
                border_colour = G.C.POW
            }
        },
        calc_function = function(card)
            if next(G.play.cards) then return end -- currently playing hand
            local sum = 0
            MadLib.loop_func(G.hand.highlighted, function(v)
                sum = sum + (not SMODS.has_no_rank(v) and (sum + v.base.nominal) or 0)
            end)
            card.joker_display_values.pow = sum == 21 and card.ability.extra.pow or 0
        end
    }

    jod['j_rgpd_joker_cubed'] = {
        text = {
            {
                border_nodes = {
                    { text = "+" },
                    { ref_table = "card.joker_display_values", ref_value = "pow", retrigger_type = "mult" },
                    { text = " Pow" },
                },
                border_colour = G.C.POW
            }
        },
        reminder_text = {
            { ref_table = "card.joker_display_values", ref_value = "localized_text" },
        },
        calc_function = function(card)
            local pow = 0
            local text, _, scoring_hand = JokerDisplay.evaluate_hand()
            if text ~= 'Unknown' then
                pow = MadLib.multiply(MadLib.JokerDisplay.get_cards_matching(scoring_hand, function(v)
                    return MadLib.list_matches_one(MadLib.RankTypes['Square'], function(c)
                        return MadLib.is_rank(v, SMODS.Ranks[c].id)
                    end)
                end), card.ability.extra.pow)
            end
            card.joker_display_values.pow = pow
            card.joker_display_values.localized_text = "(" .. localize("Ace", "ranks") .. ",4,9)"
        end,
    }

    jod['j_rgpd_pow_block'] = {
        text = {
            {
                border_nodes = {
                    { text = "+" },
                    { ref_table = "card.joker_display_values", ref_value = "pow", retrigger_type = "mult" },
                    { text = " Pow" },
                },
                border_colour = G.C.POW
            }
        },
        reminder_text = {
            { ref_table = "card.joker_display_values", ref_value = "localized_text" },
        },
        calc_function = function(card)
            card.joker_display_values.pow = (text ~= 'Unknown' and G.GAME.current_round.hands_left <= 1) and card.ability.exra.pow or 0
        end,
    }

    jod['j_rgpd_powitch'] = {
        text = {
            {
                border_nodes = {
                    { text = "+" },
                    { ref_table = "card.ability.extra", ref_value = "pow", retrigger_type = "mult" },
                    { text = " Pow" },
                },
                border_colour = G.C.POW
            }
        },
        reminder_text = {
            { text = "(" },
            { ref_table = "card.ability.extra", ref_value = "hands_current" },
            { text = "/" },
            { ref_table = "card.ability.extra", ref_value = "hands_max" },
            { text = ")" },
        },
    }

    jod['j_rgpd_brand_name_joker'] = {
        text = {
            {
                border_nodes = {
                    { text = "-" },
                    { ref_table = "card.ability.extra", ref_value = "pow", retrigger_type = "mult" },
                    { text = " Pow" },
                },
                border_colour = G.C.POW
            }
        },
        extra = {
            {
                { text = "(" },
                { ref_table = "card.joker_display_values", ref_value = "odds" },
                { text = ") " },
            }
        },
        extra_config = { colour = G.C.GREEN, scale = 0.3 },
        calc_function   = function(card)
            local numerator, denominator        = SMODS.get_probability_vars(card, 1, card.ability.extra.odds, 'brand_name_joker')
            card.joker_display_values.odds      = localize { type = 'variable', key = "jdis_odds", vars = { numerator, denominator } }
        end
    }

    jod['j_rgpd_kujenga'] = {
        text = {
            { text = "+" },
            { ref_table = "card.joker_display_values", ref_value = "mult", retrigger_type = "mult" }
        },
        text_config = { colour = G.C.MULT },
        reminder_text = {
            { text = "(" },
            { ref_table = "card.joker_display_values", ref_value = "odds" },
            { text = ")" },
        },
        calc_function = function(card)
            if G.STATE == G.STATES.HAND_PLAYED then return end
            local numerator, denominator        = SMODS.get_probability_vars(card, MadLib.add(1, card.ability.immutable.increase), card.ability.immutable.odds, 'kujenga')
            card.joker_display_values.odds      = localize { type = 'variable', key = "jdis_odds", vars = { numerator, denominator } }
            card.joker_display_values.mult      = MadLib.add(card.ability.extra.mult, card.ability.extra.mult_mod)
        end,
    }

    jod['j_rgpd_odd_one_out'] = {
        text = {
            {
                border_nodes = {
                    { text = "+" },
                    { ref_table = "card.joker_display_values", ref_value = "pow", retrigger_type = "mult" },
                    { text = " Pow" },
                },
                border_colour = G.C.POW
            }
        },
        calc_function = function(card)
            if G.STATE == G.STATES.HAND_PLAYED then return end
            local pow       = 0
            local to_debuff = 0
            for i=1,#card.area.cards do
                local v = card.area.cards[i]
                if v == card or v.config.center.key == card.config.center.key then -- cannot debuff other odd one outs
                    break
                elseif to_debuff < (card.ability.extra.cards_to_debuff or 1) then
                    to_debuff = to_debuff + 1
                else
                    pow = card.ability.extra.pow
                    break
                end
            end
            card.joker_display_values.pow = pow
        end,
    }

    jod['j_rgpd_vanta_black'] = {
        text = {
            {
                border_nodes = {
                    { text = "+" },
                    { ref_table = "card.joker_display_values", ref_value = "pow", retrigger_type = "mult" },
                    { text = " Pow" },
                },
                border_colour = G.C.POW
            }
        },
        calc_function = function(card)
            if G.STATE == G.STATES.HAND_PLAYED then return end
            card.joker_display_values.pow = Pacdam.Funcs.hand_is_dark(G.hand.highlighted) and card.ability.extra.pow or 0
        end,
    }

    jod['j_rgpd_ultrawhite'] = {
        text = {
            {
                border_nodes = {
                    { text = "+" },
                    { ref_table = "card.joker_display_values", ref_value = "pow", retrigger_type = "mult" },
                    { text = " Pow" },
                },
                border_colour = G.C.POW
            }
        },
        calc_function = function(card)
            if G.STATE == G.STATES.HAND_PLAYED then return end
            card.joker_display_values.pow = Pacdam.Funcs.hand_is_light(G.hand.highlighted) and card.ability.extra.pow or 0
        end,
    }



    jod['j_rgpd_number_cruncher'] = {
        text = {
            { text = "+" },
            { ref_table = "card.joker_display_values", ref_value = "mult", retrigger_type = "mult" }
        },
        text_config = { colour = G.C.MULT },
        reminder_text = {
            { text = "(" },
            {
                ref_table = "card.joker_display_values",
                ref_value = "localized_text",
            },
            { text = ")" },
        },
        calc_function = function(card)
            if next(G.play.cards) then return end -- currently playing hand
            local text, _, scoring_hand = JokerDisplay.evaluate_hand()
            local rank = G.GAME.current_round
                and G.GAME.current_round.rgpd_number_cruncher
                and G.GAME.current_round.rgpd_number_cruncher.rank
                or '2'
            local mult = 0
            if text ~= 'Unknown' then
                mult = MadLib.multiply(MadLib.JokerDisplay.get_cards_matching(scoring_hand, function(v)
                    return MadLib.is_rank(v, SMODS.Ranks[G.GAME.current_round.rgpd_number_cruncher.rank].id)
                end), card.ability.extra.mult)
            end
            card.joker_display_values.mult              = mult
            card.joker_display_values.localized_text    = localize(rank, 'ranks')
        end
    }

    jod['j_rgpd_wanted_poster'] = {
        text = {
            { text = "+$" },
            { ref_table = "card.joker_display_values", ref_value = "dollars", retrigger_type = "dollars" }
        },
        reminder_text = {
            { text = "(" },
            { ref_table = "card.joker_display_values", ref_value = "wanted_card", colour = G.C.ORANGE },
            { text = ")" },
        },
        text_config = { colour = G.C.MONEY },
        calc_function = function(card)
            if G.STATE == G.STATES.HAND_PLAYED then return end
            local dollars = 0
            local text, _, scoring_hand = JokerDisplay.evaluate_hand()
            if text ~= 'Unknown' then
                MadLib.loop_func(scoring_hand, function(v)
                    if MadLib.is_rank(v, G.GAME.current_round.rgpd_wanted_poster.id)
                    and v:is_suit(G.GAME.current_round.rgpd_wanted_poster.suit) then
                        dollars = dollars + 1
                    end
                end)
            end
            card.joker_display_values.dollars = MadLib.multiply(dollars, card.ability.extra.money)
            card.joker_display_values.wanted_card = localize { type = 'variable', key = "jdis_rank_of_suit", vars = { localize(G.GAME.current_round.rgpd_wanted_poster.rank, 'ranks'), localize(G.GAME.current_round.rgpd_wanted_poster.suit, 'suits_plural') } }
        end,
        style_function = function(card, text, reminder_text, extra)
            if reminder_text and reminder_text.children[2] then
                reminder_text.children[2].config.colour = lighten(G.C.SUITS[G.GAME.current_round.rgpd_wanted_poster.suit], 0.35)
            end
            return false
        end
    }

    jod['j_rgpd_madcap'] = {
        text = {
            {
                border_nodes = {
                    { text = "+" },
                    { ref_table = "card.ability.extra", ref_value = "pow", retrigger_type = "mult" },
                    { text = " Pow" },
                },
                border_colour = G.C.POW
            }
        }
    }

    jod['j_rgpd_gokusen'] = {
        text = {
            {
                border_nodes = {
                    { text = "+" },
                    { ref_table = "card.ability.extra", ref_value = "pow", retrigger_type = "mult" },
                    { text = " Pow" },
                },
                border_colour = G.C.POW
            }
        }
    }

    jod['j_rgpd_green_eggs_and_spam'] = {
        text = {
            {
                border_nodes = {
                    { text = "X" },
                    { ref_table = "card.ability.extra", ref_value = "pow", retrigger_type = "mult" },
                    { text = " Pow" },
                },
                border_colour = G.C.DARK_EDITION
            }
        }
    }

    jod['j_rgpd_thurrito'] = {
        text = {
            {
                border_nodes = {
                    { text = "X" },
                    { ref_table = "card.ability.extra", ref_value = "x_mult", retrigger_type = "exp", colour = G.C.WHITE }
                }
            },
            { text = ", " },
            {
                border_nodes = {
                    { text = "X", },
                    { ref_table = "card.ability.extra", ref_value = "x_chips", retrigger_type = "exp", colour = G.C.WHITE }
                },
                border_colour = G.C.CHIPS
            },
            { text = ", " },
            {
                border_nodes = {
                    { text = "+" },
                    { ref_table = "card.ability.extra", ref_value = "pow", retrigger_type = "mult", colour = G.C.WHITE },
                    { text = " Pow" },
                },
                border_colour = G.C.POW
            }
        },
        reminder_text = {
            { text = "(" },
            { ref_table = "card.ability.extra", ref_value = "rounds" },
            { text = "/" },
            { ref_table = "card.ability.immutable", ref_value = "max_rounds" },
            { text = ")" },
        },
        calc_function = function(card)
            if G.STATE == G.STATES.HAND_PLAYED then return end
            card.joker_display_values.x_mult   = (G.GAME.current_round.hands_played == 0 and card.ability.extra.x_mult) or 1
        end,
        style_function = function(card, text, reminder_text, extra)
            if reminder_text and reminder_text.children then
                local w = MadLib.get_warning_colour(card.ability.extra.rounds / card.ability.immutable.max_rounds)
                for i=1,#reminder_text.children do reminder_text.children[i].config.colour = w end
            end
            return false
        end
    }

    jod['j_rgpd_bishop_twin'] = {
        text = {
            {
                border_nodes = {
                    { text = "+" },
                    { ref_table = "card.joker_display_values", ref_value = "pow", retrigger_type = "mult", colour = G.C.WHITE },
                    { text = " Pow" },
                },
                border_colour = G.C.POW
            }
        },
        reminder_text = {
            { text = "(" },
            { ref_table = "card.joker_display_values", ref_value = "localized_text", colour = G.C.ORANGE },
            { text = ")" },
        },
        calc_function = function(card)
            if next(G.play.cards) then return end -- currently playing hand
            local pairs_made = 0
            MadLib.loop_func(card.ability.immutable.pair_list, function(v)
                pairs_made = pairs_made + v
            end)
            local text, _, _ = JokerDisplay.evaluate_hand()
            if text == 'Pair' then pairs_made = pairs_made + 1 end
            card.joker_display_values.pow = MadLib.multiply(card.ability.extra.pow, pairs_made)
            card.joker_display_values.localized_text = localize(card.ability.extra.poker_hand, 'poker_hands')
        end,
    }
end