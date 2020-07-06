local AIO = AIO or require("AIO");

if (AIO.AddAddon()) then
    return
end

local cmod_ExpModifier = {
    [0] = 'Experience multiplier',
    [1] = 'Allows you to modify your experience multiplier.',
    [2] = 'This will allow you to gain as much or as little experience as you choose.',
    [3] = 'Your current multiplier',
    [4] = 'Multiply by',
    [5] = 'Exit',
    [6] = 'Displays/hides the Exp modifier window.'
}

local hmod_ExpModifier = AIO.AddHandlers("hmod_ExpModifier", {});

local cmod_ExpModifier_icon;
local cmod_ExpModifier_frame;
local cmod_ExpModifier_titleBar;
local cmod_ExpModifier_frameText;
local cmod_ExpModifier_rateText;

local cmod_ExpModifier_ButtonPosX = -70;
local cmod_ExpModifier_Button = {};
local cmod_ExpModifier_ButtonText = {};

cmod_ExpModifier_icon = CreateFrame("Button", "cmod_ExpModifier_icon", PlayerFrame);
    cmod_ExpModifier_icon:EnableMouse(true);
    cmod_ExpModifier_icon:SetNormalTexture("Interface/BUTTONS/XP_Button");
    cmod_ExpModifier_icon:SetHighlightTexture("Interface/BUTTONS/XP_Button_Hover");
    cmod_ExpModifier_icon:SetPushedTexture("Interface/BUTTONS/XP_Button_Pushed");
    cmod_ExpModifier_icon:SetSize(35, 35);
    cmod_ExpModifier_icon:SetPoint("CENTER", -15, 30);
    cmod_ExpModifier_icon:SetToplevel(true);
    cmod_ExpModifier_icon:SetMovable(false);
    cmod_ExpModifier_icon:Show();

    cmod_ExpModifier_icon:SetFrameLevel(PlayerFrame:GetFrameLevel()+3);

    cmod_ExpModifier_icon:SetScript("OnEnter", function (self, button, down)
        GameTooltip:SetOwner(UIParent, "ANCHOR_BOTTOMRIGHT", 150, 150);
        GameTooltip:AddLine(cmod_ExpModifier[0], 1, 1, 1);
        GameTooltip:AddLine(cmod_ExpModifier[6]);
        GameTooltip:Show();
    end);

    cmod_ExpModifier_icon:SetScript("OnMouseUp", function (self, button, down)
        if (cmod_ExpModifier_frame:IsShown()) then
            cmod_ExpModifier_frame:Hide();
        else
            cmod_ExpModifier_frame:Show();
        end
    end);

    cmod_ExpModifier_icon:SetScript("OnLeave", function (self, button, down)
        GameTooltip:Hide();
    end);

cmod_ExpModifier_frame = CreateFrame("Frame", "cmod_ExpModifier_frame", UIParent, "UIPanelDialogTemplate");
    cmod_ExpModifier_frame:SetSize(250, 400);
    cmod_ExpModifier_frame:SetPoint("CENTER");
    cmod_ExpModifier_frame:SetToplevel(true);
    cmod_ExpModifier_frame:SetMovable(false);
    cmod_ExpModifier_frame:EnableMouse(true);
    cmod_ExpModifier_frame:Hide();

cmod_ExpModifier_titleBar = cmod_ExpModifier_frame:CreateFontString("cmod_ExpModifier_titleBar");
    cmod_ExpModifier_titleBar:SetFont("Fonts\\FRIZQT__.TTF", 13);
    cmod_ExpModifier_titleBar:SetSize(190, 5);
    cmod_ExpModifier_titleBar:SetPoint("CENTER", -10, 186);
    cmod_ExpModifier_titleBar:SetText("|cffFFC125"..cmod_ExpModifier[0].."|r");

cmod_ExpModifier_frameText = cmod_ExpModifier_frame:CreateFontString("f_expmodifier_InnerText");
    cmod_ExpModifier_frameText:SetFont("Fonts\\FRIZQT__.TTF", 12.3);
    cmod_ExpModifier_frameText:SetSize(190, 0);
    cmod_ExpModifier_frameText:SetPoint("CENTER", 0, 105);
    cmod_ExpModifier_frameText:SetText("\n\n"..cmod_ExpModifier[1].."\n\n"..cmod_ExpModifier[2].."\n\n\n|CFFa8a8ff "..cmod_ExpModifier[3].." : ");

