local mod_path = "" .. SMODS.current_mod.path       -- save the mod path for future usage!

Pacdam.object_buffer['Jokers'] = Pacdam.object_buffer['Jokers'] or {}
local function load_items(path,func)
	local files = NFS.getDirectoryItems(mod_path..path)
	--tell('File path is '.. path)
	MadLib.loop_func(files, function(file)
		--tell('File is '..file)
		local f, err = SMODS.load_file(path..file)
		if err then
			tell_error(err)
			--errors[file] = err
			return false
		end

		local item = f()
		if not (item and item.data) then
			tell('Item could not load - improper data structure.')
			return false
		elseif item.devmode and item.devmode ~= Pacdam.Data.devmode then
			tell('Item could not load - devmode only!')
			return false
		end

		if item.categories and MadLib.list_matches_one(item.categories, function(c)
			return PacdamConfig[v] ~= nil and PacdamConfig[v] == false
		end) then
			tell('Item '..(item.data and item.data.key or 'UNKNOWN')..' could not load - configs turned off.')
			return false
		end

		local data = item.data
		if data.object_type then
			if func then func(item.data) end
			--tell('Attempting to load item '..(item.data and item.data.key or 'UNKNOWN')..'.')
			SMODS[data.object_type](data)
		end
	end)
end

local function loop_directories(tbl, path)
    path = path or {}
    tell('Loading Directories')
	print(path)
	MadLib.loop_table(tbl, function(key,value)
        if type(value) ~= "table" then return false end
		if value.pass ~= nil and value.pass() == true then
			tell("Loading folder at: " .. table.concat(path, ".") .. (next(path) and "." or "") .. key)
			local final_path = 'items/'
			MadLib.loop_func(path, function(v,i)
				final_path = final_path .. v .. '/'
			end)
			load_items(final_path..key..'/',value.func)
		else
			table.insert(path, key)
			loop_directories(value, path)
			table.remove(path)
		end
	end)
end

Pacdam.JokerIds = {} -- joker ids
Pacdam.Directories = {
	['jokers'] = {
        pass = function()
            return true
        end,
        func = function(d) -- add joker id to joker ids
            d.pools = { ['MadcapJoker'] = true }
            d.blueprint_compat  = d.blueprint_compat or true
            d.eternal_compat    = d.eternal_compat or true
            d.perishable_compat = d.perishable_compat or true
            d.unlocked          = d.unlocked or true
            d.discovered        = d.discovered or true
        end
    },
	['consumeables'] = {
        ['tarot'] = {
            pass = function()
                return true
            end
        },
        ['spectral'] = {
            pass = function()
                return true
            end
        },
        ['planet'] = {
            pass = function()
                return true
            end
        }
	},
	['decks'] = {
        pass = function()
            return true
        end
	},
	['enhancements'] = {
        pass = function()
            return true
        end
	},
	['editions'] = {
		pass = function()
			return true
		end
	},
	['stickers']	= {
		pass = function()
			return true
		end
	},
	['tags'] = {
		pass = function()
			return true
		end
	},
	['blinds'] = {
		pass = function()
			return true
		end
	},
}
loop_directories(Pacdam.Directories)