addon.name = 'dummyaliases'
addon.version = '0.01'
addon.author = 'looney'

require 'common'
local chat = require('chat')

local aliases = T {
    '/organize',
    '/togglefps',
    '/pack',
    '/preppack',
    '/sneakinvis',
    '/refreshcondition'
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
                end)
            end)
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
        elseif command == '/preppack' then
            print(chat.header(addon.name):append(chat.color2(200, 'Preppacking inventory...')))
            AshitaCore:GetChatManager():QueueCommand(1, '/lac naked 10')
            ashita.tasks.once(1, function()
                AshitaCore:GetChatManager():QueueCommand(1, '/lac disable')
                ashita.tasks.once(1, function()
                    AshitaCore:GetChatManager():QueueCommand(1, '/lac preppack')
                end)
            end)
        elseif command == '/pack' then
            print(chat.header(addon.name):append(chat.color2(200, 'Packing inventory...')))
            AshitaCore:GetChatManager():QueueCommand(1, '/lac naked 10')
            ashita.tasks.once(1, function()
                AshitaCore:GetChatManager():QueueCommand(1, '/lac pack')
            end)
        elseif command == '/sneakinvis' then
            local buffs = AshitaCore:GetMemoryManager():GetPlayer():GetBuffs()
            local sneak = false
            local invisible = false

            for _, buff in pairs(buffs) do
                local buffString = AshitaCore:GetResourceManager():GetString('buffs.names', buff)
                if buffString == 'Sneak' then
                    sneak = true
                elseif buffString == 'Invisible' then
                    invisible = true
                end
            end

            if not sneak then
                print(chat.header(addon.name):append(chat.color2(200, 'Applying Sneak...')))
                AshitaCore:GetChatManager():QueueCommand(1, '/item "Silent Oil" <me>')
                if not invisible then
                    print(chat.header(addon.name):append(chat.color2(200, 'Applying Invisible in 3 seconds...')))
                    ashita.tasks.once(3, function()
                        print(chat.header(addon.name):append(chat.color2(200, 'Applying Invisible...')))
                        AshitaCore:GetChatManager():QueueCommand(1, '/item "Prism Powder" <me>')
                    end)
                else
                    print(chat.header(addon.name):append(chat.color2(200, 'Applying Invisible in 3 seconds...')))
                    ashita.tasks.once(3, function()
                        print(chat.header(addon.name):append(chat.color2(200, 'Applying Invisible...')))
                        AshitaCore:GetChatManager():QueueCommand(1, '/item "Prism Powder" <me>')
                    end)
                end
            else
                print(chat.header(addon.name):append(chat.color2(200, 'Sneak is already active.')))
                if not invisible then
                    print(chat.header(addon.name):append(chat.color2(200, 'Applying Invisible...')))
                    AshitaCore:GetChatManager():QueueCommand(1, '/item "Prism Powder" <me>')
                else
                    print(chat.header(addon.name):append(chat.color2(200, 'Invisible is already active.')))
                end
            end
        elseif command == '/refreshcondition' then
            local buffs = AshitaCore:GetMemoryManager():GetPlayer():GetBuffs()
            local refresh = false

            for _, buff in pairs(buffs) do
                if buff == 43 then
                    refresh = true
                end
            end

            if not refresh then
                AshitaCore:GetChatManager():QueueCommand(1, '/ma "Refresh" <me>')
            end
        end
    end
end)

ashita.events.register('load', 'load_cb', function()
    AshitaCore:GetChatManager():QueueCommand(1, '/fps 1')
end)
