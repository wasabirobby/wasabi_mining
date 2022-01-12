local WEBHOOK_LINK = "https://discordapp.com/api/webhooks/930362655967969310/FkhdMS-CgY6xah8q6ldIN5ToIjXH5p-llqDWDqcBKtKbxVBENwUx1o1vBFprMQmLMvRB"
local DISCORD_NAME = "Wasabi Mining"
local DISCORD_IMAGE = "https://i.imgur.com/Q72RWcB.png"

function sendToDiscord(name, message, color)
	local connect = {
		  {
			  ["color"] = color,
			  ["title"] = "**".. name .."**",
			  ["description"] = message,
			  ["footer"] = {
			  ["text"] = "Created by Wasabirobby",
			  },
		  }
	  }
	PerformHttpRequest(WEBHOOK_LINK, function(err, text, headers) end, 'POST', json.encode({username = DISCORD_NAME, embeds = connect, avatarrl = DISCORD_IMAGE}), { ['Content-Type'] = 'application/json' })
end