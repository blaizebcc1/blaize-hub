local BlaizeHub = {}

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local LocalPlayer = Players.LocalPlayer

local Theme = {
	Background   = Color3.fromRGB(15, 15, 15),
	Sidebar      = Color3.fromRGB(10, 10, 10),
	TopBar       = Color3.fromRGB(10, 10, 10),
	Accent       = Color3.fromRGB(200, 200, 200),
	AccentLine   = Color3.fromRGB(255, 255, 255),
	TabActive    = Color3.fromRGB(25, 25, 25),
	TabInactive  = Color3.fromRGB(15, 15, 15),
	Text         = Color3.fromRGB(235, 235, 235),
	SubText      = Color3.fromRGB(100, 100, 100),
	Border       = Color3.fromRGB(32, 32, 32),
	WinBtn       = Color3.fromRGB(28, 28, 28),
	WinBtnText   = Color3.fromRGB(160, 160, 160),
	Toggle       = Color3.fromRGB(38, 38, 38),
	ToggleEnabled= Color3.fromRGB(255, 255, 255),
	RowBg        = Color3.fromRGB(20, 20, 20),
	RowHover     = Color3.fromRGB(28, 28, 28),
	SectionText  = Color3.fromRGB(80, 80, 80),
}

local function Tween(obj, props, t, style, dir)
	local info = TweenInfo.new(t or 0.15, style or Enum.EasingStyle.Quad, dir or Enum.EasingDirection.Out)
	local tw = TweenService:Create(obj, info, props)
	tw:Play()
	return tw
end

local function Create(class, props)
	local inst = Instance.new(class)
	for k, v in pairs(props) do
		if k ~= "Parent" then inst[k] = v end
	end
	if props.Parent then inst.Parent = props.Parent end
	return inst
end

local function MakeDraggable(frame, handle)
	local dragging, dragInput, mousePos, framePos = false, nil, nil, nil
	handle.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = true
			mousePos = input.Position
			framePos = frame.Position
			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					dragging = false
				end
			end)
		end
	end)
	handle.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement then
			dragInput = input
		end
	end)
	UserInputService.InputChanged:Connect(function(input)
		if input == dragInput and dragging then
			local delta = input.Position - mousePos
			frame.Position = UDim2.new(
				framePos.X.Scale, framePos.X.Offset + delta.X,
				framePos.Y.Scale, framePos.Y.Offset + delta.Y
			)
		end
	end)
end

local ScreenGui

function BlaizeHub:CreateWindow(config)
	config = config or {}
	local Title = config.Title or "Blaize Hub"
	local Width = config.Width or 620
	local Height = config.Height or 430

	ScreenGui = Create("ScreenGui", {
		Name = "BlaizeHub",
		ResetOnSpawn = false,
		ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
		Parent = CoreGui,
	})

	local Main = Create("Frame", {
		Name = "Main",
		Size = UDim2.new(0, Width, 0, Height),
		Position = UDim2.new(0.5, -(Width/2), 0.5, -(Height/2)),
		BackgroundColor3 = Theme.Background,
		BorderSizePixel = 0,
		ClipsDescendants = true,
		Parent = ScreenGui,
	})
	Create("UICorner", { CornerRadius = UDim.new(0, 8), Parent = Main })
	Create("UIStroke", { Color = Theme.Border, Thickness = 1, ApplyStrokeMode = Enum.ApplyStrokeMode.Border, Parent = Main })


	local TopBar = Create("Frame", {
		Size = UDim2.new(1, 0, 0, 44),
		BackgroundColor3 = Theme.TopBar,
		BorderSizePixel = 0,
		Parent = Main,
	})
	Create("UICorner", { CornerRadius = UDim.new(0, 8), Parent = TopBar })
	-- cover bottom corners of topbar
	Create("Frame", {
		Size = UDim2.new(1, 0, 0, 8),
		Position = UDim2.new(0, 0, 1, -8),
		BackgroundColor3 = Theme.TopBar,
		BorderSizePixel = 0,
		Parent = TopBar,
	})
	-- topbar bottom border
	Create("Frame", {
		Size = UDim2.new(1, 0, 0, 1),
		Position = UDim2.new(0, 0, 1, 0),
		BackgroundColor3 = Theme.Border,
		BorderSizePixel = 0,
		Parent = TopBar,
	})

	Create("ImageLabel", {
		Size = UDim2.new(0, 22, 0, 22),
		Position = UDim2.new(0, 14, 0.5, -11),
		BackgroundTransparency = 1,
		Image = "rbxassetid://132094132649977",
		Parent = TopBar,
	})
	Create("TextLabel", {
		Size = UDim2.new(1, -130, 1, 0),
		Position = UDim2.new(0, 44, 0, 0),
		BackgroundTransparency = 1,
		Text = Title,
		TextColor3 = Theme.Text,
		Font = Enum.Font.GothamBold,
		TextSize = 13,
		TextXAlignment = Enum.TextXAlignment.Left,
		Parent = TopBar,
	})

	local function MakeWinBtn(xOffset, label)
		local b = Create("TextButton", {
			Size = UDim2.new(0, 30, 0, 20),
			Position = UDim2.new(1, xOffset, 0.5, -10),
			BackgroundColor3 = Theme.WinBtn,
			BorderSizePixel = 0,
			Text = label,
			TextColor3 = Theme.WinBtnText,
			Font = Enum.Font.GothamBold,
			TextSize = 12,
			AutoButtonColor = false,
			Parent = TopBar,
		})
		Create("UICorner", { CornerRadius = UDim.new(0, 4), Parent = b })
		return b
	end

	local BtnMin   = MakeWinBtn(-74, "-")
	local BtnClose = MakeWinBtn(-40, "x")

	BtnMin.MouseEnter:Connect(function() Tween(BtnMin, { BackgroundColor3 = Color3.fromRGB(45,45,45) }, 0.1) end)
	BtnMin.MouseLeave:Connect(function() Tween(BtnMin, { BackgroundColor3 = Theme.WinBtn }, 0.1) end)
	BtnClose.MouseEnter:Connect(function() Tween(BtnClose, { BackgroundColor3 = Color3.fromRGB(110,28,28) }, 0.1) end)
	BtnClose.MouseLeave:Connect(function() Tween(BtnClose, { BackgroundColor3 = Theme.WinBtn }, 0.1) end)

	BtnClose.MouseButton1Click:Connect(function()
		Tween(Main, { Size = UDim2.new(0, Width, 0, 0) }, 0.15)
		task.delay(0.18, function() ScreenGui:Destroy() end)
	end)

	local LogoBtn = Create("ImageButton", {
		Name = "BlaizeMinIcon",
		Size = UDim2.new(0, 46, 0, 46),
		Position = UDim2.new(0.5, -23, 0, 8),
		BackgroundColor3 = Color3.fromRGB(12, 12, 12),
		BorderSizePixel = 0,
		Image = "rbxassetid://132094132649977",
		ImageColor3 = Color3.fromRGB(255, 255, 255),
		Visible = false,
		ZIndex = 10,
		Parent = ScreenGui,
	})
	Create("UICorner", { CornerRadius = UDim.new(0, 10), Parent = LogoBtn })
	Create("UIStroke", { Color = Theme.Border, Thickness = 1.5, Parent = LogoBtn })

	LogoBtn.MouseEnter:Connect(function() Tween(LogoBtn, { BackgroundColor3 = Color3.fromRGB(26,26,26) }, 0.1) end)
	LogoBtn.MouseLeave:Connect(function() Tween(LogoBtn, { BackgroundColor3 = Color3.fromRGB(12,12,12) }, 0.1) end)
	MakeDraggable(LogoBtn, LogoBtn)
	LogoBtn.MouseButton1Click:Connect(function() LogoBtn.Visible = false Main.Visible = true end)

	local minimised = false
	BtnMin.MouseButton1Click:Connect(function()
		minimised = not minimised
		if minimised then Main.Visible = false LogoBtn.Visible = true
		else LogoBtn.Visible = false Main.Visible = true end
	end)

	MakeDraggable(Main, TopBar)

	local SidebarWidth = 155

	local Sidebar = Create("Frame", {
		Size = UDim2.new(0, SidebarWidth, 1, -44),
		Position = UDim2.new(0, 0, 0, 44),
		BackgroundColor3 = Theme.Sidebar,
		BorderSizePixel = 0,
		Parent = Main,
	})
	-- sidebar right border
	Create("Frame", {
		Size = UDim2.new(0, 1, 1, 0),
		Position = UDim2.new(1, 0, 0, 0),
		BackgroundColor3 = Theme.Border,
		BorderSizePixel = 0,
		Parent = Sidebar,
	})

	local TabList = Create("ScrollingFrame", {
		Size = UDim2.new(1, 0, 1, -10),
		Position = UDim2.new(0, 0, 0, 10),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		ScrollBarThickness = 0,
		CanvasSize = UDim2.new(0, 0, 0, 0),
		AutomaticCanvasSize = Enum.AutomaticSize.Y,
		Parent = Sidebar,
	})
	Create("UIListLayout", { SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 2), Parent = TabList })
	Create("UIPadding", { PaddingLeft = UDim.new(0, 8), PaddingRight = UDim.new(0, 8), Parent = TabList })

	local ContentArea = Create("Frame", {
		Name = "ContentArea",
		Size = UDim2.new(1, -SidebarWidth, 1, -44),
		Position = UDim2.new(0, SidebarWidth, 0, 44),
		BackgroundColor3 = Theme.Background,
		BorderSizePixel = 0,
		ClipsDescendants = true,
		Parent = Main,
	})

	local Window = {}
	local Tabs = {}
	local ActiveTab = nil

	function Window:SetActiveTab(tabName)
		for name, tab in pairs(Tabs) do
			local active = name == tabName
			tab.Button.BackgroundColor3 = active and Theme.TabActive or Theme.TabInactive
			tab.Button.TextColor3 = active and Theme.Text or Theme.SubText
			local bar = tab.Button:FindFirstChild("AccentBar")
			if bar then bar.Visible = active end
			tab.Page.Visible = active
			if active then ActiveTab = name end
		end
	end

	function Window:AddTab(config)
		config = config or {}
		local Name = config.Name or "Tab"

		local TabBtn = Create("TextButton", {
			Name = Name,
			Size = UDim2.new(1, 0, 0, 32),
			BackgroundColor3 = Theme.TabInactive,
			BorderSizePixel = 0,
			Text = Name,
			TextColor3 = Theme.SubText,
			Font = Enum.Font.GothamSemibold,
			TextSize = 12,
			TextXAlignment = Enum.TextXAlignment.Left,
			AutoButtonColor = false,
			Parent = TabList,
		})
		Create("UICorner", { CornerRadius = UDim.new(0, 5), Parent = TabBtn })
		Create("UIPadding", { PaddingLeft = UDim.new(0, 12), Parent = TabBtn })

		local AccentBar = Create("Frame", {
			Name = "AccentBar",
			Size = UDim2.new(0, 0, 0, 0),
			BackgroundTransparency = 1,
			Visible = false,
			Parent = TabBtn,
		})

		TabBtn.MouseEnter:Connect(function()
			if ActiveTab ~= Name then Tween(TabBtn, { BackgroundColor3 = Theme.TabActive }, 0.1) end
		end)
		TabBtn.MouseLeave:Connect(function()
			if ActiveTab ~= Name then Tween(TabBtn, { BackgroundColor3 = Theme.TabInactive }, 0.1) end
		end)

		local Page = Create("ScrollingFrame", {
			Name = Name .. "_Page",
			Size = UDim2.new(1, 0, 1, 0),
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			ScrollBarThickness = 2,
			ScrollBarImageColor3 = Theme.Border,
			CanvasSize = UDim2.new(0, 0, 0, 0),
			AutomaticCanvasSize = Enum.AutomaticSize.Y,
			Visible = false,
			Parent = ContentArea,
		})
		Create("UIListLayout", { SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 5), Parent = Page })
		Create("UIPadding", { PaddingTop = UDim.new(0, 12), PaddingLeft = UDim.new(0, 12), PaddingRight = UDim.new(0, 12), PaddingBottom = UDim.new(0, 12), Parent = Page })

		Tabs[Name] = { Button = TabBtn, Page = Page }
		TabBtn.MouseButton1Click:Connect(function() Window:SetActiveTab(Name) end)
		if not ActiveTab then Window:SetActiveTab(Name) end

		local Tab = {}
		Tab.Page = Page

		function Tab:AddSection(title)
			local wrap = Create("Frame", {
				Size = UDim2.new(1, 0, 0, 24),
				BackgroundTransparency = 1,
				Parent = Page,
			})
			Create("TextLabel", {
				Size = UDim2.new(0, 0, 1, 0),
				AutomaticSize = Enum.AutomaticSize.X,
				BackgroundTransparency = 1,
				Text = string.upper(title),
				TextColor3 = Theme.SectionText,
				Font = Enum.Font.GothamBold,
				TextSize = 9,
				TextXAlignment = Enum.TextXAlignment.Left,
				Parent = wrap,
			})
			Create("Frame", {
				Size = UDim2.new(1, 0, 0, 1),
				Position = UDim2.new(0, 0, 1, -1),
				BackgroundColor3 = Theme.Border,
				BorderSizePixel = 0,
				Parent = wrap,
			})
		end

		function Tab:AddToggle(config)
			config = config or {}
			local Label = config.Label or "Toggle"
			local Default = config.Default or false
			local Callback = config.Callback or function() end
			local state = Default

			local Row = Create("Frame", {
				Size = UDim2.new(1, 0, 0, 36),
				BackgroundColor3 = Theme.RowBg,
				BorderSizePixel = 0,
				Parent = Page,
			})
			Create("UICorner", { CornerRadius = UDim.new(0, 5), Parent = Row })
			Create("UIStroke", { Color = Theme.Border, Thickness = 1, Parent = Row })

			Create("TextLabel", {
				Size = UDim2.new(1, -58, 1, 0),
				Position = UDim2.new(0, 12, 0, 0),
				BackgroundTransparency = 1,
				Text = Label,
				TextColor3 = Theme.Text,
				Font = Enum.Font.Gotham,
				TextSize = 12,
				TextXAlignment = Enum.TextXAlignment.Left,
				Parent = Row,
			})

			local Track = Create("Frame", {
				Size = UDim2.new(0, 34, 0, 18),
				Position = UDim2.new(1, -46, 0.5, -9),
				BackgroundColor3 = state and Theme.ToggleEnabled or Theme.Toggle,
				BorderSizePixel = 0,
				Parent = Row,
			})
			Create("UICorner", { CornerRadius = UDim.new(1, 0), Parent = Track })

			local Knob = Create("Frame", {
				Size = UDim2.new(0, 12, 0, 12),
				Position = state and UDim2.new(1, -15, 0.5, -6) or UDim2.new(0, 3, 0.5, -6),
				BackgroundColor3 = state and Color3.fromRGB(12,12,12) or Color3.fromRGB(160,160,160),
				BorderSizePixel = 0,
				Parent = Track,
			})
			Create("UICorner", { CornerRadius = UDim.new(1, 0), Parent = Knob })

			local Zone = Create("TextButton", {
				Size = UDim2.new(1, 0, 1, 0),
				BackgroundTransparency = 1,
				Text = "",
				Parent = Row,
			})
			Zone.MouseEnter:Connect(function() Tween(Row, { BackgroundColor3 = Theme.RowHover }, 0.1) end)
			Zone.MouseLeave:Connect(function() Tween(Row, { BackgroundColor3 = Theme.RowBg }, 0.1) end)
			Zone.MouseButton1Click:Connect(function()
				state = not state
				Tween(Track, { BackgroundColor3 = state and Theme.ToggleEnabled or Theme.Toggle }, 0.12)
				Tween(Knob, {
					Position = state and UDim2.new(1, -15, 0.5, -6) or UDim2.new(0, 3, 0.5, -6),
					BackgroundColor3 = state and Color3.fromRGB(12,12,12) or Color3.fromRGB(160,160,160)
				}, 0.12)
				Callback(state)
			end)

			return {
				SetState = function(_, s)
					state = s
					Tween(Track, { BackgroundColor3 = state and Theme.ToggleEnabled or Theme.Toggle }, 0.12)
					Tween(Knob, {
						Position = state and UDim2.new(1, -15, 0.5, -6) or UDim2.new(0, 3, 0.5, -6),
						BackgroundColor3 = state and Color3.fromRGB(12,12,12) or Color3.fromRGB(160,160,160)
					}, 0.12)
				end,
				GetState = function() return state end,
			}
		end

		function Tab:AddButton(config)
			config = config or {}
			local Label = config.Label or "Button"
			local Callback = config.Callback or function() end

			local Btn = Create("TextButton", {
				Size = UDim2.new(1, 0, 0, 34),
				BackgroundColor3 = Theme.RowBg,
				BorderSizePixel = 0,
				Text = Label,
				TextColor3 = Theme.Text,
				Font = Enum.Font.GothamSemibold,
				TextSize = 12,
				AutoButtonColor = false,
				Parent = Page,
			})
			Create("UICorner", { CornerRadius = UDim.new(0, 5), Parent = Btn })
			Create("UIStroke", { Color = Theme.Border, Thickness = 1, Parent = Btn })

			Btn.MouseEnter:Connect(function() Tween(Btn, { BackgroundColor3 = Theme.RowHover }, 0.1) end)
			Btn.MouseLeave:Connect(function() Tween(Btn, { BackgroundColor3 = Theme.RowBg }, 0.1) end)
			Btn.MouseButton1Click:Connect(function() Callback() end)

			return Btn
		end

		function Tab:AddDropdown(config)
			config = config or {}
			local Label = config.Label or "Select..."
			local Options = config.Options or {}
			local Callback = config.Callback or function() end

			local ddOpen = false
			local currentLabel = Label

			local ddRow = Create("Frame", {
				Size = UDim2.new(1, 0, 0, 34),
				BackgroundColor3 = Theme.RowBg,
				BorderSizePixel = 0,
				ZIndex = 5,
				Parent = Page,
			})
			Create("UICorner", { CornerRadius = UDim.new(0, 5), Parent = ddRow })
			Create("UIStroke", { Color = Theme.Border, Thickness = 1, Parent = ddRow })

			local ddBtn = Create("TextButton", {
				Size = UDim2.new(1, -30, 1, 0),
				Position = UDim2.new(0, 12, 0, 0),
				BackgroundTransparency = 1,
				Text = currentLabel,
				TextColor3 = Theme.SubText,
				Font = Enum.Font.Gotham,
				TextSize = 12,
				AutoButtonColor = false,
				TextXAlignment = Enum.TextXAlignment.Left,
				ZIndex = 6,
				Parent = ddRow,
			})

			local ddArrow = Create("TextLabel", {
				Size = UDim2.new(0, 24, 1, 0),
				Position = UDim2.new(1, -28, 0, 0),
				BackgroundTransparency = 1,
				Text = "v",
				TextColor3 = Theme.SubText,
				Font = Enum.Font.GothamBold,
				TextSize = 9,
				ZIndex = 6,
				Parent = ddRow,
			})

			local itemH = 30
			local totalH = itemH * #Options

			local ddList = Create("Frame", {
				Size = UDim2.new(0, 0, 0, 0),
				BackgroundColor3 = Color3.fromRGB(18, 18, 18),
				BorderSizePixel = 0,
				ClipsDescendants = true,
				ZIndex = 50,
				Visible = false,
				Parent = ScreenGui,
			})
			Create("UICorner", { CornerRadius = UDim.new(0, 5), Parent = ddList })
			Create("UIStroke", { Color = Color3.fromRGB(40,40,40), Thickness = 1, Parent = ddList })
			Create("UIListLayout", { SortOrder = Enum.SortOrder.LayoutOrder, Parent = ddList })

			for _, opt in ipairs(Options) do
				local item = Create("TextButton", {
					Size = UDim2.new(1, 0, 0, itemH),
					BackgroundColor3 = Color3.fromRGB(18,18,18),
					BorderSizePixel = 0,
					Text = opt.name or opt,
					TextColor3 = Theme.SubText,
					Font = Enum.Font.Gotham,
					TextSize = 11,
					TextXAlignment = Enum.TextXAlignment.Left,
					AutoButtonColor = false,
					ZIndex = 51,
					Parent = ddList,
				})
				Create("UIPadding", { PaddingLeft = UDim.new(0, 12), Parent = item })
				item.MouseEnter:Connect(function()
					item.BackgroundColor3 = Color3.fromRGB(28,28,28)
					item.TextColor3 = Theme.Text
				end)
				item.MouseLeave:Connect(function()
					item.BackgroundColor3 = Color3.fromRGB(18,18,18)
					item.TextColor3 = Theme.SubText
				end)
				local o = opt
				item.MouseButton1Click:Connect(function()
					ddOpen = false
					ddList.Visible = false
					ddArrow.Text = "v"
					currentLabel = o.name or o
					ddBtn.Text = currentLabel
					ddBtn.TextColor3 = Theme.Text
					Callback(o)
				end)
			end

			local function PositionList()
				local abs = ddRow.AbsolutePosition
				local sz  = ddRow.AbsoluteSize
				ddList.Position = UDim2.new(0, abs.X, 0, abs.Y + sz.Y + 2)
				ddList.Size = UDim2.new(0, sz.X, 0, totalH)
			end

			game:GetService("RunService").RenderStepped:Connect(function()
				if ddOpen then PositionList() end
			end)

			ddBtn.MouseButton1Click:Connect(function()
				ddOpen = not ddOpen
				if ddOpen then
					PositionList()
					ddList.Visible = true
				else
					ddList.Visible = false
				end
				ddArrow.Text = ddOpen and "^" or "v"
			end)

			-- return a control object so callers can reset the label
			return {
				SetLabel = function(_, lbl)
					currentLabel = lbl
					ddBtn.Text = lbl
					ddBtn.TextColor3 = lbl == Label and Theme.SubText or Theme.Text
				end,
				ResetLabel = function(_)
					currentLabel = Label
					ddBtn.Text = Label
					ddBtn.TextColor3 = Theme.SubText
				end,
			}
		end

		function Tab:AddSlider(config)
			config = config or {}
			local Label = config.Label or "Slider"
			local Min = config.Min or 0
			local Max = config.Max or 100
			local Default = config.Default or 50
			local Callback = config.Callback or function() end
			local value = Default

			local Row = Create("Frame", {
				Size = UDim2.new(1, 0, 0, 56),
				BackgroundColor3 = Theme.RowBg,
				BorderSizePixel = 0,
				Parent = Page,
			})
			Create("UICorner", { CornerRadius = UDim.new(0, 5), Parent = Row })
			Create("UIStroke", { Color = Theme.Border, Thickness = 1, Parent = Row })
			Create("UIPadding", { PaddingLeft = UDim.new(0, 12), PaddingRight = UDim.new(0, 12), PaddingTop = UDim.new(0, 8), PaddingBottom = UDim.new(0, 8), Parent = Row })

			local LabelRow = Create("Frame", { Size = UDim2.new(1, 0, 0, 18), BackgroundTransparency = 1, Parent = Row })
			Create("TextLabel", {
				Size = UDim2.new(0.6, 0, 1, 0),
				BackgroundTransparency = 1,
				Text = Label,
				TextColor3 = Theme.Text,
				Font = Enum.Font.Gotham,
				TextSize = 12,
				TextXAlignment = Enum.TextXAlignment.Left,
				Parent = LabelRow,
			})

			local ValBox = Create("TextBox", {
				Size = UDim2.new(0.36, 0, 1, 0),
				Position = UDim2.new(0.64, 0, 0, 0),
				BackgroundColor3 = Color3.fromRGB(28,28,28),
				BorderSizePixel = 0,
				Text = tostring(value),
				TextColor3 = Theme.SubText,
				Font = Enum.Font.GothamBold,
				TextSize = 11,
				TextXAlignment = Enum.TextXAlignment.Center,
				ClearTextOnFocus = false,
				Parent = LabelRow,
			})
			Create("UICorner", { CornerRadius = UDim.new(0, 4), Parent = ValBox })

			local Track = Create("Frame", {
				Size = UDim2.new(1, 0, 0, 4),
				Position = UDim2.new(0, 0, 1, -6),
				BackgroundColor3 = Theme.Toggle,
				BorderSizePixel = 0,
				Parent = Row,
			})
			Create("UICorner", { CornerRadius = UDim.new(1, 0), Parent = Track })

			local pct = (value - Min) / (Max - Min)
			local Fill = Create("Frame", {
				Size = UDim2.new(pct, 0, 1, 0),
				BackgroundColor3 = Theme.AccentLine,
				BorderSizePixel = 0,
				Parent = Track,
			})
			Create("UICorner", { CornerRadius = UDim.new(1, 0), Parent = Fill })

			local Knob = Create("Frame", {
				Size = UDim2.new(0, 10, 0, 10),
				Position = UDim2.new(pct, -5, 0.5, -5),
				BackgroundColor3 = Theme.AccentLine,
				BorderSizePixel = 0,
				Parent = Track,
			})
			Create("UICorner", { CornerRadius = UDim.new(1, 0), Parent = Knob })

			local function SetValue(v)
				v = math.clamp(math.floor(v), Min, Max)
				value = v
				ValBox.Text = tostring(v)
				local r = (v - Min) / (Max - Min)
				Fill.Size = UDim2.new(r, 0, 1, 0)
				Knob.Position = UDim2.new(r, -5, 0.5, -5)
				Callback(v)
			end

			local function CalcFromMouse(mouseX)
				local trackX = Track.AbsolutePosition.X
				local trackW = Track.AbsoluteSize.X
				if trackW <= 0 then return end
				local rel = math.clamp((mouseX - trackX) / trackW, 0, 1)
				SetValue(Min + (Max - Min) * rel)
			end

			local DragZone = Create("TextButton", {
				Size = UDim2.new(1, 0, 0, 26),
				Position = UDim2.new(0, 0, 1, -28),
				BackgroundTransparency = 1,
				Text = "",
				ZIndex = 3,
				Parent = Row,
			})

			local dragging = false
			DragZone.InputBegan:Connect(function(i)
				if i.UserInputType == Enum.UserInputType.MouseButton1 then
					dragging = true
					CalcFromMouse(i.Position.X)
				end
			end)
			UserInputService.InputEnded:Connect(function(i)
				if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
			end)
			UserInputService.InputChanged:Connect(function(i)
				if dragging and i.UserInputType == Enum.UserInputType.MouseMovement then
					CalcFromMouse(i.Position.X)
				end
			end)

			ValBox.FocusLost:Connect(function()
				local n = tonumber(ValBox.Text)
				if n then SetValue(n) else ValBox.Text = tostring(value) end
			end)

			return {
				Set = function(_, v) SetValue(v) end,
				Get = function() return value end,
			}
		end

		function Tab:AddLabel(text)
			Create("TextLabel", {
				Size = UDim2.new(1, 0, 0, 16),
				BackgroundTransparency = 1,
				Text = text,
				TextColor3 = Theme.SubText,
				Font = Enum.Font.Gotham,
				TextSize = 11,
				TextXAlignment = Enum.TextXAlignment.Left,
				TextWrapped = true,
				Parent = Page,
			})
		end

		return Tab
	end

	return Window
