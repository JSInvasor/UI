-- DcusUI Series
-- by iksuwu
-- Morten UI

-- New Update
--[[
[+] Keybind
[=] Fix Scroll
[+] Textbox
[+] Window API ( UI Bind )
[+] Setting Manager
[+] Grid Background (by JSInvasor)
[+] Collapsible Sections (by JSInvasor)
[+] Collapsible Sidebar Categories (Flow-style)
]]
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Player = game:GetService("Players").LocalPlayer

-- gethui fallback
local function getGuiParent()
	local success, result = pcall(function()
		if gethui then
			return gethui()
		end
	end)
	if success and result then return result end
	
	local success2, result2 = pcall(function()
		if syn and syn.protect_gui then
			local gui = Player:WaitForChild("PlayerGui")
			syn.protect_gui(gui)
			return gui
		end
	end)
	if success2 and result2 then return result2 end
	
	local success3, result3 = pcall(function()
		return game:GetService("CoreGui")
	end)
	if success3 and result3 then return result3 end
	
	return Player:WaitForChild("PlayerGui")
end

local function Create(class, props, children)
	local obj = Instance.new(class)
	for k,v in pairs(props or {}) do obj[k] = v end
	for _,c in pairs(children or {}) do c.Parent = obj end
	return obj
end

-- Grid Background Function (Simple Square Grid)
local function CreateGridBackground(parent, config)
	config = config or {}
	local gridColor = config.GridColor or Color3.fromRGB(35, 35, 45)
	local lineThickness = config.LineThickness or 1
	local spacing = config.Spacing or 18
	local lineTransparency = config.LineTransparency or 0.5
	
	local gridContainer = Create("Frame", {
		Name = "GridBackground",
		Size = UDim2.fromScale(1, 1),
		BackgroundTransparency = 1,
		ClipsDescendants = true,
		ZIndex = 1,
		Parent = parent
	})
	
	local horizontalLines = math.ceil(400 / spacing) + 1
	for i = 0, horizontalLines do
		Create("Frame", {
			Name = "HLine_" .. i,
			Size = UDim2.new(1, 0, 0, lineThickness),
			Position = UDim2.new(0, 0, 0, i * spacing),
			BackgroundColor3 = gridColor,
			BackgroundTransparency = lineTransparency,
			BorderSizePixel = 0,
			ZIndex = 1,
			Parent = gridContainer
		})
	end
	
	local verticalLines = math.ceil(600 / spacing) + 1
	for i = 0, verticalLines do
		Create("Frame", {
			Name = "VLine_" .. i,
			Size = UDim2.new(0, lineThickness, 1, 0),
			Position = UDim2.new(0, i * spacing, 0, 0),
			BackgroundColor3 = gridColor,
			BackgroundTransparency = lineTransparency,
			BorderSizePixel = 0,
			ZIndex = 1,
			Parent = gridContainer
		})
	end
	
	return gridContainer
end

-- Default section icon (fallback)
local DEFAULT_SECTION_ICON = "rbxassetid://10734930886"

-- Default category icons
local DEFAULT_CATEGORY_ICONS = {
	["Main"] = "rbxassetid://10734930886",
	["Combat"] = "rbxassetid://10734930886",
	["Player"] = "rbxassetid://10734930886",
	["Misc"] = "rbxassetid://10734930886",
}

local Library = {}
Library.__index = Library
Library.ToggleKey = Enum.KeyCode.RightControl

function Library.SettingManager()
	local Manager = {}
	function Manager:AddToTab(tab)
		tab:Paragraph({
			Title = "UI Settings",
			Content = "Manage the interface settings and keybindings here."
		})

		tab:Keybind({
			Name = "UI Toggle Key",
			Default = Library.ToggleKey,
			OnChange = function(New)
				Library.ToggleKey = New
			end
		})

		tab:Button({
			Name = "Unload UI",
			Callback = function()
				local core = getGuiParent()
				local gui = core:FindFirstChild("DcusHub_v2.3 UI") or Player.PlayerGui:FindFirstChild("DcusHub_v2.3 UI")
				if gui then gui:Destroy() end
			end
		})
	end
	return Manager
end

