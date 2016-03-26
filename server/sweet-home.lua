class 'SweetHome'

function SweetHome:__init()
	SQL:Execute("CREATE TABLE IF NOT EXISTS players_home (steamid VARCHAR UNIQUE, homeX INTEGER, homeY INTEGER, homeZ INTEGER)")
	Events:Subscribe( "PlayerChat", self, self.PlayerChat )
end

function SweetHome:PlayerChat( args )
	local cmd_args = args.text:split(" ")
	
	if cmd_args[1] == "/sethome" then
		self:SetHome(args)
	elseif cmd_args[1] == "/home" then
		self:GoHome(args)
	elseif cmd_args[1] == "/gethome" then
		self:GetHome(args)
	end
	
end

function SweetHome:SetHome( args )
	--Console:SendChatMessage()
	local playerPos = args.player:GetPosition()
	local steamID = tostring(args.player:GetSteamId().id)

	local qry = SQL:Query('INSERT OR REPLACE INTO players_home (steamid, homeX, homeY, homeZ) VALUES(?, ?, ?, ?)')
	qry:Bind(1, tostring(steamID))
	qry:Bind(2, playerPos.x)
	qry:Bind(3, playerPos.y)
	qry:Bind(4, playerPos.z)
	qry:Execute()
	args.player:SendChatMessage(string.format("New home is now in: (%i x %i x %i)", playerPos.x, playerPos.y, playerPos.z), Color(54, 204, 113))
end

function SweetHome:GoHome( args )
	local steamID = tostring(args.player:GetSteamId().id)
	local qry = SQL:Query("SELECT * FROM players_home WHERE steamid = ?")
	qry:Bind(1, steamID)
    local result = qry:Execute()

	if #result > 0 then
		for i, v in ipairs(result) do
			args.player:SetPosition(Vector3(tonumber(v.homeX), tonumber(v.homeY), tonumber(v.homeZ)))
        end
	end
end

function SweetHome:GetHome( args )
	local steamID = tostring(args.player:GetSteamId().id)
	local qry = SQL:Query("SELECT * FROM players_home WHERE steamid = ?")
	qry:Bind(1, steamID)
    local result = qry:Execute()

	if #result > 0 then
		str = string.format("Your home is in: (%i x %i x %i)", tonumber(result[1].homeX), tonumber(result[1].homeY), tonumber(result[1].homeZ))
		args.player:SendChatMessage(str, Color(115, 255, 203))
	end
end
sweethome = SweetHome()