end

-- sounds/dialog helpers - defined before anything uses them
local soundEvent = ReplicatedStorage:FindFirstChild("playSound")
local Sounds = ReplicatedStorage:FindFirstChild("Sounds")

local notifsEnabled = true
local soundsEnabled = true

local function PlaySound(name)
	if not soundsEnabled then return end
	if soundEvent and Sounds then
		local s = Sounds:FindFirstChild(name)
		if s then firesignal(soundEvent.OnClientEvent, s) end
	end
end

local function FireDialog(lines)
	if not notifsEnabled then return end
	local e = ReplicatedStorage:FindFirstChild("receiveDialog")
	if e then firesignal(e.OnClientEvent, lines) end
end

-- custom toast notification (always shows regardless of game, used for freecam etc.)
local _toastGui = nil
local function ShowToast(message, duration)
	duration = duration or 3.5
	-- destroy any existing toast
	if _toastGui and _toastGui.Parent then _toastGui:Destroy() end

	local toastSG = Create("ScreenGui", {
		Name = "BlaizeToast",
		ResetOnSpawn = false,
		ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
		Parent = CoreGui,
	})
	_toastGui = toastSG

	local pad = 16
	local toastW = 280
	local toast = Create("Frame", {
		Size = UDim2.new(0, toastW, 0, 36),
		Position = UDim2.new(0.5, -toastW/2, 1, 10),  -- starts below screen
		BackgroundColor3 = Color3.fromRGB(14, 14, 14),
		BorderSizePixel = 0,
		Parent = toastSG,
	})
	Create("UICorner", { CornerRadius = UDim.new(0, 6), Parent = toast })
	Create("UIStroke", { Color = Color3.fromRGB(38, 38, 38), Thickness = 1, Parent = toast })
	Create("UIPadding", { PaddingLeft = UDim.new(0, pad), PaddingRight = UDim.new(0, pad), Parent = toast })

	-- accent bar on left edge
	Create("Frame", {
		Size = UDim2.new(0, 2, 1, -10),
		Position = UDim2.new(0, 0, 0, 5),
		BackgroundColor3 = Color3.fromRGB(200, 200, 200),
		BorderSizePixel = 0,
		Parent = toast,
	})

	Create("TextLabel", {
		Size = UDim2.new(1, -8, 1, 0),
		Position = UDim2.new(0, 8, 0, 0),
		BackgroundTransparency = 1,
		Text = message,
		TextColor3 = Color3.fromRGB(210, 210, 210),
		Font = Enum.Font.Gotham,
		TextSize = 11,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextWrapped = true,
		Parent = toast,
	})

	-- slide in from bottom
	local slideIn = TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
	TweenService:Create(toast, slideIn, { Position = UDim2.new(0.5, -toastW/2, 1, -52) }):Play()

	task.delay(duration, function()
		if not toastSG or not toastSG.Parent then return end
		local slideOut = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
		local tw = TweenService:Create(toast, slideOut, { Position = UDim2.new(0.5, -toastW/2, 1, 10) })
		tw:Play()
		tw.Completed:Connect(function() pcall(function() toastSG:Destroy() end) end)
	end)