function Library:New(config)
	local self = setmetatable({}, Library)

	self.Gui = Create("ScreenGui", {
		Name = "DcusHub_v2.3 UI",
		ResetOnSpawn = false,
		Parent = getGuiParent()
	})

	self.Main = Create("Frame", {
		Size = UDim2.fromOffset(550, 380),
		Position = UDim2.fromScale(0.5, 0.5),
		AnchorPoint = Vector2.new(0.5, 0.5),
		BackgroundColor3 = Color3.fromRGB(15, 15, 20),
		BorderSizePixel = 0,
		ClipsDescendants = true,
		Parent = self.Gui
	}, {
		Create("UICorner", {CornerRadius = UDim.new(0, 12)}),
		Create("UIStroke", {Color = Color3.fromRGB(45, 45, 60), Thickness = 1.5})
	})

	local gridConfig = config.Grid or {}
	CreateGridBackground(self.Main, {
		GridColor = gridConfig.Color or Color3.fromRGB(35, 35, 45),
		LineThickness = gridConfig.Thickness or 1,
		Spacing = gridConfig.Spacing or 18,
		LineTransparency = gridConfig.Transparency or 0.5
	})

	self.Top = Create("Frame", {
		Size = UDim2.new(1, 0, 0, 55),
		BackgroundColor3 = Color3.fromRGB(20, 20, 28),
		BackgroundTransparency = 0.3,
		ZIndex = 2,
		Parent = self.Main
	}, {
		Create("UICorner", {CornerRadius = UDim.new(0, 12)}),
		Create("Frame", {
			Size = UDim2.new(1, 0, 0, 1),
			Position = UDim2.new(0, 0, 1, -1),
			BackgroundColor3 = Color3.fromRGB(60, 60, 80),
			BackgroundTransparency = 0.5,
			BorderSizePixel = 0,
		})
	})

	-- macOS Style Buttons
	local buttonContainer = Create("Frame", {
		Size = UDim2.fromOffset(70, 20),
		Position = UDim2.new(1, -80, 0, 17),
		BackgroundTransparency = 1,
		ZIndex = 10,
		Parent = self.Top
	})

	local closeBtn = Create("TextButton", {
		Size = UDim2.fromOffset(14, 14),
		Position = UDim2.fromOffset(0, 3),
		BackgroundColor3 = Color3.fromRGB(255, 95, 87),
		Text = "",
		ZIndex = 11,
		Parent = buttonContainer
	}, {
		Create("UICorner", {CornerRadius = UDim.new(1, 0)}),
		Create("UIStroke", {Color = Color3.fromRGB(200, 70, 60), Thickness = 1})
	})

	local minimizeBtn = Create("TextButton", {
		Size = UDim2.fromOffset(14, 14),
		Position = UDim2.fromOffset(22, 3),
		BackgroundColor3 = Color3.fromRGB(255, 189, 46),
		Text = "",
		ZIndex = 11,
		Parent = buttonContainer
	}, {
		Create("UICorner", {CornerRadius = UDim.new(1, 0)}),
		Create("UIStroke", {Color = Color3.fromRGB(200, 150, 30), Thickness = 1})
	})

	local maximizeBtn = Create("TextButton", {
		Size = UDim2.fromOffset(14, 14),
		Position = UDim2.fromOffset(44, 3),
		BackgroundColor3 = Color3.fromRGB(40, 205, 65),
		Text = "",
		ZIndex = 11,
		Parent = buttonContainer
	}, {
		Create("UICorner", {CornerRadius = UDim.new(1, 0)}),
		Create("UIStroke", {Color = Color3.fromRGB(30, 160, 50), Thickness = 1})
	})

	closeBtn.MouseButton1Click:Connect(function()
		self.Gui:Destroy()
	end)

	local IsMinimized = false
	minimizeBtn.MouseButton1Click:Connect(function()
		IsMinimized = not IsMinimized
		local targetSize = IsMinimized and UDim2.fromOffset(550, 55) or UDim2.fromOffset(550, 380)
		TweenService:Create(self.Main, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
			Size = targetSize
		}):Play()
		self.Container.Visible = not IsMinimized
	end)

	local IsMaximized = false
	local originalSize = UDim2.fromOffset(550, 380)
	local originalPosition = UDim2.fromScale(0.5, 0.5)
	maximizeBtn.MouseButton1Click:Connect(function()
		IsMaximized = not IsMaximized
		if IsMaximized then
			TweenService:Create(self.Main, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
				Size = UDim2.fromScale(0.9, 0.9),
				Position = UDim2.fromScale(0.5, 0.5)
			}):Play()
		else
			TweenService:Create(self.Main, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
				Size = originalSize,
				Position = originalPosition
			}):Play()
		end
	end)

	local titleOffset = 18
	if config.Image then
		local Logo = Create("ImageLabel", {
			Size = UDim2.fromOffset(32, 32),
			Position = UDim2.fromOffset(12, 11),
			BackgroundTransparency = 1,
			Image = config.Image,
			ScaleType = Enum.ScaleType.Fit,
			ZIndex = 3,
			Parent = self.Top
		}, {
			Create("UICorner", {CornerRadius = UDim.new(0, 6)})
		})
		titleOffset = 52
	end

	Create("TextLabel", {
		Text = config.Title or "Dcus Hub",
		Font = Enum.Font.GothamBold,
		TextSize = 18,
		TextColor3 = Color3.fromRGB(255, 255, 255),
		TextXAlignment = "Left",
		BackgroundTransparency = 1,
		Position = UDim2.fromOffset(titleOffset, 8),
		Size = UDim2.new(0, 200, 0, 30),
		ZIndex = 3,
		Parent = self.Top
	})

	Create("TextLabel", {
		Text = config.Footer or "Premium Interface • v2.3",
		Font = Enum.Font.GothamMedium,
		TextSize = 11,
		TextColor3 = Color3.fromRGB(100, 100, 130),
		TextXAlignment = "Left",
		BackgroundTransparency = 1,
		Size = UDim2.new(0, 200, 0, 20),
		Position = UDim2.fromOffset(titleOffset, 28),
		ZIndex = 3,
		Parent = self.Top
	})

	local IsOpen = true

	self.Container = Create("Frame", {
		Size = UDim2.new(1, 0, 1, -55),
		Position = UDim2.fromOffset(0, 55),
		BackgroundTransparency = 1,
		ClipsDescendants = true,
		Visible = true,
		ZIndex = 2,
		Parent = self.Main
	})

	self.Sidebar = Create("Frame", {
		Size = UDim2.new(0, 150, 1, -16),
		Position = UDim2.fromOffset(10, 8),
		BackgroundColor3 = Color3.fromRGB(20, 20, 28),
		ZIndex = 3,
		Parent = self.Container
	}, {
		Create("UICorner", {CornerRadius = UDim.new(0, 10)}),
		Create("UIStroke", {Color = Color3.fromRGB(45, 45, 60), Thickness = 1}),
	})

	-- Scrollable sidebar content
	self.SidebarScroll = Create("ScrollingFrame", {
		Size = UDim2.new(1, 0, 1, 0),
		BackgroundTransparency = 1,
		ScrollBarThickness = 0,
		CanvasSize = UDim2.new(0, 0, 0, 0),
		ScrollingDirection = Enum.ScrollingDirection.Y,
		ZIndex = 5,
		Parent = self.Sidebar
	})

	self.TabHolder = Create("Frame", {
		Size = UDim2.new(1, 0, 0, 0), -- Auto-sized
		BackgroundTransparency = 1,
		ZIndex = 5,
		Parent = self.SidebarScroll
	}, {
		Create("UIListLayout", {Padding = UDim.new(0, 2), SortOrder = Enum.SortOrder.LayoutOrder}),
		Create("UIPadding", {PaddingTop = UDim.new(0, 8), PaddingLeft = UDim.new(0, 8), PaddingRight = UDim.new(0, 8)})
	})

	-- Auto-size sidebar scroll canvas
	local sidebarLayout = self.TabHolder:FindFirstChildOfClass("UIListLayout")
	local function UpdateSidebarCanvas()
		self.SidebarScroll.CanvasSize = UDim2.new(0, 0, 0, sidebarLayout.AbsoluteContentSize.Y + 16)
	end
	sidebarLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(UpdateSidebarCanvas)
	task.spawn(UpdateSidebarCanvas)

	self.Pages = Create("Frame", {
		Size = UDim2.new(1, -180, 1, -16),
		Position = UDim2.fromOffset(170, 8),
		BackgroundTransparency = 1,
		ZIndex = 3,
		Parent = self.Container
	})

	-- Store active tab info for highlighting
	self._activeTabBtn = nil
	self._activeTabDot = nil

	-- Dragging
	do
		local dragging, dragInput, dragStart, startPos
		local function update(input)
			local delta = input.Position - dragStart
			self.Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
		end

		self.Top.InputBegan:Connect(function(input)
			if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
				dragging = true
				dragStart = input.Position
				startPos = self.Main.Position
				input.Changed:Connect(function()
					if input.UserInputState == Enum.UserInputState.End then
						dragging = false
					end
				end)
			end
		end)

		UIS.InputChanged:Connect(function(input)
			if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
				update(input)
			end
		end)
	end

	UIS.InputBegan:Connect(function(input, gpe)
		if not gpe and input.KeyCode == Library.ToggleKey then
			self.Open = not self.Open
			self.Main.Visible = self.Open
		end
	end)

	-- Notify
	function Library:Notify(config)
		local title = config.Title or "Notification"
		local content = config.Content or "Notification Content"
		local duration = config.Time or 5
		local NotifGui = getGuiParent():FindFirstChild("DcusNotifications")
		if not NotifGui then
			NotifGui = Create("ScreenGui", {
				Name = "DcusNotifications",
				Parent = getGuiParent(),
				ZIndexBehavior = Enum.ZIndexBehavior.Sibling
			})
		end

		local Holder = NotifGui:FindFirstChild("NotifHolder")
		if not Holder then
			Holder = Create("Frame", {
				Name = "NotifHolder",
				Parent = NotifGui,
				Size = UDim2.new(0, 260, 1, -20),
				Position = UDim2.new(1, -270, 0, 10),
				BackgroundTransparency = 1
			}, {
				Create("UIListLayout", {
					VerticalAlignment = "Top",
					HorizontalAlignment = "Right",
					Padding = UDim.new(0, 10)
				})
			})
		end

		local Notif = Create("Frame", {
			Size = UDim2.new(1, 0, 0, 20),
			BackgroundColor3 = Color3.fromRGB(20, 20, 28),
			BackgroundTransparency = 1,
			Parent = Holder
		}, {
			Create("UICorner", {CornerRadius = UDim.new(0, 8)}),
			Create("UIStroke", {Color = Color3.fromRGB(80, 150, 255), Thickness = 1.2, Transparency = 1})
		})

		local TitleLabel = Create("TextLabel", {
			Text = title:upper(),
			Font = Enum.Font.GothamBold,
			TextSize = 12,
			TextColor3 = Color3.fromRGB(80, 150, 255),
			BackgroundTransparency = 1,
			TextTransparency = 1,
			Position = UDim2.fromOffset(12, 8),
			Size = UDim2.new(1, -24, 0, 15),
			TextXAlignment = "Left",
			Parent = Notif
		})

		local Divider = Create("Frame", {
			Size = UDim2.new(1, -24, 0, 1),
			Position = UDim2.fromOffset(12, 26),
			BackgroundColor3 = Color3.fromRGB(45, 45, 60),
			BorderSizePixel = 0,
			BackgroundTransparency = 1,
			Parent = Notif
		})

		local ContentLabel = Create("TextLabel", {
			Text = content,
			Font = Enum.Font.GothamMedium,
			TextSize = 12,
			TextColor3 = Color3.fromRGB(180, 180, 200),
			BackgroundTransparency = 1,
			TextTransparency = 1,
			Position = UDim2.fromOffset(12, 32),
			Size = UDim2.new(1, -24, 0, 0),
			TextXAlignment = "Left",
			TextYAlignment = "Top",
			TextWrapped = true,
			Parent = Notif
		})

		local ts = game:GetService("TextService"):GetTextSize(content, 12, Enum.Font.GothamMedium, Vector2.new(236, 10000))
		local targetSizeY = ts.Y + 45
		Notif.Position = UDim2.new(1, 50, 0, 0)

		local showTween = TweenService:Create(Notif, TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
			BackgroundTransparency = 0,
			Size = UDim2.new(1, 0, 0, targetSizeY)
		})

		TweenService:Create(Notif.UIStroke, TweenInfo.new(0.5), {Transparency = 0}):Play()
		TweenService:Create(TitleLabel, TweenInfo.new(0.5), {TextTransparency = 0}):Play()
		TweenService:Create(Divider, TweenInfo.new(0.5), {BackgroundTransparency = 0}):Play()
		TweenService:Create(ContentLabel, TweenInfo.new(0.5), {TextTransparency = 0}):Play()

		showTween:Play()
		task.delay(duration, function()
			local hideTween = TweenService:Create(Notif, TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {
				BackgroundTransparency = 1,
				Size = UDim2.new(1, 0, 0, 0)
			})

			TweenService:Create(Notif.UIStroke, TweenInfo.new(0.5), {Transparency = 1}):Play()
			TweenService:Create(TitleLabel, TweenInfo.new(0.5), {TextTransparency = 1}):Play()
			TweenService:Create(Divider, TweenInfo.new(0.5), {BackgroundTransparency = 1}):Play()
			TweenService:Create(ContentLabel, TweenInfo.new(0.5), {TextTransparency = 1}):Play()

			hideTween:Play()
			hideTween.Completed:Connect(function()
				Notif:Destroy()
			end)
		end)
	end

	-- ============================================
	-- Helper: Creates standard UI elements for a given parent container
	-- ============================================
	local function CreateElementMethods(target, parentFrame, updateCanvasFunc)

		function target:Button(config)
			local text = config.Name or config.Text or "Button"
			local callback = config.Callback or function() end

			local BtnBg = Create("Frame", {
				Size = UDim2.new(1, 0, 0, 45),
				BackgroundColor3 = Color3.fromRGB(22, 22, 30),
				ZIndex = 5,
				Parent = parentFrame
			}, {
				Create("UICorner", {CornerRadius = UDim.new(0, 8)}),
				Create("UIStroke", {Color = Color3.fromRGB(45, 45, 60), Thickness = 1})
			})

			Create("TextLabel", {
				Text = text,
				Font = Enum.Font.GothamMedium,
				TextSize = 14,
				TextColor3 = Color3.fromRGB(170, 170, 195),
				BackgroundTransparency = 1,
				Position = UDim2.fromOffset(15, 0),
				Size = UDim2.new(1, -100, 1, 0),
				TextXAlignment = "Left",
				ZIndex = 6,
				Parent = BtnBg
			})

			local RunBadge = Create("Frame", {
				Size = UDim2.fromOffset(45, 22),
				Position = UDim2.new(1, -55, 0.5, -11),
				BackgroundColor3 = Color3.fromRGB(40, 40, 55),
				ZIndex = 6,
				Parent = BtnBg
			}, {
				Create("UICorner", {CornerRadius = UDim.new(0, 6)}),
				Create("UIStroke", {Color = Color3.fromRGB(60, 60, 80), Thickness = 1}),
				Create("TextLabel", {
					Text = "Run",
					Font = Enum.Font.GothamBold,
					TextSize = 11,
					TextColor3 = Color3.fromRGB(255, 255, 255),
					BackgroundTransparency = 1,
					Size = UDim2.fromScale(1, 1),
					ZIndex = 7,
				})
			})
			RunBadge:FindFirstChild("TextLabel").Parent = RunBadge

			local Hit = Create("TextButton", {Text = "", BackgroundTransparency = 1, Size = UDim2.fromScale(1, 1), ZIndex = 10, Parent = BtnBg})
			Hit.MouseButton1Down:Connect(function()
				TweenService:Create(BtnBg, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(28, 32, 50)}):Play()
				TweenService:Create(RunBadge, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(80, 150, 255)}):Play()
			end)
			Hit.MouseButton1Up:Connect(function()
				TweenService:Create(BtnBg, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(22, 22, 30)}):Play()
				TweenService:Create(RunBadge, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(40, 40, 55)}):Play()
				callback()
			end)
		end

		function target:Toggle(config)
			local text = config.Name or "Toggle"
			local callback = config.Callback or function() end
			local state = config.Default or false

			local TglBg = Create("Frame", {
				Size = UDim2.new(1, 0, 0, 45),
				BackgroundColor3 = Color3.fromRGB(22, 22, 30),
				ZIndex = 5,
				Parent = parentFrame
			}, {
				Create("UICorner", {CornerRadius = UDim.new(0, 8)}),
				Create("UIStroke", {Color = Color3.fromRGB(45, 45, 60), Thickness = 1})
			})

			Create("TextLabel", {
				Text = text,
				Font = Enum.Font.GothamMedium,
				TextSize = 14,
				TextColor3 = Color3.fromRGB(170, 170, 195),
				BackgroundTransparency = 1,
				Position = UDim2.fromOffset(15, 0),
				Size = UDim2.new(1, -70, 1, 0),
				TextXAlignment = "Left",
				ZIndex = 6,
				Parent = TglBg
			})

			local Switch = Create("Frame", {
				Size = UDim2.fromOffset(40, 20),
				Position = UDim2.new(1, -50, 0.5, -10),
				BackgroundColor3 = state and Color3.fromRGB(80, 150, 255) or Color3.fromRGB(40, 40, 55),
				ZIndex = 6,
				Parent = TglBg
			}, {
				Create("UICorner", {CornerRadius = UDim.new(1, 0)}),
				Create("UIStroke", {Color = Color3.fromRGB(60, 60, 80), Thickness = 1})
			})

			local Knob = Create("Frame", {
				Size = UDim2.fromOffset(16, 16),
				Position = state and UDim2.fromOffset(22, 2) or UDim2.fromOffset(2, 2),
				BackgroundColor3 = Color3.new(1, 1, 1),
				ZIndex = 7,
				Parent = Switch
			}, { Create("UICorner", {CornerRadius = UDim.new(1, 0)}) })

			local function updateView(val)
				TweenService:Create(Switch, TweenInfo.new(0.2), {
					BackgroundColor3 = val and Color3.fromRGB(80, 150, 255) or Color3.fromRGB(40, 40, 55)
				}):Play()
				TweenService:Create(Knob, TweenInfo.new(0.2), {
					Position = val and UDim2.fromOffset(22, 2) or UDim2.fromOffset(2, 2)
				}):Play()
			end

			local Hit = Create("TextButton", {Text = "", BackgroundTransparency = 1, Size = UDim2.fromScale(1, 1), ZIndex = 10, Parent = TglBg})

			Hit.MouseButton1Click:Connect(function()
				state = not state
				updateView(state)
				callback(state)
			end)

			local ToggleFunctions = {}
			function ToggleFunctions:SetValue(val)
				state = val
				updateView(state)
				callback(state)
			end
			return ToggleFunctions
		end

		function target:Slider(config)
			local text = config.Name or "Slider"
			local min = config.Min or 0
			local max = config.Max or 100
			local default = config.Default or min
			local rounding = config.Rounding or 0
			local callback = config.Callback or function() end

			local SliderBg = Create("Frame", {
				Size = UDim2.new(1, 0, 0, 50),
				BackgroundColor3 = Color3.fromRGB(22, 22, 30),
				ZIndex = 5,
				Parent = parentFrame
			}, {
				Create("UICorner", {CornerRadius = UDim.new(0, 8)}),
				Create("UIStroke", {Color = Color3.fromRGB(45, 45, 60), Thickness = 1})
			})

			Create("TextLabel", {
				Text = text,
				Font = Enum.Font.GothamMedium,
				TextSize = 14,
				TextColor3 = Color3.fromRGB(170, 170, 195),
				BackgroundTransparency = 1,
				Position = UDim2.fromOffset(15, 8),
				Size = UDim2.new(1, -100, 0, 20),
				TextXAlignment = "Left",
				ZIndex = 6,
				Parent = SliderBg
			})

			local ValueLabel = Create("TextLabel", {
				Text = tostring(default),
				Font = Enum.Font.GothamBold,
				TextSize = 13,
				TextColor3 = Color3.fromRGB(80, 150, 255),
				BackgroundTransparency = 1,
				Position = UDim2.new(1, -65, 0, 8),
				Size = UDim2.new(0, 50, 0, 20),
				TextXAlignment = "Right",
				ZIndex = 6,
				Parent = SliderBg
			})

			local Tray = Create("Frame", {
				Size = UDim2.new(1, -30, 0, 4),
				Position = UDim2.new(0, 15, 1, -12),
				BackgroundColor3 = Color3.fromRGB(40, 40, 55),
				ZIndex = 6,
				Parent = SliderBg
			}, { Create("UICorner", {CornerRadius = UDim.new(1, 0)}) })

			local Fill = Create("Frame", {
				Size = UDim2.fromScale((default - min) / (max - min), 1),
				BackgroundColor3 = Color3.fromRGB(80, 150, 255),
				ZIndex = 7,
				Parent = Tray
			}, { Create("UICorner", {CornerRadius = UDim.new(1, 0)}) })

			local SliderKnob = Create("Frame", {
				Size = UDim2.fromOffset(8, 8),
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.fromScale((default - min) / (max - min), 0.5),
				BackgroundColor3 = Color3.fromRGB(22, 22, 30),
				ZIndex = 8,
				Parent = Tray
			}, {
				Create("UICorner", {CornerRadius = UDim.new(0, 4)}),
				Create("UIStroke", {Color = Color3.fromRGB(80, 150, 255), Thickness = 1.5})
			})

			local function Update(input)
				local pos = math.clamp((input.Position.X - Tray.AbsolutePosition.X) / Tray.AbsoluteSize.X, 0, 1)
				local rawVal = min + (max - min) * pos
				local val = rounding == 1 and (math.floor(rawVal * 10) / 10) or math.floor(rawVal)
				ValueLabel.Text = tostring(val)
				TweenService:Create(Fill, TweenInfo.new(0.1), {Size = UDim2.fromScale(pos, 1)}):Play()
				TweenService:Create(SliderKnob, TweenInfo.new(0.1), {Position = UDim2.fromScale(pos, 0.5)}):Play()
				callback(val)
			end

			local sdragging = false
			SliderBg.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then sdragging = true; Update(i) end end)
			UIS.InputChanged:Connect(function(i) if sdragging and i.UserInputType == Enum.UserInputType.MouseMovement then Update(i) end end)
			UIS.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then sdragging = false end end)
		end

		function target:Dropdown(config)
			local text = config.Name or "Dropdown"
			local list = config.List or {}
			local default = config.Default
			local callback = config.Callback or function() end

			local expanded = false
			local DropdownBg = Create("Frame", {
				Size = UDim2.new(1, 0, 0, 45),
				BackgroundColor3 = Color3.fromRGB(22, 22, 30),
				ClipsDescendants = true,
				ZIndex = 5,
				Parent = parentFrame
			}, {
				Create("UICorner", {CornerRadius = UDim.new(0, 8)}),
				Create("UIStroke", {Color = Color3.fromRGB(45, 45, 60), Thickness = 1})
			})

			local Header = Create("TextButton", {
				Size = UDim2.new(1, 0, 0, 45),
				BackgroundTransparency = 1,
				Text = "",
				ZIndex = 6,
				Parent = DropdownBg
			})

			local TitleLabel = Create("TextLabel", {
				Text = text,
				Font = Enum.Font.GothamMedium,
				TextSize = 14,
				TextColor3 = Color3.fromRGB(170, 170, 195),
				BackgroundTransparency = 1,
				Position = UDim2.fromOffset(15, 0),
				Size = UDim2.new(1, -50, 1, 0),
				TextXAlignment = "Left",
				ZIndex = 7,
				Parent = Header
			})

			local Arrow = Create("TextLabel", {
				Text = "▼",
				Font = Enum.Font.GothamBold,
				TextSize = 12,
				TextColor3 = Color3.fromRGB(100, 100, 130),
				BackgroundTransparency = 1,
				Position = UDim2.new(1, -35, 0, 0),
				Size = UDim2.new(0, 25, 1, 0),
				ZIndex = 7,
				Parent = Header
			})

			local DDContent = Create("Frame", {
				Size = UDim2.new(1, -20, 0, #list * 32),
				Position = UDim2.fromOffset(10, 45),
				BackgroundTransparency = 1,
				ZIndex = 6,
				Parent = DropdownBg
			})

			local DropHighlight = Create("Frame", {
				Size = UDim2.new(1, 0, 0, 30),
				BackgroundColor3 = Color3.fromRGB(80, 150, 255),
				BackgroundTransparency = 0.85,
				Visible = false,
				ZIndex = 7,
				Parent = DDContent
			}, {
				Create("UICorner", {CornerRadius = UDim.new(0, 6)}),
				Create("UIStroke", {Color = Color3.fromRGB(80, 150, 255), Thickness = 1, Transparency = 0.5})
			})

			local OptionHolder = Create("Frame", {
				Size = UDim2.fromScale(1, 1),
				BackgroundTransparency = 1,
				ZIndex = 8,
				Parent = DDContent
			})

			Create("UIListLayout", {
				Padding = UDim.new(0, 2),
				SortOrder = Enum.SortOrder.LayoutOrder,
				Parent = OptionHolder
			})

			local function Select(v, btn)
				DropHighlight.Visible = true
				local targetY = btn.AbsolutePosition.Y - DDContent.AbsolutePosition.Y
				TweenService:Create(DropHighlight, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
					Position = UDim2.fromOffset(0, targetY)
				}):Play()
				for _, o in pairs(OptionHolder:GetChildren()) do
					if o:IsA("TextButton") then
						TweenService:Create(o, TweenInfo.new(0.2), {TextColor3 = Color3.fromRGB(150, 150, 170)}):Play()
					end
				end
				TweenService:Create(btn, TweenInfo.new(0.2), {TextColor3 = Color3.fromRGB(255, 255, 255)}):Play()
				TitleLabel.Text = text .. " : " .. v
				callback(v)
			end

			for i, v in pairs(list) do
				local Opt = Create("TextButton", {
					Text = v,
					Font = Enum.Font.GothamMedium,
					TextSize = 13,
					TextColor3 = Color3.fromRGB(150, 150, 170),
					Size = UDim2.new(1, 0, 0, 30),
					BackgroundTransparency = 1,
					LayoutOrder = i,
					ZIndex = 9,
					Parent = OptionHolder
				})
				Opt.MouseButton1Click:Connect(function() Select(v, Opt) end)
				if default and v == default then
					task.spawn(function()
						repeat task.wait() until Opt.AbsolutePosition.Y > 0
						Select(v, Opt)
					end)
				end
			end

			Header.MouseButton1Click:Connect(function()
				expanded = not expanded
				TweenService:Create(DropdownBg, TweenInfo.new(0.4, Enum.EasingStyle.Quart), {
					Size = UDim2.new(1, 0, 0, expanded and (45 + #list * 32 + 10) or 45)
				}):Play()
				TweenService:Create(Arrow, TweenInfo.new(0.4), {Rotation = expanded and 180 or 0}):Play()
			end)
		end

		function target:Label(config)
			local text = config.Text or "Label"

			local LabelBg = Create("Frame", {
				Size = UDim2.new(1, 0, 0, 30),
				BackgroundColor3 = Color3.fromRGB(22, 22, 30),
				BackgroundTransparency = 0.5,
				ZIndex = 5,
				Parent = parentFrame
			}, {
				Create("UICorner", {CornerRadius = UDim.new(0, 8)}),
				Create("UIStroke", {Color = Color3.fromRGB(45, 45, 60), Thickness = 1, Transparency = 0.5})
			})

			local Text = Create("TextLabel", {
				Text = text,
				Font = Enum.Font.GothamMedium,
				TextSize = 13,
				TextColor3 = Color3.fromRGB(180, 180, 200),
				BackgroundTransparency = 1,
				Position = UDim2.fromOffset(15, 8),
				Size = UDim2.new(1, -30, 0, 0),
				TextXAlignment = "Left",
				TextYAlignment = "Center",
				TextWrapped = true,
				ZIndex = 6,
				Parent = LabelBg
			})

			local function Resize()
				local ts = game:GetService("TextService"):GetTextSize(
					Text.Text, Text.TextSize, Text.Font, Vector2.new(Text.AbsoluteSize.X, 10000)
				)
				LabelBg.Size = UDim2.new(1, 0, 0, ts.Y + 16)
				Text.Size = UDim2.new(1, -30, 0, ts.Y)
			end
			Text:GetPropertyChangedSignal("AbsoluteSize"):Connect(Resize)
			task.spawn(Resize)
		end

		function target:Paragraph(config)
			local title = config.Title or "Paragraph Title"
			local content = config.Content or "Content description goes here."

			local SectionBg = Create("Frame", {
				Size = UDim2.new(1, 0, 0, 65),
				BackgroundColor3 = Color3.fromRGB(22, 22, 30),
				ZIndex = 5,
				Parent = parentFrame
			}, {
				Create("UICorner", {CornerRadius = UDim.new(0, 8)}),
				Create("UIStroke", {Color = Color3.fromRGB(45, 45, 60), Thickness = 1})
			})

			Create("TextLabel", {
				Text = title:upper(),
				Font = Enum.Font.GothamBold,
				TextSize = 12,
				TextColor3 = Color3.fromRGB(80, 150, 255),
				BackgroundTransparency = 1,
				Position = UDim2.fromOffset(15, 8),
				Size = UDim2.new(1, -30, 0, 20),
				TextXAlignment = "Left",
				ZIndex = 6,
				Parent = SectionBg
			})

			Create("Frame", {
				Size = UDim2.new(1, -30, 0, 1),
				Position = UDim2.fromOffset(15, 30),
				BackgroundColor3 = Color3.fromRGB(45, 45, 60),
				BorderSizePixel = 0,
				ZIndex = 6,
				Parent = SectionBg
			})

			local Desc = Create("TextLabel", {
				Text = content,
				Font = Enum.Font.GothamMedium,
				TextSize = 13,
				TextColor3 = Color3.fromRGB(150, 150, 170),
				BackgroundTransparency = 1,
				Position = UDim2.fromOffset(15, 38),
				Size = UDim2.new(1, -30, 0, 0),
				TextXAlignment = "Left",
				TextYAlignment = "Top",
				TextWrapped = true,
				ZIndex = 6,
				Parent = SectionBg
			})

			local function Resize()
				local ts = game:GetService("TextService"):GetTextSize(
					Desc.Text, Desc.TextSize, Desc.Font, Vector2.new(Desc.AbsoluteSize.X, 10000)
				)
				SectionBg.Size = UDim2.new(1, 0, 0, ts.Y + 50)
				Desc.Size = UDim2.new(1, -30, 0, ts.Y)
			end
			Desc:GetPropertyChangedSignal("AbsoluteSize"):Connect(Resize)
			task.spawn(Resize)
		end

		function target:Keybind(config)
			local text = config.Name or "Keybind"
			local default = config.Default or Enum.KeyCode.E
			local callback = config.Callback or function() end
			local onChange = config.OnChange or function() end
			local listening = false

			local BindBg = Create("Frame", {
				Size = UDim2.new(1, 0, 0, 40),
				BackgroundColor3 = Color3.fromRGB(22, 22, 30),
				ZIndex = 5,
				Parent = parentFrame
			}, {
				Create("UICorner", {CornerRadius = UDim.new(0, 8)}),
				Create("UIStroke", {Color = Color3.fromRGB(45, 45, 60), Thickness = 1})
			})

			Create("TextLabel", {
				Text = text,
				Font = Enum.Font.GothamMedium,
				TextSize = 13,
				TextColor3 = Color3.fromRGB(170, 170, 195),
				BackgroundTransparency = 1,
				Position = UDim2.fromOffset(15, 0),
				Size = UDim2.new(1, -85, 1, 0),
				TextXAlignment = "Left",
				ZIndex = 6,
				Parent = BindBg
			})

			local BindDisplay = Create("Frame", {
				Size = UDim2.fromOffset(60, 24),
				Position = UDim2.new(1, -75, 0.5, -12),
				BackgroundColor3 = Color3.fromRGB(30, 30, 40),
				ZIndex = 6,
				Parent = BindBg
			}, {
				Create("UICorner", {CornerRadius = UDim.new(0, 6)}),
				Create("UIStroke", {Color = Color3.fromRGB(60, 60, 80), Thickness = 1})
			})

			local BindText = Create("TextLabel", {
				Text = default.Name,
				Font = Enum.Font.GothamBold,
				TextSize = 11,
				TextColor3 = Color3.fromRGB(255, 255, 255),
				BackgroundTransparency = 1,
				Size = UDim2.fromScale(1, 1),
				ZIndex = 7,
				Parent = BindDisplay
			})

			local Hit = Create("TextButton", {Text = "", BackgroundTransparency = 1, Size = UDim2.fromScale(1, 1), ZIndex = 10, Parent = BindBg})

			Hit.MouseButton1Click:Connect(function()
				listening = true
				BindText.Text = "..."
				TweenService:Create(BindDisplay:FindFirstChildOfClass("UIStroke"), TweenInfo.new(0.2), {Color = Color3.fromRGB(80, 150, 255)}):Play()
			end)

			UIS.InputBegan:Connect(function(input, gpe)
				if gpe then return end
				if listening and input.UserInputType == Enum.UserInputType.Keyboard then
					listening = false
					default = input.KeyCode
					BindText.Text = input.KeyCode.Name
					TweenService:Create(BindDisplay:FindFirstChildOfClass("UIStroke"), TweenInfo.new(0.2), {Color = Color3.fromRGB(60, 60, 80)}):Play()
					onChange(input.KeyCode)
				elseif not listening and input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode == default then
					local t = TweenService:Create(BindDisplay, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(80, 150, 255)})
					t:Play()
					t.Completed:Connect(function()
						TweenService:Create(BindDisplay, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(30, 30, 40)}):Play()
					end)
					callback()
				end
			end)
		end

		function target:Textbox(config)
			local text = config.Name or "Textbox"
			local placeholder = config.Placeholder or "Enter..."
			local callback = config.Callback or function() end

			local BoxBg = Create("Frame", {
				Size = UDim2.new(1, 0, 0, 40),
				BackgroundColor3 = Color3.fromRGB(22, 22, 30),
				ZIndex = 5,
				Parent = parentFrame
			}, {
				Create("UICorner", {CornerRadius = UDim.new(0, 8)}),
				Create("UIStroke", {Color = Color3.fromRGB(45, 45, 60), Thickness = 1})
			})

			Create("TextLabel", {
				Text = text,
				Font = Enum.Font.GothamMedium,
				TextSize = 13,
				TextColor3 = Color3.fromRGB(170, 170, 195),
				BackgroundTransparency = 1,
				Position = UDim2.fromOffset(15, 0),
				Size = UDim2.new(1, -80, 1, 0),
				TextXAlignment = "Left",
				ZIndex = 6,
				Parent = BoxBg
			})

			local InputHolder = Create("Frame", {
				Size = UDim2.new(0, 60, 0, 26),
				Position = UDim2.new(1, -75, 0.5, -13),
				BackgroundColor3 = Color3.fromRGB(15, 15, 20),
				ClipsDescendants = true,
				ZIndex = 6,
				Parent = BoxBg
			}, {
				Create("UICorner", {CornerRadius = UDim.new(0, 6)}),
				Create("UIStroke", {Color = Color3.fromRGB(50, 50, 70), Thickness = 1})
			})

			local Input = Create("TextBox", {
				Text = "",
				PlaceholderText = placeholder,
				Font = Enum.Font.GothamMedium,
				TextSize = 11,
				TextColor3 = Color3.fromRGB(255, 255, 255),
				BackgroundTransparency = 1,
				Size = UDim2.new(1, -10, 1, 0),
				Position = UDim2.fromOffset(5, 0),
				TextXAlignment = "Center",
				ZIndex = 7,
				Parent = InputHolder
			})

			local Label = BoxBg:FindFirstChild("TextLabel")

			Input.Focused:Connect(function()
				TweenService:Create(InputHolder, TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
					Size = UDim2.new(0, 180, 0, 26),
					Position = UDim2.new(1, -195, 0.5, -13)
				}):Play()
				TweenService:Create(InputHolder:FindFirstChildOfClass("UIStroke"), TweenInfo.new(0.4), {Color = Color3.fromRGB(80, 150, 255)}):Play()
				if Label then
					TweenService:Create(Label, TweenInfo.new(0.4), {TextTransparency = 0.5}):Play()
				end
			end)

			Input.FocusLost:Connect(function(enterPressed)
				TweenService:Create(InputHolder, TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
					Size = UDim2.new(0, 60, 0, 26),
					Position = UDim2.new(1, -75, 0.5, -13)
				}):Play()
				TweenService:Create(InputHolder:FindFirstChildOfClass("UIStroke"), TweenInfo.new(0.4), {Color = Color3.fromRGB(50, 50, 70)}):Play()
				if Label then
					TweenService:Create(Label, TweenInfo.new(0.4), {TextTransparency = 0}):Play()
				end
				callback(Input.Text, enterPressed)
			end)
		end
	end

	-- ============================================
	-- Internal: Select a tab (highlight sidebar + show page)
	-- ============================================
	local function SelectTab(tabBtn, tabDot, page)
		-- Deselect all tabs
		for _, catFrame in pairs(self.TabHolder:GetChildren()) do
			if catFrame:IsA("Frame") then
				-- Category sub-tab buttons
				local subHolder = catFrame:FindFirstChild("SubTabHolder")
				if subHolder then
					for _, subFrame in pairs(subHolder:GetChildren()) do
						if subFrame:IsA("Frame") then
							local btn = subFrame:FindFirstChildOfClass("TextButton")
							local dot = subFrame:FindFirstChild("Dot")
							if btn then
								TweenService:Create(btn, TweenInfo.new(0.2), {TextColor3 = Color3.fromRGB(130, 130, 155)}):Play()
							end
							if dot then
								TweenService:Create(dot, TweenInfo.new(0.2), {ImageColor3 = Color3.fromRGB(50, 50, 65)}):Play()
							end
							-- Remove highlight bg
							local hl = subFrame:FindFirstChild("TabHighlightBg")
							if hl then
								TweenService:Create(hl, TweenInfo.new(0.2), {BackgroundTransparency = 1}):Play()
								local hlStroke = hl:FindFirstChildOfClass("UIStroke")
								if hlStroke then
									TweenService:Create(hlStroke, TweenInfo.new(0.2), {Transparency = 1}):Play()
								end
							end
						end
					end
				end
			end
		end

		-- Hide all pages
		for _, p in pairs(self.Pages:GetChildren()) do
			if p:IsA("ScrollingFrame") then p.Visible = false end
		end

		-- Select this tab
		if tabBtn then
			TweenService:Create(tabBtn, TweenInfo.new(0.2), {TextColor3 = Color3.fromRGB(255, 255, 255)}):Play()
		end
		if tabDot then
			TweenService:Create(tabDot, TweenInfo.new(0.2), {ImageColor3 = Color3.fromRGB(80, 150, 255)}):Play()
		end

		-- Show highlight bg
		local subFrame = tabBtn and tabBtn.Parent
		if subFrame then
			local hl = subFrame:FindFirstChild("TabHighlightBg")
			if hl then
				TweenService:Create(hl, TweenInfo.new(0.25, Enum.EasingStyle.Quart), {BackgroundTransparency = 0.88}):Play()
				local hlStroke = hl:FindFirstChildOfClass("UIStroke")
				if hlStroke then
					TweenService:Create(hlStroke, TweenInfo.new(0.25), {Transparency = 0.5}):Play()
				end
			end
		end

		page.Visible = true
		self._activeTabBtn = tabBtn
		self._activeTabDot = tabDot
	end

	-- ============================================
	-- NewCategory: Creates a collapsible category in sidebar (Flow-style)
	-- Usage:
	--   local cat = Window:NewCategory({Name = "Main", Icon = "rbxassetid://..."})
	--   local tab = cat:NewTab("Combat")
	-- ============================================
	local _categoryOrder = 0

	function self:NewCategory(config)
		local Window = self -- Store Window reference for closures
		local catName = config.Name or "Category"
		local catIcon = config.Icon or DEFAULT_CATEGORY_ICONS[catName] or DEFAULT_SECTION_ICON
		local defaultOpen = config.Default
		if defaultOpen == nil then defaultOpen = true end

		_categoryOrder = _categoryOrder + 1
		local catExpanded = defaultOpen

		local Category = {}

		-- Category container (holds header + sub tabs)
		local CatContainer = Create("Frame", {
			Name = "Cat_" .. catName,
			Size = UDim2.new(1, 0, 0, 26), -- Will auto-resize
			BackgroundTransparency = 1,
			ClipsDescendants = true,
			LayoutOrder = _categoryOrder,
			ZIndex = 5,
			Parent = self.TabHolder
		})

		-- Category header button
		local CatHeader = Create("TextButton", {
			Name = "CatHeader",
			Size = UDim2.new(1, 0, 0, 26),
			BackgroundTransparency = 1,
			Text = "",
			ZIndex = 7,
			Parent = CatContainer
		})

		-- Subtle bottom separator line
		local CatSeparator = Create("Frame", {
			Name = "CatSep",
			Size = UDim2.new(1, -12, 0, 1),
			Position = UDim2.new(0, 6, 1, -1),
			BackgroundColor3 = Color3.fromRGB(40, 40, 55),
			BorderSizePixel = 0,
			ZIndex = 7,
			Parent = CatHeader
		})

		-- Category icon (left side - accent colored)
		local CatIcon = Create("ImageLabel", {
			Image = catIcon,
			Size = UDim2.fromOffset(12, 12),
			Position = UDim2.fromOffset(6, 7),
			BackgroundTransparency = 1,
			ImageColor3 = Color3.fromRGB(80, 150, 255),
			ScaleType = Enum.ScaleType.Fit,
			ZIndex = 8,
			Parent = CatHeader
		})

		-- Category title (centered, uppercase, subtle)
		local CatTitle = Create("TextLabel", {
			Text = string.upper(catName),
			Font = Enum.Font.GothamMedium,
			TextSize = 10,
			TextColor3 = Color3.fromRGB(120, 120, 145),
			BackgroundTransparency = 1,
			Position = UDim2.fromOffset(22, 0),
			Size = UDim2.new(1, -44, 1, 0),
			TextXAlignment = "Center",
			ZIndex = 8,
			Parent = CatHeader
		})

		-- Arrow Icon (Lucide arrow-up-down, rotates 90 when expanded)
		local CAT_ARROW_ICON = "rbxassetid://10709768538"

		local CatArrowIcon = Create("ImageLabel", {
			Name = "CatArrowIcon",
			Image = CAT_ARROW_ICON,
			Size = UDim2.fromOffset(10, 10),
			Position = UDim2.new(1, -16, 0.5, -5),
			BackgroundTransparency = 1,
			ImageColor3 = Color3.fromRGB(255, 255, 255),
			ImageTransparency = 0.4,
			ScaleType = Enum.ScaleType.Fit,
			ZIndex = 8,
			Rotation = catExpanded and 90 or 0,
			Parent = CatHeader
		})

		-- Sub tab holder (tabs go here)
		local SubTabHolder = Create("Frame", {
			Name = "SubTabHolder",
			Size = UDim2.new(1, 0, 0, 0), -- Auto-sized
			Position = UDim2.fromOffset(0, 28),
			BackgroundTransparency = 1,
			ZIndex = 5,
			Parent = CatContainer
		}, {
			Create("UIListLayout", {Padding = UDim.new(0, 3), SortOrder = Enum.SortOrder.LayoutOrder}),
			Create("UIPadding", {PaddingLeft = UDim.new(0, 6)})
		})

		local subLayout = SubTabHolder:FindFirstChildOfClass("UIListLayout")
		local subTabOrder = 0

		-- Update category container size
		local function UpdateCatSize()
			local contentHeight = subLayout.AbsoluteContentSize.Y
			local targetHeight
			if catExpanded then
				targetHeight = 28 + contentHeight + 4
			else
				targetHeight = 26
			end

			TweenService:Create(CatContainer, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
				Size = UDim2.new(1, 0, 0, targetHeight)
			}):Play()
		end

		subLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
			if catExpanded then
				UpdateCatSize()
			end
		end)

		-- Toggle category expand/collapse
		CatHeader.MouseButton1Click:Connect(function()
			catExpanded = not catExpanded

			-- Smooth rotate arrow
			TweenService:Create(CatArrowIcon, TweenInfo.new(0.35, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
				Rotation = catExpanded and 90 or 0
			}):Play()

			TweenService:Create(CatTitle, TweenInfo.new(0.2), {
				TextColor3 = catExpanded and Color3.fromRGB(120, 120, 145) or Color3.fromRGB(90, 90, 110)
			}):Play()

			TweenService:Create(CatIcon, TweenInfo.new(0.2), {
				ImageColor3 = catExpanded and Color3.fromRGB(180, 180, 200) or Color3.fromRGB(100, 100, 130)
			}):Play()

			UpdateCatSize()
		end)

		-- Hover effect on header
		CatHeader.MouseEnter:Connect(function()
			TweenService:Create(CatTitle, TweenInfo.new(0.15), {
				TextColor3 = Color3.fromRGB(180, 180, 200)
			}):Play()
			TweenService:Create(CatArrowIcon, TweenInfo.new(0.15), {
				ImageTransparency = 0.1
			}):Play()
		end)
		CatHeader.MouseLeave:Connect(function()
			TweenService:Create(CatTitle, TweenInfo.new(0.15), {
				TextColor3 = catExpanded and Color3.fromRGB(120, 120, 145) or Color3.fromRGB(90, 90, 110)
			}):Play()
			TweenService:Create(CatArrowIcon, TweenInfo.new(0.15), {
				ImageTransparency = 0.4
			}):Play()
		end)

		-- ============================================
		-- Category:NewTab - Creates a sub-tab under this category
		-- ============================================
		function Category:NewTab(name)
			local Tab = {}
			subTabOrder = subTabOrder + 1

			-- Sub tab frame in sidebar
			local SubTabFrame = Create("Frame", {
				Name = "SubTab_" .. name,
				Size = UDim2.new(1, -6, 0, 26),
				BackgroundTransparency = 1,
				LayoutOrder = subTabOrder,
				ZIndex = 6,
				Parent = SubTabHolder
			})

			-- Highlight background (shown when active)
			local TabHighlightBg = Create("Frame", {
				Name = "TabHighlightBg",
				Size = UDim2.fromScale(1, 1),
				BackgroundColor3 = Color3.fromRGB(80, 150, 255),
				BackgroundTransparency = 1,
				ZIndex = 6,
				Parent = SubTabFrame
			}, {
				Create("UICorner", {CornerRadius = UDim.new(0, 6)}),
				Create("UIStroke", {Color = Color3.fromRGB(80, 150, 255), Thickness = 1, Transparency = 1})
			})

			-- Corner arrow icon (lucide corner-down-right)
			local Dot = Create("ImageLabel", {
				Name = "Dot",
				Image = "rbxassetid://10709812485",
				Size = UDim2.fromOffset(10, 10),
				Position = UDim2.fromOffset(6, 8),
				BackgroundTransparency = 1,
				ImageColor3 = Color3.fromRGB(50, 50, 65),
				ScaleType = Enum.ScaleType.Fit,
				ZIndex = 8,
				Parent = SubTabFrame
			})

			-- Tab button text
			local TabBtn = Create("TextButton", {
				Text = name,
				Font = Enum.Font.GothamMedium,
				TextSize = 11,
				TextColor3 = Color3.fromRGB(110, 110, 135),
				BackgroundTransparency = 1,
				Position = UDim2.fromOffset(20, 0),
				Size = UDim2.new(1, -20, 1, 0),
				TextXAlignment = "Left",
				ZIndex = 9,
				Parent = SubTabFrame
			})

			-- Content page (scrollable)
			local Page = Create("ScrollingFrame", {
				Size = UDim2.fromScale(1, 1),
				BackgroundTransparency = 1,
				Visible = false,
				ScrollBarThickness = 2,
				ScrollBarImageColor3 = Color3.fromRGB(80, 150, 255),
				CanvasSize = UDim2.new(0, 0, 0, 0),
				ZIndex = 4,
				Parent = Window.Pages
			}, {
				Create("UIListLayout", {
					Padding = UDim.new(0, 8),
					SortOrder = Enum.SortOrder.LayoutOrder
				}),
				Create("UIPadding", {
					PaddingTop = UDim.new(0, 2),
					PaddingLeft = UDim.new(0, 2),
					PaddingRight = UDim.new(0, 8)
				})
			})

			local UIListLayout = Page:FindFirstChildOfClass("UIListLayout")

			local function UpdateCanvasSize()
				Page.CanvasSize = UDim2.new(0, 0, 0, UIListLayout.AbsoluteContentSize.Y + 15)
			end
			UIListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(UpdateCanvasSize)
			task.spawn(UpdateCanvasSize)

			-- Click to select tab
			TabBtn.MouseButton1Click:Connect(function()
				SelectTab(TabBtn, Dot, Page)
			end)

			-- Hover effects
			TabBtn.MouseEnter:Connect(function()
				if Window._activeTabBtn ~= TabBtn then
					TweenService:Create(TabBtn, TweenInfo.new(0.15), {TextColor3 = Color3.fromRGB(170, 170, 195)}):Play()
					TweenService:Create(Dot, TweenInfo.new(0.15), {ImageColor3 = Color3.fromRGB(100, 100, 130)}):Play()
				end
			end)
			TabBtn.MouseLeave:Connect(function()
				if Window._activeTabBtn ~= TabBtn then
					TweenService:Create(TabBtn, TweenInfo.new(0.15), {TextColor3 = Color3.fromRGB(130, 130, 155)}):Play()
					TweenService:Create(Dot, TweenInfo.new(0.15), {ImageColor3 = Color3.fromRGB(50, 50, 65)}):Play()
				end
			end)

			-- Add all standard element methods to Tab
			CreateElementMethods(Tab, Page, UpdateCanvasSize)

			-- ============================================
			-- Section: Collapsible group of elements (same as before)
			-- ============================================
			function Tab:Section(config)
				local sectionName = config.Name or config.Title or "Section"
				local sectionDesc = config.Description or config.Desc or nil
				local icon = config.Icon or DEFAULT_SECTION_ICON
				local defaultOpen = config.Default
				if defaultOpen == nil then defaultOpen = true end
				local sExpanded = defaultOpen

				local Section = {}

				local SectionContainer = Create("Frame", {
					Name = "Section_" .. sectionName,
					Size = UDim2.new(1, 0, 0, 40),
					BackgroundColor3 = Color3.fromRGB(18, 18, 25),
					ClipsDescendants = true,
					ZIndex = 5,
					Parent = Page
				}, {
					Create("UICorner", {CornerRadius = UDim.new(0, 10)}),
					Create("UIStroke", {Color = Color3.fromRGB(45, 45, 60), Thickness = 1})
				})

				local HeaderBtn = Create("TextButton", {
					Name = "SectionHeader",
					Size = UDim2.new(1, 0, 0, 40),
					BackgroundTransparency = 1,
					Text = "",
					ZIndex = 7,
					Parent = SectionContainer
				})

				local AccentBar = Create("Frame", {
					Size = UDim2.new(0, 3, 0, 20),
					Position = UDim2.fromOffset(0, 10),
					BackgroundColor3 = Color3.fromRGB(80, 150, 255),
					BorderSizePixel = 0,
					ZIndex = 8,
					Parent = HeaderBtn
				}, {
					Create("UICorner", {CornerRadius = UDim.new(0, 2)})
				})

				local IconLabel = Create("ImageLabel", {
					Image = icon,
					Size = UDim2.fromOffset(16, 16),
					Position = UDim2.new(0, 14, 0.5, -8),
					BackgroundTransparency = 1,
					ImageColor3 = Color3.fromRGB(80, 150, 255),
					ScaleType = Enum.ScaleType.Fit,
					ZIndex = 8,
					Parent = HeaderBtn
				})

				local SectionTitle = Create("TextLabel", {
					Text = sectionName,
					Font = Enum.Font.GothamBold,
					TextSize = 14,
					TextColor3 = Color3.fromRGB(230, 230, 245),
					BackgroundTransparency = 1,
					Position = UDim2.fromOffset(38, 0),
					Size = UDim2.new(1, -80, 1, 0),
					TextXAlignment = "Left",
					ZIndex = 8,
					Parent = HeaderBtn
				})

				local SEC_ARROW_ICON = "rbxassetid://10709768538"  -- lucide arrow-up-down

				local SectionArrow = Create("ImageLabel", {
					Name = "SectionArrow",
					Image = SEC_ARROW_ICON,
					Size = UDim2.fromOffset(14, 14),
					Position = UDim2.new(1, -28, 0.5, -7),
					BackgroundTransparency = 1,
					ImageColor3 = Color3.fromRGB(255, 255, 255),
					ScaleType = Enum.ScaleType.Fit,
					ZIndex = 8,
					Rotation = sExpanded and 90 or 0,
					Parent = HeaderBtn
				})

				local descHeight = 0
				if sectionDesc then
					Create("TextLabel", {
						Text = sectionDesc,
						Font = Enum.Font.GothamMedium,
						TextSize = 11,
						TextColor3 = Color3.fromRGB(100, 100, 130),
						BackgroundTransparency = 1,
						Position = UDim2.fromOffset(38, 25),
						Size = UDim2.new(1, -80, 0, 15),
						TextXAlignment = "Left",
						ZIndex = 8,
						Parent = HeaderBtn
					})
					descHeight = 8
					HeaderBtn.Size = UDim2.new(1, 0, 0, 48)
				end

				local headerHeight = sectionDesc and 48 or 40

				local HeaderDivider = Create("Frame", {
					Size = UDim2.new(1, -16, 0, 1),
					Position = UDim2.fromOffset(8, headerHeight),
					BackgroundColor3 = Color3.fromRGB(40, 40, 55),
					BackgroundTransparency = sExpanded and 0 or 1,
					BorderSizePixel = 0,
					ZIndex = 7,
					Parent = SectionContainer
				})

				local ContentHolder = Create("Frame", {
					Name = "SectionContent",
					Size = UDim2.new(1, -16, 0, 0),
					Position = UDim2.fromOffset(8, headerHeight + 4),
					BackgroundTransparency = 1,
					ZIndex = 6,
					Parent = SectionContainer
				}, {
					Create("UIListLayout", {
						Padding = UDim.new(0, 6),
						SortOrder = Enum.SortOrder.LayoutOrder
					}),
					Create("UIPadding", {
						PaddingTop = UDim.new(0, 4),
						PaddingBottom = UDim.new(0, 4),
						PaddingLeft = UDim.new(0, 2),
						PaddingRight = UDim.new(0, 2)
					})
				})

				local ContentLayout = ContentHolder:FindFirstChildOfClass("UIListLayout")

				local function UpdateSectionSize()
					local contentHeight = ContentLayout.AbsoluteContentSize.Y + 12
					local targetHeight = sExpanded and (headerHeight + 4 + contentHeight) or headerHeight

					TweenService:Create(SectionContainer, TweenInfo.new(0.35, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
						Size = UDim2.new(1, 0, 0, targetHeight)
					}):Play()

					TweenService:Create(HeaderDivider, TweenInfo.new(0.2), {
						BackgroundTransparency = sExpanded and 0 or 1
					}):Play()

					task.delay(0.4, UpdateCanvasSize)
				end

				ContentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
					if sExpanded then
						UpdateSectionSize()
					end
				end)

				HeaderBtn.MouseButton1Click:Connect(function()
					sExpanded = not sExpanded

					-- Smooth rotate arrow
					TweenService:Create(SectionArrow, TweenInfo.new(0.35, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
						Rotation = sExpanded and 90 or 0
					}):Play()

					TweenService:Create(AccentBar, TweenInfo.new(0.2), {
						BackgroundColor3 = sExpanded and Color3.fromRGB(80, 150, 255) or Color3.fromRGB(60, 60, 80)
					}):Play()

					TweenService:Create(IconLabel, TweenInfo.new(0.2), {
						ImageColor3 = sExpanded and Color3.fromRGB(80, 150, 255) or Color3.fromRGB(100, 100, 130)
					}):Play()

					TweenService:Create(SectionTitle, TweenInfo.new(0.2), {
						TextColor3 = sExpanded and Color3.fromRGB(230, 230, 245) or Color3.fromRGB(160, 160, 180)
					}):Play()

					UpdateSectionSize()
				end)

				HeaderBtn.MouseEnter:Connect(function()
					TweenService:Create(SectionContainer, TweenInfo.new(0.15), {
						BackgroundColor3 = Color3.fromRGB(22, 22, 30)
					}):Play()
				end)

				HeaderBtn.MouseLeave:Connect(function()
					TweenService:Create(SectionContainer, TweenInfo.new(0.15), {
						BackgroundColor3 = Color3.fromRGB(18, 18, 25)
					}):Play()
				end)

				CreateElementMethods(Section, ContentHolder, UpdateCanvasSize)

				if sExpanded then
					task.spawn(function()
						task.wait(0.1)
						UpdateSectionSize()
					end)
				else
					SectionContainer.Size = UDim2.new(1, 0, 0, headerHeight)
					AccentBar.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
					IconLabel.ImageColor3 = Color3.fromRGB(100, 100, 130)
					SectionTitle.TextColor3 = Color3.fromRGB(160, 160, 180)
					SectionArrow.Rotation = 0
				end

				function Section:SetExpanded(val)
					sExpanded = val
					TweenService:Create(SectionArrow, TweenInfo.new(0.35, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
						Rotation = sExpanded and 90 or 0
					}):Play()
					UpdateSectionSize()
				end

				function Section:IsExpanded()
					return sExpanded
				end

				return Section
			end

			-- Update category size after adding tab
			task.spawn(function()
				task.wait(0.05)
				UpdateCatSize()
			end)

			return Tab
		end

		-- Initial size
		if catExpanded then
			task.spawn(function()
				task.wait(0.1)
				UpdateCatSize()
			end)
		else
			CatContainer.Size = UDim2.new(1, 0, 0, 26)
			CatArrowIcon.Rotation = 0
			CatTitle.TextColor3 = Color3.fromRGB(140, 140, 160)
			CatIcon.ImageColor3 = Color3.fromRGB(100, 100, 130)
		end

		-- Category API
		function Category:SetExpanded(val)
			catExpanded = val
			TweenService:Create(CatArrowIcon, TweenInfo.new(0.35, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
				Rotation = catExpanded and 90 or 0
			}):Play()
			UpdateCatSize()
		end

		function Category:IsExpanded()
			return catExpanded
		end

		return Category
	end

	-- ============================================
	-- NewTab (BACKWARD COMPATIBLE - creates a tab without category)
	-- Works exactly like before for users who don't want categories
	-- ============================================
	function self:NewTab(name)
		local Tab = {}

		_categoryOrder = _categoryOrder + 1

		local TabBg = Create("Frame", {
			Size = UDim2.new(1, 0, 0, 34),
			BackgroundColor3 = Color3.fromRGB(25, 25, 35),
			LayoutOrder = _categoryOrder,
			ZIndex = 6,
			Parent = self.TabHolder
		}, {
			Create("UICorner", {CornerRadius = UDim.new(0, 8)}),
			Create("UIStroke", {Color = Color3.fromRGB(45, 45, 60), Thickness = 1})
		})

		local Dot = Create("Frame", {
			Name = "Dot",
			Size = UDim2.fromOffset(4, 4),
			Position = UDim2.new(0, 10, 0.5, -2),
			BackgroundColor3 = Color3.fromRGB(150, 150, 170),
			ZIndex = 7,
			Parent = TabBg
		}, { Create("UICorner", {CornerRadius = UDim.new(1, 0)}) })

		local TabBtn = Create("TextButton", {
			Text = name,
			Font = Enum.Font.GothamMedium,
			TextSize = 13,
			TextColor3 = Color3.fromRGB(150, 150, 170),
			BackgroundTransparency = 1,
			Size = UDim2.fromScale(1, 1),
			ZIndex = 8,
			Parent = TabBg
		})

		local Page = Create("ScrollingFrame", {
			Size = UDim2.fromScale(1, 1),
			BackgroundTransparency = 1,
			Visible = false,
			ScrollBarThickness = 2,
			ScrollBarImageColor3 = Color3.fromRGB(80, 150, 255),
			CanvasSize = UDim2.new(0, 0, 0, 0),
			ZIndex = 4,
			Parent = self.Pages
		}, {
			Create("UIListLayout", {
				Padding = UDim.new(0, 8),
				SortOrder = Enum.SortOrder.LayoutOrder
			}),
			Create("UIPadding", {
				PaddingTop = UDim.new(0, 2),
				PaddingLeft = UDim.new(0, 2),
				PaddingRight = UDim.new(0, 8)
			})
		})

		local UIListLayout = Page:FindFirstChildOfClass("UIListLayout")

		local function UpdateCanvasSize()
			Page.CanvasSize = UDim2.new(0, 0, 0, UIListLayout.AbsoluteContentSize.Y + 15)
		end
		UIListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(UpdateCanvasSize)
		task.spawn(UpdateCanvasSize)

		TabBtn.MouseButton1Click:Connect(function()
			-- Deselect all
			for _, p in pairs(self.Pages:GetChildren()) do if p:IsA("ScrollingFrame") then p.Visible = false end end
			for _, bg in pairs(self.TabHolder:GetChildren()) do
				if bg:IsA("Frame") and bg:FindFirstChild("Frame") then
					local btn = bg:FindFirstChildOfClass("TextButton")
					local dot = bg:FindFirstChild("Frame")
					if btn then
						TweenService:Create(btn, TweenInfo.new(0.2), {TextColor3 = Color3.fromRGB(150, 150, 170)}):Play()
					end
					if dot then
						TweenService:Create(dot, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(150, 150, 170)}):Play()
					end
				end
			end
			Page.Visible = true
			TweenService:Create(TabBtn, TweenInfo.new(0.2), {TextColor3 = Color3.fromRGB(255, 255, 255)}):Play()
			TweenService:Create(Dot, TweenInfo.new(0.2), {ImageColor3 = Color3.fromRGB(80, 150, 255)}):Play()
		end)

		CreateElementMethods(Tab, Page, UpdateCanvasSize)

		-- Section support (same as category tabs)
		function Tab:Section(config)
			local sectionName = config.Name or config.Title or "Section"
			local sectionDesc = config.Description or config.Desc or nil
			local icon = config.Icon or DEFAULT_SECTION_ICON
			local defaultOpen = config.Default
			if defaultOpen == nil then defaultOpen = true end
			local sExpanded = defaultOpen

			local Section = {}

			local SectionContainer = Create("Frame", {
				Name = "Section_" .. sectionName,
				Size = UDim2.new(1, 0, 0, 40),
				BackgroundColor3 = Color3.fromRGB(18, 18, 25),
				ClipsDescendants = true,
				ZIndex = 5,
				Parent = Page
			}, {
				Create("UICorner", {CornerRadius = UDim.new(0, 10)}),
				Create("UIStroke", {Color = Color3.fromRGB(45, 45, 60), Thickness = 1})
			})

			local HeaderBtn = Create("TextButton", {
				Size = UDim2.new(1, 0, 0, 40),
				BackgroundTransparency = 1,
				Text = "",
				ZIndex = 7,
				Parent = SectionContainer
			})

			local AccentBar = Create("Frame", {
				Size = UDim2.new(0, 3, 0, 20),
				Position = UDim2.fromOffset(0, 10),
				BackgroundColor3 = Color3.fromRGB(80, 150, 255),
				BorderSizePixel = 0,
				ZIndex = 8,
				Parent = HeaderBtn
			}, { Create("UICorner", {CornerRadius = UDim.new(0, 2)}) })

			local IconLabel = Create("ImageLabel", {
				Image = icon,
				Size = UDim2.fromOffset(16, 16),
				Position = UDim2.new(0, 14, 0.5, -8),
				BackgroundTransparency = 1,
				ImageColor3 = Color3.fromRGB(80, 150, 255),
				ScaleType = Enum.ScaleType.Fit,
				ZIndex = 8,
				Parent = HeaderBtn
			})

			local SectionTitle = Create("TextLabel", {
				Text = sectionName,
				Font = Enum.Font.GothamBold,
				TextSize = 14,
				TextColor3 = Color3.fromRGB(230, 230, 245),
				BackgroundTransparency = 1,
				Position = UDim2.fromOffset(38, 0),
				Size = UDim2.new(1, -80, 1, 0),
				TextXAlignment = "Left",
				ZIndex = 8,
				Parent = HeaderBtn
			})

			local SEC_ARROW_ICON2 = "rbxassetid://10709768538"

			local SectionArrow = Create("ImageLabel", {
				Name = "SectionArrow",
				Image = SEC_ARROW_ICON2,
				Size = UDim2.fromOffset(14, 14),
				Position = UDim2.new(1, -28, 0.5, -7),
				BackgroundTransparency = 1,
				ImageColor3 = Color3.fromRGB(255, 255, 255),
				ScaleType = Enum.ScaleType.Fit,
				ZIndex = 8,
				Rotation = sExpanded and 90 or 0,
				Parent = HeaderBtn
			})

			if sectionDesc then
				Create("TextLabel", {
					Text = sectionDesc,
					Font = Enum.Font.GothamMedium,
					TextSize = 11,
					TextColor3 = Color3.fromRGB(100, 100, 130),
					BackgroundTransparency = 1,
					Position = UDim2.fromOffset(38, 25),
					Size = UDim2.new(1, -80, 0, 15),
					TextXAlignment = "Left",
					ZIndex = 8,
					Parent = HeaderBtn
				})
				HeaderBtn.Size = UDim2.new(1, 0, 0, 48)
			end

			local headerHeight = sectionDesc and 48 or 40

			local HeaderDivider = Create("Frame", {
				Size = UDim2.new(1, -16, 0, 1),
				Position = UDim2.fromOffset(8, headerHeight),
				BackgroundColor3 = Color3.fromRGB(40, 40, 55),
				BackgroundTransparency = sExpanded and 0 or 1,
				BorderSizePixel = 0,
				ZIndex = 7,
				Parent = SectionContainer
			})

			local ContentHolder = Create("Frame", {
				Size = UDim2.new(1, -16, 0, 0),
				Position = UDim2.fromOffset(8, headerHeight + 4),
				BackgroundTransparency = 1,
				ZIndex = 6,
				Parent = SectionContainer
			}, {
				Create("UIListLayout", {Padding = UDim.new(0, 6), SortOrder = Enum.SortOrder.LayoutOrder}),
				Create("UIPadding", {PaddingTop = UDim.new(0, 4), PaddingBottom = UDim.new(0, 4), PaddingLeft = UDim.new(0, 2), PaddingRight = UDim.new(0, 2)})
			})

			local ContentLayout = ContentHolder:FindFirstChildOfClass("UIListLayout")

			local function UpdateSectionSize()
				local contentHeight = ContentLayout.AbsoluteContentSize.Y + 12
				local targetHeight = sExpanded and (headerHeight + 4 + contentHeight) or headerHeight
				TweenService:Create(SectionContainer, TweenInfo.new(0.35, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
					Size = UDim2.new(1, 0, 0, targetHeight)
				}):Play()
				TweenService:Create(HeaderDivider, TweenInfo.new(0.2), {BackgroundTransparency = sExpanded and 0 or 1}):Play()
				task.delay(0.4, UpdateCanvasSize)
			end

			ContentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
				if sExpanded then UpdateSectionSize() end
			end)

			HeaderBtn.MouseButton1Click:Connect(function()
				sExpanded = not sExpanded
				TweenService:Create(SectionArrow, TweenInfo.new(0.35, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Rotation = sExpanded and 90 or 0}):Play()
				TweenService:Create(AccentBar, TweenInfo.new(0.2), {BackgroundColor3 = sExpanded and Color3.fromRGB(80, 150, 255) or Color3.fromRGB(60, 60, 80)}):Play()
				TweenService:Create(IconLabel, TweenInfo.new(0.2), {ImageColor3 = sExpanded and Color3.fromRGB(80, 150, 255) or Color3.fromRGB(100, 100, 130)}):Play()
				TweenService:Create(SectionTitle, TweenInfo.new(0.2), {TextColor3 = sExpanded and Color3.fromRGB(230, 230, 245) or Color3.fromRGB(160, 160, 180)}):Play()
				UpdateSectionSize()
			end)

			HeaderBtn.MouseEnter:Connect(function()
				TweenService:Create(SectionContainer, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(22, 22, 30)}):Play()
			end)
			HeaderBtn.MouseLeave:Connect(function()
				TweenService:Create(SectionContainer, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(18, 18, 25)}):Play()
			end)

			CreateElementMethods(Section, ContentHolder, UpdateCanvasSize)

			if sExpanded then
				task.spawn(function() task.wait(0.1); UpdateSectionSize() end)
			else
				SectionContainer.Size = UDim2.new(1, 0, 0, headerHeight)
				AccentBar.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
				IconLabel.ImageColor3 = Color3.fromRGB(100, 100, 130)
				SectionTitle.TextColor3 = Color3.fromRGB(160, 160, 180)
			end

			function Section:SetExpanded(val)
				sExpanded = val
				TweenService:Create(SectionArrow, TweenInfo.new(0.35, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Rotation = sExpanded and 90 or 0}):Play()
				UpdateSectionSize()
			end
			function Section:IsExpanded() return sExpanded end

			return Section
		end

		return Tab
	end

	return self
end

return Library
