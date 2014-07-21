-- Include sc_default
require "lua_scripts/base/sc_default"

local file = io.open("lua_scripts/ChatLog.log", "a")

cddcdm = ""

function OnChat_Command(event, player, message, type, language)
    swm = string.lower(message)

    local plrname = player:GetName()
    local accname = player:GetAccountName()
    local giddy = message:gsub(cddcdm.."","")

    if (swm:find(cddcdm.." ") == false) then
    else
        pg = player:GetGuildName()
        msgtype = ChatMsg(type)
        tom = type

        if (language ~= -1) then
            if (tom == 10) then
                file:write("("..os.date()..") "..GmCheck(player)" ["..accname.."] ["..plrname.."] "..giddy"\n")
            else
                file:write("("..os.date()..") ["..accname.."] ["..plrname.."] "..msgtype..": "..giddy.."\n")
                file:flush()
            end
        end
    end
end

function GmCheck(player)
    if (player:IsGm() == true) then
        return("[GM]")
    end
end

RegisterPlayerEvent(18, OnChat_Command)
RegisterPlayerEvent(19, OnChat_Command)
RegisterPlayerEvent(20, OnChat_Command)
RegisterPlayerEvent(21, OnChat_Command)
RegisterPlayerEvent(22, OnChat_Command)