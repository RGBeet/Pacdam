return {
    descriptions = {
        Back = {
            b_rgpd_powerful = {
                name = "Powerful Deck",
                text = {
                    "{C:pow}+#1#{} Pow",
                    "{X:mult,C:white}X#2#{} Mult",
                    "{X:attention,C:white}X#3#{} blind size",
                    "{C:pow}Pacdam{} cards are",
                    "{C:attention}2X{} more likely to appear"
                },
            },
        },
        Enhanced = {
            m_rgpd_vis = {
                name = "Vis Card",
                text = {
                    "{C:pow}+#1#{} Pow",
                    "{C:mult}-#2#{} Mult"
                }
            },
            m_rgpd_flux = {
                name = "Flux Card",
                text = {
                    "{C:pow}+#1#{} Pow",
                    "while this card",
                    "stays in hand",
                    "{C:green}#2# in #3#{} chance to",
                    "destroy card",
                    "after activation",
                }
            }
        },
        Edition = {
            e_rgpd_glow = {
                name = "Luminous",
                text = {
                    "{C:pow}+#1#{} Pow",
                    Pacdam.powerful_desc()
                }
            }
        },
        Tag = {
            tag_rgpd_pow = {
                name = "POW! Tag",
                text = {
                    "{C:pow}+#1#{} Pow",
                    "for the round"
                }
            },
            tag_rgpd_phish = {
                name = "Phish Tag",
                text = {
                    "Gain between",
                    "1-3 {C:fish}Fish{}",
                }
            },
        },
        Fish = {
            c_rgpd_fish = {
                name = "Fish",
                text = {
                    "Go Fish! {C:inactive}(Draw a card)",
                    "{C:inactive,s:0.8}(Currently {C:fish,s:0.8}#1# / #2#{C:inactive,s:0.8} Fish)",
                    Pacdam.powerful_desc()
                },
            }
        },
        Joker = {
            j_rgpd_power_of_two = {
                name = "Power of Two",
                text = {
                    "{C:pow}+#1#{} Pow if played",
                    "hand contains",
                    "a {C:attention}Pair{}",
                    Pacdam.powerful_desc()
                }
            },
            j_rgpd_power_of_three = {
                name = "Power of Three",
                text = {
                    "{C:pow}+#1#{} Pow if played",
                    "hand contains",
                    "a {C:attention}Three of a Kind",
                    Pacdam.powerful_desc()
                }
            },
            j_rgpd_power_of_four = {
                name = "Power of Four",
                text = {
                    "{C:pow}+#1#{} Pow if played",
                    "hand contains",
                    "a {C:attention}Four of a Kind",
                    Pacdam.powerful_desc()
                }
            },
            j_rgpd_power_series = {
                name = "Power Series",
                text = {
                    "{C:pow}+#1#{} Pow if played",
                    "hand contains",
                    "a {C:attention}Straight",
                    Pacdam.powerful_desc()
                }
            },
            j_rgpd_power_set = {
                name = "Power Set",
                text = {
                    "{C:pow}+#1#{} Pow if played",
                    "hand contains",
                    "a {C:attention}Flush",
                    Pacdam.powerful_desc()
                }
            },
            j_rgpd_power_play = {
                name = "Power Play",
                text = {
                    "{C:pow}+#1#{} Pow if card",
                    "contains equals {C:attention}Blackjack",
                    Pacdam.powerful_desc()
                }
            },
            j_rgpd_fisherman = {
                name = "Fisherman",
                text = {
                    "After discarding,",
                    "gain a {C:fish}Fish",
                    "{C:inactive}(Must have room)",
                    Pacdam.powerful_desc()
                },
            },
            j_rgpd_lich = {
                name = "Lich",
                text = {
                    "Adds a random",
                    "{C:dark_edition}Negative{} {V:1}Tethered{}",
                    "joker when Boss",
                    "Blind is defeated",
                    Pacdam.powerful_desc()
                },
            },
            j_rgpd_frog = {
                name = "Frog",
                text = {
                    "#1#",
                    "When hand is played,",
                    "{C:pow}#1# in #3#{} chance to eat",
                    "a non-scoring card",
                    "Eaten cards {C:attention}always score",
                    Pacdam.powerful_desc()
                }
            },
            j_rgpd_broker = {
                name = "Broker",
                text = {
                    "Stonks.",
                    "{C:pow}+#1#{} Pow for every",
                    "{C:money}$#2#{} you have",
                    "{C:inactive}(Currently {C:pow}+#3#{C:inactive} Pow)",
                    Pacdam.powerful_desc()
                }
            },
            j_rgpd_uranium_glass = {
                name = "Uranium Glass",
                text = {
                    "Played {C:attention}Stone Cards{}",
                    "give {C:pow}+#1#{} Pow",
                    "when scored",
                    Pacdam.powerful_desc()
                }
            },
            j_rgpd_reverse_card = {
                name = "Reverse Card",
                text = {
                    "Swaps {C:chips}Chips{} and {C:mult}Mult{}",
                    Pacdam.powerful_desc()
                },
            },
            j_rgpd_joku = {
                name = "Joku",
                text = {
                    "This joker gains {C:pow}+#1#{} Pow",
                    "per {C:attention}consecutive{} hand that",
                    "exceeds required chips",
                    "{C:inactive}(Currently {C:pow}+#2#{} {C:inactive}Pow)",
                    "{C:inactive}What does the scouter say",
                    "{C:inactive}about his {C:attention, E:1}power level?!",
                    Pacdam.powerful_desc()
                },
            },
            j_rgpd_power_bluff = {
                name = "Power Bluff",
                text = {
                    "{C:pow}+#1#{} Pow, {C:red}#2#{} Mult",
                    "Start with {C:attention}1{} hand",
                    Pacdam.powerful_desc()
                },
            },
            j_rgpd_biker = {
                name = "Biker",
                text = {
                    "Every played {C:attention}card",
                    "permanently gains",
                    "{C:pow}+#1#{} Pow",
                    "{C:red}#2#{} Mult",
                    "when scored",
                    Pacdam.powerful_desc()
                },
            },
            j_rgpd_chameleon_ball = {
                name = "Wild Chameleon",
                text = {
                    "Each {C:attention}Wild Card",
                    "held in hand",
                    "gives {C:pow}+#1#{} Pow",
                    Pacdam.powerful_desc()
                },
            },
            j_rgpd_superhero = {
                name = "Superhero",
                text = {
                    "{C:pow}+#1#{} Pow",
                    "{C:attention}Flips{} when most played",
                    "{C:attention}poker hand{} is played",
                    Pacdam.powerful_desc()
                },
            },
            j_rgpd_alter_ego = {
                name = "Alter Ego",
                text = {
                    "Becomes {C:attention}Superhero",
                    "when {C:attention}Boss Blind",
                    "is selected",
                    Pacdam.powerful_desc()
                },
            },
            j_rgpd_joker_cubed = {
                name = "Joker Cubed",
                text = {
                    "Scored {C:attention}square number{} ranks",
                    "give {C:pow}+#1#{} Pow",
                },
            },
            j_rgpd_pow_block = {
                name = "POW! Block",
                text = {
                    "If {C:attention}final{} hand",
                    "does not clear blind,",
                    "this Joker",
                    "gives {C:pow}+#1#{} Pow",
                    "and {C:red}self destructs{}"
                },
            },
            j_rgpd_powitch = {
                name = "Powitch",
                text = {
                    "{C:pow}+#1#{} Pow",
                    "{C:pow}-#2#{} Pow for every",
                    "{C:attention}#4#{} hands played",
                    "{C:inactive}(#3#/#4# hands played)",
                },
            },
            j_rgpd_brand_name_joker = {
                name = "Brand Name Joker",
                text = {
                    "{C:green}#1# in #2#{} chance to",
                    "retrigger a {C:attention}random{}",
                    "owned Joker",
                    "{C:pow}-#3#{} Pow"
                },
            },
            j_rgpd_kujenga = {
                name = "Kujenga",
                text = {
                    "{C:green}#1# in #2# chance",
                    "this Joker gains {C:mult}+#3#{} Mult",
                    "upon {C:red}discard{}",
                    "Otherwise, this Joker",
                    "loses {C:red}-#4#{} Mult",
                    "{C:inactive}(Currently {C:chips}+#4#{C:inactive} Chips)",
                    "Reduce numerator by {C:attention}-#5#{}",
                    "per used {C:red}discard{}"
                },
            },
            j_rgpd_odd_one_out = {
                name = "Odd One Out",
                text = {
                    "{C:attention}Before{} scoring,",
                    "{C:red}debuffs{} leftmost Joker",
                    "{C:pow}+#1#{} Pow if this is",
                    "{C:red}not{} leftmost Joker"
                },
            },
            j_rgpd_odd_one_out_multi = {
                name = "Odd One Out",
                text = {
                    "{C:attention}Before{} scoring,",
                    "{C:red}debuffs{} leftmost {C:attention}#2#{} Jokers",
                    "{C:pow}+#1#{} Pow per triggered debuff",
                    "if this is {C:red}not{} leftmost Joker"
                },
            },
        },
        Tarot = {
            c_rgpd_growth = {
                name = "Growth",
                text = {
                    "Enhances up to {C:attention}#1#{}",
                    "selected cards to",
                    "{C:attention}#2#s",
                }
            },
            c_rgpd_deluge = {
                name = "Deluge",
                text = {
                    "Enhances up to {C:attention}#1#{}",
                    "selected cards to",
                    "{C:attention}#2#s",
                }
            },
        },
        Spectral = {
            c_rgpd_geist = {
                name = "Geist",
                text = {
                    "Apply {C:dark_edition}#1#",
                    "effect to {C:attention}#2#{} selected",
                    "card(s) in hand",
                    Pacdam.powerful_desc()
                }
            }
        },
        Rotarot = {
            c_rgpd_rot_vis = {
                name = "Growth!",
                text = {
                    "Enhances up to {C:attention}#1#{}",
                    "selected cards to",
                    "{C:attention}#2#s"
                }
            },
            c_rgpd_rot_deluge = {
                name = "Deluge!",
                text = {
                    "Enhances up to {C:attention}#1#{}",
                    "selected cards to",
                    "{C:attention}#2#s"
                }
            },
        },
        Other = {
            card_pow = {
                text = { "{C:pow}+#1#{} Pow" }
            },
            card_decay = {
                text = { "{X:pow,C:white}-#1#{} Pow" }
            },
            rgpd_tethered = {
                name = "Tethered",
                text = {
                    "Can not be sold",
                    "nor destroyed",
                    "If parent card is",
                    "sold or destroyed,",
                    "Debuff this card and",
                    "remove {V:1}Tethered{} sticker"
                }
            }
        },
    },
    misc = {
        dictionary = {
            k_fish = "Fish",
            b_fish_cards = "Fish Cards",
        },
        labels = {
            rgpd_tethered = "Tethered",
            rgpd_glow = "Luminous"
        },
        v_dictionary = {
            a_pow = "+#1# Pow",
            a_pow_minus = "-#1# Pow",
            a_xpow = "X#1# Pow",
            a_xpow_minus = "-X#1# Pow",
            a_decay = "Decay",
        }
    }
}