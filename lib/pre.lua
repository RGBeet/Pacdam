Pacdam = {
    devmode = true,
    Funcs = { },
    JokerLists = { },
    object_buffer = {}
}
pmfuncs 	= Pacdam.Funcs
pmjokers	= Pacdam.JokerLists

-- enabled type stuff
PacdamConfig = SMODS.current_mod.config          	-- loading configuration
Pacdam.enabled = copy_table(PacdamConfig)      		-- what is enabled?

-------------------------------------
-------- HELPERS & CONSTANTS --------
-------------------------------------

G.C.POW         = HEX('57C185')
G.C.FISH        = HEX("308fe3")
G.C.TETHERED    = HEX('248571')
G.C.UI_POW      = G.C.POW

POW = Pacdam

-- rarity boosters
-- fire, air, earth, water blinds
-- sulphur, mercury, salt

-- rarity boosters
-- fire, air, earth, water blinds
-- sulphur, mercury, salt

function Pacdam.Funcs.calc_chips(chips, mult, pow)
    --print(" Chips = " .. tostring(chips) .. ", Mult = " .. tostring(mult) .. ", Pow = " .. tostring(pow) .. ".")
    return (math.abs(chips) ^ pow) * mult
end

Pacdam.GUI = {}

function mod_pow(_pow)
  SMODS.Scoring_Parameters.pow:modify(nil, _pow - (pow or 1))
  return _pow
end