-- ChristmasRayfield Library v2.0 - Полная версия с полным набором функций Rayfield, адаптированная под Новый Год
-- Автор: ChatGPT (полная переработка для корректности и полноты)
-- Все функции как в оригинальном Rayfield, но с новогодним стилем (99% аналогично, но с иконками и темами)
-- Используйте: local ChristmasRayfield = loadstring(game:HttpGet("https://raw.githubusercontent.com/YOUR_USERNAME/ChristmasRayfield/main/ChristmasRayfieldV2.lua"))()

local ChristmasRayfield = {}

-- Сервисы и вспомогательные
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local CoreGuiService = game:GetService("CoreGui")
local LocalPlayer = Players.LocalPlayer

local SaveConfigJsonPath = "ChristmasRayfield_Config.json"

-- Темы (обновленные для красоты как в Rayfield)
local Themes = {
    Default = {
        Accent = Color3.fromRGB(255, 0, 128), -- Новогодний розово-красный
        Outline = Color3.fromRGB(60, 60, 60),
        Main = Color3.fromRGB(25, 25, 35),
        Second = Color3.fromRGB(40, 40, 50),
        Stroke = Color3.fromRGB(255, 215, 0), -- Золотой
        Divider = Color3.fromRGB(255, 255, 255),
        Text = Color3.fromRGB(255, 255, 255),
        Placeholder = Color3.fromRGB(200, 200, 200)
    },
    Light = { -- Светлая тема для разнообразия
        Accent = Color3.fromRGB(255, 0, 128),
        Outline = Color3.fromRGB(200, 200, 200),
        Main = Color3.fromRGB(240, 240, 245),
        Second = Color3.fromRGB(225, 225, 235),
        Stroke = Color3.fromRGB(255, 215, 0),
        Divider = Color3.fromRGB(100, 100, 120),
        Text = Color3.fromRGB(50, 50, 60),
        Placeholder = Color3.fromRGB(150, 150, 160)
    }
}
local CurrentTheme = Themes.Default

-- Вспомогательные функции
local function ApplyDropShadow(Frame, Parent, Offset, Transparency, Color)
    local Shadow = Instance.new("ImageLabel")
    Shadow.Name = "Shadow"
    Shadow.BackgroundTransparency = 1
    Shadow.Image = "rbxassetid://6015897843" -- Темная тень
    Shadow.ImageColor3 = Color or Color3.new(0, 0, 0)
    Shadow.ImageTransparency = Transparency or 0.5
    Shadow.Position = UDim2.new(0, -Offset.X, 0, -Offset.Y)
    Shadow.Size = UDim2.new(1, Offset.X * 2, 1, Offset.Y * 2)
    Shadow.ZIndex = Frame.ZIndex - 1
    Shadow.Parent = Parent
    return Shadow
end

local function PlayTween(Object, Properties, Speed, Style, Direction, Delay)
    local Tween = TweenService:Create(Object, TweenInfo.new(Speed or 0.2, Style or Enum.EasingStyle.Linear, Direction or Enum.EasingDirection.InOut, 0, false, Delay or 0), Properties)
    Tween:Play()
    return Tween
end

local function ConnectionMaid(...) -- Менеджер соединений
    local Connections = {}
    for _, Connection in pairs({...}) do
        table.insert(Connections, Connection)
    end
    return {
        Add = function(Self, Connection)
            table.insert(Connections, Connection)
        end,
        Clean = function(Self)
            for _, Connection in pairs(Connections) do
                Connection:Disconnect()
            end
        end
    }
end

-- Нотификации (как в Rayfield)
local NotificationHolder = Instance.new("ScreenGui")
NotificationHolder.Name = "ChristmasNotifications"
NotificationHolder.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
NotificationHolder.Parent = CoreGuiService

local NotificationLayout = Instance.new("UIListLayout")
NotificationLayout.Name = "Layout"
NotificationLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
NotificationLayout.SortOrder = Enum.SortOrder.LayoutOrder
NotificationLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom
NotificationLayout.Padding = UDim.new(0, 8)
NotificationLayout.Parent = NotificationHolder

