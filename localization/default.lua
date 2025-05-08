return {
    descriptions = {
        Joker = {
            j_pow_Hasty = {
                name = "Hasty Joker",
                text = {
                    "{C:green}+#1#{} Pow if played",
                    "hand contains",
                    "a {C:attention}Pair{}"
                }
            },
            j_pow_Eager = {
                name = "Eager Joker",
                text = {
                    "{C:green}+#1#{} Pow if played",
                    "hand contains",
                    "a {C:attention}Three of a Kind{}"
                }
            },
            j_pow_Restless = {
                name = "Restless Joker",
                text = {
                    "{C:green}+#1#{} Pow if played",
                    "hand contains",
                    "a {C:attention}Two Pair{}"
                }
            },
            j_pow_Frantic = {
                name = "Frantic Joker",
                text = {
                    "{C:green}+#1#{} Pow if played",
                    "hand contains",
                    "a {C:attention}Straight{}"
                }
            },
            j_pow_Manic = {
                name = "Manic Joker",
                text = {
                    "{C:green}+#1#{} Pow if played",
                    "hand contains",
                    "a {C:attention}Flush{}"
                }
            },
            j_pow_Blackjack = {
                name = "Blackjack",
                text = {
                    "{C:green}+#1#{} Pow if ranks",
                    "of played cards",
                    "sum to {C:attention}21{}"
                }
            },
            j_pow_Fisherman = {
                name = "Fisherman",
                text = {
                    "After Discard,",
                    "gain a {C:fish}Fish{}",
                    "{C:inactive}(Must have room){}"
                },
            },
            j_pow_Lich = {
                name = "Lich",
                text = {
                    "Adds a random",
                    "{C:dark_edition}Negative{} {V:1}Tethered{}",
                    "joker when Boss",
                    "Blind is defeated"
                }
            },
            j_pow_Frog = {
                name = "Frog",
                text = {
                    "#1#",
                    "{C:inactive}(when hand is played,",
                    "{C:green}#2# in #3#{} {C:inactive}chance to eat",
                    "{C:inactive}a non-scoring card.", 
                    "{C:inactive}Scores all eaten cards)"
                }
            },
            j_pow_Broker = {
                name = "Broker",
                text = {
                    "{C:green}+#1#{} Pow for every",
                    "{C:money}$#2#{} you have", 
                    "{C:inactive}(Currently {C:green}+#3#{C:inactive} Pow)"
                }
            },
            j_pow_Uranium = {
                name = "Uranium Glass",
                text = {
                    "Played {C:attention}Stone Cards{}",
                    "give {C:green}+#1#{} Pow",
                    "when scored"
                }
            },
            j_pow_Reverse = {
                name = "Reverse",
                text = {
                    "Swaps {C:chips}Chips{} and {C:mult}Mult{}"
                },
            },
            j_pow_Joku = {
                name = "Joku",
                text = {
                    "This joker gains {C:green}+#1#{} Pow",
                    "per {C:attention}consecutive{} hand that",
                    "exceeds required chips",
                    "{C:inactive}(Currently {C:green}+#2#{} {C:inactive}Pow)"
                },
            },
            j_pow_BigBluff = {
                name = "Big Bluff",
                text = {
                    "{C:green}+#1#{} Pow, {C:red}-#2#{} Mult",
                    "Start with {C:attention}one hand{}"
                },
            },
            j_pow_Biker = {
                name = "Biker",
                text = {
                    "Every played {C:attention}card",
                    "permanently gains",
                    "{C:green}+#1#{} Pow, {C:red}-#2#{} Mult",
                    "when scored"
                },
            },
        },
        Fish = {
            c_pow_Fish = {
                name = "Fish",
                text = {
                    "Draw a card",
                    "{C:inactive}Currently #1#/#2# Fish{}"
                },
            }
        },
        Other = {
            card_pow = {
                text = {
                    "{C:green}+#1#{} Pow"
                }
            },
            pow_tethered = {
                name = "Tethered",
                text = {
                    "Can't be sold or",
                    "destroyed. Loses",
                    "{V:1}Tethered{} and becomes",
                    "Debuffed if {C:attention}Lich{}",
                    "is sold or destroyed."
                }
            }
        }
    },
    misc = {
        dictionary = {
            k_fish = "Fish",
            b_fish_cards = "Fish Cards",
        },
        labels = {
            pow_tethered = "Tethered"
        },
        v_dictionary={
            a_pow="+#1# Pow",
            a_pow_minus="-#1# Pow",
        }
    }
}