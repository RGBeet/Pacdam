return {
    descriptions = {
        Edition = {
            e_pow_Glow = {
                name = "Glow in the Dark",
                text = {
                    "Gives {C:green}+#1#{} Pow"
                }
            }
        },
        Fish = {
            c_pow_Fish = {
                name = "Fish",
                text = {
                    "Draw a card",
                    "{C:inactive}(Currently #1#/#2# Fish){}"
                },
            }
        },
        Joker = {
            j_pow_Twins = {
                name = "Power of Two",
                text = {
                    "{C:green}+#1#{} Pow if played",
                    "hand contains",
                    "a {C:attention}Pair{}"
                }
            },
            j_pow_Triplets = {
                name = "Power of Three",
                text = {
                    "{C:green}+#1#{} Pow if played",
                    "hand contains",
                    "a {C:attention}Three of a Kind{}"
                }
            },
            j_pow_Quadruplets = {
                name = "Power of Four",
                text = {
                    "{C:green}+#1#{} Pow if played",
                    "hand contains",
                    "a {C:attention}Four of a Kind{}"
                }
            },
            j_pow_Mob = {
                name = "Power Series",
                text = {
                    "{C:green}+#1#{} Pow if played",
                    "hand contains",
                    "a {C:attention}Straight{}"
                }
            },
            j_pow_Squad = {
                name = "Power Set",
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
            j_pow_Chameleon = {
                name = "Chameleon",
                text = {
                    "Each {C:attention}Wild Card",
                    "held in hand",
                    "gives {C:green}+#1#{} Pow",
                },
            },
            j_pow_Superhero = {
                name = "Superhero",
                text = {
                    "{C:green}+#1#{} Pow",
                    "{C:attention}Flips{} when most played",
                    "{C:attention}poker hand{} is played"
                },
            },
            j_pow_AlterEgo = {
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
                    "{C:green}+#1#{} Pow"
                }
            },
            card_decay = {
                text = {
                    "{X:green,C:white}-#1#{} Pow"
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
        Stake = {
            stake_green = {
                name = "Green Stake",
                text = {
                    "All jokers {X:green,C:white}Decay{} at the end of each round"
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
            pow_tethered = "Tethered",
            pow_Glow = "Glow in the Dark"
        },
        v_dictionary={
            a_pow="+#1# Pow",
            a_pow_minus="-#1# Pow",
            a_decay = "Decay",
        }
    }
}