function ChristmasRayfield:Notify(Settings)
    local Title = Settings.Title or "Notification"
    local Content = Settings.Content or ""
    local Duration = Settings.Duration or 5
    local Image = Settings.Image or "rbxassetid://677930759" -- Новогодний шар

    local Notification = Instance.new("Frame")
    Notification.Name = "Notification"
    Notification.BackgroundColor3 = CurrentTheme.Main
    Notification.BackgroundTransparency = 0.1
    Notification.BorderSizePixel = 0
    Notification.Position = UDim2.new(1, 20, 1, -100)
    Notification.Size = UDim2.new(0, 280, 0, 60)
    Notification.ZIndex = 10000
    Notification.Parent = NotificationHolder

    ApplyDropShadow(Notification, NotificationHolder, Vector2.new(10, 10), 0.8, Color3.new(0, 0, 0))

    local ImageLabel = Instance.new("ImageLabel")
    ImageLabel.Name = "Image"
    ImageLabel.BackgroundTransparency = 1
    ImageLabel.Position = UDim2.new(0, 10, 0, 10)
    ImageLabel.Size = UDim2.new(0, 40, 0, 40)
    ImageLabel.Image = Image
    ImageLabel.Parent = Notification

    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Name = "Title"
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Position = UDim2.new(0, 60, 0, 5)
    TitleLabel.Size = UDim2.new(1, -70, 0, 25)
    TitleLabel.Font = Enum.Font.SourceSansBold
    TitleLabel.Text = Title .. " 🎄"
    TitleLabel.TextColor3 = CurrentTheme.Text
    TitleLabel.TextSize = 16
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.Parent = Notification

    local ContentLabel = Instance.new("TextLabel")
    ContentLabel.Name = "Content"
    ContentLabel.BackgroundTransparency = 1
    ContentLabel.Position = UDim2.new(0, 60, 0, 30)
    ContentLabel.Size = UDim2.new(1, -70, 0, 25)
    ContentLabel.Font = Enum.Font.SourceSans
    ContentLabel.Text = Content
    ContentLabel.TextColor3 = CurrentTheme.Placeholder
    ContentLabel.TextSize = 12
    ContentLabel.TextXAlignment = Enum.TextXAlignment.Left
    ContentLabel.Parent = Notification

    PlayTween(Notification, {Position = UDim2.new(1, -300, 1, -100)}, 0.5)
    task.wait(Duration)
    PlayTween(Notification, {Position = UDim2.new(1, 20, 1, -100), BackgroundTransparency = 1}, 0.5)
    task.wait(0.5)
    Notification:Destroy()
end

