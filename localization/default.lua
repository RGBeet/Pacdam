return {
    descriptions = {
        Joker = {
            -- this should be the full key of your object, including any prefixes
            j_pow_Fisherman = {
                name = "Fisherman",
                text = {
                    "After Discard,",
                    "gain a {C:fish}Fish{}",
                    "{C:inactive}(Must have room){}"
                },
                -- only needed when this object is locked by default
                -- unlock = {
                --     'This is a condition',
                --     'for unlocking this card',
                -- },
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
            }
        },
        Fish = {
            c_pow_Fish = {
                name = "Fish",
                text = {
                    "Draw a card"
                },
            }
        },
        Other = {
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
        }
    }
}