-- ChristmasRayfield Library v1.0 - Рождественская версия Rayfield для Roblox
-- Автор: ChatGPT (на основе Rayfield, но с новогодним стилем 99% аналогична)
-- Используйте: local ChristmasRayfield = loadstring(game:HttpGet("https://raw.githubusercontent.com/YOUR_USERNAME/ChristmasRayfield/main/ChristmasRayfield.lua"))()

local ChristmasRayfield = {}

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer

local SaveConfigJsonPath = "ChristmasRayfield_Config.json"

-- Вспомогательные функции
local function PlayTween(Object, Properties, Speed, Style, Direction, Delay)
    local Tween = TweenService:Create(Object, TweenInfo.new(Speed or 0.2, Style or Enum.EasingStyle.Linear, Direction or Enum.EasingDirection.InOut, 0, false, Delay or 0), Properties)
    Tween:Play()
    return Tween
end

local Themes = {
    Accent = Color3.fromRGB(255, 0, 0),  -- Красный (ёлка)
    Outline = Color3.fromRGB(0, 100, 0), -- Тёмно-зелёный
    Main = Color3.fromRGB(10, 10, 10),    -- Тёмный фон
    Second = Color3.fromRGB(20, 20, 20),  -- Средний фон
    Stroke = Color3.fromRGB(255, 215, 0), -- Золотой
    Text = Color3.fromRGB(255, 255, 255)   -- Белый (снег)
}

-- Снегопад эффект
local function CreateSnowfall(Parent)
    local SnowParticles = Instance.new("ParticleEmitter")
    SnowParticles.LightEmission = 0
    SnowParticles.LightInfluence = 0
    SnowParticles.Acceleration = Vector3.new(0, -10, 0)
    SnowParticles.Drag = 5
    SnowParticles.EmissionDirection = Enum.NormalId.Back
    SnowParticles.FlipbookFramerate = NumberRange.new(5, 15)
    SnowParticles.Lifetime = NumberRange.new(10, 15)
    SnowParticles.Rate = 50
    SnowParticles.Rotation = NumberRange.new(-180, 180)
    SnowParticles.RotSpeed = NumberRange.new(-10, 10)
    SnowParticles.Size = NumberSequence.new{NumberSequenceKeypoint.new(0, 0.5, 0.1), NumberSequenceKeypoint.new(1, 0, 0.1)}
    SnowParticles.Speed = NumberRange.new(5, 10)
    SnowParticles.SpreadAngle = Vector2.new(60, 60)
    SnowParticles.Texture = "rbxassetid://320370105"  -- Снежинка текстура
    SnowParticles.ZOffset = -100
    SnowParticles.Parent = Parent
end