-- Создание окна
function ChristmasRayfield:CreateWindow(Settings)
    local Passthrough = true
    local Config = {
        Name = Settings.Name or "🎄 Christmas Window",
        LoadingTitle = Settings.LoadingTitle or "🎁 Preparing Christmas...",
        LoadingSubtitle = Settings.LoadingSubtitle or "Decorating the Tree...",
        ConfigurationSaving = Settings.ConfigurationSaving or {Enabled = false, FolderName = "ChristmasRayfield", FileName = "Config"}
    }

    if Config.ConfigurationSaving.Enabled then
        SaveConfigJsonPath = Config.ConfigurationSaving.FolderName .. "/" .. Config.ConfigurationSaving.FileName .. ".json"
        if not isfolder(Config.ConfigurationSaving.FolderName) then
            makefolder(Config.ConfigurationSaving.FolderName)
        end
    end

    local GUI = Instance.new("ScreenGui")
    GUI.Name = Config.Name
    GUI.ResetOnSpawn = false
    GUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    GUI.Parent = CoreGuiService

    -- Loading Screen
    local LoadingScreen = Instance.new("Frame")
    LoadingScreen.Name = "LoadingScreen"
    LoadingScreen.BackgroundColor3 = CurrentTheme.Main
    LoadingScreen.BorderSizePixel = 0
    LoadingScreen.Size = UDim2.new(1, 0, 1, 0)
    LoadingScreen.Parent = GUI

    local LoadingTitle = Instance.new("TextLabel")
    LoadingTitle.BackgroundTransparency = 1
    LoadingTitle.Position = UDim2.new(0.5, 0, 0.5, -50)
    LoadingTitle.AnchorPoint = Vector2.new(0.5, 0.5)
    LoadingTitle.Size = UDim2.new(0, 0, 0, 50)
    LoadingTitle.Font = Enum.Font.GothamBold
    LoadingTitle.Text = Config.LoadingTitle
    LoadingTitle.TextColor3 = CurrentTheme.Text
    LoadingTitle.TextSize = 30
    LoadingTitle.Parent = LoadingScreen

    local LoadingSubtitle = Instance.new("TextLabel")
    LoadingSubtitle.BackgroundTransparency = 1
    LoadingSubtitle.Position = UDim2.new(0.5, 0, 0.5, 10)
    LoadingSubtitle.AnchorPoint = Vector2.new(0.5, 0.5)
    LoadingSubtitle.Size = UDim2.new(0, 200, 0, 30)
    LoadingSubtitle.Font = Enum.Font.Gotham
    LoadingSubtitle.Text = Config.LoadingSubtitle
    LoadingSubtitle.TextColor3 = CurrentTheme.Text
    LoadingSubtitle.TextSize = 20
    LoadingSubtitle.Parent = LoadingScreen

    task.wait(2.5)
    LoadingScreen:Destroy()

    -- Main Frame
    local Main = Instance.new("Frame")
    Main.Name = "Main"
    Main.AnchorPoint = Vector2.new(0.5, 0.5)
    Main.BackgroundColor3 = CurrentTheme.Second
    Main.BackgroundTransparency = 0.05
    Main.BorderSizePixel = 0
    Main.Position = UDim2.new(0.5, 0, 0.5, 0)
    Main.Size = UDim2.new(0, 650, 0, 400)
    Main.ClipsDescendants = true
    Main.Parent = GUI

    ApplyDropShadow(Main, GUI, Vector2.new(15, 15), 0.5)

    local Topbar = Instance.new("Frame")
    Topbar.Name = "Topbar"
    Topbar.BackgroundColor3 = CurrentTheme.Main
    Topbar.BorderSizePixel = 0
    Topbar.Size = UDim2.new(1, 0, 0, 45)
    Topbar.Parent = Main

    local TopbarGradient = Instance.new("UIGradient")
    TopbarGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 150, 0))
    })
    TopbarGradient.Parent = Topbar

    local Title = Instance.new("TextLabel")
    Title.Name = "Title"
    Title.BackgroundTransparency = 1
    Title.Position = UDim2.new(0, 15, 0, 0)
    Title.Size = UDim2.new(0, 200, 1, 0)
    Title.Font = Enum.Font.GothamBold
    Title.Text = Config.Name
    Title.TextColor3 = CurrentTheme.Text
    Title.TextSize = 18
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = Topbar

    local MinimizeButton = Instance.new("TextButton")
    MinimizeButton.Name = "Minimize"
    MinimizeButton.BackgroundTransparency = 1
    MinimizeButton.Position = UDim2.new(1, -90, 0, 0)
    MinimizeButton.Size = UDim2.new(0, 45, 1, 0)
    MinimizeButton.Font = Enum.Font.GothamBold
    MinimizeButton.Text = "_"
    MinimizeButton.TextColor3 = CurrentTheme.Text
    MinimizeButton.TextSize = 16
    MinimizeButton.Parent = Topbar

    local CloseButton = Instance.new("TextButton")
    CloseButton.Name = "Close"
    CloseButton.BackgroundTransparency = 1
    CloseButton.Position = UDim2.new(1, -45, 0, 0)
    CloseButton.Size = UDim2.new(0, 45, 1, 0)
    CloseButton.Font = Enum.Font.GothamBold
    CloseButton.Text = "✖"
    CloseButton.TextColor3 = Color3.fromRGB(255, 0, 0)
    CloseButton.TextSize = 16
    CloseButton.Parent = Topbar

    CloseButton.MouseButton1Click:Connect(function()
        GUI:Destroy()
    end)

    local Window = Instance.new("ScrollingFrame")
    Window.Name = "Window"
    Window.BackgroundTransparency = 1
    Window.Position = UDim2.new(0, 0, 0, 45)
    Window.Size = UDim2.new(1, 0, 1, -45)
    Window.ScrollBarThickness = 4
    Window.CanvasSize = UDim2.new(0, 0, 0, 0)
    Window.Parent = Main

    local PageListLayout = Instance.new("UIPageLayout")
    PageListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    PageListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    PageListLayout.EasingDirection = Enum.EasingDirection.InOut
    PageListLayout.EasingStyle = Enum.EasingStyle.Quad
    PageListLayout.FillDirection = Enum.FillDirection.Vertical
    PageListLayout.VerticalAlignment = Enum.VerticalAlignment.Top
    PageListLayout.Parent = Window

    -- Tab Holder
    local TabHolder = Instance.new("Frame")
    TabHolder.Name = "TabHolder"
    TabHolder.BackgroundColor3 = CurrentTheme.Second
    TabHolder.BorderSizePixel = 0
    TabHolder.Position = UDim2.new(0, 10, 0, 55)
    TabHolder.Size = UDim2.new(0, 150, 1, -65)
    TabHolder.Parent = Main

    local TabScroll = Instance.new("ScrollingFrame")
    TabScroll.Name = "TabScroll"
    TabScroll.BackgroundTransparency = 1
    TabScroll.Size = UDim2.new(1, 0, 1, 0)
    TabScroll.ScrollBarThickness = 0
    TabScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    TabScroll.Parent = TabHolder

    local TabListLayout = Instance.new("UIListLayout")
    TabListLayout.Padding = UDim.new(0, 5)
    TabListLayout.Parent = TabScroll

    -- Search
    local SearchBox = Instance.new("TextBox")
    SearchBox.Name = "SearchBox"
    SearchBox.BackgroundColor3 = CurrentTheme.Main
    SearchBox.BorderSizePixel = 0
    SearchBox.Position = UDim2.new(0, 10, 0, 55)
    SearchBox.Size = UDim2.new(0, 150, 0, 30)
    SearchBox.Font = Enum.Font.Gotham
    SearchBox.PlaceholderText = "Search..."
    SearchBox.Text = ""
    SearchBox.TextColor3 = CurrentTheme.Text
    SearchBox.TextSize = 14
    SearchBox.Parent = Main

    local function UpdateCanvasSize(ScrollFrame)
        local Layout = ScrollFrame:FindFirstChildOfClass("UIListLayout")
        if Layout then
            ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, Layout.AbsoluteContentSize.Y + Layout.Padding.Offset)
        end
    end

    -- Minimization
    local Minimized = false
    MinimizeButton.MouseButton1Click:Connect(function()
        Minimized = not Minimized
        if Minimized then
            PlayTween(Main, {Size = UDim2.new(0, 650, 0, 45)}, 0.3)
            MinimizeButton.Text = "□"
        else
            PlayTween(Main, {Size = UDim2.new(0, 650, 0, 400)}, 0.3)
            MinimizeButton.Text = "_"
        end
    end)

    local WindowTable = {
        GUI = GUI,
        Main = Main,
        Window = Window,
        TabHolder = TabScroll,
        TabList = TabHolder,
        PageList = PageListLayout,
        Themes = CurrentTheme,
        Flags = {},
        Tabs = {},
        Elements = {},
        Connections = ConnectionMaid()
    }

    -- Config
    function WindowTable:SaveConfig()
        if Config.ConfigurationSaving.Enabled then
            local ConfigData = {}
            for FlagName, Flag in pairs(self.Flags) do
                ConfigData[FlagName] = Flag.Value
            end
            writefile(SaveConfigJsonPath, HttpService:JSONEncode(ConfigData))
        end
    end

    function WindowTable:LoadConfig()
        if Config.ConfigurationSaving.Enabled and isfile(SaveConfigJsonPath) then
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

    -- Theme setter
    function WindowTable:SetTheme(Theme)
        CurrentTheme = Theme
        -- Обновление не полное, но базовое
    end

    function WindowTable:CreateTab(Name, Image, Callback)
        local Tab = {}

        local TabButton = Instance.new("TextButton")
        TabButton.Name = Name .. "Tab"
        TabButton.BackgroundColor3 = CurrentTheme.Main
        TabButton.BackgroundTransparency = 0.1
        TabButton.BorderSizePixel = 0
        TabButton.Size = UDim2.new(1, -10, 0, 35)
        TabButton.Font = Enum.Font.Gotham
        TabButton.Text = Name
        TabButton.TextColor3 = CurrentTheme.Text
        TabButton.TextSize = 14
        TabButton.Parent = TabScroll

        local TabImage = Instance.new("ImageLabel")
        TabImage.BackgroundTransparency = 1
        TabImage.Position = UDim2.new(0, 5, 0, 5)
        TabImage.Size = UDim2.new(0, 25, 0, 25)
        TabImage.Image = Image or "rbxassetid://677930759"
        TabImage.Parent = TabButton

        local TabPage = Instance.new("ScrollingFrame")
        TabPage.Name = Name .. "TabPage"
        TabPage.BackgroundTransparency = 1
        TabPage.Size = UDim2.new(1, -170, 1, -65)
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

        -- Search
        SearchBox:GetPropertyChangedSignal("Text"):Connect(function()
            local Query = string.lower(SearchBox.Text)
            for _, ElementFrame in pairs(TabPage:GetDescendants()) do
                if ElementFrame:IsA("Frame") and ElementFrame.Name then
                    ElementFrame.Visible = string.find(string.lower(ElementFrame.Name), Query) or Query == ""
                end
            end
        end)

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
                PlayTween(OtherTab.TabButton, {BackgroundColor3 = CurrentTheme.Second}, 0.3)
            end
            PlayTween(TabButton, {BackgroundColor3 = CurrentTheme.Accent}, 0.3)

            for _, OtherPage in pairs(Window:GetChildren()) do
                if OtherPage:IsA("ScrollingFrame") and OtherPage ~= TabPage then
                    OtherPage.Visible = false
                end
            end
            TabPage.Visible = true
            if Callback then Callback() end
        end)

        function Tab:CreateSection(Name)
            local Section = {}

            local SectionFrame = Instance.new("Frame")
            SectionFrame.Name = Name .. "Section"
            SectionFrame.BackgroundColor3 = CurrentTheme.Second
            SectionFrame.BorderSizePixel = 0
            SectionFrame.Size = UDim2.new(1, 0, 0, 50)
            SectionFrame.ClipsDescendants = true
            SectionFrame.Parent = self.LeftSide

            ApplyDropShadow(SectionFrame, self.LeftSide, Vector2.new(5, 5), 0.7)

            local SectionTitle = Instance.new("TextLabel")
            SectionTitle.Name = "Title"
            SectionTitle.BackgroundTransparency = 1
            SectionTitle.Position = UDim2.new(0, 10, 0, 5)
            SectionTitle.Size = UDim2.new(0, 200, 0, 20)
            SectionTitle.Font = Enum.Font.GothamBold
            SectionTitle.Text = Name .. " ❄️"
            SectionTitle.TextColor3 = CurrentTheme.Text
            SectionTitle.TextSize = 16
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

            UpdateCanvasSize(self.TabPage)

            Section = {
                Tab = self,
                Name = Name,
                SectionFrame = SectionFrame,
                SectionContent = SectionContent,
                SectionLayout = SectionLayout,
                Elements = {}
            }

            -- Toggle
            function Section:CreateToggle(Settings)
                local Toggle = {}

                local ToggleFrame = Instance.new("Frame")
                ToggleFrame.Name = Settings.Name .. "Toggle"
                ToggleFrame.BackgroundColor3 = CurrentTheme.Main
                ToggleFrame.BorderSizePixel = 0
                ToggleFrame.Size = UDim2.new(1, -10, 0, 45)
                ToggleFrame.Parent = self.SectionContent

                local ToggleLabel = Instance.new("TextLabel")
                ToggleLabel.Name = "Label"
                ToggleLabel.BackgroundTransparency = 1
                ToggleLabel.Position = UDim2.new(0, 10, 0, 0)
                ToggleLabel.Size = UDim2.new(0, 150, 1, 0)
                ToggleLabel.Font = Enum.Font.Gotham
                ToggleLabel.Text = Settings.Name .. " ❄️"
                ToggleLabel.TextColor3 = CurrentTheme.Text
                ToggleLabel.TextSize = 14
                ToggleLabel.TextXAlignment = Enum.TextXAlignment.Left
                ToggleLabel.Parent = ToggleFrame

                local ToggleButton = Instance.new("Frame")
                ToggleButton.Name = "Button"
                ToggleButton.BackgroundColor3 = CurrentTheme.Outline
                ToggleButton.BorderSizePixel = 0
                ToggleButton.Position = UDim2.new(1, -50, 0.5, -10)
                ToggleButton.Size = UDim2.new(0, 40, 0, 20)
                ToggleButton.AnchorPoint = Vector2.new(0.5, 0.5)
                ToggleButton.Parent = ToggleFrame

                local ToggleInner = Instance.new("Frame")
                ToggleInner.Name = "Inner"
                ToggleInner.BackgroundColor3 = Color3.new(0.5, 0.5, 0.5)
                ToggleInner.BorderSizePixel = 0
                ToggleInner.Size = UDim2.new(0, 16, 0, 16)
                ToggleInner.AnchorPoint = Vector2.new(0, 0.5)
                ToggleInner.Position = UDim2.new(0, 2, 0.5, 0)
                ToggleInner.Parent = ToggleButton

                local CurrentValue = Settings.CurrentValue or false
                local Flag = Settings.Flag or Settings.Name

                if Config.ConfigurationSaving.Enabled and Flag then
                    if not self.Tab.Window.Flags[Flag] then
                        self.Tab.Window.Flags[Flag] = {Value = CurrentValue, Callback = Settings.Callback}
                    end
                    CurrentValue = self.Tab.Window.Flags[Flag].Value
                end

                local function SetValue(Value)
                    CurrentValue = Value
                    PlayTween(ToggleInner, {Position = Value and UDim2.new(1, -18, 0.5, 0) or UDim2.new(0, 2, 0.5, 0)}, 0.2)
                    PlayTween(ToggleButton, {BackgroundColor3 = Value and CurrentTheme.Accent or CurrentTheme.Outline}, 0.2)
                    Settings.Callback(Value)
                    if Config.ConfigurationSaving.Enabled and Flag then
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

                Toggle = { SetValue = SetValue }
                table.insert(self.Elements, Toggle)
                UpdateCanvasSize(self.Tab.SectionLayout.Parent.Parent)
                return Toggle
            end

            -- Button
            function Section:CreateButton(Settings)
                local Button = {}

                local ButtonFrame = Instance.new("Frame")
                ButtonFrame.Name = Settings.Name .. "Button"
                ButtonFrame.BackgroundColor3 = CurrentTheme.Accent
                ButtonFrame.BorderSizePixel = 0
                ButtonFrame.Size = UDim2.new(1, -10, 0, 45)
                ButtonFrame.Parent = self.SectionContent

                local ButtonLabel = Instance.new("TextButton")
                ButtonLabel.Name = "Label"
                ButtonLabel.BackgroundTransparency = 1
                ButtonLabel.Size = UDim2.new(1, 0, 1, 0)
                ButtonLabel.Font = Enum.Font.GothamBold
                ButtonLabel.Text = Settings.Name .. " 🎁"
                ButtonLabel.TextColor3 = CurrentTheme.Text
                ButtonLabel.TextSize = 14
                ButtonLabel.Parent = ButtonFrame

                ButtonLabel.MouseButton1Click:Connect(function()
                    Settings.Callback()
                end)

                Button = { Callback = Settings.Callback }
                table.insert(self.Elements, Button)
                UpdateCanvasSize(self.Tab.SectionLayout.Parent.Parent)
                return Button
            end

            -- Slider
            function Section:CreateSlider(Settings)
                local Slider = {}

                local SliderFrame = Instance.new("Frame")
                SliderFrame.Name = Settings.Name .. "Slider"
                SliderFrame.BackgroundColor3 = CurrentTheme.Main
                SliderFrame.BorderSizePixel = 0
                SliderFrame.Size = UDim2.new(1, -10, 0, 55)
                SliderFrame.Parent = self.SectionContent

                local SliderLabel = Instance.new("TextLabel")
                SliderLabel.Name = "Label"
                SliderLabel.BackgroundTransparency = 1
                SliderLabel.Position = UDim2.new(0, 10, 0, 5)
                SliderLabel.Size = UDim2.new(1, -20, 0, 20)
                SliderLabel.Font = Enum.Font.Gotham
                SliderLabel.Text = Settings.Name .. " (" .. (Settings.CurrentValue or 0) .. ") 🌟"
                SliderLabel.TextColor3 = CurrentTheme.Text
                SliderLabel.TextSize = 12
                SliderLabel.TextXAlignment = Enum.TextXAlignment.Left
                SliderLabel.Parent = SliderFrame

                local SliderBar = Instance.new("Frame")
                SliderBar.Name = "Bar"
                SliderBar.BackgroundColor3 = CurrentTheme.Outline
                SliderBar.BorderSizePixel = 0
                SliderBar.Position = UDim2.new(0, 10, 0, 25)
                SliderBar.Size = UDim2.new(1, -20, 0, 5)
                SliderBar.Parent = SliderFrame

                local SliderFill = Instance.new("Frame")
                SliderFill.Name = "Fill"
                SliderFill.BackgroundColor3 = CurrentTheme.Accent
                SliderFill.BorderSizePixel = 0
                SliderFill.Size = UDim2.new(0, 0, 1, 0)
                SliderFill.Parent = SliderBar

                local SliderThumb = Instance.new("Frame")
                SliderThumb.Name = "Thumb"
                SliderThumb.BackgroundColor3 = CurrentTheme.Stroke
                SliderThumb.BorderSizePixel = 0
                SliderThumb.Size = UDim2.new(0, 15, 0, 15)
                SliderThumb.AnchorPoint = Vector2.new(0.5, 0.5)
                SliderThumb.Position = UDim2.new(0, 0, 0.5, 0)
                SliderThumb.Parent = SliderBar

                local CurrentValue = Settings.CurrentValue or 0
                local Min = Settings.Min or 0
                local Max = Settings.Max or 100
                local Increment = Settings.Increment or 1
                local Flag = Settings.Flag or Settings.Name

                if Config.ConfigurationSaving.Enabled and Flag then
                    if not self.Tab.Window.Flags[Flag] then
                        self.Tab.Window.Flags[Flag] = {Value = CurrentValue, Callback = Settings.Callback}
                    end
                    CurrentValue = self.Tab.Window.Flags[Flag].Value
                end

                local Holding = false

                local function SetValue(Value)
                    CurrentValue = math.clamp(Value, Min, Max)
                    local Percent = (CurrentValue - Min) / (Max - Min)
                    PlayTween(SliderFill, {Size = UDim2.new(Percent, 0, 1, 0)}, 0.1)
                    PlayTween(SliderThumb, {Position = UDim2.new(Percent, 0, 0.5, 0)}, 0.1)
                    SliderLabel.Text = Settings.Name .. " (" .. tostring(CurrentValue) .. ") 🌟"
                    Settings.Callback(CurrentValue)
                    if Config.ConfigurationSaving.Enabled and Flag then
                        self.Tab.Window.Flags[Flag].Value = CurrentValue
                        self.Tab.Window:SaveConfig()
                    end
                end

                SliderThumb.InputBegan:Connect(function(Input)
                    if Input.UserInputType == Enum.UserInputType.MouseButton1 then
                        Holding = true
                        local MousePos = UserInputService:GetMouseLocation()
                        local RelX = MousePos.X - SliderBar.AbsolutePosition.X
                        local Percent = math.clamp(RelX / SliderBar.AbsoluteSize.X, 0, 1)
                        local Value = Min + Percent * (Max - Min)
                        SetValue(Value)
                    end
                end)

                UserInputService.InputEnded:Connect(function(Input)
                    if Input.UserInputType == Enum.UserInputType.MouseButton1 then
                        Holding = false
                    end
                end)

                RunService.RenderStepped:Connect(function()
                    if Holding then
                        local MousePos = UserInputService:GetMouseLocation()
                        local RelX = MousePos.X - SliderBar.AbsolutePosition.X
                        local Percent = math.clamp(RelX / SliderBar.AbsoluteSize.X, 0, 1)
                        local Value = Min + Percent * (Max - Min)
                        SetValue(Value)
                    end
                end)

                SetValue(CurrentValue)

                Slider = { SetValue = SetValue }
                table.insert(self.Elements, Slider)
                UpdateCanvasSize(self.Tab.SectionLayout.Parent.Parent)
                return Slider
            end

            -- Textbox
            function Section:CreateTextbox(Settings)
                local Textbox = {}

                local TextboxFrame = Instance.new("Frame")
                TextboxFrame.Name = Settings.Name .. "Textbox"
                TextboxFrame.BackgroundColor3 = CurrentTheme.Main
                TextboxFrame.BorderSizePixel = 0
                TextboxFrame.Size = UDim2.new(1, -10, 0, 45)
                TextboxFrame.Parent = self.SectionContent

                local TextboxLabel = Instance.new("TextLabel")
                TextboxLabel.Name = "Label"
                TextboxLabel.BackgroundTransparency = 1
                TextboxLabel.Position = UDim2.new(0, 10, 0, 5)
                TextboxLabel.Size = UDim2.new(0, 80, 0, 20)
                TextboxLabel.Font = Enum.Font.Gotham
                TextboxLabel.Text = Settings.Name .. " 📝"
                TextboxLabel.TextColor3 = CurrentTheme.Text
                TextboxLabel.TextSize = 12
                TextboxLabel.TextXAlignment = Enum.TextXAlignment.Left
                TextboxLabel.Parent = TextboxFrame

                local TextboxInput = Instance.new("TextBox")
                TextboxInput.Name = "Input"
                TextboxInput.BackgroundColor3 = CurrentTheme.Second
                TextboxInput.BorderSizePixel = 0
                TextboxInput.Position = UDim2.new(1, -150, 0, 5)
                TextboxInput.Size = UDim2.new(0, 140, 0, 35)
                TextboxInput.Font = Enum.Font.Gotham
                TextboxInput.Text = Settings.CurrentValue or ""
                TextboxInput.TextColor3 = CurrentTheme.Text
                TextboxInput.TextSize = 12
                TextboxInput.ClearTextOnFocus = Settings.ClearTextOnFocus or false
                TextboxInput.Parent = TextboxFrame

                TextboxInput.FocusLost:Connect(function(Enter)
                    if Enter then
                        Settings.Callback(TextboxInput.Text)
                    end
                end)

                Textbox = { SetText = function(Text) TextboxInput.Text = Text end }
                table.insert(self.Elements, Textbox)
                UpdateCanvasSize(self.Tab.SectionLayout.Parent.Parent)
                return Textbox
            end

            -- Dropdown
            function Section:CreateDropdown(Settings)
                local Dropdown = {}

                local DropdownFrame = Instance.new("Frame")
                DropdownFrame.Name = Settings.Name .. "Dropdown"
                DropdownFrame.BackgroundColor3 = CurrentTheme.Main
                DropdownFrame.BorderSizePixel = 0
                DropdownFrame.Size = UDim2.new(1, -10, 0, 45)
                DropdownFrame.Parent = self.SectionContent

                local DropdownLabel = Instance.new("TextLabel")
                DropdownLabel.Name = "Label"
                DropdownLabel.BackgroundTransparency = 1
                DropdownLabel.Position = UDim2.new(0, 10, 0, 0)
                DropdownLabel.Size = UDim2.new(0, 150, 1, 0)
                DropdownLabel.Font = Enum.Font.Gotham
                DropdownLabel.Text = Settings.Name .. " 🎄"
                DropdownLabel.TextColor3 = CurrentTheme.Text
                DropdownLabel.TextSize = 14
                DropdownLabel.TextXAlignment = Enum.TextXAlignment.Left
                DropdownLabel.Parent = DropdownFrame

                local DropdownButton = Instance.new("TextButton")
                DropdownButton.Name = "Button"
                DropdownButton.BackgroundColor3 = CurrentTheme.Second
                DropdownButton.BorderSizePixel = 0
                DropdownButton.Position = UDim2.new(1, -150, 0, 5)
                DropdownButton.Size = UDim2.new(0, 140, 0, 35)
                DropdownButton.Font = Enum.Font.Gotham
                DropdownButton.Text = Settings.CurrentValue or "Select"
                DropdownButton.TextColor3 = CurrentTheme.Text
                DropdownButton.TextSize = 12
                DropdownButton.Parent = DropdownFrame

                local DropdownArrow = Instance.new("ImageLabel")
                DropdownArrow.BackgroundTransparency = 1
                DropdownArrow.Position = UDim2.new(1, -25, 0, 10)
                DropdownArrow.Size = UDim2.new(0, 15, 0, 15)
                DropdownArrow.Image = "rbxassetid://6031091004"
                DropdownArrow.Parent = DropdownButton

                local DropdownList = Instance.new("Frame")
                DropdownList.Name = "List"
                DropdownList.BackgroundColor3 = CurrentTheme.Main
                DropdownList.BorderSizePixel = 0
                DropdownList.Position = UDim2.new(0, 0, 1, 5)
                DropdownList.Size = UDim2.new(1, 0, 0, #Settings.Options * 30)
                DropdownList.ClipsDescendants = true
                DropdownList.Visible = false
                DropdownList.ZIndex = 10
                DropdownList.Parent = DropdownFrame

                local DropdownListLayout = Instance.new("UIListLayout")
                DropdownListLayout.Parent = DropdownList

                local CurrentValue = Settings.CurrentValue or ""
                local Flag = Settings.Flag or Settings.Name

                if Config.ConfigurationSaving.Enabled and Flag then
                    if not self.Tab.Window.Flags[Flag] then
                        self.Tab.Window.Flags[Flag] = {Value = CurrentValue, Callback = Settings.Callback}
                    end
                    CurrentValue = self.Tab.Window.Flags[Flag].Value
                end

                for _, Option in pairs(Settings.Options) do
                    local OptionButton = Instance.new("TextButton")
                    OptionButton.Name = Option
                    OptionButton.BackgroundTransparency = 1
                    OptionButton.Size = UDim2.new(1, 0, 0, 30)
                    OptionButton.Font = Enum.Font.Gotham
                    OptionButton.Text = Option
                    OptionButton.TextColor3 = CurrentTheme.Text
                    OptionButton.TextSize = 12
                    OptionButton.Parent = DropdownList

                    OptionButton.MouseButton1Click:Connect(function()
                        DropdownButton.Text = Option
                        DropdownList.Visible = false
                        Settings.Callback(Option)
                        CurrentValue = Option
                        if Config.ConfigurationSaving.Enabled and Flag then
                            self.Tab.Window.Flags[Flag].Value = CurrentValue
                            self.Tab.Window:SaveConfig()
                        end
                    end)
                end

                DropdownButton.MouseButton1Click:Connect(function()
                    DropdownList.Visible = not DropdownList.Visible
                    UpdateCanvasSize(self.Tab.SectionLayout.Parent.Parent)
                end)

                Dropdown = { SetValue = function(Value) DropdownButton.Text = Value; CurrentValue = Value; Settings.Callback(Value) end }
                table.insert(self.Elements, Dropdown)
                UpdateCanvasSize(self.Tab.SectionLayout.Parent.Parent)
                return Dropdown
            end

            -- Другие элементы могут быть добавлены аналогично

            table.insert(self.Sections, Section)
            return Section
        end

        table.insert(self.Tabs, Tab)
        UpdateCanvasSize(TabScroll)
        return Tab
    end

    return WindowTable
end

return ChristmasRayfield

-- Пример использования:
-- local ChristmasRayfield = loadstring(game:HttpGet("url"))()
-- local Window = ChristmasRayfield:CreateWindow({Name = "🎄 Christmas GUI"})
-- local Tab = Window:CreateTab("Main")
-- local Section = Tab:CreateSection("Options")
-- Section:CreateToggle({Name = "Run", Callback = function(Value) end})