end

local Islands = {
	{ name = "Industrial Island", x = -265,  z = -950  },
	{ name = "Sunny Isle",        x = -2200, z = -2500 },
	{ name = "Pirates' Shore",    x = 1550,  z = -900  },
	{ name = "Firelight Bay",     x = -2447, z = 2232  },
}

local function GetFloorY(x, z, refY)
	local origin = Vector3.new(x, (refY or 500) + 100, z)
	local params = RaycastParams.new()
	params.FilterType = Enum.RaycastFilterType.Exclude
	params.FilterDescendantsInstances = { LocalPlayer.Character }
	local result = Workspace:Raycast(origin, Vector3.new(0, -1200, 0), params)
	if result then return result.Position.Y + 3 end
	return 10
end

local function GetHRP()
	local char = LocalPlayer.Character
	if not char then return nil end
	return char:FindFirstChild("HumanoidRootPart")
end

-- acBypass / acStrict declared here so SafeTP can use them, and so helpers below can call SafeTP
local noclipConn = nil
local flyConn = nil
local freecamConn = nil
local freecamInputConn = nil
local freecamActive = false

local acBypass = false
local acStrict = false

local function SafeTP(targetCFrame)
	local hrp = GetHRP()
	if not hrp then return end
	if not acBypass then
		hrp.CFrame = targetCFrame
		return
	end

	local char    = LocalPlayer.Character
	local hum     = char and char:FindFirstChildOfClass("Humanoid")
	local current = hrp.Position
	local goal    = targetCFrame.Position
	local dist    = (goal - current).Magnitude

	local steps = math.clamp(math.ceil(dist / 30), 5, 60)
	local rot   = targetCFrame - targetCFrame.Position

	local prevSpeed = nil
	local noclipConn2 = nil
	if acStrict then
		if hum then
			prevSpeed = hum.WalkSpeed
			hum.WalkSpeed = 16
		end
		noclipConn2 = game:GetService("RunService").Heartbeat:Connect(function()
			local c = LocalPlayer.Character
			if not c then return end
			for _, p in ipairs(c:GetDescendants()) do
				if p:IsA("BasePart") then p.CanCollide = false end
			end
		end)
	end

	for i = 1, steps do
		local hrp2 = GetHRP()
		if not hrp2 then break end
		hrp2.CFrame = CFrame.new(current:Lerp(goal, i / steps)) * rot
		task.wait(0.05)
	end

	local hrpFinal = GetHRP()
	if hrpFinal then hrpFinal.CFrame = targetCFrame end

	if acStrict then
		if noclipConn2 then noclipConn2:Disconnect() end
		local humFinal = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
		if humFinal and prevSpeed then humFinal.WalkSpeed = prevSpeed end
		local cFinal = LocalPlayer.Character
		if cFinal then
			for _, p in ipairs(cFinal:GetDescendants()) do
				if p:IsA("BasePart") then p.CanCollide = true end
			end
		end
	end
end

local function TeleportTo(x, y, z)
	SafeTP(CFrame.new(x, y, z))
end

local function NudgeForward(studs)
	local hrp = GetHRP()
	if hrp then hrp.CFrame = hrp.CFrame + hrp.CFrame.LookVector * (studs or 1) end
end

local Wrecks = {
	{ name = "SS Nomadia",     x = 2550,  z = 3350,  y = -40, dwell = 3 },
	{ name = "SS Fitzwilliam", x = 5600,  z = -2550, y = -40, dwell = 3 },
	{ name = "Crane Ship",     x = -500,  z = -3300, y = -40, dwell = 3 },
	{ name = "Crane Piece",    x = -500,  z = -3000, y = -40, dwell = 3 },
	{ name = "RMS Carvania",   x = -1800, z = 4200,  y = -40, dwell = 3 },
	{ name = "Deep Tugboat",   x = 777,   z = -1777, y = -80, dwell = 4 },
	{ name = "Wooden Ship",    x = 2300,  z = 750,   y = -30, dwell = 3 },
}

local isBusy = false

local function RunSequence(locations, btn, doneText, dialogText)
	if isBusy then return end
	isBusy = true

	local hrp = GetHRP()
	if not hrp then isBusy = false return end

	local startCFrame = hrp.CFrame
	local originalText = btn and btn.Text or doneText
	if btn then btn.Text = "working..." end

	for _, loc in ipairs(locations) do
		if btn then btn.Text = loc.name end
		local targetY = loc.y or GetFloorY(loc.x, loc.z, startCFrame.Position.Y)
		TeleportTo(loc.x, targetY, loc.z)
		task.wait(0.3)
		NudgeForward(3)
		task.wait(loc.dwell or 0.8)
	end

	if btn then btn.Text = "returning..." end
	local returnHRP = GetHRP()
	if returnHRP then returnHRP.CFrame = startCFrame end
	task.wait(0.2)

	PlaySound("gifted")
	FireDialog({ dialogText })

	if btn then btn.Text = "done!" end
	task.wait(1.2)
	if btn then btn.Text = originalText end
	isBusy = false
end

local function TeleportToIsland(island)
	local hrp = GetHRP()
	if not hrp then return end
	local floorY = GetFloorY(island.x, island.z, hrp.Position.Y)
	SafeTP(CFrame.new(island.x, floorY, island.z))
	task.wait(0.3)
	NudgeForward(3)
end

local function TeleportToWreck(wreck)
	local hrp = GetHRP()
	if not hrp then return end
	SafeTP(CFrame.new(wreck.x, wreck.y or -40, wreck.z))
	task.wait(0.3)
	NudgeForward(3)
end
local flyBV, flyBG = nil, nil

-- list of supported games shown on the game menu
local Games = {
	{ id = "sns",  name = "Sail and Sink Simulator",         sub = "sail & sink"        },
	{ id = "sve",  name = "Speed Verity Escape",              sub = "stage teleporter"   },
	{ id = "fpc",  name = "+1 Followers Per Click",           sub = "click farming"      },
	{ id = "ctc",  name = "Clean the Cinema!",                sub = "auto clean lobby"   },
	{ id = "ccs",  name = "Concrete Cleaning Simulator",      sub = "voxel autoclean"    },
	{ id = "bga",  name = "Build a Gun Army",                 sub = "auto kill"          },
	{ id = "apc",  name = "+1 Ammo Per Click",                sub = "ammo farm"          },
	{ id = "ftn",  name = "Find the Needohs!",               sub = "needoh finder"      },
}

local KEY = "e"

-- shared ScreenGui for all pre-hub screens
local gateGui = Create("ScreenGui", {
	Name = "BlaizeGate",
	ResetOnSpawn = false,
	ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
	Parent = CoreGui,
})

-- helper: dark card frame centred on screen
local function MakeCard(w, h)
	local bg = Create("Frame", {
		Size = UDim2.new(0, w, 0, h),
		Position = UDim2.new(0.5, -w/2, 0.5, -h/2),
		BackgroundColor3 = Color3.fromRGB(8, 8, 8),
		BorderSizePixel = 0,
		Parent = gateGui,
	})
	Create("UICorner", { CornerRadius = UDim.new(0, 6), Parent = bg })
	Create("UIStroke", { Color = Color3.fromRGB(35,35,35), Thickness = 1, Parent = bg })
	return bg
end

