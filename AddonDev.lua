local AceGUI = LibStub("AceGUI-3.0")

local EventFrame = CreateFrame("Frame")
EventFrame:RegisterEvent("PLAYER_LOGIN")
ChatFrame1:AddMessage('AddonDev loaded.')
EventFrame:SetScript("OnEvent", function(self, event, ...)
    if type(AddonDev_CharacterVar) ~= "number" then
        AddonDev_CharacterVar = 1
        ChatFrame1:AddMessage('Hello ' .. UnitName("Player") .. ". This is the first time we've met. Nice to meet you!")
    else

        ChatFrame1:AddMessage('Hello ' .. UnitName("Player") .. ". You have logged into this character " .. AddonDev_CharacterVar .. " times before.")

        AddonDev_CharacterVar = AddonDev_CharacterVar + 1
    end
end)

--local frame = AceGUI:Create("Frame")
--frame:SetTitle("Example Frame")
--frame:SetStatusText("AceGUI-3.0 Example Container Frame")

AddonDev = LibStub("AceAddon-3.0"):NewAddon("AddonDev", "AceConsole-3.0", "AceEvent-3.0")

local options = {
    name = "AddonDev",
    handler = AddonDev,
    type = 'group',
    args = {
        msg = {
            type = "input",
            name = "Message",
            desc = "The message to be displayed when you change zones.",
            usage = "<Your message>",
            get = "GetMessage",
            set = "SetMessage",
        },
        showInChat = {
            type = "toggle",
            name = "Show in Chat",
            desc = "Toggles the display of the message in the chat window.",
            get = "IsShowInChat",
            set = "ToggleShowInChat",
        },
        showOnScreen = {
            type = "toggle",
            name = "Show on Screen",
            desc = "Toggles the display of the message on the screen.",
            get = "IsShowOnScreen",
            set = "ToggleShowOnScreen"
        },
    },
}

local defaults = {
    profile = {
        message = "Zone changed!",
        showInChat = false,
        showOnScreen = false,
    },
}


function AddonDev:OnInitialize()
    -- Called when the addon is loaded
    self.db = LibStub("AceDB-3.0"):New("AddonDevDB", defaults, true) --if true, all characters will share the same "Default" profile.

    LibStub("AceConfig-3.0"):RegisterOptionsTable("AddonDev", options)
    self.optionsFrame = LibStub("AceConfigDialog-3.0"):AddToBlizOptions("AddonDev", "AddonDev")
    self:RegisterChatCommand("addondev", "ChatCommand")
    self:RegisterChatCommand("ad", "ChatCommand")
end

function AddonDev:OnEnable()
    -- Called when the addon is enabled
    self.Print("Ace Side loaded")
    self:RegisterEvent("ZONE_CHANGED")
end

function AddonDev:OnDisable()
    -- Called when the addon is disabled
end

function AddonDev:ZONE_CHANGED()

    if self.db.profile.showInChat then
        self:Print(self.db.profile.message);
    end

    if self.db.profile.showOnScreen then
        UIErrorsFrame:AddMessage(self.db.profile.message, 1.0, 1.0, 1.0, 5.0)  --This channel is shomehow blocked for me, but works.
    end
end

function AddonDev:ChatCommand(input)
    if not input or input:trim() == "" then
        InterfaceOptionsFrame_OpenToCategory(self.optionsFrame)
    else
        LibStub("AceConfigCmd-3.0"):HandleCommand("ad", "addondev", input)
    end
end

function AddonDev:GetMessage(info)
    return self.db.profile.message
end

function AddonDev:SetMessage(info, newValue)
    self.db.profile.message = newValue
end


function AddonDev:IsShowInChat(info)
    return self.db.profile.showInChat
end

function AddonDev:ToggleShowInChat(info, value)
    self.db.profile.showInChat = value
end

function AddonDev:IsShowOnScreen(info)
    return self.db.profile.showOnScreen
end

function AddonDev:ToggleShowOnScreen(info, value)
    self.db.profile.showOnScreen = value
end