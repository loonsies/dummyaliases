addon.name = 'dummyaliases'
addon.version = '0.01'
addon.author = 'looney'

require 'common'
local chat = require('chat')

local aliases = T {
    '/organize',
    '/togglefps'
}
local state = {
    fastFps = false
}

ashita.events.register('command', 'command_cb', function(cmd, nType)
    if not cmd or not cmd.command then
        return false
    end
    local args = cmd.command:args()
    if #args ~= 0 then
        local command = string.lower(args[1])
        local arg = #args > 1 and string.lower(args[2]) or ''
        local arg2 = #args > 2 and string.lower(args[3]) or ''


        if not aliases:contains(command) then
            return false
        end


        if command == '/organize' then
            print(chat.header(addon.name):append(chat.color2(200, 'Organizing inventory...')))
            AshitaCore:GetChatManager():QueueCommand(1, '/packer load nogear')
            ashita.tasks.once(1, function()
                AshitaCore:GetChatManager():QueueCommand(1, '/packer organize')

                ashita.tasks.once(5, function()
                    AshitaCore:GetChatManager():QueueCommand(1, '/packer load default')
                end
                )
            end
            )
        elseif command == '/togglefps' then
            if state.fastFps == false then
                state.fastFps = true
                print(chat.header(addon.name):append(chat.color2(101, 'Fast FPS mode enabled.')))
                AshitaCore:GetChatManager():QueueCommand(1, '/fps 0')
            else
                state.fastFps = false
                print(chat.header(addon.name):append(chat.color2(102, 'Fast FPS mode disabled.')))
                AshitaCore:GetChatManager():QueueCommand(1, '/fps 1')
            end
        end
    end
end)

ashita.events.register('load', 'load_cb', function()
    AshitaCore:GetChatManager():QueueCommand(1, '/fps 1')
end)