local function LaunchHub(selectedGame)
	-- clear game menu, show loading screen
	for _, ch in ipairs(gateGui:GetChildren()) do ch:Destroy() end
	local loadBg = MakeCard(220, 90)
	Create("ImageLabel", {
		Size = UDim2.new(0, 36, 0, 36),
		Position = UDim2.new(0.5, -18, 0, 10),
		BackgroundTransparency = 1,
		Image = "rbxassetid://132094132649977",
		Parent = loadBg,
	})
	local loadSub = Create("TextLabel", {
		Size = UDim2.new(1, 0, 0, 18),
		Position = UDim2.new(0, 0, 0, 62),
		BackgroundTransparency = 1,
		Text = "loading...",
		TextColor3 = Color3.fromRGB(90,90,90),
		Font = Enum.Font.Gotham,
		TextSize = 11,
		Parent = loadBg,
	})

	local dots = 0
	local dotConn
	dotConn = game:GetService("RunService").Heartbeat:Connect(function()
		dots = (dots + 1) % 4
		loadSub.Text = "loading" .. string.rep(".", dots)
	end)

	task.wait(2)
	dotConn:Disconnect()
	gateGui:Destroy()

	local Window = BlaizeHub:CreateWindow({
		Title = "Blaize Hub",
		Width = 580,
		Height = 420,
	})

	if selectedGame and selectedGame.id == "fpc" then
		-- +1 Followers Per Click tabs
		local clickRemote   = ReplicatedStorage:FindFirstChild("Remotes") and ReplicatedStorage.Remotes:FindFirstChild("Events") and ReplicatedStorage.Remotes.Events:FindFirstChild("ClickRemote")
		local battleRemote  = ReplicatedStorage:FindFirstChild("Remotes") and ReplicatedStorage.Remotes:FindFirstChild("Events") and ReplicatedStorage.Remotes.Events:FindFirstChild("BattleSync")

		-- CLICK tab
		local ClickTab = Window:AddTab({ Name = "Click" })
		ClickTab:AddSection("Followers")

		ClickTab:AddButton({
			Label = "+ Get Follower",
			Callback = function()
				if clickRemote then clickRemote:FireServer() end
			end,
		})

		ClickTab:AddSection("Auto Click")

		-- interval input row
		local clickIntervalMs = 100
		local clickRunning = false

		local intervalRow = Create("Frame", {
			Size = UDim2.new(1, 0, 0, 34),
			BackgroundColor3 = Theme.RowBg,
			BorderSizePixel = 0,
			Parent = ClickTab.Page,
		})
		Create("UICorner", { CornerRadius = UDim.new(0, 4), Parent = intervalRow })
		Create("TextLabel", {
			Size = UDim2.new(0.55, 0, 1, 0),
			Position = UDim2.new(0, 10, 0, 0),
			BackgroundTransparency = 1,
			Text = "Interval (ms)",
			TextColor3 = Theme.Text,
			Font = Enum.Font.Gotham,
			TextSize = 12,
			TextXAlignment = Enum.TextXAlignment.Left,
			Parent = intervalRow,
		})
		local intervalInput = Create("TextBox", {
			Size = UDim2.new(0.32, 0, 0, 24),
			Position = UDim2.new(0.62, 0, 0.5, -12),
			BackgroundColor3 = Color3.fromRGB(25,25,25),
			BorderSizePixel = 0,
			Text = "100",
			TextColor3 = Theme.Text,
			Font = Enum.Font.GothamBold,
			TextSize = 12,
			TextXAlignment = Enum.TextXAlignment.Center,
			ClearTextOnFocus = false,
			Parent = intervalRow,
		})
		Create("UICorner", { CornerRadius = UDim.new(0, 3), Parent = intervalInput })
		intervalInput.FocusLost:Connect(function()
			local n = tonumber(intervalInput.Text)
			if n and n >= 10 and n <= 1000 then
				clickIntervalMs = math.floor(n)
				intervalInput.Text = tostring(clickIntervalMs)
			else
				intervalInput.Text = tostring(clickIntervalMs)
			end
		end)

		ClickTab:AddToggle({
			Label = "Auto Click",
			Default = false,
			Callback = function(state)
				if state then
					if clickIntervalMs < 50 then
						FireDialog({ "[BLAIZE]Warning: below 50ms may cause lag or detection." })
					end
					clickRunning = true
					task.spawn(function()
						while clickRunning do
							if clickRemote then clickRemote:FireServer() end
							task.wait(clickIntervalMs / 1000)
						end
					end)
				else
					clickRunning = false
				end
			end,
		})

		-- LANES tab (World 1, Lane 1-21)
		local LanesTab = Window:AddTab({ Name = "Lanes" })
		LanesTab:AddSection("World 1 Lanes")

		local laneOptions = {}
		for i = 1, 21 do
			table.insert(laneOptions, { name = "Lane " .. i, num = i })
		end

		LanesTab:AddDropdown({
			Label = "Teleport to Lane...",
			Options = laneOptions,
			Callback = function(opt)
				local hrp = GetHRP()
				if not hrp then return end
				local ok, part = pcall(function()
					return Workspace.Worlds.World1.Map.Win["Lane" .. opt.num].WinPart
				end)
				if ok and part then
					hrp.CFrame = CFrame.new(part.Position + Vector3.new(0, 3, 0))
				else
					FireDialog({ "[BLAIZE]Lane " .. opt.num .. " not found." })
				end
			end,
		})

		-- BATTLE tab
		local BattleTab = Window:AddTab({ Name = "Battle" })
		BattleTab:AddSection("Auto Battle")

		-- broken warning
		local brokenRow = Create("Frame", {
			Size = UDim2.new(1, 0, 0, 34),
			BackgroundColor3 = Color3.fromRGB(40, 12, 12),
			BorderSizePixel = 0,
			Parent = BattleTab.Page,
		})
		Create("UICorner", { CornerRadius = UDim.new(0, 4), Parent = brokenRow })
		Create("UIStroke", { Color = Color3.fromRGB(100, 30, 30), Thickness = 1, Parent = brokenRow })
		Create("TextLabel", {
			Size = UDim2.new(1, -16, 1, 0),
			Position = UDim2.new(0, 8, 0, 0),
			BackgroundTransparency = 1,
			Text = "⚠ Auto Battle is currently broken.",
			TextColor3 = Color3.fromRGB(220, 80, 80),
			Font = Enum.Font.GothamBold,
			TextSize = 11,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextWrapped = true,
			Parent = brokenRow,
		})

		local battleRunning = false
		local battleHP = 100000000

		local hpRow = Create("Frame", {
			Size = UDim2.new(1, 0, 0, 34),
			BackgroundColor3 = Theme.RowBg,
			BorderSizePixel = 0,
			Parent = BattleTab.Page,
		})
		Create("UICorner", { CornerRadius = UDim.new(0, 4), Parent = hpRow })
		Create("TextLabel", {
			Size = UDim2.new(0.5, 0, 1, 0),
			Position = UDim2.new(0, 10, 0, 0),
			BackgroundTransparency = 1,
			Text = "Set HP",
			TextColor3 = Theme.Text,
			Font = Enum.Font.Gotham,
			TextSize = 12,
			TextXAlignment = Enum.TextXAlignment.Left,
			Parent = hpRow,
		})
		local hpInput = Create("TextBox", {
			Size = UDim2.new(0.45, 0, 0, 24),
			Position = UDim2.new(0.5, 0, 0.5, -12),
			BackgroundColor3 = Color3.fromRGB(25,25,25),
			BorderSizePixel = 0,
			Text = "100000000",
			TextColor3 = Theme.Text,
			Font = Enum.Font.GothamBold,
			TextSize = 11,
			TextXAlignment = Enum.TextXAlignment.Center,
			ClearTextOnFocus = false,
			Parent = hpRow,
		})
		Create("UICorner", { CornerRadius = UDim.new(0, 3), Parent = hpInput })
		hpInput.FocusLost:Connect(function()
			local n = tonumber(hpInput.Text)
			if n and n > 0 then
				battleHP = math.floor(n)
				hpInput.Text = tostring(battleHP)
			else
				hpInput.Text = tostring(battleHP)
			end
		end)

		BattleTab:AddToggle({
			Label = "Auto Battle",
			Default = false,
			Callback = function(state)
				if state then
					battleRunning = true
					FireDialog({ "[BLAIZE]Auto battle on. HP: " .. tostring(battleHP) })
					task.spawn(function()
						while battleRunning do
							if battleRemote then
								pcall(function()
									firesignal(battleRemote.OnClientEvent, battleHP, battleHP, battleHP)
								end)
							end
							task.wait(0.05)
						end
					end)
				else
					battleRunning = false
					FireDialog({ "[BLAIZE]Auto battle off." })
				end
			end,
		})

	elseif selectedGame and selectedGame.id == "ctc" then
		-- Clean the Cinema! tabs
		local Notify       = ReplicatedStorage:FindFirstChild("Remotes") and ReplicatedStorage.Remotes:FindFirstChild("Notify")
		local BagUpdate    = ReplicatedStorage:FindFirstChild("Remotes") and ReplicatedStorage.Remotes:FindFirstChild("BagUpdate")
		local PickupResult = ReplicatedStorage:FindFirstChild("Remotes") and ReplicatedStorage.Remotes:FindFirstChild("PickupResult")
		local PickupDirt   = ReplicatedStorage:FindFirstChild("Remotes") and ReplicatedStorage.Remotes:FindFirstChild("PickupDirt")
		local StainCleaned = ReplicatedStorage:FindFirstChild("Remotes") and ReplicatedStorage.Remotes:FindFirstChild("StainCleaned")
		local ScrubStain   = ReplicatedStorage:FindFirstChild("Remotes") and ReplicatedStorage.Remotes:FindFirstChild("ScrubStain")

		-- maps Bin attribute value to the folder name under Workspace.Theatre.Trash
		local BinFolderName = {
			Plastic    = "Plastic",
			Recyclable = "Recycable",  -- folder spelt with one 'c'
			FoodWaste  = "Food_Waste",
		}

		local function SendNotify(kind, msg)
			if Notify then pcall(function() firesignal(Notify.OnClientEvent, kind, msg) end) end
		end

		-- find TouchPart1 inside the correct bin model
		local function GetBinTouchPart(binCategory)
			local folderName = BinFolderName[binCategory]
			if not folderName then return nil end
			local ok, folder = pcall(function() return Workspace.Theatre.Trash[folderName] end)
			if not ok or not folder then return nil end
			-- find any Model in the folder that contains a TouchPart1
			for _, child in ipairs(folder:GetChildren()) do
				if child:IsA("Model") then
					local tp = child:FindFirstChild("TouchPart1")
					if tp then return tp end
				end
			end
			return nil
		end

		-- simulate picking up one trash item (client + server)
		local function SimulatePickup(item, uid, binCategory)
			if BagUpdate then
				pcall(function()
					firesignal(BagUpdate.OnClientEvent, {
						{ uid = uid, name = item.Name, bin = binCategory }
					})
				end)
			end
			if PickupResult then
				pcall(function() firesignal(PickupResult.OnClientEvent, item, true, binCategory) end)
			end
			if PickupDirt then
				pcall(function() PickupDirt:FireServer(item) end)
			end
		end

		-- clean one stain: scrub server call at full amount, then fire client confirmation
		local function CleanStain(stain)
			if ScrubStain then
				pcall(function() ScrubStain:FireServer(stain, 1) end)
			end
			if StainCleaned then
				-- use whatever position/size/color the stain has, falling back to sensible defaults
				local pos   = pcall(function() return stain.Position end) and stain.Position or Vector3.new(0,0,0)
				local size  = 40
				local color = Color3.new(1,1,1)
				pcall(function() color = stain.Color end)
				pcall(function()
					firesignal(StainCleaned.OnClientEvent, stain, pos, size, color, LocalPlayer)
				end)
			end
		end

		-- collect all bins (Plastic/Recyclable/FoodWaste) from Workspace.Suciedad
		local ValidBins = { Plastic = true, Recyclable = true, FoodWaste = true }
		local function GetAllDirt()
			local items = {}
			local ok, suciedad = pcall(function() return Workspace.Suciedad end)
			if not ok or not suciedad then return items end
			for _, child in ipairs(suciedad:GetChildren()) do
				local dirtId = child:GetAttribute("DirtId")
				local bin    = child:GetAttribute("Bin")
				if dirtId and bin and ValidBins[bin] then
					table.insert(items, { instance = child, uid = dirtId, bin = bin, isStain = false })
				end
			end
			return items
		end

		-- collect all stains from Workspace.Suciedad (no Bin/DirtId, but have a Position)
		local function GetAllStains()
			local stains = {}
			local ok, suciedad = pcall(function() return Workspace.Suciedad end)
			if not ok or not suciedad then return stains end
			for _, child in ipairs(suciedad:GetChildren()) do
				local bin = child:GetAttribute("Bin")
				-- stains have no ValidBin attribute - they are parts/meshes without a Bin we recognise
				if not bin or not ValidBins[bin] then
					-- only include things that look like stains (have a Position)
					if child:IsA("BasePart") or child:IsA("MeshPart") or child:IsA("SpecialMesh") then
						table.insert(stains, child)
					elseif child:IsA("Model") then
						-- stain models: grab the first BasePart inside
						local part = child:FindFirstChildWhichIsA("BasePart")
						if part then table.insert(stains, part) end
					end
				end
			end
			return stains
		end

		-- walk the character to a bin's TouchPart1 using Humanoid:MoveTo
		-- this uses the real walking animation and actually triggers touch hitboxes
		local function GoToBin(binCategory)
			local tp = GetBinTouchPart(binCategory)
			if not tp then
				SendNotify("error", "Bin not found: " .. tostring(binCategory))
				return false
			end
			local char = LocalPlayer.Character
			if not char then return false end
			local hum = char:FindFirstChildOfClass("Humanoid")
			local hrp = char:FindFirstChild("HumanoidRootPart")
			if not hum or not hrp then return false end

			local goal = tp.Position

			-- teleport close to the bin first (within walking distance) so pathing is short
			local dir = (hrp.Position - goal)
			local dist = dir.Magnitude
			if dist > 60 then
				-- too far to walk naturally - teleport to just outside trigger range first
				local closePos = goal + dir.Unit * 12
				hrp.CFrame = CFrame.new(closePos.X, closePos.Y + 3, closePos.Z)
				task.wait(0.3)
			end

			-- now walk in using MoveTo so touch fires properly
			hum:MoveTo(goal)

			-- wait until we arrive, with a 6 second safety timeout
			local arrived = false
			local conn
			conn = hum.MoveToFinished:Connect(function(reached)
				arrived = true
				conn:Disconnect()
			end)
			local t = 0
			while not arrived and t < 6 do
				task.wait(0.1)
				t = t + 0.1
			end
			if conn then pcall(function() conn:Disconnect() end) end

			-- give the touch hitbox a moment to register
			task.wait(0.5)
			return true
		end

		-- CLEAN tab
		local CleanTab = Window:AddTab({ Name = "Clean" })
		CleanTab:AddSection("Bag Size")

		local bagLimit = 5

		-- bag size input row
		local bagRow = Create("Frame", {
			Size = UDim2.new(1, 0, 0, 34),
			BackgroundColor3 = Theme.RowBg,
			BorderSizePixel = 0,
			Parent = CleanTab.Page,
		})
		Create("UICorner", { CornerRadius = UDim.new(0, 4), Parent = bagRow })
		Create("TextLabel", {
			Size = UDim2.new(0.55, 0, 1, 0),
			Position = UDim2.new(0, 10, 0, 0),
			BackgroundTransparency = 1,
			Text = "Bag Size",
			TextColor3 = Theme.Text,
			Font = Enum.Font.Gotham,
			TextSize = 12,
			TextXAlignment = Enum.TextXAlignment.Left,
			Parent = bagRow,
		})
		local bagInput = Create("TextBox", {
			Size = UDim2.new(0.32, 0, 0, 24),
			Position = UDim2.new(0.62, 0, 0.5, -12),
			BackgroundColor3 = Color3.fromRGB(25,25,25),
			BorderSizePixel = 0,
			Text = "5",
			TextColor3 = Theme.Text,
			Font = Enum.Font.GothamBold,
			TextSize = 12,
			TextXAlignment = Enum.TextXAlignment.Center,
			ClearTextOnFocus = false,
			Parent = bagRow,
		})
		Create("UICorner", { CornerRadius = UDim.new(0, 3), Parent = bagInput })
		bagInput.FocusLost:Connect(function()
			local n = tonumber(bagInput.Text)
			if n and n >= 1 and n <= 99 then
				bagLimit = math.floor(n)
				bagInput.Text = tostring(bagLimit)
			else
				bagInput.Text = tostring(bagLimit)
			end
		end)

		CleanTab:AddSection("Auto Clean")

		-- autosort broken warning
		local ctcWarnRow = Create("Frame", {
			Size = UDim2.new(1, 0, 0, 34),
			BackgroundColor3 = Color3.fromRGB(40, 28, 8),
			BorderSizePixel = 0,
			Parent = CleanTab.Page,
		})
		Create("UICorner", { CornerRadius = UDim.new(0, 4), Parent = ctcWarnRow })
		Create("UIStroke", { Color = Color3.fromRGB(100, 70, 20), Thickness = 1, Parent = ctcWarnRow })
		Create("TextLabel", {
			Size = UDim2.new(1, -16, 1, 0),
			Position = UDim2.new(0, 8, 0, 0),
			BackgroundTransparency = 1,
			Text = "⚠ Auto Sort is currently buggy.",
			TextColor3 = Color3.fromRGB(220, 160, 60),
			Font = Enum.Font.GothamBold,
			TextSize = 11,
			TextXAlignment = Enum.TextXAlignment.Left,
			Parent = ctcWarnRow,
		})

		local cleanRunning = false

		CleanTab:AddToggle({
			Label = "Auto Clean",
			Default = false,
			Callback = function(state)
				if state then
					cleanRunning = true
					task.spawn(function()
						while cleanRunning do
							-- stains first - no bag needed, just fire and move on
							local stains = GetAllStains()
							local stainCount = 0
							for _, stain in ipairs(stains) do
								if not cleanRunning then break end
								CleanStain(stain)
								stainCount = stainCount + 1
								task.wait(0.2)
							end
							if stainCount > 0 then
								SendNotify("success", tostring(stainCount) .. " stains cleaned!")
							end

							-- get remaining trash items
							local dirt = GetAllDirt()
							if #dirt == 0 and stainCount == 0 then
								SendNotify("success", "Lobby is clean!")
								cleanRunning = false
								break
							end

							-- fill bag up to bagLimit, grouped by bin so we minimise bin trips
							-- strategy: pick items bin-by-bin up to the limit, then deposit each bin
							local remaining = dirt
							while #remaining > 0 and cleanRunning do
								-- build this bag's batch: take up to bagLimit items, grouped by bin
								local batch = {}        -- list of items to pick up this round
								local batchByBin = {}   -- bin -> list
								local batchOrder = {}   -- ordered bin names
								local taken = 0

								for _, item in ipairs(remaining) do
									if taken >= bagLimit then break end
									local b = item.bin
									if not batchByBin[b] then
										batchByBin[b] = {}
										table.insert(batchOrder, b)
									end
									table.insert(batchByBin[b], item)
									table.insert(batch, item)
									taken = taken + 1
								end

								-- pick them all up with a pause so the server registers each one
								for _, item in ipairs(batch) do
									if not cleanRunning then break end
									SimulatePickup(item.instance, item.uid, item.bin)
									task.wait(0.7)
								end

								-- walk to each bin in turn and deposit
								for _, binCategory in ipairs(batchOrder) do
									if not cleanRunning then break end
									local reached = GoToBin(binCategory)
									if reached then
										SendNotify("success", tostring(#batchByBin[binCategory]) .. " " .. binCategory .. " sorted!")
									end
									task.wait(0.5)
								end

								-- remove deposited items from remaining list
								local batchSet = {}
								for _, item in ipairs(batch) do batchSet[item.instance] = true end
								local newRemaining = {}
								for _, item in ipairs(remaining) do
									if not batchSet[item.instance] then
										table.insert(newRemaining, item)
									end
								end
								remaining = newRemaining

								task.wait(0.3)
							end

							task.wait(1)
						end
					end)
				else
					cleanRunning = false
					SendNotify("warn", "Auto clean stopped.")
				end
			end,
		})


	elseif selectedGame and selectedGame.id == "ccs" then
		-- Concrete Cleaning Simulator tabs
		local CleaningSync    = ReplicatedStorage:FindFirstChild("Assets") and ReplicatedStorage.Assets:FindFirstChild("Remotes") and ReplicatedStorage.Assets.Remotes:FindFirstChild("JobSystemRemotes") and ReplicatedStorage.Assets.Remotes.JobSystemRemotes:FindFirstChild("CleaningSync")
		local CleanVoxelReward = ReplicatedStorage:FindFirstChild("Assets") and ReplicatedStorage.Assets:FindFirstChild("Remotes") and ReplicatedStorage.Assets.Remotes:FindFirstChild("CleanVoxelReward")

		local CCSTab = Window:AddTab({ Name = "Clean" })
		CCSTab:AddSection("Auto Clean Floor")

		-- job id input
		local ccsJobId = 1
		local jobRow = Create("Frame", {
			Size = UDim2.new(1, 0, 0, 34),
			BackgroundColor3 = Theme.RowBg,
			BorderSizePixel = 0,
			Parent = CCSTab.Page,
		})
		Create("UICorner", { CornerRadius = UDim.new(0, 4), Parent = jobRow })
		Create("TextLabel", {
			Size = UDim2.new(0.55, 0, 1, 0),
			Position = UDim2.new(0, 10, 0, 0),
			BackgroundTransparency = 1,
			Text = "Job ID",
			TextColor3 = Theme.Text,
			Font = Enum.Font.Gotham,
			TextSize = 12,
			TextXAlignment = Enum.TextXAlignment.Left,
			Parent = jobRow,
		})
		local jobInput = Create("TextBox", {
			Size = UDim2.new(0.32, 0, 0, 24),
			Position = UDim2.new(0.62, 0, 0.5, -12),
			BackgroundColor3 = Color3.fromRGB(25,25,25),
			BorderSizePixel = 0,
			Text = "1",
			TextColor3 = Theme.Text,
			Font = Enum.Font.GothamBold,
			TextSize = 12,
			TextXAlignment = Enum.TextXAlignment.Center,
			ClearTextOnFocus = false,
			Parent = jobRow,
		})
		Create("UICorner", { CornerRadius = UDim.new(0, 3), Parent = jobInput })
		jobInput.FocusLost:Connect(function()
			local n = tonumber(jobInput.Text)
			if n and n >= 1 then
				ccsJobId = math.floor(n)
				jobInput.Text = tostring(ccsJobId)
			else
				jobInput.Text = tostring(ccsJobId)
			end
		end)

		-- floor id input
		local ccsFloorId = "Job1_Floor_1"
		local floorRow = Create("Frame", {
			Size = UDim2.new(1, 0, 0, 34),
			BackgroundColor3 = Theme.RowBg,
			BorderSizePixel = 0,
			Parent = CCSTab.Page,
		})
		Create("UICorner", { CornerRadius = UDim.new(0, 4), Parent = floorRow })
		Create("TextLabel", {
			Size = UDim2.new(0.45, 0, 1, 0),
			Position = UDim2.new(0, 10, 0, 0),
			BackgroundTransparency = 1,
			Text = "Floor ID",
			TextColor3 = Theme.Text,
			Font = Enum.Font.Gotham,
			TextSize = 12,
			TextXAlignment = Enum.TextXAlignment.Left,
			Parent = floorRow,
		})
		local floorInput = Create("TextBox", {
			Size = UDim2.new(0.52, 0, 0, 24),
			Position = UDim2.new(0.45, 0, 0.5, -12),
			BackgroundColor3 = Color3.fromRGB(25,25,25),
			BorderSizePixel = 0,
			Text = "Job1_Floor_1",
			TextColor3 = Theme.Text,
			Font = Enum.Font.GothamBold,
			TextSize = 10,
			TextXAlignment = Enum.TextXAlignment.Center,
			ClearTextOnFocus = false,
			Parent = floorRow,
		})
		Create("UICorner", { CornerRadius = UDim.new(0, 3), Parent = floorInput })
		floorInput.FocusLost:Connect(function()
			local s = floorInput.Text:gsub("%s", "")
			if s ~= "" then
				ccsFloorId = s
				floorInput.Text = s
			else
				floorInput.Text = ccsFloorId
			end
		end)

		-- helper: build voxel list by scanning workspace for dirty voxels
		-- falls back to firing a grid range if no workspace data found
		local function GetDirtyVoxels(floorPath)
			local voxels = {}
			-- try to find floor data in workspace
			local ok, floorFolder = pcall(function()
				return Workspace:FindFirstChild("DirtyFloor") or Workspace:FindFirstChild("Floors")
			end)
			if ok and floorFolder then
				for _, v in ipairs(floorFolder:GetDescendants()) do
					local vx = v:GetAttribute("VoxelX")
					local vy = v:GetAttribute("VoxelY")
					if vx and vy then
						table.insert(voxels, { VoxelX = vx, VoxelY = vy, FloorPath = floorPath, Mode = "Cleaning", Gain = 1, FloorId = ccsFloorId })
					end
				end
			end
			if #voxels == 0 then
				-- scan a broad range - server ignores voxels that aren't dirty
				for x = 160, 200 do
					for y = 230, 270 do
						table.insert(voxels, { VoxelX = x, VoxelY = y, FloorPath = floorPath, Mode = "Cleaning", Gain = 1, FloorId = ccsFloorId })
					end
				end
			end
			return voxels
		end

		local function FireCleanBatch(voxelList, mode, batchSize)
			batchSize = batchSize or 100
			-- patch mode into each voxel
			for _, v in ipairs(voxelList) do v.Mode = mode end
			local i = 1
			while i <= #voxelList do
				local batch = {}
				for j = i, math.min(i + batchSize - 1, #voxelList) do
					table.insert(batch, voxelList[j])
				end
				if CleaningSync then
					pcall(function() CleaningSync:FireServer("Batch", ccsJobId, batch) end)
				end
				i = i + batchSize
				task.wait(0.2)
			end
		end

		CCSTab:AddButton({
			Label = "Clean Floor",
			Callback = function()
				task.spawn(function()
					local voxels = GetDirtyVoxels("DirtyFloor")
					FireCleanBatch(voxels, "Cleaning")
					FireDialog({ "[BLAIZE]Floor cleaned." })
				end)
			end,
		})

		CCSTab:AddSection("Seal Coat")

		CCSTab:AddButton({
			Label = "Seal Coat Floor",
			Callback = function()
				task.spawn(function()
					local voxels = GetDirtyVoxels("DirtyFloor")
					FireCleanBatch(voxels, "Epoxy")
					FireDialog({ "[BLAIZE]Seal coat applied." })
				end)
			end,
		})

		CCSTab:AddButton({
			Label = "Clean + Seal (Full Job)",
			Callback = function()
				task.spawn(function()
					local voxels = GetDirtyVoxels("DirtyFloor")
					FireCleanBatch(voxels, "Cleaning")
					task.wait(0.5)
					FireCleanBatch(voxels, "Epoxy")
					FireDialog({ "[BLAIZE]Full job done." })
				end)
			end,
		})

		CCSTab:AddSection("Money Farm")

		local farmRunning = false
		local farmRate = 50  -- ms between reward fires

		local farmRateRow = Create("Frame", {
			Size = UDim2.new(1, 0, 0, 34),
			BackgroundColor3 = Theme.RowBg,
			BorderSizePixel = 0,
			Parent = CCSTab.Page,
		})
		Create("UICorner", { CornerRadius = UDim.new(0, 4), Parent = farmRateRow })
		Create("TextLabel", {
			Size = UDim2.new(0.55, 0, 1, 0),
			Position = UDim2.new(0, 10, 0, 0),
			BackgroundTransparency = 1,
			Text = "Interval (ms)",
			TextColor3 = Theme.Text,
			Font = Enum.Font.Gotham,
			TextSize = 12,
			TextXAlignment = Enum.TextXAlignment.Left,
			Parent = farmRateRow,
		})
		local farmRateInput = Create("TextBox", {
			Size = UDim2.new(0.32, 0, 0, 24),
			Position = UDim2.new(0.62, 0, 0.5, -12),
			BackgroundColor3 = Color3.fromRGB(25,25,25),
			BorderSizePixel = 0,
			Text = "50",
			TextColor3 = Theme.Text,
			Font = Enum.Font.GothamBold,
			TextSize = 12,
			TextXAlignment = Enum.TextXAlignment.Center,
			ClearTextOnFocus = false,
			Parent = farmRateRow,
		})
		Create("UICorner", { CornerRadius = UDim.new(0, 3), Parent = farmRateInput })
		farmRateInput.FocusLost:Connect(function()
			local n = tonumber(farmRateInput.Text)
			if n and n >= 10 then
				farmRate = math.floor(n)
				farmRateInput.Text = tostring(farmRate)
			else
				farmRateInput.Text = tostring(farmRate)
			end
		end)

		CCSTab:AddToggle({
			Label = "Auto Farm Money",
			Default = false,
			Callback = function(state)
				if state then
					farmRunning = true
					task.spawn(function()
						while farmRunning do
							if CleanVoxelReward then
								pcall(function() CleanVoxelReward:FireServer() end)
							end
							task.wait(farmRate / 1000)
						end
					end)
					FireDialog({ "[BLAIZE]Money farm on." })
				else
					farmRunning = false
					FireDialog({ "[BLAIZE]Money farm off." })
				end
			end,
		})

	elseif selectedGame and selectedGame.id == "bga" then
		-- Build a Gun Army tabs
		local EnemiesHitEvent = ReplicatedStorage:FindFirstChild("RemoteEvents") and ReplicatedStorage.RemoteEvents:FindFirstChild("EnemiesHitEvent")

		local BGATab = Window:AddTab({ Name = "Kill" })

		-- early warning - quick implementation
		local bgaWarnRow = Create("Frame", {
			Size = UDim2.new(1, 0, 0, 46),
			BackgroundColor3 = Color3.fromRGB(40, 28, 8),
			BorderSizePixel = 0,
			Parent = BGATab.Page,
		})
		Create("UICorner", { CornerRadius = UDim.new(0, 4), Parent = bgaWarnRow })
		Create("UIStroke", { Color = Color3.fromRGB(100, 70, 20), Thickness = 1, Parent = bgaWarnRow })
		Create("TextLabel", {
			Size = UDim2.new(1, -16, 1, 0),
			Position = UDim2.new(0, 8, 0, 0),
			BackgroundTransparency = 1,
			Text = "⚠ Early build - one of the least tested games. May be buggy.",
			TextColor3 = Color3.fromRGB(220, 160, 60),
			Font = Enum.Font.GothamBold,
			TextSize = 11,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextWrapped = true,
			Parent = bgaWarnRow,
		})

		BGATab:AddSection("Plot")

		-- plot picker (1-6)
		local bgaPlot = 3
		local plotRow = Create("Frame", {
			Size = UDim2.new(1, 0, 0, 34),
			BackgroundColor3 = Theme.RowBg,
			BorderSizePixel = 0,
			Parent = BGATab.Page,
		})
		Create("UICorner", { CornerRadius = UDim.new(0, 4), Parent = plotRow })
		Create("TextLabel", {
			Size = UDim2.new(0.55, 0, 1, 0),
			Position = UDim2.new(0, 10, 0, 0),
			BackgroundTransparency = 1,
			Text = "Plot Number (1-6)",
			TextColor3 = Theme.Text,
			Font = Enum.Font.Gotham,
			TextSize = 12,
			TextXAlignment = Enum.TextXAlignment.Left,
			Parent = plotRow,
		})
		local plotInput = Create("TextBox", {
			Size = UDim2.new(0.32, 0, 0, 24),
			Position = UDim2.new(0.62, 0, 0.5, -12),
			BackgroundColor3 = Color3.fromRGB(25,25,25),
			BorderSizePixel = 0,
			Text = "3",
			TextColor3 = Theme.Text,
			Font = Enum.Font.GothamBold,
			TextSize = 12,
			TextXAlignment = Enum.TextXAlignment.Center,
			ClearTextOnFocus = false,
			Parent = plotRow,
		})
		Create("UICorner", { CornerRadius = UDim.new(0, 3), Parent = plotInput })
		plotInput.FocusLost:Connect(function()
			local n = tonumber(plotInput.Text)
			if n and n >= 1 and n <= 6 then
				bgaPlot = math.floor(n)
				plotInput.Text = tostring(bgaPlot)
			else
				plotInput.Text = tostring(bgaPlot)
			end
		end)

		BGATab:AddSection("Auto Kill")

		-- get enemy Model references from the plot's SpawnedEnemies folder
		local function GetEnemies()
			local models = {}
			local ok, folder = pcall(function()
				return Workspace.Plots["Plot_" .. bgaPlot].SpawnedEnemies
			end)
			if not ok or not folder then
				FireDialog({ "[BLAIZE]SpawnedEnemies not found for Plot_" .. bgaPlot })
				return models
			end
			for _, child in ipairs(folder:GetChildren()) do
				if child:IsA("Model") then
					table.insert(models, child)
				end
			end
			return models
		end

		-- kill enemies: set Dead/Health attributes directly (server watches AttributeChanged)
		-- also fire client event for the visual hit effect
		local function KillAll()
			local models = GetEnemies()
			if #models == 0 then
				FireDialog({ "[BLAIZE]No enemies found." })
				return
			end
			local names = {}
			for _, m in ipairs(models) do
				table.insert(names, m.Name)
				pcall(function()
					m:SetAttribute("Dead", true)
					m:SetAttribute("Health", 0)
				end)
			end
			if EnemiesHitEvent then
				pcall(function() firesignal(EnemiesHitEvent.OnClientEvent, names) end)
			end
			FireDialog({ "[BLAIZE]Killed " .. #models .. " enemies." })
		end

		BGATab:AddButton({
			Label = "Kill All Enemies",
			Callback = function()
				task.spawn(KillAll)
			end,
		})

		local killRunning = false
		local killInterval = 200  -- ms between sweeps

		local killIntervalRow = Create("Frame", {
			Size = UDim2.new(1, 0, 0, 34),
			BackgroundColor3 = Theme.RowBg,
			BorderSizePixel = 0,
			Parent = BGATab.Page,
		})
		Create("UICorner", { CornerRadius = UDim.new(0, 4), Parent = killIntervalRow })
		Create("TextLabel", {
			Size = UDim2.new(0.55, 0, 1, 0),
			Position = UDim2.new(0, 10, 0, 0),
			BackgroundTransparency = 1,
			Text = "Interval (ms)",
			TextColor3 = Theme.Text,
			Font = Enum.Font.Gotham,
			TextSize = 12,
			TextXAlignment = Enum.TextXAlignment.Left,
			Parent = killIntervalRow,
		})
		local killIntervalInput = Create("TextBox", {
			Size = UDim2.new(0.32, 0, 0, 24),
			Position = UDim2.new(0.62, 0, 0.5, -12),
			BackgroundColor3 = Color3.fromRGB(25,25,25),
			BorderSizePixel = 0,
			Text = "200",
			TextColor3 = Theme.Text,
			Font = Enum.Font.GothamBold,
			TextSize = 12,
			TextXAlignment = Enum.TextXAlignment.Center,
			ClearTextOnFocus = false,
			Parent = killIntervalRow,
		})
		Create("UICorner", { CornerRadius = UDim.new(0, 3), Parent = killIntervalInput })
		killIntervalInput.FocusLost:Connect(function()
			local n = tonumber(killIntervalInput.Text)
			if n and n >= 50 then
				killInterval = math.floor(n)
				killIntervalInput.Text = tostring(killInterval)
			else
				killIntervalInput.Text = tostring(killInterval)
			end
		end)

		BGATab:AddToggle({
			Label = "Auto Kill Loop",
			Default = false,
			Callback = function(state)
				if state then
					killRunning = true
					task.spawn(function()
						while killRunning do
							local models = GetEnemies()
							if #models > 0 then
								local names = {}
								for _, m in ipairs(models) do
									table.insert(names, m.Name)
									pcall(function()
										m:SetAttribute("Dead", true)
										m:SetAttribute("Health", 0)
									end)
								end
								if EnemiesHitEvent then
									pcall(function() firesignal(EnemiesHitEvent.OnClientEvent, names) end)
								end
							end
							task.wait(killInterval / 1000)
						end
					end)
					FireDialog({ "[BLAIZE]Auto kill on - Plot_" .. bgaPlot })
				else
					killRunning = false
					FireDialog({ "[BLAIZE]Auto kill off." })
				end
			end,
		})

	elseif selectedGame and selectedGame.id == "sve" then
		-- Speed Verity Escape tabs
		local sveRebirthEvent = ReplicatedStorage:FindFirstChild("Remotes") and ReplicatedStorage.Remotes:FindFirstChild("RequestRebirth")

		local function TeleportToWinPad(stageNum)
			local hrp = GetHRP()
			if not hrp then return end
			local ok, pad = pcall(function()
				return Workspace.Worlds["World1"].WinPads["Stage" .. stageNum .. "WinPad"]
			end)
			if not ok or not pad then
				FireDialog({ "[BLAIZE]Stage " .. stageNum .. " pad not found." })
				return
			end
			SafeTP(CFrame.new(pad.Position + Vector3.new(0, 3, 0)))
		end

		local stageOptions = {}
		for i = 1, 15 do
			table.insert(stageOptions, { name = "Stage " .. i, num = i })
		end

		-- World 1 tab
		local W1Tab = Window:AddTab({ Name = "World 1" })

		W1Tab:AddSection("Autofarm")

		-- autofarm target stage - stored so the toggle callback can read it
		local autofarmStage = 1
		local autofarmConn = nil

		-- Stage number input row
		local stageRow = Create("Frame", {
			Size = UDim2.new(1, 0, 0, 34),
			BackgroundColor3 = Theme.RowBg,
			BorderSizePixel = 0,
			Parent = W1Tab.Page,
		})
		Create("UICorner", { CornerRadius = UDim.new(0, 4), Parent = stageRow })
		Create("TextLabel", {
			Size = UDim2.new(0.55, 0, 1, 0),
			Position = UDim2.new(0, 10, 0, 0),
			BackgroundTransparency = 1,
			Text = "Farm Stage",
			TextColor3 = Theme.Text,
			Font = Enum.Font.Gotham,
			TextSize = 12,
			TextXAlignment = Enum.TextXAlignment.Left,
			Parent = stageRow,
		})
		local stageInput = Create("TextBox", {
			Size = UDim2.new(0.32, 0, 0, 24),
			Position = UDim2.new(0.62, 0, 0.5, -12),
			BackgroundColor3 = Color3.fromRGB(25,25,25),
			BorderSizePixel = 0,
			Text = "1",
			TextColor3 = Theme.Text,
			Font = Enum.Font.GothamBold,
			TextSize = 12,
			TextXAlignment = Enum.TextXAlignment.Center,
			ClearTextOnFocus = false,
			Parent = stageRow,
		})
		Create("UICorner", { CornerRadius = UDim.new(0, 3), Parent = stageInput })
		stageInput.FocusLost:Connect(function()
			local n = tonumber(stageInput.Text)
			if n and n >= 1 and n <= 15 then
				autofarmStage = math.floor(n)
				stageInput.Text = tostring(autofarmStage)
			else
				stageInput.Text = tostring(autofarmStage)
			end
		end)

		local autofarmRunning = false

		W1Tab:AddToggle({
			Label = "Autofarm",
			Default = false,
			Callback = function(state)
				if state then
					autofarmRunning = true
					FireDialog({ "[BLAIZE]Autofarm started - Stage " .. autofarmStage .. "." })
					task.spawn(function()
						while autofarmRunning do
							TeleportToWinPad(autofarmStage)
							task.wait(0.1)
							-- brief pause so the stage registers, then teleport back
							local hrp = GetHRP()
							if hrp then
								local origin = hrp.CFrame
								task.wait(0.05)
								local hrp2 = GetHRP()
								if hrp2 then hrp2.CFrame = origin end
							end
							task.wait(0.05)
						end
					end)
				else
					autofarmRunning = false
					FireDialog({ "[BLAIZE]Autofarm stopped." })
				end
			end,
		})

		-- Stages tab
		local StagesTab = Window:AddTab({ Name = "Stages" })
		StagesTab:AddSection("Stage Teleport")

		local selectedStageNum = 1
		local stageDropdown = StagesTab:AddDropdown({
			Label = "Select Stage...",
			Options = stageOptions,
			Callback = function(opt)
				selectedStageNum = opt.num
			end,
		})
		StagesTab:AddButton({
			Label = "Teleport",
			Callback = function()
				TeleportToWinPad(selectedStageNum)
				task.delay(0.5, function()
					if stageDropdown then stageDropdown:ResetLabel() end
				end)
			end,
		})

		-- Rebirth tab
		local RebirthTab = Window:AddTab({ Name = "Rebirth" })

		RebirthTab:AddSection("Auto Rebirth")

		local rebirthRunning = false

		RebirthTab:AddButton({
			Label = "Rebirth Once",
			Callback = function()
				if sveRebirthEvent then
					pcall(function() sveRebirthEvent:InvokeServer() end)
					FireDialog({ "[BLAIZE]Rebirth triggered." })
				else
					FireDialog({ "[BLAIZE]Rebirth remote not found." })
				end
			end,
		})

		RebirthTab:AddToggle({
			Label = "Auto Rebirth",
			Default = false,
			Callback = function(state)
				if state then
					rebirthRunning = true
					FireDialog({ "[BLAIZE]Auto rebirth on." })
					task.spawn(function()
						while rebirthRunning do
							if sveRebirthEvent then
								pcall(function() sveRebirthEvent:InvokeServer() end)
							end
							task.wait(1)
						end
					end)
				else
					rebirthRunning = false
					FireDialog({ "[BLAIZE]Auto rebirth off." })
				end
			end,
		})
	elseif selectedGame and selectedGame.id == "ftn" then
		-- Find the Needohs!
		local NeedohEvent = ReplicatedStorage:FindFirstChild("NeedohFound")

		local FTNTab = Window:AddTab({ Name = "Needohs" })
		FTNTab:AddSection("Find All Needohs")

		-- single needoh options (1-190)
		local needohOptions = {}
		for i = 1, 190 do
			table.insert(needohOptions, { name = "Needoh" .. i, id = "Needoh" .. i })
		end

		local selectedNeedoh = needohOptions[1]
		FTNTab:AddDropdown({
			Label = "Select Needoh...",
			Options = needohOptions,
			Callback = function(opt)
				selectedNeedoh = opt
			end,
		})
		FTNTab:AddButton({
			Label = "Fire Selected Needoh",
			Callback = function()
				if not NeedohEvent then
					FireDialog({ "[BLAIZE]NeedohFound event not found." })
					return
				end
				pcall(function()
					firesignal(NeedohEvent.OnClientEvent, selectedNeedoh.id)
				end)
				FireDialog({ "[BLAIZE]Fired " .. selectedNeedoh.id .. "." })
			end,
		})

		FTNTab:AddSection("Auto Farm")

		FTNTab:AddButton({
			Label = "Fire All Needohs (1-190)",
			Callback = function()
				if not NeedohEvent then
					FireDialog({ "[BLAIZE]NeedohFound event not found." })
					return
				end
				for i = 1, 190 do
					pcall(function()
						firesignal(NeedohEvent.OnClientEvent, "Needoh" .. i)
					end)
				end
				FireDialog({ "[BLAIZE]All 190 Needohs fired!" })
			end,
		})

	elseif selectedGame and selectedGame.id == "apc" then
		-- +1 Ammo Per Click
		local AddKick = ReplicatedStorage.Packages._Index["sleitnick_knit@1.7.0"].knit.Services.KickService.RF.AddKick

		local APCTab = Window:AddTab({ Name = "Ammo" })
		APCTab:AddSection("Ammo Farm")

		APCTab:AddButton({
			Label = "+ Get Ammo",
			Callback = function()
				pcall(function() AddKick:InvokeServer(nil) end)
			end,
		})

		local apcFarmRunning = false
		local apcFarmRate    = 50

		local apcRateRow = Create("Frame", {
			Size = UDim2.new(1, 0, 0, 34),
			BackgroundColor3 = Theme.RowBg,
			BorderSizePixel = 0,
			Parent = APCTab.Page,
		})
		Create("UICorner", { CornerRadius = UDim.new(0, 4), Parent = apcRateRow })
		Create("TextLabel", {
			Size = UDim2.new(0.55, 0, 1, 0),
			Position = UDim2.new(0, 10, 0, 0),
			BackgroundTransparency = 1,
			Text = "Interval (ms)",
			TextColor3 = Theme.Text,
			Font = Enum.Font.Gotham,
			TextSize = 12,
			TextXAlignment = Enum.TextXAlignment.Left,
			Parent = apcRateRow,
		})
		local apcRateInput = Create("TextBox", {
			Size = UDim2.new(0.32, 0, 0, 24),
			Position = UDim2.new(0.62, 0, 0.5, -12),
			BackgroundColor3 = Color3.fromRGB(25,25,25),
			BorderSizePixel = 0,
			Text = "50",
			TextColor3 = Theme.Text,
			Font = Enum.Font.GothamBold,
			TextSize = 12,
			TextXAlignment = Enum.TextXAlignment.Center,
			ClearTextOnFocus = false,
			Parent = apcRateRow,
		})
		Create("UICorner", { CornerRadius = UDim.new(0, 3), Parent = apcRateInput })
		apcRateInput.FocusLost:Connect(function()
			local n = tonumber(apcRateInput.Text)
			if n and n >= 10 then
				apcFarmRate = math.floor(n)
				apcRateInput.Text = tostring(apcFarmRate)
			else
				apcRateInput.Text = tostring(apcFarmRate)
			end
		end)

		APCTab:AddToggle({
			Label = "Auto Farm Ammo",
			Default = false,
			Callback = function(state)
				if state then
					apcFarmRunning = true
					task.spawn(function()
						while apcFarmRunning do
							pcall(function() AddKick:InvokeServer(nil) end)
							task.wait(apcFarmRate / 1000)
						end
					end)
					FireDialog({ "[BLAIZE]Ammo farm on." })
				else
					apcFarmRunning = false
					FireDialog({ "[BLAIZE]Ammo farm off." })
				end
			end,
		})

	else
		-- Sail and Sink Simulator tabs

		-- World tab
		local WorldTab = Window:AddTab({ Name = "World" })

		WorldTab:AddSection("Islands")

		local islandBtnRef = {}
		local islandBtn = WorldTab:AddButton({
			Label = "Unlock All Islands",
			Callback = function()
				if isBusy then return end
				local islandList = {}
				for _, isl in ipairs(Islands) do
					table.insert(islandList, { name = isl.name, x = isl.x, z = isl.z })
				end
				task.spawn(RunSequence, islandList, islandBtnRef[1], "Unlock All Islands", "[BLAIZE]All islands visited.")
			end,
		})
		islandBtnRef[1] = islandBtn

		local selectedIsland = Islands[1]
		WorldTab:AddDropdown({
			Label = "Select Island...",
			Options = Islands,
			Callback = function(island)
				selectedIsland = island
			end,
		})
		WorldTab:AddButton({
			Label = "Teleport to Island",
			Callback = function()
				if selectedIsland then task.spawn(TeleportToIsland, selectedIsland) end
			end,
		})

		-- Wrecks tab
		local WrecksTab = Window:AddTab({ Name = "Wrecks" })

		WrecksTab:AddSection("Teleport")

		local selectedWreck = Wrecks[1]
		WrecksTab:AddDropdown({
			Label = "Select Wreck...",
			Options = Wrecks,
			Callback = function(wreck)
				selectedWreck = wreck
			end,
		})
		WrecksTab:AddButton({
			Label = "Teleport to Wreck",
			Callback = function()
				if selectedWreck then task.spawn(TeleportToWreck, selectedWreck) end
			end,
		})
	end

	-- Cheats tab
	local CheatsTab = Window:AddTab({ Name = "Cheats" })

	CheatsTab:AddSection("Teleport")

	-- player list for TP-to-player dropdown
	local function GetPlayerOptions()
		local opts = {}
		for _, p in ipairs(Players:GetPlayers()) do
			if p ~= LocalPlayer then
				table.insert(opts, { name = p.Name, player = p })
			end
		end
		return opts
	end

	local selectedTPTarget = nil
	local tpPlayerDropdown = CheatsTab:AddDropdown({
		Label = "Select Player...",
		Options = GetPlayerOptions(),
		Callback = function(opt)
			selectedTPTarget = opt.player
		end,
	})

	CheatsTab:AddButton({
		Label = "Teleport to Player",
		Callback = function()
			local target = selectedTPTarget
			if not target then
				FireDialog({ "[BLAIZE]Select a player first." })
				return
			end
			task.spawn(function()
				-- STRATEGY: on StreamingEnabled games the target's character model
				-- may not exist in our Workspace at all. We find their position via
				-- any available source, TP ourselves near there to trigger streaming,
				-- then snap to them once their model loads.

				local targetPos = nil

				-- 1. try Character model (works if they're nearby or streaming is off)
				local char = target.Character
				if char then
					local ok, piv = pcall(function() return char:GetPivot() end)
					if ok and piv then targetPos = piv.Position end
					if not targetPos then
						local hrp = char:FindFirstChild("HumanoidRootPart")
						if hrp then targetPos = hrp.Position end
					end
				end

				-- 2. check ReplicatedStorage/leaderstats for a stored position value
				if not targetPos then
					pcall(function()
						local ls = target:FindFirstChild("leaderstats")
						-- some games store MapX/MapZ or similar
						local px = ls and (ls:FindFirstChild("X") or ls:FindFirstChild("PosX") or ls:FindFirstChild("MapX"))
						local pz = ls and (ls:FindFirstChild("Z") or ls:FindFirstChild("PosZ") or ls:FindFirstChild("MapZ"))
						if px and pz then
							targetPos = Vector3.new(px.Value, 0, pz.Value)
						end
					end)
				end

				-- 3. scan Workspace for any Model whose Name matches the player's name
				--    (some games put characters outside the default streaming path)
				if not targetPos then
					pcall(function()
						for _, obj in ipairs(Workspace:GetDescendants()) do
							if obj:IsA("Model") and obj.Name == target.Name then
								local hrp = obj:FindFirstChild("HumanoidRootPart")
								if hrp then targetPos = hrp.Position break end
								local ok, piv = pcall(function() return obj:GetPivot() end)
								if ok and piv and piv.Position.Magnitude > 0.1 then
									targetPos = piv.Position break
								end
							end
						end
					end)
				end

				if not targetPos then
					FireDialog({ "[BLAIZE]" .. target.Name .. "'s position not found - they may be too far away." })
					return
				end

				-- TP ourselves close to that area to trigger streaming
				local myHRP = GetHRP()
				if not myHRP then return end
				myHRP.CFrame = CFrame.new(targetPos + Vector3.new(0, 5, 0))

				-- request streaming around target position
				pcall(function() Workspace:RequestStreamAroundAsync(targetPos, 5) end)

				-- wait for their character to appear
				local waited = 0
				local tHRP = nil
				repeat
					task.wait(0.15)
					waited = waited + 0.15
					char = target.Character
					if char then tHRP = char:FindFirstChild("HumanoidRootPart") end
				until tHRP or waited >= 4

				if tHRP then
					SafeTP(tHRP.CFrame + tHRP.CFrame.LookVector * 3)
					FireDialog({ "[BLAIZE]Teleported to " .. target.Name .. "." })
				else
					-- already near them from the initial TP, just nudge
					FireDialog({ "[BLAIZE]Near " .. target.Name .. " but character still loading." })
				end
			end)
		end,
	})

	CheatsTab:AddButton({
		Label = "Refresh Player List",
		Callback = function()
			-- rebuild the options and reset the dropdown label
			local newOpts = GetPlayerOptions()
			selectedTPTarget = nil
			if tpPlayerDropdown then tpPlayerDropdown:ResetLabel() end
			FireDialog({ "[BLAIZE]Player list refreshed - " .. #newOpts .. " player(s) found." })
		end,
	})

	CheatsTab:AddSection("Movement")

	local targetSpeed = 16
	local speedConn = nil

	local function ApplySpeed(v)
		targetSpeed = v
		local char = LocalPlayer.Character
		if char and char:FindFirstChild("Humanoid") then
			char.Humanoid.WalkSpeed = v
		end
		-- start enforcer if not running
		if not speedConn then
			speedConn = game:GetService("RunService").Heartbeat:Connect(function()
				if targetSpeed == 16 then return end  -- no need to fight AC at default
				local c = LocalPlayer.Character
				if c then
					local hum = c:FindFirstChild("Humanoid")
					if hum and hum.WalkSpeed ~= targetSpeed then
						hum.WalkSpeed = targetSpeed
					end
				end
			end)
		end
	end

	local speedSlider = CheatsTab:AddSlider({
		Label = "Walk Speed",
		Min = 16,
		Max = 1500,
		Default = 16,
		Callback = function(v)
			ApplySpeed(v)
		end,
	})

	CheatsTab:AddButton({
		Label = "Reset Speed",
		Callback = function()
			if speedConn then speedConn:Disconnect() speedConn = nil end
			targetSpeed = 16
			local char = LocalPlayer.Character
			if char and char:FindFirstChild("Humanoid") then
				char.Humanoid.WalkSpeed = 16
			end
			if speedSlider then speedSlider:Set(16) end
			FireDialog({ "[BLAIZE]Speed reset to 16." })
		end,
	})

	CheatsTab:AddToggle({
		Label = "Infinite Jump",
		Default = false,
		Callback = function(state)
			if state then
				_G.BlaizeIJ = UserInputService.JumpRequest:Connect(function()
					local char = LocalPlayer.Character
					if char and char:FindFirstChild("Humanoid") then
						char.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
					end
				end)
				FireDialog({ "[BLAIZE]Infinite jump on." })
			else
				if _G.BlaizeIJ then _G.BlaizeIJ:Disconnect() _G.BlaizeIJ = nil end
				FireDialog({ "[BLAIZE]Infinite jump off." })
			end
		end,
	})

	CheatsTab:AddToggle({
		Label = "Noclip",
		Default = false,
		Callback = function(state)
			if state then
				noclipConn = game:GetService("RunService").Heartbeat:Connect(function()
					local char = LocalPlayer.Character
					if not char then return end
					for _, p in ipairs(char:GetDescendants()) do
						if p:IsA("BasePart") then
							p.CanCollide = false
						end
					end
				end)
				FireDialog({ "[BLAIZE]Noclip on." })
			else
				if noclipConn then noclipConn:Disconnect() noclipConn = nil end
				local char = LocalPlayer.Character
				if char then
					for _, p in ipairs(char:GetDescendants()) do
						if p:IsA("BasePart") then p.CanCollide = true end
					end
				end
				FireDialog({ "[BLAIZE]Noclip off." })
			end
		end,
	})

	local flySpeed = 60
	CheatsTab:AddSlider({
		Label = "Fly Speed",
		Min = 10,
		Max = 500,
		Default = 60,
		Callback = function(v)
			flySpeed = v
		end,
	})

	CheatsTab:AddToggle({
		Label = "Fly",
		Default = false,
		Callback = function(state)
			local hrp = GetHRP()
			if not hrp then return end
			if state then
				local char = LocalPlayer.Character
				local hum = char and char:FindFirstChild("Humanoid")
				if hum then hum.PlatformStand = true end

				flyBV = Instance.new("BodyVelocity")
				flyBV.Velocity = Vector3.zero
				flyBV.MaxForce = Vector3.new(1e5, 1e5, 1e5)
				flyBV.Parent = hrp

				flyBG = Instance.new("BodyGyro")
				flyBG.MaxTorque = Vector3.new(1e5, 1e5, 1e5)
				flyBG.CFrame = hrp.CFrame
				flyBG.Parent = hrp

				flyConn = game:GetService("RunService").Heartbeat:Connect(function()
					local fhrp = GetHRP()
					if not fhrp or not flyBV or not flyBV.Parent then return end
					local cam = Workspace.CurrentCamera
					local dir = Vector3.zero
					if UserInputService:IsKeyDown(Enum.KeyCode.W) then dir = dir + cam.CFrame.LookVector end
					if UserInputService:IsKeyDown(Enum.KeyCode.S) then dir = dir - cam.CFrame.LookVector end
					if UserInputService:IsKeyDown(Enum.KeyCode.A) then dir = dir - cam.CFrame.RightVector end
					if UserInputService:IsKeyDown(Enum.KeyCode.D) then dir = dir + cam.CFrame.RightVector end
					if UserInputService:IsKeyDown(Enum.KeyCode.Space) then dir = dir + Vector3.new(0,1,0) end
					if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then dir = dir - Vector3.new(0,1,0) end
					flyBV.Velocity = dir.Magnitude > 0 and dir.Unit * flySpeed or Vector3.zero
					flyBG.CFrame = cam.CFrame
				end)
				FireDialog({ "[BLAIZE]Fly on. WASD + Space/Shift." })
			else
				if flyConn then flyConn:Disconnect() flyConn = nil end
				if flyBV then flyBV:Destroy() flyBV = nil end
				if flyBG then flyBG:Destroy() flyBG = nil end
				local char = LocalPlayer.Character
				local hum = char and char:FindFirstChild("Humanoid")
				if hum then hum.PlatformStand = false end
				FireDialog({ "[BLAIZE]Fly off." })
			end
		end,
	})

	CheatsTab:AddSection("Freecam")

	local freecamSpeed = 40
	CheatsTab:AddSlider({
		Label = "Freecam Speed",
		Min = 5,
		Max = 300,
		Default = 40,
		Callback = function(v)
			freecamSpeed = v
		end,
	})

	local freecamToggleRef = nil

	local function StopFreecam()
		freecamActive = false
		if freecamConn then freecamConn:Disconnect() freecamConn = nil end
		if freecamInputConn then freecamInputConn:Disconnect() freecamInputConn = nil end
		local cam = Workspace.CurrentCamera
		cam.CameraType = Enum.CameraType.Custom
		if freecamToggleRef then freecamToggleRef:SetState(false) end
	end

	local function StartFreecam()
		freecamActive = true
		local cam = Workspace.CurrentCamera
		cam.CameraType = Enum.CameraType.Scriptable

		-- show toast always (uses our custom notif, not game dialog)
		ShowToast("Freecam on  -  Shift + P to exit", 5)

		local freecamCF = cam.CFrame

		freecamConn = game:GetService("RunService").RenderStepped:Connect(function(dt)
			local dir = Vector3.zero
			local spd = freecamSpeed * dt * 60  -- frame-rate independent

			if UserInputService:IsKeyDown(Enum.KeyCode.W) then dir = dir + freecamCF.LookVector end
			if UserInputService:IsKeyDown(Enum.KeyCode.S) then dir = dir - freecamCF.LookVector end
			if UserInputService:IsKeyDown(Enum.KeyCode.A) then dir = dir - freecamCF.RightVector end
			if UserInputService:IsKeyDown(Enum.KeyCode.D) then dir = dir + freecamCF.RightVector end
			if UserInputService:IsKeyDown(Enum.KeyCode.E) or UserInputService:IsKeyDown(Enum.KeyCode.Space) then
				dir = dir + Vector3.new(0, 1, 0)
			end
			if UserInputService:IsKeyDown(Enum.KeyCode.Q) then
				dir = dir - Vector3.new(0, 1, 0)
			end

			if dir.Magnitude > 0 then
				freecamCF = freecamCF + dir.Unit * spd
			end

			-- mouse look: use mouse delta for camera rotation
			local delta = UserInputService:GetMouseDelta()
			if delta.Magnitude > 0 then
				local rx = CFrame.Angles(0, -delta.X * 0.003, 0)
				local ry = CFrame.Angles(-delta.Y * 0.003, 0, 0)
				freecamCF = rx * freecamCF * ry
			end

			cam.CFrame = freecamCF
		end)

		-- Shift+P to exit
		freecamInputConn = UserInputService.InputBegan:Connect(function(input, gpe)
			if input.KeyCode == Enum.KeyCode.P and UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
				StopFreecam()
				ShowToast("Freecam off", 2)
			end
		end)
	end

	freecamToggleRef = CheatsTab:AddToggle({
		Label = "Freecam",
		Default = false,
		Callback = function(state)
			if state then
				StartFreecam()
			else
				StopFreecam()
			end
		end,
	})

	-- Settings tab
	local SettingsTab = Window:AddTab({ Name = "Settings" })

	SettingsTab:AddSection("Theme")

	local Themes = {
		{ name = "Dark",    bg = Color3.fromRGB(12,12,12),   sidebar = Color3.fromRGB(8,8,8),    top = Color3.fromRGB(6,6,6),    row = Color3.fromRGB(18,18,18),  border = Color3.fromRGB(35,35,35)  },
		{ name = "Darker",  bg = Color3.fromRGB(4,4,4),      sidebar = Color3.fromRGB(2,2,2),    top = Color3.fromRGB(0,0,0),    row = Color3.fromRGB(10,10,10),  border = Color3.fromRGB(22,22,22)  },
		{ name = "Slate",   bg = Color3.fromRGB(18,20,26),   sidebar = Color3.fromRGB(12,14,20), top = Color3.fromRGB(10,12,18), row = Color3.fromRGB(24,26,34),  border = Color3.fromRGB(40,44,56)  },
		{ name = "Midnight",bg = Color3.fromRGB(10,10,22),   sidebar = Color3.fromRGB(6,6,16),   top = Color3.fromRGB(4,4,14),   row = Color3.fromRGB(16,16,30),  border = Color3.fromRGB(32,32,55)  },
		{ name = "Forest",  bg = Color3.fromRGB(10,16,12),   sidebar = Color3.fromRGB(6,12,8),   top = Color3.fromRGB(4,10,6),   row = Color3.fromRGB(14,22,16),  border = Color3.fromRGB(30,46,34)  },
	}

	local function ApplyTheme(t)
		Theme.Background = t.bg
		Theme.Sidebar = t.sidebar
		Theme.TopBar = t.top
		Theme.RowBg = t.row
		Theme.Border = t.border
		local gui = CoreGui:FindFirstChild("BlaizeHub")
		if not gui then return end
		local main = gui:FindFirstChild("Main")
		if not main then return end
		main.BackgroundColor3 = t.bg
		local ca = main:FindFirstChild("ContentArea")
		if ca then ca.BackgroundColor3 = t.bg end
		local tb = main:FindFirstChild("TopBar")
		if tb then tb.BackgroundColor3 = t.top end
		local sb = main:FindFirstChild("Sidebar")
		if sb then sb.BackgroundColor3 = t.sidebar end
	end

	SettingsTab:AddDropdown({
		Label = "Colour Theme",
		Options = Themes,
		Callback = function(t)
			ApplyTheme(t)
		end,
	})

	SettingsTab:AddSection("Notifications")

	SettingsTab:AddToggle({
		Label = "Enable Notifications",
		Default = true,
		Callback = function(state)
			notifsEnabled = state
		end,
	})

	SettingsTab:AddToggle({
		Label = "Enable Notif Sounds",
		Default = true,
		Callback = function(state)
			soundsEnabled = state
		end,
	})

	SettingsTab:AddSection("UI Scale")

	SettingsTab:AddSlider({
		Label = "Scale %",
		Min = 60,
		Max = 150,
		Default = 100,
		Callback = function(v)
			local gui = CoreGui:FindFirstChild("BlaizeHub")
			if not gui then return end
			local main = gui:FindFirstChild("Main")
			if not main then return end
			local scale = v / 100
			main.Size = UDim2.new(0, math.floor(580 * scale), 0, math.floor(420 * scale))
		end,
	})

	SettingsTab:AddSection("Anticheat")

	local strictToggleRef = nil

	SettingsTab:AddToggle({
		Label = "AC Bypass (Smooth TP)",
		Default = false,
		Callback = function(state)
			acBypass = state
			if not state then
				acStrict = false
				if strictToggleRef then strictToggleRef:SetState(false) end
			end
			-- grey/ungrey the strict row
			if strictToggleRef and strictToggleRef._row then
				strictToggleRef._row.BackgroundColor3 = state
					and Theme.RowBg
					or Color3.fromRGB(14, 14, 14)
				local lbl = strictToggleRef._row:FindFirstChildWhichIsA("TextLabel")
				if lbl then lbl.TextColor3 = state and Theme.Text or Theme.SubText end
			end
			if state then
				FireDialog({ "[BLAIZE]AC bypass on. Teleports step gradually." })
			else
				FireDialog({ "[BLAIZE]AC bypass off. Teleports are instant." })
			end
		end,
	})

	-- strict mode row - manually built so we can grey it out
	do
		local strictRow = Create("Frame", {
			Size = UDim2.new(1, 0, 0, 36),
			BackgroundColor3 = Color3.fromRGB(14, 14, 14),
			BorderSizePixel = 0,
			Parent = SettingsTab.Page,
		})
		Create("UICorner", { CornerRadius = UDim.new(0, 5), Parent = strictRow })
		Create("UIStroke", { Color = Theme.Border, Thickness = 1, Parent = strictRow })

		local strictLbl = Create("TextLabel", {
			Size = UDim2.new(1, -58, 1, 0),
			Position = UDim2.new(0, 12, 0, 0),
			BackgroundTransparency = 1,
			Text = "Strict Mode (Lock Speed + Noclip)",
			TextColor3 = Theme.SubText,
			Font = Enum.Font.Gotham,
			TextSize = 12,
			TextXAlignment = Enum.TextXAlignment.Left,
			Parent = strictRow,
		})

		local strictState = false
		local sTrack = Create("Frame", {
			Size = UDim2.new(0, 34, 0, 18),
			Position = UDim2.new(1, -46, 0.5, -9),
			BackgroundColor3 = Theme.Toggle,
			BorderSizePixel = 0,
			Parent = strictRow,
		})
		Create("UICorner", { CornerRadius = UDim.new(1, 0), Parent = sTrack })
		local sKnob = Create("Frame", {
			Size = UDim2.new(0, 12, 0, 12),
			Position = UDim2.new(0, 3, 0.5, -6),
			BackgroundColor3 = Color3.fromRGB(160, 160, 160),
			BorderSizePixel = 0,
			Parent = sTrack,
		})
		Create("UICorner", { CornerRadius = UDim.new(1, 0), Parent = sKnob })

		local sZone = Create("TextButton", {
			Size = UDim2.new(1, 0, 1, 0),
			BackgroundTransparency = 1,
			Text = "",
			Parent = strictRow,
		})
		sZone.MouseButton1Click:Connect(function()
			if not acBypass then
				FireDialog({ "[BLAIZE]Enable AC Bypass first." })
				return
			end
			strictState = not strictState
			acStrict = strictState
			Tween(sTrack, { BackgroundColor3 = strictState and Theme.ToggleEnabled or Theme.Toggle }, 0.12)
			Tween(sKnob, {
				Position = strictState and UDim2.new(1, -15, 0.5, -6) or UDim2.new(0, 3, 0.5, -6),
				BackgroundColor3 = strictState and Color3.fromRGB(12,12,12) or Color3.fromRGB(160,160,160),
			}, 0.12)
			FireDialog({ "[BLAIZE]Strict mode " .. (strictState and "on." or "off.") })
		end)

		strictToggleRef = {
			SetState = function(_, s)
				strictState = s
				Tween(sTrack, { BackgroundColor3 = s and Theme.ToggleEnabled or Theme.Toggle }, 0.12)
				Tween(sKnob, {
					Position = s and UDim2.new(1, -15, 0.5, -6) or UDim2.new(0, 3, 0.5, -6),
					BackgroundColor3 = s and Color3.fromRGB(12,12,12) or Color3.fromRGB(160,160,160),
				}, 0.12)
			end,
			_row = strictRow,
		}
	end

	SettingsTab:AddSection("Misc")

	SettingsTab:AddButton({
		Label = "Change Game",
		Callback = function()
			if noclipConn then noclipConn:Disconnect() noclipConn = nil end
			if flyConn    then flyConn:Disconnect()    flyConn = nil end
			if flyBV      then flyBV:Destroy()         flyBV = nil end
			if flyBG      then flyBG:Destroy()         flyBG = nil end
			if _G.BlaizeIJ then _G.BlaizeIJ:Disconnect() _G.BlaizeIJ = nil end
			if speedConn  then speedConn:Disconnect()  speedConn = nil end
			if freecamActive then StopFreecam() end
			targetSpeed = 16
			local char = LocalPlayer.Character
			if char then
				local hum = char:FindFirstChild("Humanoid")
				if hum then hum.WalkSpeed = 16 hum.PlatformStand = false end
				for _, p in ipairs(char:GetDescendants()) do
					if p:IsA("BasePart") then p.CanCollide = true end
				end
			end
			local gui = CoreGui:FindFirstChild("BlaizeHub")
			if gui then gui:Destroy() end
			gateGui = Create("ScreenGui", {
				Name           = "BlaizeGate",
				ResetOnSpawn   = false,
				ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
				Parent         = CoreGui,
			})
			ShowGameMenu()
		end,
	})

	SettingsTab:AddButton({
		Label = "Unload Blaize Hub",
		Callback = function()
			if noclipConn then noclipConn:Disconnect() end
			if flyConn then flyConn:Disconnect() end
			if flyBV then flyBV:Destroy() end
			if flyBG then flyBG:Destroy() end
			if _G.BlaizeIJ then _G.BlaizeIJ:Disconnect() end
			if speedConn then speedConn:Disconnect() speedConn = nil end
			if freecamActive then StopFreecam() end
			targetSpeed = 16
			local char = LocalPlayer.Character
			if char then
				local hum = char:FindFirstChild("Humanoid")
				if hum then hum.WalkSpeed = 16 hum.PlatformStand = false end
				for _, p in ipairs(char:GetDescendants()) do
					if p:IsA("BasePart") then p.CanCollide = true end
				end
			end
			local gui = CoreGui:FindFirstChild("BlaizeHub")
			if gui then gui:Destroy() end
		end,
	})

	task.spawn(function()
		task.wait(0.5)
		PlaySound("gamepass")
		FireDialog({ "[BLAIZE]Blaize Hub loaded. Welcome, " .. LocalPlayer.Name .. "." })
	end)
end

-- GAME MENU SCREEN
local function ShowGameMenu()
	for _, ch in ipairs(gateGui:GetChildren()) do ch:Destroy() end

	local menuW, menuH = 380, 460
	local menuBg = MakeCard(menuW, menuH)
	menuBg.Size = UDim2.new(0, menuW, 0, menuH)
	menuBg.Position = UDim2.new(0.5, -menuW/2, 0.5, -menuH/2)

	Create("UICorner", { CornerRadius = UDim.new(0, 6), Parent = menuBg })

	-- header row
	local headerH = 52
	Create("ImageLabel", {
		Size = UDim2.new(0, 26, 0, 26),
		Position = UDim2.new(0, 14, 0, headerH/2 - 13),
		BackgroundTransparency = 1,
		Image = "rbxassetid://132094132649977",
		Parent = menuBg,
	})
	Create("TextLabel", {
		Size = UDim2.new(1, -80, 0, headerH),
		Position = UDim2.new(0, 48, 0, 0),
		BackgroundTransparency = 1,
		Text = "Select Game",
		TextColor3 = Color3.fromRGB(220,220,220),
		Font = Enum.Font.GothamBold,
		TextSize = 14,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextYAlignment = Enum.TextYAlignment.Center,
		Parent = menuBg,
	})

	-- close button
	local menuClose = Create("TextButton", {
		Size = UDim2.new(0, 28, 0, 22),
		Position = UDim2.new(1, -34, 0, headerH/2 - 11),
		BackgroundTransparency = 1,
		Text = "x",
		TextColor3 = Color3.fromRGB(70,70,70),
		Font = Enum.Font.GothamBold,
		TextSize = 12,
		AutoButtonColor = false,
		Parent = menuBg,
	})
	menuClose.MouseEnter:Connect(function() menuClose.TextColor3 = Color3.fromRGB(180,55,55) end)
	menuClose.MouseLeave:Connect(function() menuClose.TextColor3 = Color3.fromRGB(70,70,70) end)
	menuClose.MouseButton1Click:Connect(function() gateGui:Destroy() end)

	-- divider below header
	Create("Frame", {
		Size = UDim2.new(1, -24, 0, 1),
		Position = UDim2.new(0, 12, 0, headerH),
		BackgroundColor3 = Color3.fromRGB(30,30,30),
		BorderSizePixel = 0,
		Parent = menuBg,
	})

	-- search bar
	local searchY = headerH + 10
	local searchBar = Create("TextBox", {
		Size = UDim2.new(1, -24, 0, 30),
		Position = UDim2.new(0, 12, 0, searchY),
		BackgroundColor3 = Color3.fromRGB(16,16,16),
		BorderSizePixel = 0,
		Text = "",
		PlaceholderText = "search games...",
		PlaceholderColor3 = Color3.fromRGB(55,55,55),
		TextColor3 = Color3.fromRGB(200,200,200),
		Font = Enum.Font.Gotham,
		TextSize = 12,
		ClearTextOnFocus = false,
		Parent = menuBg,
	})
	Create("UICorner", { CornerRadius = UDim.new(0, 5), Parent = searchBar })
	Create("UIStroke", { Color = Color3.fromRGB(32,32,32), Thickness = 1, Parent = searchBar })
	Create("UIPadding", { PaddingLeft = UDim.new(0, 10), Parent = searchBar })

	-- scrolling list of games
	local listY = searchY + 38
	local listH = menuH - listY - 10
	local gameList = Create("ScrollingFrame", {
		Size = UDim2.new(1, -24, 0, listH),
		Position = UDim2.new(0, 12, 0, listY),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		ScrollBarThickness = 2,
		ScrollBarImageColor3 = Color3.fromRGB(40,40,40),
		CanvasSize = UDim2.new(0, 0, 0, 0),
		AutomaticCanvasSize = Enum.AutomaticSize.Y,
		Parent = menuBg,
	})
	Create("UIListLayout", { SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 6), Parent = gameList })

	local gameCards = {}

	local function BuildList(filter)
		for _, ch in ipairs(gameList:GetChildren()) do
			if ch:IsA("Frame") or ch:IsA("TextButton") then ch:Destroy() end
		end
		gameCards = {}
		local shown = 0
		for _, g in ipairs(Games) do
			local lname = string.lower(g.name)
			local lsub  = string.lower(g.sub or "")
			local lf    = string.lower(filter or "")
			if lf == "" or lname:find(lf, 1, true) or lsub:find(lf, 1, true) then
				local card = Create("Frame", {
					Size = UDim2.new(1, 0, 0, 52),
					BackgroundColor3 = Color3.fromRGB(16,16,16),
					BorderSizePixel = 0,
					Parent = gameList,
				})
				Create("UICorner", { CornerRadius = UDim.new(0, 6), Parent = card })
				Create("UIStroke", { Color = Color3.fromRGB(28,28,28), Thickness = 1, Parent = card })

				-- game name
				Create("TextLabel", {
					Size = UDim2.new(1, -100, 0, 26),
					Position = UDim2.new(0, 12, 0, 8),
					BackgroundTransparency = 1,
					Text = g.name,
					TextColor3 = Color3.fromRGB(215,215,215),
					Font = Enum.Font.GothamSemibold,
					TextSize = 12,
					TextXAlignment = Enum.TextXAlignment.Left,
					Parent = card,
				})
				-- sub label
				Create("TextLabel", {
					Size = UDim2.new(1, -100, 0, 16),
					Position = UDim2.new(0, 12, 0, 30),
					BackgroundTransparency = 1,
					Text = g.sub or "",
					TextColor3 = Color3.fromRGB(60,60,60),
					Font = Enum.Font.Gotham,
					TextSize = 10,
					TextXAlignment = Enum.TextXAlignment.Left,
					Parent = card,
				})

				-- execute button
				local execBtn = Create("TextButton", {
					Size = UDim2.new(0, 74, 0, 26),
					Position = UDim2.new(1, -82, 0.5, -13),
					BackgroundColor3 = Color3.fromRGB(22,22,22),
					BorderSizePixel = 0,
					Text = "Execute",
					TextColor3 = Color3.fromRGB(180,180,180),
					Font = Enum.Font.GothamSemibold,
					TextSize = 11,
					AutoButtonColor = false,
					Parent = card,
				})
				Create("UICorner", { CornerRadius = UDim.new(0, 5), Parent = execBtn })
				Create("UIStroke", { Color = Color3.fromRGB(40,40,40), Thickness = 1, Parent = execBtn })

				execBtn.MouseEnter:Connect(function()
					Tween(execBtn, { BackgroundColor3 = Color3.fromRGB(32,32,32) }, 0.1)
					execBtn.TextColor3 = Color3.fromRGB(220,220,220)
				end)
				execBtn.MouseLeave:Connect(function()
					Tween(execBtn, { BackgroundColor3 = Color3.fromRGB(22,22,22) }, 0.1)
					execBtn.TextColor3 = Color3.fromRGB(180,180,180)
				end)

				-- hover on card (not button)
				local cardBtn = Create("TextButton", {
					Size = UDim2.new(1, -90, 1, 0),
					BackgroundTransparency = 1,
					Text = "",
					AutoButtonColor = false,
					Parent = card,
				})
				cardBtn.MouseEnter:Connect(function() Tween(card, { BackgroundColor3 = Color3.fromRGB(20,20,20) }, 0.1) end)
				cardBtn.MouseLeave:Connect(function() Tween(card, { BackgroundColor3 = Color3.fromRGB(16,16,16) }, 0.1) end)

				local capturedGame = g
				execBtn.MouseButton1Click:Connect(function()
					task.spawn(LaunchHub, capturedGame)
				end)
				cardBtn.MouseButton1Click:Connect(function()
					task.spawn(LaunchHub, capturedGame)
				end)

				table.insert(gameCards, card)
				shown = shown + 1
			end
		end
		if shown == 0 then
			Create("TextLabel", {
				Size = UDim2.new(1, 0, 0, 30),
				BackgroundTransparency = 1,
				Text = "no games found",
				TextColor3 = Color3.fromRGB(50,50,50),
				Font = Enum.Font.Gotham,
				TextSize = 11,
				Parent = gameList,
			})
		end
	end

	BuildList("")

	searchBar:GetPropertyChangedSignal("Text"):Connect(function()
		BuildList(searchBar.Text)
	end)
end

-- KEY ENTRY SCREEN
local function ShowKeyScreen()
	for _, ch in ipairs(gateGui:GetChildren()) do ch:Destroy() end

	local keyBg = MakeCard(320, 170)

	-- close button
	local keyClose = Create("TextButton", {
		Size = UDim2.new(0, 28, 0, 20),
		Position = UDim2.new(1, -32, 0, 6),
		BackgroundTransparency = 1,
		Text = "x",
		TextColor3 = Color3.fromRGB(80,80,80),
		Font = Enum.Font.GothamBold,
		TextSize = 12,
		AutoButtonColor = false,
		Parent = keyBg,
	})
	keyClose.MouseEnter:Connect(function() keyClose.TextColor3 = Color3.fromRGB(180,60,60) end)
	keyClose.MouseLeave:Connect(function() keyClose.TextColor3 = Color3.fromRGB(80,80,80) end)
	keyClose.MouseButton1Click:Connect(function() gateGui:Destroy() end)

	Create("ImageLabel", {
		Size = UDim2.new(0, 44, 0, 44),
		Position = UDim2.new(0.5, -22, 0, 12),
		BackgroundTransparency = 1,
		Image = "rbxassetid://132094132649977",
		Parent = keyBg,
	})

	local keyBox = Create("TextBox", {
		Size = UDim2.new(0, 240, 0, 32),
		Position = UDim2.new(0.5, -120, 0, 68),
		BackgroundColor3 = Color3.fromRGB(18,18,18),
		BorderSizePixel = 0,
		Text = "",
		PlaceholderText = "key...",
		PlaceholderColor3 = Color3.fromRGB(70,70,70),
		TextColor3 = Color3.fromRGB(220,220,220),
		Font = Enum.Font.Gotham,
		TextSize = 12,
		ClearTextOnFocus = true,
		Parent = keyBg,
	})
	Create("UICorner", { CornerRadius = UDim.new(0, 4), Parent = keyBox })
	Create("UIStroke", { Color = Color3.fromRGB(40,40,40), Thickness = 1, Parent = keyBox })

	local keyStatus = Create("TextLabel", {
		Size = UDim2.new(1, 0, 0, 16),
		Position = UDim2.new(0, 0, 0, 152),
		BackgroundTransparency = 1,
		Text = "",
		TextColor3 = Color3.fromRGB(180,60,60),
		Font = Enum.Font.Gotham,
		TextSize = 10,
		Parent = keyBg,
	})

	local checkBtn = Create("TextButton", {
		Size = UDim2.new(0, 240, 0, 28),
		Position = UDim2.new(0.5, -120, 0, 112),
		BackgroundColor3 = Color3.fromRGB(22,22,22),
		BorderSizePixel = 0,
		Text = "Continue",
		TextColor3 = Color3.fromRGB(200,200,200),
		Font = Enum.Font.GothamSemibold,
		TextSize = 12,
		AutoButtonColor = false,
		Parent = keyBg,
	})
	Create("UICorner", { CornerRadius = UDim.new(0, 4), Parent = checkBtn })
	Create("UIStroke", { Color = Color3.fromRGB(45,45,45), Thickness = 1, Parent = checkBtn })

	checkBtn.MouseEnter:Connect(function() Tween(checkBtn, { BackgroundColor3 = Color3.fromRGB(35,35,35) }, 0.1) end)
	checkBtn.MouseLeave:Connect(function() Tween(checkBtn, { BackgroundColor3 = Color3.fromRGB(22,22,22) }, 0.1) end)

	local function TryKey()
		local input = keyBox.Text:gsub("%s", "")
		if input == KEY then
			_G.BlaizeKeyPassed = true  -- remember so re-runs skip key screen
			checkBtn.Text = "..."
			checkBtn.Active = false
			keyBox.TextEditable = false
			keyStatus.Text = ""
			task.wait(0.8)
			ShowGameMenu()
		else
			keyStatus.Text = "invalid key"
			keyBox.Text = ""
			task.delay(1.5, function()
				if keyStatus and keyStatus.Parent then keyStatus.Text = "" end
			end)
		end
	end

	checkBtn.MouseButton1Click:Connect(TryKey)
	keyBox.FocusLost:Connect(function(enterPressed)
		if enterPressed then TryKey() end
	end)
end

-- KEY SYSTEM: set to true to require a key, false for keyless
local KEY_ENABLED = false

if not KEY_ENABLED or _G.BlaizeKeyPassed then
	ShowGameMenu()
else
	ShowKeyScreen()
end
