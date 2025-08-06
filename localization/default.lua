return {
    descriptions = {
        Edition = {
            e_pow_glow = {
                name = "Glow in the Dark",
                text = {
                    "Gives {C:pow}+#1#{} Pow"
                }
            }
        },
        Fish = {
            c_pow_fish = {
                name = "Fish",
                text = {
                    "Draw a card",
                    "{C:inactive}(Currently #1#/#2# Fish){}"
                },
            }
        },
        Joker = {
            j_rgpd_power_of_two = {
                name = "Power of Two",
                text = {
                    "{C:pow}+#1#{} Pow if played",
                    "hand contains",
                    "a {C:attention}Pair{}"
                }
            },
            j_rgpd_power_of_three = {
                name = "Power of Three",
                text = {
                    "{C:pow}+#1#{} Pow if played",
                    "hand contains",
                    "a {C:attention}Three of a Kind{}"
                }
            },
            j_rgpd_power_of_four = {
                name = "Power of Four",
                text = {
                    "{C:pow}+#1#{} Pow if played",
                    "hand contains",
                    "a {C:attention}Four of a Kind{}"
                }
            },
            j_rgpd_power_series = {
                name = "Power Series",
                text = {
                    "{C:pow}+#1#{} Pow if played",
                    "hand contains",
                    "a {C:attention}Straight{}"
                }
            },
            j_rgpd_power_set = {
                name = "Power Set",
                text = {
                    "{C:pow}+#1#{} Pow if played",
                    "hand contains",
                    "a {C:attention}Flush{}"
                }
            },
            j_rgpd_power_play = {
                name = "Power Play",
                text = {
                    "{C:pow}+#1#{} Pow if ranks",
                    "of played cards",
                    "sum to {C:attention}21{}"
                }
            },
            j_rgpd_fisherman = {
                name = "Fisherman",
                text = {
                    "After Discard,",
                    "gain a {C:fish}Fish{}",
                    "{C:inactive}(Must have room){}"
                },
            },
            j_rgpd_countess = {
                name = "Countess",
                text = {
                    "Adds a random",
                    "{C:dark_edition}Negative{} {V:1}Tethered{}",
                    "joker when Boss",
                    "Blind is defeated"
                }
            },
            j_rgpd_frog = {
                name = "Frog",
                text = {
                    "#1#",
                    "{C:inactive}(when hand is played,",
                    "{C:pow}#2# in #3#{} {C:inactive}chance to eat",
                    "{C:inactive}a non-scoring card.", 
                    "{C:inactive}Scores all eaten cards)"
                }
            },
            j_rgpd_broker = {
                name = "Broker",
                text = {
                    "{C:pow}+#1#{} Pow for every",
                    "{C:money}$#2#{} you have", 
                    "{C:inactive}(Currently {C:pow}+#3#{C:inactive} Pow)"
                }
            },
            j_rgpd_uranium_glass = {
                name = "Uranium Glass",
                text = {
                    "Played {C:attention}Stone Cards{}",
                    "give {C:pow}+#1#{} Pow",
                    "when scored"
                }
            },
            j_rgpd_reverse_card = {
                name = "Reverse Card",
                text = {
                    "Swaps {C:chips}Chips{} and {C:mult}Mult{}"
                },
            },
            j_rgpd_joku = {
                name = "Joku",
                text = {
                    "This joker gains {C:pow}+#1#{} Pow",
                    "per {C:attention}consecutive{} hand that",
                    "exceeds required chips",
                    "{C:inactive}(Currently {C:pow}+#2#{} {C:inactive}Pow)",
                    "What does the scouter say",
                    "about his power level?!"
                },
            },
            j_rgpd_power_bluff = {
                name = "Power Bluff",
                text = {
                    "{C:pow}+#1#{} Pow, {C:red}-#2#{} Mult",
                    "Start with {C:attention}1{} hand"
                },
            },
            j_rgpd_biker = {
                name = "Biker",
                text = {
                    "Every played {C:attention}card",
                    "permanently gains",
                    "{C:pow}+#1#{} Pow, {C:red}-#2#{} Mult",
                    "when scored"
                },
            },
            j_rgpd_chameleon_ball = {
                name = "Chameleon Ball",
                text = {
                    "Each {C:attention}Wild Card",
                    "held in hand",
                    "gives {C:pow}+#1#{} Pow",
                },
            },
            j_rgpd_superhero = {
                name = "Superhero",
                text = {
                    "{C:pow}+#1#{} Pow",
                    "{C:attention}Flips{} when most played",
                    "{C:attention}poker hand{} is played"
                },
            },
            j_rgpd_alter_ego = {
                name = "Alter Ego",
                text = {
                    "{C:attention}Flips{} when {C:attention}Boss Blind{}",
                    "is selected"
                },
            },
        },
        Other = {
            card_pow = {
                text = {
                    "{C:pow}+#1#{} Pow"
                }
            },
            card_decay = {
                text = {
                    "{X:pow,C:white}-#1#{} Pow"
                }
            },
            pow_tethered = {
                name = "Tethered",
                text = {
                    "Can't be sold or",
                    "destroyed. Loses",
                    "{V:1}Tethered{} and becomes",
                    "Debuffed if {C:attention}Countess{}",
                    "is sold or destroyed."
                }
            }
        },
        Spectral = {
            c_pow_geist = {
                name = "Geist",
                text = {
                    "Apply {C:dark_edition}#1#{}",
                    "effect to {C:attention}1{} selected",
                    "card in hand"
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
            pow_tethered = "Tethered",
            pow_glow = "Glow in the Dark"
        },
        v_dictionary={
            a_pow="+#1# Pow",
            a_pow_minus="-#1# Pow",
            a_decay = "Decay",
        }
    }
}