function ChristmasRayfield:CreateWindow(Settings)
    local Passthrough = true
    local Config = {
        Name = Settings.Name or "🎄 Christmas Window 🎄",
        LoadingTitle = Settings.LoadingTitle or "🎁 Preparing Christmas...",
        LoadingSubtitle = Settings.LoadingSubtitle or "Decorating the Tree...",
        ConfigurationSaving = Settings.ConfigurationSaving or {Enabled = false}
    }

    -- Создание ScreenGui
    local GUI = Instance.new("ScreenGui")
    GUI.Name = Config.Name
    GUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    GUI.Parent = LocalPlayer:WaitForChild("PlayerGui")

    local LoadingScreen = Instance.new("Frame")
    LoadingScreen.Name = "LoadingScreen"
    LoadingScreen.BackgroundColor3 = Themes.Main
    LoadingScreen.BorderSizePixel = 0
    LoadingScreen.Size = UDim2.new(1, 0, 1, 0)
    LoadingScreen.Parent = GUI

    local LoadingUICorner = Instance.new("UICorner")
    LoadingUICorner.CornerRadius = UDim.new(0, 15)
    LoadingUICorner.Parent = LoadingScreen

    local Gradient = Instance.new("UIGradient")
    Gradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 215, 0)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 255, 0))
    })
    Gradient.Parent = LoadingScreen

    local Title = Instance.new("TextLabel")
    Title.Name = "Title"
    Title.BackgroundTransparency = 1
    Title.Position = UDim2.new(0.5, 0, 0.5, -50)
    Title.AnchorPoint = Vector2.new(0.5, 0.5)
    Title.Size = UDim2.new(0, 0, 0, 50)
    Title.Font = Enum.Font.SourceSansBold
    Title.Text = Config.LoadingTitle
    Title.TextColor3 = Themes.Text
    Title.TextSize = 30
    Title.Parent = LoadingScreen

    local Subtitle = Instance.new("TextLabel")
    Subtitle.Name = "Subtitle"
    Subtitle.BackgroundTransparency = 1
    Subtitle.Position = UDim2.new(0.5, 0, 0.5, 10)
    Subtitle.AnchorPoint = Vector2.new(0.5, 0.5)
    Subtitle.Size = UDim2.new(0, 200, 0, 30)
    Subtitle.Font = Enum.Font.SourceSans
    Subtitle.Text = Config.LoadingSubtitle
    Subtitle.TextColor3 = Themes.Text
    Subtitle.TextSize = 20
    Subtitle.Parent = LoadingScreen

    wait(2)
    LoadingScreen:Destroy()

    -- Основное окно
    local Main = Instance.new("Frame")
    Main.Name = "Main"
    Main.AnchorPoint = Vector2.new(0.5, 0.5)
    Main.BackgroundColor3 = Themes.Second
    Main.BorderSizePixel = 0
    Main.Position = UDim2.new(0.5, 0, 0.5, 0)
    Main.Size = UDim2.new(0, 600, 0, 350)
    Main.ClipsDescendants = true
    Main.Parent = GUI

    local MainUICorner = Instance.new("UICorner")
    MainUICorner.CornerRadius = UDim.new(0, 10)
    MainUICorner.Parent = Main

    local Topbar = Instance.new("Frame")
    Topbar.Name = "Topbar"
    Topbar.BackgroundColor3 = Themes.Main
    Topbar.BorderSizePixel = 0
    Topbar.Size = UDim2.new(1, 0, 0, 40)
    Topbar.Parent = Main

    local TopbarGradient = Instance.new("UIGradient")
    TopbarGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 150, 0))
    })
    TopbarGradient.Parent = Topbar

    local Title2 = Instance.new("TextLabel")
    Title2.Name = "Title"
    Title2.BackgroundTransparency = 1
    Title2.Position = UDim2.new(0, 15, 0, 0)
    Title2.Size = UDim2.new(0, 200, 1, 0)
    Title2.Font = Enum.Font.SourceSansBold
    Title2.Text = Config.Name
    Title2.TextColor3 = Themes.Text
    Title2.TextSize = 18
    Title2.TextXAlignment = Enum.TextXAlignment.Left
    Title2.Parent = Topbar

    local Icon = Instance.new("ImageLabel")
    Icon.Name = "Icon"
    Icon.BackgroundTransparency = 1
    Icon.Position = UDim2.new(1, -40, 0, 5)
    Icon.Size = UDim2.new(0, 30, 0, 30)
    Icon.Image = "rbxassetid://677930759"  -- Новогодний шар
    Icon.Parent = Topbar

    local CloseButton = Instance.new("TextButton")
    CloseButton.Name = "Close"
    CloseButton.BackgroundTransparency = 1
    CloseButton.Position = UDim2.new(1, -40, 0, 0)
    CloseButton.Size = UDim2.new(0, 40, 1, 0)
    CloseButton.Font = Enum.Font.SourceSansBold
    CloseButton.Text = "✖"
    CloseButton.TextColor3 = Color3.fromRGB(255, 0, 0)
    CloseButton.TextSize = 16
    CloseButton.Parent = Topbar

    CloseButton.MouseButton1Click:Connect(function()
        GUI:Destroy()
    end)

    local MinimizeButton = Instance.new("TextButton")
    MinimizeButton.Name = "Minimize"
    MinimizeButton.BackgroundTransparency = 1
    MinimizeButton.Position = UDim2.new(1, -80, 0, 0)
    MinimizeButton.Size = UDim2.new(0, 40, 1, 0)
    MinimizeButton.Font = Enum.Font.SourceSansBold
    MinimizeButton.Text = "_"
    MinimizeButton.TextColor3 = Themes.Text
    MinimizeButton.TextSize = 16
    MinimizeButton.Parent = Topbar

    local Window = Instance.new("ScrollingFrame")
    Window.Name = "Window"
    Window.BackgroundTransparency = 1
    Window.Position = UDim2.new(0, 0, 0, 40)
    Window.Size = UDim2.new(1, 0, 1, -40)
    Window.ScrollBarThickness = 4
    Window.CanvasSize = UDim2.new(0, 0, 0, 0)
    Window.Parent = Main

    local PageList = Instance.new("UIPageLayout")
    PageList.Name = "PageList"
    PageList.HorizontalAlignment = Enum.HorizontalAlignment.Right
    PageList.SortOrder = Enum.SortOrder.LayoutOrder
    PageList.EasingDirection = Enum.EasingDirection.InOut
    PageList.EasingStyle = Enum.EasingStyle.Quad
    PageList.FillDirection = Enum.FillDirection.Vertical
    PageList.HorizontalAlignment = Enum.HorizontalAlignment.Center
    PageList.SortOrder = Enum.SortOrder.LayoutOrder
    PageList.VerticalAlignment = Enum.VerticalAlignment.Top
    PageList.Parent = Window

    local TabList = Instance.new("Frame")
    TabList.Name = "TabList"
    TabList.BackgroundColor3 = Themes.Second
    TabList.BorderSizePixel = 0
    TabList.Position = UDim2.new(0, 10, 0, 50)
    TabList.Size = UDim2.new(0, 130, 1, -60)
    TabList.Parent = Main

    local TabListUICorner = Instance.new("UICorner")
    TabListUICorner.CornerRadius = UDim.new(0, 8)
    TabListUICorner.Parent = TabList

    local TabHolder = Instance.new("ScrollingFrame")
    TabHolder.Name = "TabHolder"
    TabHolder.BackgroundTransparency = 1
    TabHolder.Size = UDim2.new(1, 0, 1, 0)
    TabHolder.ScrollBarThickness = 0
    TabHolder.CanvasSize = UDim2.new(0, 0, 0, 0)
    TabHolder.Parent = TabList

    local TabListLayout = Instance.new("UIListLayout")
    TabListLayout.Name = "TabListLayout"
    TabListLayout.Padding = UDim.new(0, 5)
    TabListLayout.Parent = TabHolder

    local WindowTable = {
        GUI = GUI,
        Main = Main,
        Window = Window,
        TabHolder = TabHolder,
        TabList = TabList,
        PageList = PageList,
        Themes = Themes,
        Flags = {},
        Tabs = {},
        Elements = {}
    }

    -- Снегопад
    CreateSnowfall(GUI)

    -- Сохранение/загрузка конфига
    function WindowTable:SaveConfig()
        local ConfigData = {}
        for FlagName, Flag in pairs(self.Flags) do
            ConfigData[FlagName] = Flag.Value
        end
        writefile(SaveConfigJsonPath, HttpService:JSONEncode(ConfigData))
    end

    function WindowTable:LoadConfig()
        if isfile(SaveConfigJsonPath) then
            local ConfigData = HttpService:JSONDecode(readfile(SaveConfigJsonPath))
            for FlagName, Flag in pairs(self.Flags) do
                if ConfigData[FlagName] ~= nil then
                    Flag.Value = ConfigData[FlagName]
                    Flag.Callback(Flag.Value)
                end
            end
        end
    end

    if Config.ConfigurationSaving.Enabled then
        WindowTable:LoadConfig()
    end

    function WindowTable:CreateTab(Name, Icon)
        local Tab = {}

        local TabButton = Instance.new("TextButton")
        TabButton.Name = Name .. "TabButton"
        TabButton.BackgroundColor3 = Themes.Second
        TabButton.BorderSizePixel = 0
        TabButton.Size = UDim2.new(1, 0, 0, 30)
        TabButton.Font = Enum.Font.SourceSansBold
        TabButton.Text = Name
        TabButton.TextColor3 = Themes.Text
        TabButton.TextSize = 14
        TabButton.Parent = TabHolder

        local TabButtonUICorner = Instance.new("UICorner")
        TabButtonUICorner.CornerRadius = UDim.new(0, 5)
        TabButtonUICorner.Parent = TabButton

        local TabPage = Instance.new("ScrollingFrame")
        TabPage.Name = Name .. "TabPage"
        TabPage.BackgroundTransparency = 1
        TabPage.Size = UDim2.new(1, -150, 1, -60)
        TabPage.CanvasSize = UDim2.new(0, 0, 0, 0)
        TabPage.ScrollBarThickness = 4
        TabPage.Parent = Window

        local LeftSide = Instance.new("Frame")
        LeftSide.Name = "LeftSide"
        LeftSide.BackgroundTransparency = 1
        LeftSide.Size = UDim2.new(0.5, -5, 1, 0)
        LeftSide.Parent = TabPage

        local RightSide = Instance.new("Frame")
        RightSide.Name = "RightSide"
        RightSide.BackgroundTransparency = 1
        RightSide.Position = UDim2.new(0.5, 5, 0, 0)
        RightSide.Size = UDim2.new(0.5, -5, 1, 0)
        RightSide.Parent = TabPage

        local LeftLayout = Instance.new("UIListLayout")
        LeftLayout.Padding = UDim.new(0, 8)
        LeftLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
        LeftLayout.SortOrder = Enum.SortOrder.LayoutOrder
        LeftLayout.VerticalAlignment = Enum.VerticalAlignment.Top
        LeftLayout.Parent = LeftSide

        local RightLayout = Instance.new("UIListLayout")
        RightLayout.Padding = UDim.new(0, 8)
        RightLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
        RightLayout.SortOrder = Enum.SortOrder.LayoutOrder
        RightLayout.VerticalAlignment = Enum.VerticalAlignment.Top
        RightLayout.Parent = RightSide

        if Config.ConfigurationSaving.Enabled then
            self.Flags[Name] = {}
        end

        Tab = {
            Window = self,
            Name = Name,
            TabButton = TabButton,
            TabPage = TabPage,
            LeftSide = LeftSide,
            RightSide = RightSide,
            LeftLayout = LeftLayout,
            RightLayout = RightLayout,
            Sections = {},
            Elements = {}
        }

        TabButton.MouseButton1Click:Connect(function()
            for _, OtherTab in pairs(self.Tabs) do
                PlayTween(OtherTab.TabButton, {BackgroundColor3 = Themes.Second}, 0.3)
            end
            PlayTween(TabButton, {BackgroundColor3 = Themes.Accent}, 0.3)

            for _, OtherPage in pairs(Window:GetChildren()) do
                if OtherPage:IsA("ScrollingFrame") and OtherPage ~= TabPage then
                    PlayTween(OtherPage, {Size = UDim2.new(0, 0, 0, 0)}, 0.3)
                end
            end
            PlayTween(TabPage, {Size = UDim2.new(1, -150, 1, -60)}, 0.3)
        end)

        function Tab:CreateSection(Name)
            local Section = {}

            local SectionFrame = Instance.new("Frame")
            SectionFrame.Name = Name .. "Section"
            SectionFrame.BackgroundColor3 = Themes.Second
            SectionFrame.BorderSizePixel = 0
            SectionFrame.Size = UDim2.new(1, 0, 0, 50)
            SectionFrame.ClipsDescendants = true
            SectionFrame.Parent = self.LeftSide

            local SectionUICorner = Instance.new("UICorner")
            SectionUICorner.CornerRadius = UDim.new(0, 6)
            SectionUICorner.Parent = SectionFrame

            local Stroke = Instance.new("UIStroke")
            Stroke.Color = Themes.Stroke
            Stroke.Thickness = 1
            Stroke.Parent = SectionFrame

            local SectionTitle = Instance.new("TextLabel")
            SectionTitle.Name = "Title"
            SectionTitle.BackgroundTransparency = 1
            SectionTitle.Position = UDim2.new(0, 10, 0, 5)
            SectionTitle.Size = UDim2.new(0, 200, 0, 20)
            SectionTitle.Font = Enum.Font.SourceSansBold
            SectionTitle.Text = Name .. " 🎀"
            SectionTitle.TextColor3 = Themes.Text
            SectionTitle.TextSize = 14
            SectionTitle.TextXAlignment = Enum.TextXAlignment.Left
            SectionTitle.Parent = SectionFrame

            local SectionContent = Instance.new("Frame")
            SectionContent.Name = "Content"
            SectionContent.BackgroundTransparency = 1
            SectionContent.Position = UDim2.new(0, 0, 0, 30)
            SectionContent.Size = UDim2.new(1, 0, 1, -30)
            SectionContent.Parent = SectionFrame

            local SectionLayout = Instance.new("UIListLayout")
            SectionLayout.Padding = UDim.new(0, 5)
            SectionLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
            SectionLayout.SortOrder = Enum.SortOrder.LayoutOrder
            SectionLayout.VerticalAlignment = Enum.VerticalAlignment.Top
            SectionLayout.Parent = SectionContent

            Section = {
                Tab = self,
                Name = Name,
                SectionFrame = SectionFrame,
                SectionContent = SectionContent,
                SectionLayout = SectionLayout,
                Elements = {}
            }

            function Section:CreateToggle(Settings)
                local Toggle = {}

                local ToggleFrame = Instance.new("Frame")
                ToggleFrame.Name = Settings.Name .. "Toggle"
                ToggleFrame.BackgroundColor3 = Themes.Main
                ToggleFrame.BorderSizePixel = 0
                ToggleFrame.Size = UDim2.new(1, 0, 0, 35)
                ToggleFrame.Parent = self.SectionContent

                local ToggleUICorner = Instance.new("UICorner")
                ToggleUICorner.CornerRadius = UDim.new(0, 5)
                ToggleUICorner.Parent = ToggleFrame

                local ToggleLabel = Instance.new("TextLabel")
                ToggleLabel.Name = "Label"
                ToggleLabel.BackgroundTransparency = 1
                ToggleLabel.Position = UDim2.new(0, 10, 0, 0)
                ToggleLabel.Size = UDim2.new(0, 150, 1, 0)
                ToggleLabel.Font = Enum.Font.SourceSans
                ToggleLabel.Text = Settings.Name .. " ❄️"
                ToggleLabel.TextColor3 = Themes.Text
                ToggleLabel.TextSize = 14
                ToggleLabel.TextXAlignment = Enum.TextXAlignment.Left
                ToggleLabel.Parent = ToggleFrame

                local ToggleButton = Instance.new("Frame")
                ToggleButton.Name = "Button"
                ToggleButton.BackgroundColor3 = Themes.Outline
                ToggleButton.BorderSizePixel = 0
                ToggleButton.Position = UDim2.new(1, -50, 0.5, -10)
                ToggleButton.Size = UDim2.new(0, 40, 0, 20)
                ToggleButton.AnchorPoint = Vector2.new(0.5, 0.5)
                ToggleButton.Parent = ToggleFrame

                local ToggleButtonUICorner = Instance.new("UICorner")
                ToggleButtonUICorner.CornerRadius = UDim.new(1, 0)
                ToggleButtonUICorner.Parent = ToggleButton

                local ToggleButtonInner = Instance.new("Frame")
                ToggleButtonInner.Name = "Inner"
                ToggleButtonInner.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
                ToggleButtonInner.BorderSizePixel = 0
                ToggleButtonInner.Size = UDim2.new(0, 16, 0, 16)
                ToggleButtonInner.AnchorPoint = Vector2.new(0, 0.5)
                ToggleButtonInner.Position = UDim2.new(0, 2, 0.5, 0)
                ToggleButtonInner.Parent = ToggleButton

                local ToggleInnerUICorner = Instance.new("UICorner")
                ToggleInnerUICorner.CornerRadius = UDim.new(1, 0)
                ToggleInnerUICorner.Parent = ToggleButtonInner

                local CurrentValue = Settings.CurrentValue or false
                local Flag = Settings.Flag or Settings.Name

                if self.Tab.Window.ConfigurationSaving.Enabled and Flag then
                    if not self.Tab.Window.Flags[Flag] then
                        self.Tab.Window.Flags[Flag] = {Value = CurrentValue, Callback = Settings.Callback}
                    end
                    CurrentValue = self.Tab.Window.Flags[Flag].Value
                end

                local function SetValue(Value)
                    CurrentValue = Value
                    PlayTween(ToggleButtonInner, {Position = Value and UDim2.new(1, -18, 0.5, 0) or UDim2.new(0, 2, 0.5, 0)}, 0.2)
                    PlayTween(ToggleButton, {BackgroundColor3 = Value and Themes.Accent or Themes.Outline}, 0.2)
                    Settings.Callback(Value)
                    if self.Tab.Window.ConfigurationSaving.Enabled and Flag then
                        self.Tab.Window.Flags[Flag].Value = Value
                        self.Tab.Window:SaveConfig()
                    end
                end

                ToggleButton.InputBegan:Connect(function(Input)
                    if Input.UserInputType == Enum.UserInputType.MouseButton1 then
                        SetValue(not CurrentValue)
                    end
                end)

                SetValue(CurrentValue)

                Toggle = {
                    SetValue = SetValue
                }

                table.insert(self.Elements, Toggle)
                return Toggle
            end

            function Section:CreateButton(Settings)
                local Button = {}

                local ButtonFrame = Instance.new("Frame")
                ButtonFrame.Name = Settings.Name .. "Button"
                ButtonFrame.BackgroundColor3 = Themes.Accent
                ButtonFrame.BorderSizePixel = 0
                ButtonFrame.Size = UDim2.new(1, 0, 0, 35)
                ButtonFrame.Parent = self.SectionContent

                local ButtonUICorner = Instance.new("UICorner")
                ButtonUICorner.CornerRadius = UDim.new(0, 5)
                ButtonUICorner.Parent = ButtonFrame

                local ButtonLabel = Instance.new("TextButton")
                ButtonLabel.Name = "Label"
                ButtonLabel.BackgroundTransparency = 1
                ButtonLabel.Size = UDim2.new(1, 0, 1, 0)
                ButtonLabel.Font = Enum.Font.SourceSansBold
                ButtonLabel.Text = Settings.Name .. " 🎁"
                ButtonLabel.TextColor3 = Themes.Text
                ButtonLabel.TextSize = 14
                ButtonLabel.Parent = ButtonFrame

                local Stroke = Instance.new("UIStroke")
                Stroke.Color = Themes.Stroke
                Stroke.Thickness = 1
                Stroke.Parent = ButtonFrame

                ButtonLabel.MouseButton1Click:Connect(function()
                    Settings.Callback()
                end)

                Button = {
                    Callback = Settings.Callback
                }

                table.insert(self.Elements, Button)
                return Button
            end

            function Section:CreateSlider(Settings)
                local Slider = {}

                local SliderFrame = Instance.new("Frame")
                SliderFrame.Name = Settings.Name .. "Slider"
                SliderFrame.BackgroundColor3 = Themes.Main
                SliderFrame.BorderSizePixel = 0
                SliderFrame.Size = UDim2.new(1, 0, 0, 50)
                SliderFrame.Parent = self.SectionContent

                local SliderUICorner = Instance.new("UICorner")
                SliderUICorner.CornerRadius = UDim.new(0, 5)
                SliderUICorner.Parent = SliderFrame

                local SliderLabel = Instance.new("TextLabel")
                SliderLabel.Name = "Label"
                SliderLabel.BackgroundTransparency = 1
                SliderLabel.Position = UDim2.new(0, 10, 0, 5)
                SliderLabel.Size = UDim2.new(1, -20, 0, 20)
                SliderLabel.Font = Enum.Font.SourceSans
                SliderLabel.Text = Settings.Name .. " (" .. Settings.CurrentValue .. ") 🌟"
                SliderLabel.TextColor3 = Themes.Text
                SliderLabel.TextSize = 12
                SliderLabel.TextXAlignment = Enum.TextXAlignment.Left
                SliderLabel.Parent = SliderFrame

                local SliderBar = Instance.new("Frame")
                SliderBar.Name = "Bar"
                SliderBar.BackgroundColor3 = Themes.Outline
                SliderBar.BorderSizePixel = 0
                SliderBar.Position = UDim2.new(0, 10, 0, 25)
                SliderBar.Size = UDim2.new(1, -20, 0, 5)
                SliderBar.Parent = SliderFrame

                local SliderBarUICorner = Instance.new("UICorner")
                SliderBarUICorner.CornerRadius = UDim.new(1, 0)
                SliderBarUICorner.Parent = SliderBar

                local SliderFill = Instance.new("Frame")
                SliderFill.Name = "Fill"
                SliderFill.BackgroundColor3 = Themes.Accent
                SliderFill.BorderSizePixel = 0
                SliderFill.Size = UDim2.new(0, 0, 1, 0)
                SliderFill.Parent = SliderBar

                local SliderFillUICorner = Instance.new("UICorner")
                SliderFillUICorner.CornerRadius = UDim.new(1, 0)
                SliderFillUICorner.Parent = SliderFill

                local SliderThumb = Instance.new("Frame")
                SliderThumb.Name = "Thumb"
                SliderThumb.BackgroundColor3 = Themes.Stroke
                SliderThumb.BorderSizePixel = 0
                SliderThumb.Size = UDim2.new(0, 15, 1, 5)
                SliderThumb.AnchorPoint = Vector2.new(0.5, 0.5)
                SliderThumb.Parent = SliderBar

                local SliderThumbUICorner = Instance.new("UICorner")
                SliderThumbUICorner.CornerRadius = UDim.new(1, 0)
                SliderThumbUICorner.Parent = SliderThumb

                local CurrentValue = Settings.CurrentValue or 0
                local Min = Settings.Min or 0
                local Max = Settings.Max or 100
                local Flag = Settings.Flag or Settings.Name

                if self.Tab.Window.ConfigurationSaving.Enabled and Flag then
                    if not self.Tab.Window.Flags[Flag] then
                        self.Tab.Window.Flags[Flag] = {Value = CurrentValue, Callback = Settings.Callback}
                    end
                    CurrentValue = self.Tab.Window.Flags[Flag].Value
                end

                local function SetValue(Value)
                    CurrentValue = math.clamp(Value, Min, Max)
                    local Percent = (CurrentValue - Min) / (Max - Min)
                    PlayTween(SliderFill, {Size = UDim2.new(Percent, 0, 1, 0)}, 0.1)
                    PlayTween(SliderThumb, {Position = UDim2.new(Percent, 0, 0.5, 0)}, 0.1)
                    SliderLabel.Text = Settings.Name .. " (" .. tostring(CurrentValue) .. ") 🌟"
                    Settings.Callback(CurrentValue)
                    if self.Tab.Window.ConfigurationSaving.Enabled and Flag then
                        self.Tab.Window.Flags[Flag].Value = CurrentValue
                        self.Tab.Window:SaveConfig()
                    end
                end

                SliderThumb.InputBegan:Connect(function(Input)
                    if Input.UserInputType == Enum.UserInputType.MouseButton1 then
                        local Holding = true
                        local MousePos = UserInputService:GetMouseLocation()
                        local RelX = MousePos.X - SliderBar.AbsolutePosition.X
                        local Percent = math.clamp(RelX / SliderBar.AbsoluteSize.X, 0, 1)
                        local Value = Min + Percent * (Max - Min)
                        SetValue(Value)
                        while Holding do
                            RunService.RenderStepped:Wait()
                            MousePos = UserInputService:GetMouseLocation()
                            RelX = MousePos.X - SliderBar.AbsolutePosition.X
                            Percent = math.clamp(RelX / SliderBar.AbsoluteSize.X, 0, 1)
                            Value = Min + Percent * (Max - Min)
                            SetValue(Value)
                            if Holding == false then break end
                        end
                    end
                end)

                UserInputService.InputEnded:Connect(function(Input)
                    if Input.UserInputType == Enum.UserInputType.MouseButton1 then
                        Holding = false
                    end
                end)

                SetValue(CurrentValue)

                Slider = {
                    SetValue = SetValue
                }

                table.insert(self.Elements, Slider)
                return Slider
            end

            function Section:CreateTextbox(Settings)
                local Textbox = {}

                local TextboxFrame = Instance.new("Frame")
                TextboxFrame.Name = Settings.Name .. "Textbox"
                TextboxFrame.BackgroundColor3 = Themes.Main
                TextboxFrame.BorderSizePixel = 0
                TextboxFrame.Size = UDim2.new(1, 0, 0, 35)
                TextboxFrame.Parent = self.SectionContent

                local TextboxUICorner = Instance.new("UICorner")
                TextboxUICorner.CornerRadius = UDim.new(0, 5)
                TextboxUICorner.Parent = TextboxFrame

                local TextboxLabel = Instance.new("TextLabel")
                TextboxLabel.Name = "Label"
                TextboxLabel.BackgroundTransparency = 1
                TextboxLabel.Position = UDim2.new(0, 10, 0, 5)
                TextboxLabel.Size = UDim2.new(0, 80, 0, 20)
                TextboxLabel.Font = Enum.Font.SourceSans
                TextboxLabel.Text = Settings.Name .. " 📝"
                TextboxLabel.TextColor3 = Themes.Text
                TextboxLabel.TextSize = 12
                TextboxLabel.TextXAlignment = Enum.TextXAlignment.Left
                TextboxLabel.Parent = TextboxFrame

                local TextboxInput = Instance.new("TextBox")
                TextboxInput.Name = "Input"
                TextboxInput.BackgroundColor3 = Themes.Second
                TextboxInput.BorderSizePixel = 0
                TextboxInput.Position = UDim2.new(1, -150, 0, 5)
                TextboxInput.Size = UDim2.new(0, 140, 0, 25)
                TextboxInput.Font = Enum.Font.SourceSans
                TextboxInput.Text = Settings.CurrentValue or ""
                TextboxInput.TextColor3 = Themes.Text
                TextboxInput.TextSize = 12
                TextboxInput.ClearTextOnFocus = Settings.ClearTextOnFocus or false
                TextboxInput.Parent = TextboxFrame

                local TextboxInputUICorner = Instance.new("UICorner")
                TextboxInputUICorner.CornerRadius = UDim.new(0, 4)
                TextboxInputUICorner.Parent = TextboxInput

                TextboxInput.FocusLost:Connect(function(Enter)
                    if Enter then
                        Settings.Callback(TextboxInput.Text)
                    end
                end)

                Textbox = {
                    SetText = function(Text)
                        TextboxInput.Text = Text
                    end
                }

                table.insert(self.Elements, Textbox)
                return Textbox
            end

            function Section:CreateDropdown(Settings)
                local Dropdown = {}

                local DropdownFrame = Instance.new("Frame")
                DropdownFrame.Name = Settings.Name .. "Dropdown"
                DropdownFrame.BackgroundColor3 = Themes.Main
                DropdownFrame.BorderSizePixel = 0
                DropdownFrame.Size = UDim2.new(1, 0, 0, 35)
                DropdownFrame.Parent = self.SectionContent

                local DropdownUICorner = Instance.new("UICorner")
                DropdownUICorner.CornerRadius = UDim.new(0, 5)
                DropdownUICorner.Parent = DropdownFrame

                local DropdownLabel = Instance.new("TextLabel")
                DropdownLabel.Name = "Label"
                DropdownLabel.BackgroundTransparency = 1
                DropdownLabel.Position = UDim2.new(0, 10, 0, 0)
                DropdownLabel.Size = UDim2.new(0, 150, 1, 0)
                DropdownLabel.Font = Enum.Font.SourceSans
                DropdownLabel.Text = Settings.Name .. " 🎄"
                DropdownLabel.TextColor3 = Themes.Text
                DropdownLabel.TextSize = 14
                DropdownLabel.TextXAlignment = Enum.TextXAlignment.Left
                DropdownLabel.Parent = DropdownFrame

                local DropdownButton = Instance.new("TextButton")
                DropdownButton.Name = "Button"
                DropdownButton.BackgroundColor3 = Themes.Second
                DropdownButton.BorderSizePixel = 0
                DropdownButton.Position = UDim2.new(1, -150, 0, 5)
                DropdownButton.Size = UDim2.new(0, 140, 0, 25)
                DropdownButton.Font = Enum.Font.SourceSans
                DropdownButton.Text = Settings.CurrentValue or "Select"
                DropdownButton.TextColor3 = Themes.Text
                DropdownButton.TextSize = 12
                DropdownButton.Parent = DropdownFrame

                local DropdownButtonUICorner = Instance.new("UICorner")
                DropdownButtonUICorner.CornerRadius = UDim.new(0, 4)
                DropdownButtonUICorner.Parent = DropdownButton

                local DropdownList = Instance.new("Frame")
                DropdownList.Name = "List"
                DropdownList.BackgroundColor3 = Themes.Main
                DropdownList.BorderSizePixel = 0
                DropdownList.Position = UDim2.new(0, 0, 1, 5)
                DropdownList.Size = UDim2.new(1, 0, 0, #Settings.Options * 25)
                DropdownList.ClipsDescendants = true
                DropdownList.Visible = false
                DropdownList.Parent = DropdownFrame

                local DropdownListLayout = Instance.new("UIListLayout")
                DropdownListLayout.Parent = DropdownList

                local CurrentValue = Settings.CurrentValue or ""
                local Flag = Settings.Flag or Settings.Name

                if self.Tab.Window.ConfigurationSaving.Enabled and Flag then
                    if not self.Tab.Window.Flags[Flag] then
                        self.Tab.Window.Flags[Flag] = {Value = CurrentValue, Callback = Settings.Callback}
                    end
                    CurrentValue = self.Tab.Window.Flags[Flag].Value
                end

                for _, Option in pairs(Settings.Options) do
                    local OptionButton = Instance.new("TextButton")
                    OptionButton.Name = Option
                    OptionButton.BackgroundTransparency = 1
                    OptionButton.Size = UDim2.new(1, 0, 0, 25)
                    OptionButton.Font = Enum.Font.SourceSans
                    OptionButton.Text = Option
                    OptionButton.TextColor3 = Themes.Text
                    OptionButton.TextSize = 12
                    OptionButton.Parent = DropdownList

                    OptionButton.MouseButton1Click:Connect(function()
                        DropdownButton.Text = Option
                        DropdownList.Visible = false
                        Settings.Callback(Option)
                        CurrentValue = Option
                        if self.Tab.Window.ConfigurationSaving.Enabled and Flag then
                            self.Tab.Window.Flags[Flag].Value = CurrentValue
                            self.Tab.Window:SaveConfig()
                        end
                    end)
                end

                DropdownButton.MouseButton1Click:Connect(function()
                    DropdownList.Visible = not DropdownList.Visible
                end)

                if CurrentValue ~= "" then
                    DropdownButton.Text = CurrentValue
                end

                Dropdown = {
                    SetValue = function(Value)
                        DropdownButton.Text = Value
                        Settings.Callback(Value)
                    end
                }

                table.insert(self.Elements, Dropdown)
                return Dropdown
            end

            function Section:CreateColorPicker(Settings)
                -- Простая версия ColorPicker (расширьте при необходимости)
                local ColorPicker = {}

                local ColorPickerFrame = Instance.new("Frame")
                ColorPickerFrame.Name = Settings.Name .. "ColorPicker"
                ColorPickerFrame.BackgroundColor3 = Themes.Main
                ColorPickerFrame.BorderSizePixel = 0
                ColorPickerFrame.Size = UDim2.new(1, 0, 0, 35)
                ColorPickerFrame.Parent = self.SectionContent

                local ColorPickerLabel = Instance.new("TextLabel")
                ColorPickerLabel.Name = "Label"
                ColorPickerLabel.BackgroundTransparency = 1
                ColorPickerLabel.Position = UDim2.new(0, 10, 0, 0)
                ColorPickerLabel.Size = UDim2.new(0, 150, 1, 0)
                ColorPickerLabel.Font = Enum.Font.SourceSans
                ColorPickerLabel.Text = Settings.Name .. " 🎨"
                ColorPickerLabel.TextColor3 = Themes.Text
                ColorPickerLabel.TextSize = 14
                ColorPickerLabel.TextXAlignment = Enum.TextXAlignment.Left
                ColorPickerLabel.Parent = ColorPickerFrame

                local ColorDisplay = Instance.new("Frame")
                ColorDisplay.Name = "Display"
                ColorDisplay.BackgroundColor3 = Settings.CurrentValue or Color3.fromRGB(255, 255, 255)
                ColorDisplay.BorderSizePixel = 2
                ColorDisplay.BorderColor3 = Themes.Stroke
                ColorDisplay.Position = UDim2.new(1, -40, 0, 5)
                ColorDisplay.Size = UDim2.new(0, 30, 0, 25)
                ColorDisplay.Parent = ColorPickerFrame

                local CurrentValue = Settings.CurrentValue or Color3.new(1, 1, 1)
                local Flag = Settings.Flag or Settings.Name

                ColorDisplay.InputBegan:Connect(function(Input)
                    if Input.UserInputType == Enum.UserInputType.MouseButton1 then
                        -- Для полной имплементации добавьте пикер (здесь просто callback с цветом)
                        Settings.Callback(CurrentValue)
                    end
                end)

                ColorPicker = {
                    SetColor = function(Color)
                        ColorDisplay.BackgroundColor3 = Color
                        Settings.Callback(Color)
                        CurrentValue = Color
                    end
                }

                table.insert(self.Elements, ColorPicker)
                return ColorPicker
            end

            function Section:CreateLabel(Settings)
                local Label = {}

                local LabelFrame = Instance.new("Frame")
                LabelFrame.Name = Settings.Name .. "Label"
                LabelFrame.BackgroundColor3 = Themes.Main
                LabelFrame.BorderSizePixel = 0
                LabelFrame.Size = UDim2.new(1, 0, 0, 35)
                LabelFrame.Parent = self.SectionContent

                local LabelText = Instance.new("TextLabel")
                LabelText.Name = "Text"
                LabelText.BackgroundTransparency = 1
                LabelText.Size = UDim2.new(1, 0, 1, 0)
                LabelText.Font = Enum.Font.SourceSans
                LabelText.Text = Settings.Text .. " 🎄"
                LabelText.TextColor3 = Themes.Text
                LabelText.TextSize = 14
                LabelText.Parent = LabelFrame

                Label = {
                    SetText = function(Text)
                        LabelText.Text = Text .. " 🎄"
                    end
                }

                table.insert(self.Elements, Label)
                return Label
            end

            table.insert(self.Tab.Sections, Section)
            return Section
        end

        table.insert(self.Window.Tabs, Tab)
        return Tab
    end

    return WindowTable
end

return ChristmasRayfield