cmod_ExpModifier_rateText = cmod_ExpModifier_frame:CreateFontString("cmod_ExpModifier_rateText", function()
    AIO.Handle("hmod_ExpModifier", "getRateModifier", 1)
end);
    cmod_ExpModifier_rateText:SetFont("Fonts\\FRIZQT__.TTF", 20)
    cmod_ExpModifier_rateText:SetSize(190, 0)
    cmod_ExpModifier_rateText:SetPoint("CENTER", 0, -10)

for i=1, 4 do
    if (i < 4 ) then
        cmod_ExpModifier_Button[i] = CreateFrame("Button", "cmod_ExpModifier_Button["..i.."]", cmod_ExpModifier_frame);
        cmod_ExpModifier_Button[i]:SetSize(170, 30);
        cmod_ExpModifier_Button[i]:SetPoint("CENTER", 0, cmod_ExpModifier_ButtonPosX);
        cmod_ExpModifier_Button[i]:EnableMouse(true);
        cmod_ExpModifier_Button[i]:SetNormalTexture("Interface/BUTTONS/UI-DialogBox-Button-Up");
        cmod_ExpModifier_Button[i]:SetHighlightTexture("Interface/BUTTONS/UI-DialogBox-Button-Highlight");
        cmod_ExpModifier_Button[i]:SetPushedTexture("Interface/BUTTONS/UI-DialogBox-Button-Down");
        cmod_ExpModifier_Button[i]:SetScript("OnMouseUp", function() AIO.Handle("hmod_ExpModifier", "setRateModifier", i) end);
        cmod_ExpModifier_ButtonPosX = cmod_ExpModifier_ButtonPosX - 25;

        cmod_ExpModifier_ButtonText[i] = cmod_ExpModifier_Button[i]:CreateFontString("cmod_ExpModifier_ButtonText["..i.."]");
        cmod_ExpModifier_ButtonText[i]:SetFont("Fonts\\FRIZQT__.TTF", 12);
        cmod_ExpModifier_ButtonText[i]:SetSize(190, 10);
        cmod_ExpModifier_ButtonText[i]:SetPoint("CENTER", 0, 5);
        cmod_ExpModifier_ButtonText[i]:SetText(cmod_ExpModifier[4].." "..i);
    else
        cmod_ExpModifier_ButtonPosX = cmod_ExpModifier_ButtonPosX - 30;
        cmod_ExpModifier_Button[i] = CreateFrame("Button", "cmod_ExpModifier_Button["..i.."]", cmod_ExpModifier_frame, "UIPanelCloseButton");
        cmod_ExpModifier_Button[i]:SetSize(170, 30);
        cmod_ExpModifier_Button[i]:SetPoint("CENTER", 0, cmod_ExpModifier_ButtonPosX);
        cmod_ExpModifier_Button[i]:EnableMouse(true);
        cmod_ExpModifier_Button[i]:SetNormalTexture("Interface/BUTTONS/UI-DialogBox-Button-Up");
        cmod_ExpModifier_Button[i]:SetHighlightTexture("Interface/BUTTONS/UI-DialogBox-Button-Highlight");
        cmod_ExpModifier_Button[i]:SetPushedTexture("Interface/BUTTONS/UI-DialogBox-Button-Down");

        cmod_ExpModifier_ButtonText[i] = cmod_ExpModifier_Button[i]:CreateFontString("cmod_ExpModifier_ButtonText["..i.."]");
        cmod_ExpModifier_ButtonText[i]:SetFont("Fonts\\FRIZQT__.TTF", 12);
        cmod_ExpModifier_ButtonText[i]:SetSize(190, 10);
        cmod_ExpModifier_ButtonText[i]:SetPoint("CENTER", 0, 5);
        cmod_ExpModifier_ButtonText[i]:SetText(cmod_ExpModifier[5]);
    end
end

function hmod_ExpModifier.ShowFrame(player)
    cmod_ExpModifier_frame:Show();
end

function hmod_ExpModifier.receiveInformations(player, msg)
    cmod_ExpModifier_rateText:SetText("|CFFa8a8ff "..msg);
end