function Pacdam.Funcs.get_powerful_desc()
    return "{s:0.6,C:inactive}(Originally from {s:0.6,C:pow}Powerful{s:0.6,C:inactive}",
    "{s:0.6,C:inactive}by {E:1,C:green,s:0.6}chaseoqueso{s:0.6,C:inactive})"
end

function Pacdam.Funcs.do_fish(card)
    local fish
    MadLib.loop_func(G.consumeables.cards, function(v)
        if v.config.center.key == "c_rgpd_fish" and v.ability.extra.num_fish < 5 then fish = v end
    end)
    if fish then
        local num_fish = fish.ability.extra.num_fish
        num_fish = num_fish + 1
        fish.ability.extra.num_fish = num_fish

        fish.sell_cost = num_fish - 1
        fish.children.center:set_sprite_pos({ x = num_fish - 1, y = 0 })
        fish:juice_up()
    elseif #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
        G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
        fish = SMODS.add_card({area = G.consumeables, key = "c_rgpd_fish"})
        fish.ability.extra.num_fish = 1
        fish.sell_cost = 0
        MadLib.event({
            trigger = "before",
            delay = 0.0,
            func = (function()
                -- fish = SMODS.add_card({area = G.consumeables, key = "c_pow_Fish"})
                G.GAME.consumeable_buffer = 0
                -- fish.ability.extra.num_fish = 1
                -- fish.sell_cost = 0
                return true
            end)
        })
    end
    if card then
        card_eval_status_text(card, 'extra', nil, nil, nil, { message = "Caught one!", colour = G.C.FILTER })
    end
end

function Pacdam.Funcs.flip_helper(source, targets, func)
    if source then
        MadLib.event({
            trigger = 'after',
            delay = 0.4,
            func = function()
                play_sound('tarot1')
                source:juice_up(0.3, 0.5)
                return true
            end
        })
    end
    for i = 1, #targets do
        local percent = 1.15 - (i - 0.999) / (#targets - 0.998) * 0.3
        MadLib.event({
            trigger = 'after',
            delay = 0.15,
            func = function()
                targets[i]:flip(); play_sound('card1', percent); targets[i]:juice_up(0.3, 0.3); return true
            end
        })
    end
    delay(0.2)
    for i = 1, #targets do
        MadLib.event({
            trigger = 'after',
            delay = 0.1,
            func = func
        })
    end
    for i = 1, #targets do
        local percent = 0.85 + (i - 0.999) / (#targets - 0.998) * 0.3
        MadLib.event({
            trigger = 'after',
            delay = 0.15,
            func = function()
                targets[i]:flip()
                play_sound('tarot2', percent, 0.6)
                targets[i]:juice_up(0.3, 0.3)
                return true
            end
        })
    end
    MadLib.event({
        trigger = 'after',
        delay = 0.2,
        func = function()
            G.hand:unhighlight_all()
            return true
        end
    })
    delay(0.5)
end