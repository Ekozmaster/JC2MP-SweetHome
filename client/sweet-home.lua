class 'SweetHomeHelp'

function SweetHomeHelp:__init()
	Events:Subscribe( "ModulesLoad", self, self.ModulesLoad )
	Events:Subscribe( "Render", self, self.Render )
end

function SweetHomeHelp:ModulesLoad()
    Events:Fire( "HelpAddItem",
        {
            name = "SweetHome",
			text = "SweetHome Let you set a place to live.\n\n" ..
				   "> Commands:\n\n" ..
				   "    /sethome - Will set your current place as your home\n" ..
				   "    /home    - Will teleport you to your home\n" ..
				   "    /gethome - Print the coords of your current home"
        } )
end

SweetHomeHelp()
