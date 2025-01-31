require "ISUI/ISPanel"
require "ISUI/ISButton"
require "ISUI/ISLabel"
require "ISUI/ISComboBox"

RPClientUI = ISPanel:derive("RPClientUI")

function RPClientUI:initialise()
    ISPanel.initialise(self)
    self:createChildren()
end

function RPClientUI:createChildren()
    local screenWidth = getCore():getScreenWidth()
    local screenHeight = getCore():getScreenHeight()

    -- Fondo negro
    self.background = ISPanel:new(0, 0, screenWidth, screenHeight)
    self.background.backgroundColor = {r=0, g=0, b=0, a=1}
    self:addChild(self.background)

    self.messageLabel = ISLabel:new(0, 0, 25, "", 1, 1, 1, 1, UIFont.Medium, true)
    self.continueButton = ISButton:new(0, 0, 200, 25, "Continue", self, RPClientUI.onContinueButtonClick)
    self.roleComboBox = ISComboBox:new(0, 0, 200, 25, self, RPClientUI.onRoleSelected)
    self.confirmRoleButton = ISButton:new(0, 0, 200, 25, "Confirm Role", self, RPClientUI.onConfirmRoleButtonClick)
    
    self.roleDescriptionLabel = ISLabel:new(0, 0, 25, "", 1, 1, 1, 1, UIFont.Medium, true)
    self.roleDescriptionLabel:setVisible(false)

    self.roleComboBox:setVisible(false)
    self.confirmRoleButton:setVisible(false)

    self:addChild(self.messageLabel)
    self:addChild(self.continueButton)
    self:addChild(self.roleComboBox)
    self:addChild(self.confirmRoleButton)
    self:addChild(self.roleDescriptionLabel)
end

function RPClientUI:showMessage(message)
    if not self.messageLabel then
        print("Error: self.messageLabel is nil")
        return
    end

    local screenWidth = getCore():getScreenWidth()
    local screenHeight = getCore():getScreenHeight()
    
    self.messageLabel:setName(message)
    self.messageLabel:setVisible(true)
    
    -- Centrar el mensaje
    local textWidth = getTextManager():MeasureStringX(UIFont.Medium, message)
    local textHeight = getTextManager():MeasureStringY(UIFont.Medium, message)
    self.messageLabel:setX((screenWidth - textWidth) / 2)
    self.messageLabel:setY((screenHeight - textHeight) / 2)
    self.messageLabel:setWidth(textWidth)
    self.messageLabel:setHeight(textHeight)
    
    self.continueButton:setVisible(true)
    self.continueButton:setX((screenWidth - self.continueButton:getWidth()) / 2)
    self.continueButton:setY(self.messageLabel:getY() + self.messageLabel:getHeight() + 10)
    
    self.roleComboBox:setVisible(false)
    self.confirmRoleButton:setVisible(false)
    self.roleDescriptionLabel:setVisible(false)
end

function RPClientUI:showRoleSelection(roles)
    if not self.roleComboBox then
        print("Error: self.roleComboBox is nil")
        return
    end

    self.messageLabel:setVisible(false)
    self.continueButton:setVisible(false)
    self.roleComboBox:clear()
    for _, role in ipairs(roles) do
        self.roleComboBox:addOption(role.Name)
    end
    self.roleComboBox:setVisible(true)
    self.roleComboBox:setX((getCore():getScreenWidth() - self.roleComboBox:getWidth()) / 2)
    self.roleComboBox:setY((getCore():getScreenHeight() - self.roleComboBox:getHeight()) / 2)
    self.confirmRoleButton:setVisible(false)
    self.roleDescriptionLabel:setVisible(false)
end

function RPClientUI:showRoleDescription(role)
    if not self.roleDescriptionLabel then
        print("Error: self.roleDescriptionLabel is nil")
        return
    end

    if role.Description then
        local screenWidth = getCore():getScreenWidth()
        local screenHeight = getCore():getScreenHeight()
        
        self.roleDescriptionLabel:setName(role.Description)
        self.roleDescriptionLabel:setVisible(true)
        
        -- Centrar la descripción del rol
        local textWidth = getTextManager():MeasureStringX(UIFont.Medium, role.Description)
        local textHeight = getTextManager():MeasureStringY(UIFont.Medium, role.Description)
        self.roleDescriptionLabel:setX((screenWidth - textWidth) / 2)
        self.roleDescriptionLabel:setY(screenHeight / 2 + 200)
        self.roleDescriptionLabel:setWidth(textWidth)
        self.roleDescriptionLabel:setHeight(textHeight)
        
        self.confirmRoleButton:setVisible(true)
        self.confirmRoleButton:setX((screenWidth - self.confirmRoleButton:getWidth()) / 2)
        self.confirmRoleButton:setY(self.roleDescriptionLabel:getY() + self.roleDescriptionLabel:getHeight() + 10)
    else
        print("Error: role.Description is nil")
    end
end

function RPClientUI:onContinueButtonClick()
    RPClient.showNextMessage()
end

function RPClientUI:onRoleSelected()
    local selectedRole = self.roleComboBox:getSelectedText()
    RPClient.onRoleSelected(selectedRole)
end

function RPClientUI:onConfirmRoleButtonClick()
    RPClient.confirmRoleSelection()
end

RPClientUI.instance = nil

function RPClientUI:new(x, y, width, height)
    local o = ISPanel.new(self, x, y, width, height)
    RPClientUI.instance = o
    return o
end

function RPClientUI:show()
    self:setVisible(true)
    self:addToUIManager()
end

function RPClientUI:hide()
    self:setVisible(false)
    self:removeFromUIManager()
end