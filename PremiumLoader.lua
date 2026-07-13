--[[
    HANSZ HUB - Premium 3D Loading Screen v2.0
    Drawing API | Executor UI
    Author: Hansz Hub Team

    ▸ Logo: Change LOGO_PATH below to use your image
    ▸ All colors in Theme table
    ▸ All timings in Config table
    ▸ Fully modular functions
]]

-- ============================================================================
-- LOGO CONFIGURATION
-- ============================================================================
-- Change these to use your own logo image
local LOGO_PATH = "img.png"               -- Path to your logo image file
local LOGO_USE_BASE64 = false             -- Set true if using base64 encoded data
local LOGO_BASE64_DATA = ""               -- Base64 encoded image data (if LOGO_USE_BASE64)

-- ============================================================================
-- THEME
-- ============================================================================
local Theme = {
    Background      = Color3.fromRGB(6, 6, 16),
    Surface         = Color3.fromRGB(10, 12, 26),
    Primary         = Color3.fromRGB(59, 130, 246),
    PrimaryDark     = Color3.fromRGB(29, 78, 216),
    PrimaryLight    = Color3.fromRGB(96, 165, 250),
    Cyan            = Color3.fromRGB(6, 182, 212),
    CyanLight       = Color3.fromRGB(34, 211, 238),
    White           = Color3.fromRGB(240, 244, 255),
    GrayLight       = Color3.fromRGB(170, 178, 210),
    Gray            = Color3.fromRGB(110, 118, 155),
    GrayDark        = Color3.fromRGB(55, 60, 82),
    GlassBg         = Color3.fromRGB(12, 16, 34),
    GlassBorder     = Color3.fromRGB(59, 130, 246),
    Success         = Color3.fromRGB(34, 197, 94),
    Accent          = Color3.fromRGB(139, 92, 246),
    AccentLight     = Color3.fromRGB(167, 139, 250),
}

-- ============================================================================
-- CONFIG
-- ============================================================================
local Config = {
    IntroDuration     = 1.8,
    FadeSpeed         = 2.5,
    ScaleSpeed        = 3.0,
    SlideSpeed        = 2.2,
    ProgressEase      = 2.0,
    TipInterval       = 3.5,
    ParticleCount     = 40,
    BokehCount        = 5,
    GlowCircleCount   = 3,
    RingSegments      = 16,
    StatusCount       = 6,
    NotificationTime  = 4.5,
    FrameRate         = 60,
    GradientStrips    = 10,
    DustCount         = 15,
    SparkCount        = 10,

    ProgressTargets   = {0, 3, 8, 15, 25, 39, 52, 67, 81, 94, 100},
}

-- ============================================================================
-- MENU CONFIG
-- ============================================================================
local MenuConfig = {
    WindowWidth     = 480,
    WindowHeight    = 340,
    SidebarWidth    = 70,
    SidebarExpanded = 180,
    CornerRadius    = 12,
    BlurAmount      = 0.52,
    AnimationSpeed  = 3.0,
    TransitionTime  = 0.6,
    BounceStrength  = 1.70158,
    NotifDuration   = 3.5,
    NotifWidth      = 220,
}

-- ============================================================================
-- ANIMATION CONFIG
-- ============================================================================
local AnimationConfig = {
    FadeSpeed     = 3.0,
    ScaleSpeed    = 4.0,
    SlideSpeed    = 3.5,
    SpringSpeed   = 5.0,
    SpringDamping = 0.85,
    GlowPulse     = 0.7,
    SmoothEase    = 0.15,
}

-- ============================================================================
-- MENU THEME EXTENSION
-- ============================================================================
local MTheme = {
    SidebarBg      = Color3.fromRGB(8, 10, 24),
    SidebarHover   = Color3.fromRGB(20, 25, 50),
    SidebarActive  = Color3.fromRGB(59, 130, 246),
    CardBg         = Color3.fromRGB(14, 18, 38),
    CardBorder     = Color3.fromRGB(30, 35, 60),
    CardGlow       = Color3.fromRGB(59, 130, 246),
    ToggleBg       = Color3.fromRGB(30, 35, 55),
    ToggleActive   = Color3.fromRGB(59, 130, 246),
    ToggleKnob     = Color3.fromRGB(220, 225, 240),
    HeaderBg       = Color3.fromRGB(10, 12, 28),
    FooterBg       = Color3.fromRGB(8, 10, 22),
    ScrollbarBg    = Color3.fromRGB(25, 28, 50),
    ScrollbarThumb = Color3.fromRGB(59, 130, 246),
    SearchBg       = Color3.fromRGB(12, 15, 32),
    StatusGreen    = Color3.fromRGB(34, 197, 94),
    StatusYellow   = Color3.fromRGB(234, 179, 8),
    StatusRed      = Color3.fromRGB(239, 68, 68),
}

-- ============================================================================
-- TEXT DATA
-- ============================================================================
local LoadingTexts = {
    "Initializing...",
    "Loading Assets...",
    "Loading Modules...",
    "Loading UI...",
    "Preparing Functions...",
    "Checking Environment...",
    "Optimizing...",
    "Connecting...",
    "Finalizing...",
    "Done!",
}

local TipsList = {
    "Preparing Premium Experience...",
    "Loading Resources...",
    "Optimizing Memory...",
    "Almost Ready...",
    "Checking Compatibility...",
    "Applying Settings...",
    "Calibrating Modules...",
    "Enhancing Performance...",
    "Validating Environment...",
    "Final Polish...",
}

local StatusList = {
    "Assets Loaded",
    "Modules Loaded",
    "Interface Ready",
    "Security Checked",
    "Configuration Loaded",
    "Functions Loaded",
}

-- ============================================================================
-- STATE
-- ============================================================================
local S = {}
local state = {
    running       = true,
    progress      = 0,
    targetIdx     = 1,
    time          = 0,

    -- Intro
    introDone     = false,
    bgDarkness    = 0,
    fadeIn        = 0,
    panelSlide    = 0,
    logoScale     = 0,

    -- Rings
    ringAngle     = 0,
    innerAngle    = 0,

    -- Loading text
    loadTextIdx   = 1,
    loadTextTm    = 0,
    loadTextFd    = 0,

    -- Tips
    tipIdx        = 1,
    tipTm         = 0,
    tipFd         = 0,

    -- Status
    statusItems   = {},

    -- Particles dynamic data
    particleData  = {},
    glowData      = {},
    dustData      = {},
    sparkData     = {},

    -- Finish
    finishing     = false,
    finishTimer   = 0,
    finished      = false,

    -- Notification
    notif = {
        active = false,
        timer  = 0,
        slide  = 0,
        alpha  = 0,
    },

    -- Menu state
    menuPhase      = 0,  -- 0=none, 1=transition, 2=ready
    menuCreated    = false,
    menuRunning    = false,
    mousePos       = Vector2.new(0, 0),
    mouseDown      = false,
    mouseClicked   = false,
    mouseButton    = 0,
}

for _ = 1, Config.StatusCount do
    state.statusItems[_] = {alpha = 0, done = false}
end

-- ============================================================================
-- SCREEN INFO
-- ============================================================================
local function GetScreenSize()
    local tmp = Drawing.new("Square")
    tmp.Visible = false
    local sz = tmp.Size
    tmp:Destroy()
    return sz or Vector2.new(1920, 1080)
end

S = GetScreenSize()
local CX = S.X / 2
local CY = S.Y / 2
local PctX = function(p) return S.X * p / 100 end
local PctY = function(p) return S.Y * p / 100 end

-- ============================================================================
-- UTILITY
-- ============================================================================
local lerp = function(a, b, t) return a + (b - a) * t end
local clamp = function(v, mn, mx) return math.max(mn, math.min(mx, v)) end
local cubic = function(t) return 1 - (1 - t) ^ 3 end
local quart  = function(t) return 1 - (1 - t) ^ 4 end
local quint  = function(t) return 1 - (1 - t) ^ 5 end

local function outBack(t)
    local c = 1.70158
    return 1 + c * (t - 1) ^ 3 + (c + 1) * (t - 1) ^ 2
end

local function inOutCubic(t)
    if t < 0.5 then return 4 * t ^ 3 else return 1 - (-2 * t + 2) ^ 3 / 2 end
end

local function lerpC(c1, c2, t)
    return Color3.new(lerp(c1.R, c2.R, t), lerp(c1.G, c2.G, t), lerp(c1.B, c2.B, t))
end

-- ============================================================================
-- DRAWING POOL
-- ============================================================================
local D = {}

local function New(t, props)
    local o = Drawing.new(t)
    for k, v in pairs(props) do
        o[k] = v
    end
    return o
end

-- ============================================================================
-- CREATE LOADER
-- ============================================================================
function CreateLoader()
    -- ── Background ──
    D.bg = New("Square", {Size = S, Position = Vector2.new(0, 0), Color = Theme.Background, Transparency = 0, Visible = true, ZIndex = 0})
    D.bgOverlay = New("Square", {Size = S, Position = Vector2.new(0, 0), Color = Color3.new(0, 0, 0), Transparency = 1, Visible = true, ZIndex = 1})

    -- ── Animated Gradient Strips ──
    D.grads = {}
    local stripH = math.ceil(S.Y / Config.GradientStrips) + 1
    for i = 1, Config.GradientStrips do
        D.grads[i] = New("Square", {
            Size = Vector2.new(S.X, stripH),
            Position = Vector2.new(0, (i - 1) * stripH),
            Color = Theme.Primary, Transparency = 0.93, Visible = true, ZIndex = 1,
        })
    end

    -- ── Bokeh ──
    D.bokehs = {}
    for i = 1, Config.BokehCount do
        D.bokehs[i] = New("Circle", {
            Radius = 80 + i * 20, NumSides = 36,
            Position = Vector2.new(math.random(50, S.X - 50), math.random(50, S.Y - 50)),
            Color = Theme.Primary, Transparency = 0.95, Visible = true, ZIndex = 1,
        })
    end

    -- ── Glow Circles ──
    D.glowCircles = {}
    for i = 1, Config.GlowCircleCount do
        D.glowCircles[i] = New("Circle", {
            Radius = 120 + i * 40, NumSides = 48,
            Position = Vector2.new(math.random(80, S.X - 80), math.random(80, S.Y - 80)),
            Color = Theme.Primary, Transparency = 0.93, Visible = true, ZIndex = 1,
        })
        state.glowData[i] = {
            ox = D.glowCircles[i].Position.X, oy = D.glowCircles[i].Position.Y,
            r = 120 + i * 40, phase = math.random() * 6.28, spd = 0.08 + math.random() * 0.1,
        }
    end

    -- ── Neon Lines ──
    D.neonLines = {}
    D.neonGlows = {}
    for i = 1, 3 do
        local x = PctX(8 + math.random(0, 84))
        D.neonLines[i] = New("Line", {From = Vector2.new(x, PctY(18)), To = Vector2.new(x, PctY(82)), Color = Theme.Primary, Transparency = 0.86, Thickness = 1, Visible = true, ZIndex = 1})
        D.neonGlows[i] = New("Line", {From = D.neonLines[i].From, To = D.neonLines[i].To, Color = Theme.Primary, Transparency = 0.96, Thickness = 5, Visible = true, ZIndex = 1})
    end
    for i = 4, 5 do
        local y = PctY(15 + math.random(0, 70))
        D.neonLines[i] = New("Line", {From = Vector2.new(PctX(4), y), To = Vector2.new(PctX(96), y), Color = Theme.Cyan, Transparency = 0.88, Thickness = 1, Visible = true, ZIndex = 1})
        D.neonGlows[i] = New("Line", {From = D.neonLines[i].From, To = D.neonLines[i].To, Color = Theme.Cyan, Transparency = 0.97, Thickness = 5, Visible = true, ZIndex = 1})
    end

    -- ── Particles ──
    D.particles = {}
    for i = 1, Config.ParticleCount do
        D.particles[i] = New("Circle", {Radius = math.random(1, 4), Position = Vector2.new(math.random(0, S.X), math.random(0, S.Y)), Color = Color3.fromRGB(170, 195, 255), Transparency = math.random() * 0.5 + 0.2, Visible = true, ZIndex = 2})
        state.particleData[i] = {x = math.random(0, S.X), y = math.random(0, S.Y), vx = (math.random() - 0.5) * 0.35, vy = (math.random() - 0.5) * 0.35 - 0.08, a = math.random() * 0.4 + 0.1, ph = math.random() * 6.28}
    end

    -- ── Dust ──
    D.dust = {}
    for i = 1, Config.DustCount do
        D.dust[i] = New("Circle", {Radius = math.random() * 0.6 + 0.2, Position = Vector2.new(math.random(0, S.X), math.random(0, S.Y)), Color = Color3.fromRGB(200, 215, 255), Transparency = math.random() * 0.4 + 0.3, Visible = true, ZIndex = 2})
        state.dustData[i] = {x = math.random(0, S.X), y = math.random(0, S.Y), vx = (math.random() - 0.5) * 0.12, vy = -(math.random() * 0.08 + 0.03), ph = math.random() * 6.28}
    end

    -- ── Light Rays ──
    D.rays = {}
    for i = 1, 3 do
        local w = PctX(30 + math.random(0, 40))
        local angle = math.rad(-30 + math.random(0, 60))
        local x1 = (S.X / 4) * i
        D.rays[i] = New("Triangle", {
            PointA = Vector2.new(x1 - w / 2, 0),
            PointB = Vector2.new(x1 + w / 2, 0),
            PointC = Vector2.new(x1 + math.tan(angle) * S.Y, S.Y),
            Color = Theme.Primary, Transparency = 0.96, Visible = true, ZIndex = 1,
        })
    end

    -- ── Main Glass Panel ──
    local pw, ph = PctX(44), PctY(54)
    local px, py = CX - pw / 2, CY - ph / 2 + PctY(4)
    state.px, state.py = px, py
    state.pw, state.ph = pw, ph

    D.panelShadow = New("Square", {Size = Vector2.new(pw, ph), Position = Vector2.new(px + 5, py + 5), Color = Color3.new(0, 0, 0), Transparency = 0.75, Visible = false, ZIndex = 3})
    D.panel = New("Square", {Size = Vector2.new(pw, ph), Position = Vector2.new(px, py), Color = Theme.GlassBg, Transparency = 0.52, Visible = false, ZIndex = 4})
    D.panelBorder = New("Square", {Size = Vector2.new(pw, ph), Position = Vector2.new(px, py), Color = Theme.GlassBorder, Transparency = 0.68, Visible = false, ZIndex = 5, Thickness = 1})
    D.panelGlass = New("Square", {Size = Vector2.new(pw * 0.94, ph * 0.42), Position = Vector2.new(px + pw * 0.03, py + ph * 0.02), Color = Theme.White, Transparency = 0.95, Visible = false, ZIndex = 5})
    D.panelGlow = New("Square", {Size = Vector2.new(pw - 4, ph - 4), Position = Vector2.new(px + 2, py + 2), Color = Theme.Primary, Transparency = 0.95, Visible = false, ZIndex = 5})

    -- ── Logo Area ──
    local logoCenterY = py + PctY(8)
    state.logoY = logoCenterY

    D.logoGlow1 = New("Circle", {Radius = 80, Position = Vector2.new(CX, logoCenterY), Color = Theme.Primary, Transparency = 1, Visible = false, ZIndex = 6, NumSides = 40})
    D.logoGlow2 = New("Circle", {Radius = 55, Position = Vector2.new(CX, logoCenterY), Color = Theme.Cyan, Transparency = 1, Visible = false, ZIndex = 7, NumSides = 32})
    D.logoGlow3 = New("Circle", {Radius = 35, Position = Vector2.new(CX, logoCenterY), Color = Theme.PrimaryLight, Transparency = 1, Visible = false, ZIndex = 8, NumSides = 24})
    D.logoReflect = New("Square", {Size = Vector2.new(PctX(16), PctY(4)), Position = Vector2.new(CX - PctX(8), logoCenterY + PctY(5)), Color = Theme.Primary, Transparency = 1, Visible = false, ZIndex = 8})

    D.logoTitle = New("Text", {Text = "Hansz Hub", Size = 30, Position = Vector2.new(CX, py + PctY(16)), Color = Theme.White, Transparency = 1, Visible = true, ZIndex = 10, Center = true})
    D.logoSub = New("Text", {Text = "Premium Roblox Script", Size = 13, Position = Vector2.new(CX, py + PctY(20)), Color = Theme.Gray, Transparency = 1, Visible = true, ZIndex = 10, Center = true})

    -- Logo depth layers for 3D effect (will be filled by LoadLogo)
    D.logoDepth = {}

    -- ── Circular Ring Loader ──
    local rcX, rcY = CX, py + PctY(28)
    state.rcX, state.rcY = rcX, rcY
    local oR, iR = 26, 16
    state.oR, state.iR = oR, iR
    local segs = Config.RingSegments
    state.segs = segs

    D.ringOuter = {}
    D.ringInner = {}
    D.ringGlow = {}
    D.ringTrail = {}
    for i = 1, segs do
        local a = (i - 1) / segs * math.pi * 2
        D.ringOuter[i] = New("Circle", {Radius = 3.5, Position = Vector2.new(rcX + math.cos(a) * oR, rcY + math.sin(a) * oR), Color = Theme.Primary, Transparency = 1, Visible = true, ZIndex = 12})
        D.ringGlow[i] = New("Circle", {Radius = 7, Position = Vector2.new(rcX + math.cos(a) * oR, rcY + math.sin(a) * oR), Color = Theme.Primary, Transparency = 1, Visible = true, ZIndex = 11})
        D.ringInner[i] = New("Circle", {Radius = 2, Position = Vector2.new(rcX + math.cos(a) * iR, rcY + math.sin(a) * iR), Color = Theme.Cyan, Transparency = 1, Visible = true, ZIndex = 12})
        D.ringTrail[i] = New("Circle", {Radius = 1.5, Position = Vector2.new(rcX + math.cos(a) * (oR + 8), rcY + math.sin(a) * (oR + 8)), Color = Theme.CyanLight, Transparency = 1, Visible = true, ZIndex = 11})
    end

    -- ── Loading Bar ──
    local bW, bH = PctX(30), PctY(1.0)
    local bX, bY = CX - bW / 2, py + PctY(32.5)
    local bH2 = bH * 1.8
    state.bW, state.bH = bW, bH2
    state.bX, state.bY = bX, bY

    D.barBG = New("Square", {Size = Vector2.new(bW, bH2), Position = Vector2.new(bX, bY - (bH2 - bH) / 2), Color = Color3.fromRGB(7, 9, 20), Transparency = 0.25, Visible = true, ZIndex = 12})
    D.barGlowBG = New("Square", {Size = Vector2.new(bW + 10, bH2 + 8), Position = Vector2.new(bX - 5, bY - (bH2 - bH) / 2 - 4), Color = Theme.Primary, Transparency = 0.93, Visible = true, ZIndex = 11})
    D.barProgress = New("Square", {Size = Vector2.new(0, bH2), Position = Vector2.new(bX, bY - (bH2 - bH) / 2), Color = Theme.Primary, Transparency = 1, Visible = true, ZIndex = 13})
    D.barGlow = New("Square", {Size = Vector2.new(0, bH2 + 6), Position = Vector2.new(bX - 3, bY - (bH2 - bH) / 2 - 3), Color = Theme.Primary, Transparency = 0.55, Visible = true, ZIndex = 12})
    D.barShine = New("Square", {Size = Vector2.new(PctX(5), bH2 * 0.5), Position = Vector2.new(bX - PctX(5), bY - (bH2 - bH) / 2 + bH2 * 0.25), Color = Theme.White, Transparency = 0.75, Visible = true, ZIndex = 14})
    D.barBorder = New("Square", {Size = Vector2.new(bW, bH2), Position = Vector2.new(bX, bY - (bH2 - bH) / 2), Color = Theme.GlassBorder, Transparency = 0.6, Visible = true, ZIndex = 14, Thickness = 1})

    -- ── Percentage ──
    D.percent = New("Text", {Text = "0%", Size = 17, Position = Vector2.new(CX + bW / 2 + PctX(4.5), bY + bH2 / 2), Color = Theme.PrimaryLight, Transparency = 1, Visible = true, ZIndex = 15, Center = true})

    -- ── Loading Text ──
    D.loadText = New("Text", {Text = LoadingTexts[1], Size = 13, Position = Vector2.new(CX, py + PctY(35.5)), Color = Theme.GrayLight, Transparency = 1, Visible = true, ZIndex = 15, Center = true})

    -- ── Status Items ──
    D.statIcon = {}
    D.statText = {}
    for i = 1, Config.StatusCount do
        local sy = py + PctY(37) + (i - 1) * PctY(2.4)
        D.statIcon[i] = New("Text", {Text = "○", Size = 11, Position = Vector2.new(bX + PctX(2), sy), Color = Theme.Gray, Transparency = 1, Visible = true, ZIndex = 15})
        D.statText[i] = New("Text", {Text = StatusList[i], Size = 11, Position = Vector2.new(bX + PctX(5), sy), Color = Theme.Gray, Transparency = 1, Visible = true, ZIndex = 15})
    end

    -- ── Tips ──
    D.tip = New("Text", {Text = TipsList[1], Size = 11, Position = Vector2.new(CX, py + ph - PctY(4.5)), Color = Theme.Gray, Transparency = 0.6, Visible = true, ZIndex = 15, Center = true})

    -- ─── Sparks ──
    D.sparks = {}
    for i = 1, Config.SparkCount do
        D.sparks[i] = New("Circle", {Radius = math.random() * 1.2 + 0.3, Position = Vector2.new(CX + (math.random() - 0.5) * PctX(28), CY + (math.random() - 0.5) * PctY(18)), Color = Color3.fromRGB(255, 235, 190), Transparency = 0.4, Visible = false, ZIndex = 3})
        state.sparkData[i] = {x = D.sparks[i].Position.X, y = D.sparks[i].Position.Y, vx = (math.random() - 0.5) * 0.45, vy = -math.random() * 0.35 - 0.05, life = math.random() * 0.6 + 0.2, ph = math.random() * 6.28}
    end

    -- ── Notification ──
    local nw, nh = PctX(24), PctY(9)
    state.nw, state.nh = nw, nh
    local nx, ny = S.X - nw - PctX(2), PctY(3)
    state.nx, state.ny = nx, ny

    D.notif = New("Square", {Size = Vector2.new(nw, nh), Position = Vector2.new(S.X + nw, ny), Color = Theme.GlassBg, Transparency = 0.15, Visible = false, ZIndex = 50})
    D.notifBorder = New("Square", {Size = Vector2.new(nw, nh), Position = Vector2.new(S.X + nw, ny), Color = Theme.Success, Transparency = 0.5, Visible = false, ZIndex = 51, Thickness = 1})
    D.notifGlow = New("Square", {Size = Vector2.new(nw + 8, nh + 8), Position = Vector2.new(S.X + nw - 4, ny - 4), Color = Theme.Success, Transparency = 0.88, Visible = false, ZIndex = 49})
    D.notifIcon = New("Text", {Text = "✔", Size = 18, Position = Vector2.new(nx + PctX(3), ny + PctY(2)), Color = Theme.Success, Transparency = 1, Visible = false, ZIndex = 52})
    D.notifTitle = New("Text", {Text = "Hansz Hub Loaded Successfully", Size = 13, Position = Vector2.new(nx + PctX(8.5), ny + PctY(1.2)), Color = Theme.White, Transparency = 1, Visible = false, ZIndex = 52})
    D.notifDesc = New("Text", {Text = "Script berhasil dijalankan.", Size = 11, Position = Vector2.new(nx + PctX(8.5), ny + PctY(5)), Color = Theme.Gray, Transparency = 1, Visible = false, ZIndex = 52})
    D.notifTimer = New("Square", {Size = Vector2.new(nw - PctX(2), 2), Position = Vector2.new(nx + PctX(1), ny + nh - 3), Color = Theme.Success, Transparency = 1, Visible = false, ZIndex = 52})
end

-- ============================================================================
-- LOAD LOGO
-- ============================================================================
function LoadLogo()
    local imageData = nil

    if LOGO_USE_BASE64 and LOGO_BASE64_DATA ~= "" then
        imageData = LOGO_BASE64_DATA
    else
        local ok, res = pcall(readfile, LOGO_PATH)
        if ok and res then
            imageData = res
        end
    end

    if imageData then
        D.logoImage = New("Image", {
            Data = imageData,
            Size = Vector2.new(140, 140),
            Position = Vector2.new(CX, state.logoY),
            Color = Theme.White,
            Transparency = 1,
            Visible = false,
            ZIndex = 10,
        })

        -- Depth layers for 3D effect
        for idx = 1, 3 do
            D.logoDepth[idx] = New("Image", {
                Data = imageData,
                Size = Vector2.new(140, 140),
                Position = Vector2.new(CX + idx * 2, state.logoY + idx * 1.5),
                Color = Theme.Primary,
                Transparency = 1,
                Visible = false,
                ZIndex = 9 - idx,
            })
        end
    else
        -- Fallback text logo
        D.logoImage = New("Text", {
            Text = "◈",
            Size = 52,
            Position = Vector2.new(CX, state.logoY),
            Color = Theme.Primary,
            Transparency = 1,
            Visible = false,
            ZIndex = 10,
            Center = true,
        })
        D.logoDepth = {}
    end
end

-- ============================================================================
-- ANIMATE BACKGROUND
-- ============================================================================
function AnimateBackground(dt)
    -- Overlay
    D.bgOverlay.Transparency = clamp(1 - state.bgDarkness, 0, 1)

    -- Gradient strips
    for i, g in ipairs(D.grads) do
        local oy = math.sin(state.time * 0.25 + i * 0.7) * PctY(2.5)
        local stripH = math.ceil(S.Y / Config.GradientStrips) + 1
        g.Position = Vector2.new(0, (i - 1) * stripH + oy)
        g.Color = Color3.new(
            clamp(Theme.Primary.R + math.sin(state.time * 0.18 + i * 0.55) * 0.05, 0.15, 0.4),
            clamp(Theme.Primary.G + math.sin(state.time * 0.12 + i * 0.65) * 0.05, 0.3, 0.65),
            clamp(Theme.Primary.B + math.sin(state.time * 0.22 + i * 0.45) * 0.05, 0.45, 0.85)
        )
    end

    -- Bokeh
    for i, b in ipairs(D.bokehs) do
        local ph = i * 1.5 + state.time * 0.06
        local dx = math.sin(ph * 0.4) * PctX(4)
        local dy = math.cos(ph * 0.6) * PctY(3)
        local ox = (S.X / (Config.BokehCount + 1)) * i
        local oy = S.Y * (0.2 + (i % 3) * 0.3)
        b.Position = Vector2.new(ox + dx, oy + dy)
        b.Radius = 80 + i * 20 + math.sin(state.time * 0.2 + i) * 10
        b.Color = lerpC(Theme.Primary, Theme.Cyan, (math.sin(state.time * 0.15 + i * 0.7) + 1) / 2)
    end

    -- Glow circles
    for i, g in ipairs(D.glowCircles) do
        local gd = state.glowData[i]
        local dx = math.sin(state.time * gd.spd + gd.phase) * PctX(10)
        local dy = math.cos(state.time * gd.spd * 0.6 + gd.phase) * PctY(7)
        g.Position = Vector2.new(gd.ox + dx, gd.oy + dy)
        local pulse = (math.sin(state.time * 0.4 + gd.phase) + 1) / 2
        g.Transparency = 0.9 + pulse * 0.05
        g.Radius = gd.r + math.sin(state.time * 0.25 + gd.phase) * 12
        g.Color = lerpC(Theme.Primary, Theme.Accent, pulse)
    end

    -- Neon lines
    for i, ng in ipairs(D.neonGlows) do
        ng.Transparency = 0.95 + math.sin(state.time * 0.7 + i * 1.1) * 0.03
    end

    -- Light rays
    for i, r in ipairs(D.rays) do
        r.Transparency = 0.95 + math.sin(state.time * 0.15 + i * 0.8) * 0.03
    end

    -- Particles
    for i, p in ipairs(D.particles) do
        local pd = state.particleData[i]
        pd.x = pd.x + pd.vx
        pd.y = pd.y + pd.vy
        if pd.x < -10 then pd.x = S.X + 10 end
        if pd.x > S.X + 10 then pd.x = -10 end
        if pd.y < -10 then pd.y = S.Y + 10 end
        if pd.y > S.Y + 10 then pd.y = -10 end
        p.Position = Vector2.new(pd.x, pd.y)
        p.Transparency = 1 - (pd.a * (0.8 + math.sin(state.time * 0.5 + pd.ph) * 0.2))
    end

    -- Dust
    for i, d in ipairs(D.dust) do
        local dd = state.dustData[i]
        dd.x = dd.x + dd.vx
        dd.y = dd.y + dd.vy
        if dd.y < -5 then dd.y = S.Y + 5 end
        if dd.x < -5 then dd.x = S.X + 5 end
        if dd.x > S.X + 5 then dd.x = -5 end
        d.Position = Vector2.new(dd.x, dd.y)
        d.Transparency = 0.45 + math.sin(state.time * 0.25 + dd.ph) * 0.3
    end

    -- Sparks
    for i, sp in ipairs(D.sparks) do
        local sd = state.sparkData[i]
        sd.x = sd.x + sd.vx
        sd.y = sd.y + sd.vy
        sd.life = sd.life - dt * 0.12
        if sd.life <= 0 then
            sd.x = CX + (math.random() - 0.5) * PctX(24)
            sd.y = CY + (math.random() - 0.5) * PctY(16)
            sd.life = math.random() * 0.8 + 0.3
            sd.vx = (math.random() - 0.5) * 0.4
            sd.vy = -math.random() * 0.3 - 0.05
        end
        sp.Position = Vector2.new(sd.x, sd.y)
        sp.Transparency = lerp(0.15, 0.85, 1 - sd.life)
        sp.Visible = state.introDone
        sp.Color = lerpC(Color3.fromRGB(255, 235, 190), Color3.fromRGB(180, 200, 255), (math.sin(state.time * 0.5 + sd.ph) + 1) / 2)
    end
end

-- ============================================================================
-- ANIMATE LOGO
-- ============================================================================
function AnimateLogo(dt)
    local logo = D.logoImage
    if not logo then return end

    local fi = state.fadeIn
    local ls = state.logoScale

    -- Base size
    local baseW, baseH = 140, 140
    local scale = ls * (1 + math.sin(state.time * 0.5) * 0.015)
    local w, h = baseW * scale, baseH * scale

    -- Floating animation
    local floatY = math.sin(state.time * 0.7) * 3
    local floatX = math.sin(state.time * 0.4) * 1.5

    -- Position
    local lx = CX + floatX
    local ly = state.logoY + floatY

    logo.Size = Vector2.new(w, h)
    logo.Position = Vector2.new(lx, ly)
    logo.Transparency = clamp(1 - fi, 0, 1)
    logo.Visible = true

    -- Neon glow circles behind logo
    local glowAlpha = fi * (0.5 + math.sin(state.time * 0.8) * 0.15)
    D.logoGlow1.Radius = 75 * scale + math.sin(state.time * 0.5) * 6
    D.logoGlow1.Position = Vector2.new(lx, ly)
    D.logoGlow1.Transparency = clamp(1 - glowAlpha * 0.4, 0.5, 1)
    D.logoGlow1.Visible = fi > 0.1

    D.logoGlow2.Radius = 50 * scale + math.sin(state.time * 0.7 + 1) * 4
    D.logoGlow2.Position = Vector2.new(lx, ly)
    D.logoGlow2.Transparency = clamp(1 - glowAlpha * 0.25, 0.6, 1)
    D.logoGlow2.Visible = fi > 0.15
    D.logoGlow2.Color = lerpC(Theme.Cyan, Theme.PrimaryLight, (math.sin(state.time * 0.6) + 1) / 2)

    D.logoGlow3.Radius = 32 * scale + math.sin(state.time * 0.9 + 2) * 3
    D.logoGlow3.Position = Vector2.new(lx, ly)
    D.logoGlow3.Transparency = clamp(1 - glowAlpha * 0.65, 0.35, 1)
    D.logoGlow3.Visible = fi > 0.2

    -- Reflection below logo
    local refY = ly + h / 2 + PctY(1.5)
    D.logoReflect.Size = Vector2.new(w * 0.8, PctY(3))
    D.logoReflect.Position = Vector2.new(lx - w * 0.4, refY)
    local refAlpha = fi * (0.4 + math.sin(state.time * 0.5) * 0.1)
    D.logoReflect.Transparency = clamp(1 - refAlpha, 0.5, 1)
    D.logoReflect.Visible = fi > 0.2
    D.logoReflect.Color = lerpC(Theme.Primary, Theme.Cyan, (math.sin(state.time * 0.3) + 1) / 2)

    -- Depth layers (3D effect)
    for idx, dl in ipairs(D.logoDepth) do
        local offsetX = math.sin(state.time * (0.3 + idx * 0.1) + idx) * 2.5
        local offsetY = math.sin(state.time * (0.2 + idx * 0.08) + idx) * 2
        dl.Size = Vector2.new(w, h)
        dl.Position = Vector2.new(lx + idx * 1.8 + offsetX, ly + idx * 1.2 + offsetY)
        local dlAlpha = fi * (0.35 - idx * 0.1)
        dl.Transparency = clamp(1 - dlAlpha, 0.55, 1)
        dl.Visible = fi > 0.1
        dl.Color = lerpC(Theme.PrimaryDark, Theme.Primary, idx == 1 and 0.5 or 0.3)
    end

    -- Text fade
    D.logoTitle.Transparency = clamp(1 - fi, 0, 1)
    D.logoSub.Transparency = clamp(1 - fi * 0.8, 0.2, 1)
end

-- ============================================================================
-- UPDATE PROGRESS
-- ============================================================================
function UpdateProgress(dt)
    if state.finishing then return end

    local target = Config.ProgressTargets[state.targetIdx]
    if not target then
        state.progress = 100
        FinishLoading()
        return
    end

    local diff = target - state.progress
    if math.abs(diff) < 0.08 then
        state.progress = target
        state.targetIdx = state.targetIdx + 1
        if target >= 100 then
            FinishLoading()
        end
        return
    end

    state.progress = lerp(state.progress, target, dt * Config.ProgressEase)
    state.progress = clamp(state.progress, 0, 100)
end

-- ============================================================================
-- UPDATE STATUS
-- ============================================================================
function UpdateStatus(dt)
    -- Loading text
    state.loadTextTm = state.loadTextTm + dt
    if state.loadTextTm > 1.6 and state.loadTextIdx < #LoadingTexts then
        state.loadTextIdx = state.loadTextIdx + 1
        state.loadTextTm = 0
        state.loadTextFd = 0
    end
    if state.loadTextFd < 1 then
        state.loadTextFd = state.loadTextFd + dt * Config.FadeSpeed
    end
    local ltf = inOutCubic(clamp(state.loadTextFd, 0, 1))
    D.loadText.Text = LoadingTexts[state.loadTextIdx]
    D.loadText.Transparency = clamp(1 - ltf * state.fadeIn, 0, 1)

    -- Status checklist
    for i = 1, Config.StatusCount do
        local threshold = (i / Config.StatusCount) * 0.7
        if state.progress / 100 > threshold then
            state.statusItems[i].done = true
            state.statusItems[i].alpha = math.min(state.statusItems[i].alpha + dt * 2.8, 1)
        end
        local sa = cubic(state.statusItems[i].alpha)
        D.statIcon[i].Transparency = clamp(1 - sa * state.fadeIn, 0, 1)
        D.statText[i].Transparency = clamp(1 - sa * state.fadeIn, 0, 1)

        if state.statusItems[i].done and sa > 0.4 then
            D.statIcon[i].Text = "✔"
            D.statIcon[i].Color = Theme.Success
            D.statText[i].Color = lerpC(Theme.Gray, Theme.Success, (sa - 0.4) * 1.66)
        else
            D.statIcon[i].Text = "○"
            D.statIcon[i].Color = Theme.Gray
            D.statText[i].Color = Theme.Gray
        end
    end

    -- Tips
    state.tipTm = state.tipTm + dt
    if state.tipTm > Config.TipInterval then
        state.tipTm = 0
        state.tipIdx = (state.tipIdx % #TipsList) + 1
        state.tipFd = 0
    end
    if state.tipFd < 1 then
        state.tipFd = state.tipFd + dt * 1.6
    end
    local tf = inOutCubic(clamp(state.tipFd, 0, 1))
    D.tip.Text = TipsList[state.tipIdx]
    D.tip.Transparency = clamp(lerp(1, 0.55, tf * state.fadeIn), 0, 1)
end

-- ============================================================================
-- FINISH LOADING
-- ============================================================================
function FinishLoading()
    if state.finished then return end
    state.finished = true
    state.finishing = true
    state.menuPhase = 1
    state.finishTimer = 0
    state.progress = 100

    task.spawn(function()
        task.wait(0.3)
        ShowNotification()
    end)

    -- Shine sweep flash at finish
    D.barShine.Transparency = 0.3
    D.barProgress.Color = Theme.CyanLight
    D.barGlow.Color = Theme.CyanLight
end

-- ============================================================================
-- SHOW NOTIFICATION
-- ============================================================================
function ShowNotification()
    local n = state.notif
    n.active = true
    n.timer = 0
    n.slide = 0
    n.alpha = 0

    D.notif.Visible = true
    D.notifBorder.Visible = true
    D.notifGlow.Visible = true
    D.notifIcon.Visible = true
    D.notifTitle.Visible = true
    D.notifDesc.Visible = true
    D.notifTimer.Visible = true

    D.notif.Transparency = 1
    D.notifBorder.Transparency = 1
    D.notifGlow.Transparency = 1
    D.notifIcon.Transparency = 1
    D.notifTitle.Transparency = 1
    D.notifDesc.Transparency = 1
    D.notifTimer.Transparency = 1
end

-- ============================================================================
-- DESTROY LOADING ONLY (keep background for menu)
-- ============================================================================
local function DestroyLoadingOnly()
    local keepKeys = {
        bg=true, bgOverlay=true, grads=true, bokehs=true,
        glowCircles=true, neonLines=true, neonGlows=true,
        particles=true, dust=true, rays=true,
    }
    for k, obj in pairs(D) do
        if keepKeys[k] then
            -- keep background elements for menu
        elseif type(obj) == "table" then
            for _, sub in pairs(obj) do
                pcall(function() sub:Destroy() end)
            end
            D[k] = nil
        else
            pcall(function() obj:Destroy() end)
            D[k] = nil
        end
    end
end

-- ============================================================================
-- DESTROY LOADER
-- ============================================================================
function DestroyLoader()
    for _, obj in pairs(D) do
        if type(obj) == "table" then
            for _, sub in pairs(obj) do
                pcall(function() sub:Destroy() end)
            end
        else
            pcall(function() obj:Destroy() end)
        end
    end
    for k in pairs(D) do D[k] = nil end
    state.running = false
end

-- ============================================================================
-- MAIN UPDATE LOOP (called every frame)
-- ============================================================================
function UpdateFrame(dt)
    state.time = state.time + dt

    AnimateBackground(dt)
    AnimateLogo(dt)

    -- Panel slide
    local slideOff = (1 - state.panelSlide) * PctY(18)
    local pY = state.py + slideOff

    D.panelShadow.Position = Vector2.new(state.px + 5, pY + 5)
    D.panel.Position = Vector2.new(state.px, pY)
    D.panelBorder.Position = Vector2.new(state.px, pY)
    D.panelGlass.Position = Vector2.new(state.px + state.pw * 0.03, pY + state.ph * 0.02)
    D.panelGlow.Position = Vector2.new(state.px + 2, pY + 2)

    local pVis = state.panelSlide > 0.01
    D.panelShadow.Visible = pVis
    D.panel.Visible = pVis
    D.panelBorder.Visible = pVis
    D.panelGlass.Visible = pVis
    D.panelGlow.Visible = pVis

    -- Panel glow breathing
    local breath = (math.sin(state.time * 0.7) + 1) / 2
    D.panelGlow.Transparency = 0.93 + breath * 0.04
    D.panelGlow.Color = lerpC(Theme.Primary, Theme.Accent, breath * 0.25)
    D.panelBorder.Transparency = 0.68 + (math.sin(state.time * 0.5) + 1) / 2 * 0.12
    D.panelBorder.Color = lerpC(Theme.GlassBorder, Theme.Cyan, (math.sin(state.time * 0.4) + 1) / 2 * 0.4)

    -- Circular ring loader
    state.ringAngle = state.ringAngle + dt * 2.8
    state.innerAngle = state.innerAngle - dt * 3.5
    local segs = state.segs

    for i = 1, segs do
        local a = state.ringAngle + (i - 1) / segs * math.pi * 2
        local x = state.rcX + math.cos(a) * state.oR
        local y = state.rcY + math.sin(a) * state.oR
        D.ringOuter[i].Position = Vector2.new(x, y)
        D.ringGlow[i].Position = Vector2.new(x, y)

        local a2 = state.innerAngle + (i - 1) / segs * math.pi * 2
        local x2 = state.rcX + math.cos(a2) * state.iR
        local y2 = state.rcY + math.sin(a2) * state.iR
        D.ringInner[i].Position = Vector2.new(x2, y2)

        local a3 = state.ringAngle + (i - 1) / segs * math.pi * 2 + 0.3
        local x3 = state.rcX + math.cos(a3) * (state.oR + 9)
        local y3 = state.rcY + math.sin(a3) * (state.oR + 9)
        D.ringTrail[i].Position = Vector2.new(x3, y3)

        local wave = (math.sin(state.ringAngle - (i - 1) / segs * math.pi * 2) + 1) / 2
        local wave2 = (math.sin(state.innerAngle - (i - 1) / segs * math.pi * 2) + 1) / 2
        local wave3 = (math.sin(state.ringAngle - (i - 1) / segs * math.pi * 2 + 0.5) + 1) / 2

        D.ringOuter[i].Transparency = 1 - (0.25 + wave * 0.75) * state.fadeIn
        D.ringInner[i].Transparency = 1 - (0.2 + wave2 * 0.8) * state.fadeIn
        D.ringGlow[i].Transparency = lerp(1, 0.72 - wave * 0.22, state.fadeIn)
        D.ringTrail[i].Transparency = 1 - (wave3 * 0.5) * state.fadeIn

        D.ringOuter[i].Color = lerpC(Theme.Primary, Theme.Cyan, wave)
        D.ringInner[i].Color = lerpC(Theme.Cyan, Theme.PrimaryLight, wave2)
        D.ringGlow[i].Color = lerpC(Theme.Primary, Theme.Cyan, wave)
        D.ringTrail[i].Color = lerpC(Theme.CyanLight, Theme.PrimaryLight, wave3)

        local rVis = state.panelSlide > 0.4
        D.ringOuter[i].Visible = rVis
        D.ringInner[i].Visible = rVis
        D.ringGlow[i].Visible = rVis
        D.ringTrail[i].Visible = rVis
    end

    -- Loading bar
    local prog = state.progress / 100
    local bw = state.bW * prog

    D.barProgress.Size = Vector2.new(math.max(bw, 0), state.bH)
    D.barGlow.Size = Vector2.new(math.max(bw + 8, 0), state.bH + 6)
    D.barGlow.Position = Vector2.new(state.bX - 4, state.bY - (state.bH - PctY(1.0)) / 2 - 3)
    D.barProgress.Position = Vector2.new(state.bX, state.bY - (state.bH - PctY(1.0)) / 2)

    local barC = lerpC(Theme.Primary, Theme.Cyan, prog)
    D.barProgress.Color = barC
    D.barGlow.Color = barC

    -- Shine sweep
    local shineX = state.bX - PctX(5) + (state.bW + PctX(10)) * ((state.time * 0.35 + state.progress * 0.01) % 1)
    D.barShine.Position = Vector2.new(shineX, state.bY - state.bH * 0.5 + state.bH * 0.25)
    D.barShine.Size = Vector2.new(PctX(5), state.bH * 0.5)
    D.barShine.Transparency = 0.7 + math.sin(state.time * 4) * 0.08

    -- Percentage
    D.percent.Text = tostring(math.floor(state.progress)) .. "%"
    D.percent.Transparency = clamp(1 - state.fadeIn, 0, 1)

    -- Visibility based on intro state
    if not state.introDone then
        local sfx = state.fadeIn
        D.logoTitle.Visible = sfx > 0.01
        D.logoSub.Visible = sfx > 0.01
        D.barProgress.Visible = sfx > 0.01
        D.barGlow.Visible = sfx > 0.01
        D.barShine.Visible = sfx > 0.01
        D.barBG.Visible = sfx > 0.01
        D.barGlowBG.Visible = sfx > 0.01
        D.barBorder.Visible = sfx > 0.01
        D.percent.Visible = sfx > 0.01
        D.loadText.Visible = sfx > 0.01
        D.tip.Visible = sfx > 0.01
    end

    -- Finishing animation
    if state.finishing then
        state.finishTimer = state.finishTimer + dt
        local fp = clamp(state.finishTimer / 1.6, 0, 1)

        if fp < 0.45 then
            local sp = outBack(clamp(fp / 0.45, 0, 1))
            local logo = D.logoImage
            if logo then
                local baseW, baseH = 140, 140
                local curScale = state.logoScale
                local newScale = curScale * (1 + sp * 0.06)
                logo.Size = Vector2.new(baseW * newScale, baseH * newScale)
            end
            D.logoGlow3.Transparency = clamp(D.logoGlow3.Transparency - dt * 0.5, 0.15, 1)
            D.logoGlow2.Transparency = clamp(D.logoGlow2.Transparency - dt * 0.3, 0.4, 1)
        else
            local fo = (fp - 0.45) / 0.55
            local fv = inOutCubic(clamp(fo, 0, 1))

            if D.logoImage then
                local img = D.logoImage
                img.Transparency = fv
                for _, dl in ipairs(D.logoDepth) do dl.Transparency = lerp(dl.Transparency, 1, fv) end
            end

            D.logoGlow1.Transparency = lerp(D.logoGlow1.Transparency, 1, fv)
            D.logoGlow2.Transparency = lerp(D.logoGlow2.Transparency, 1, fv)
            D.logoGlow3.Transparency = lerp(D.logoGlow3.Transparency, 1, fv)
            D.logoReflect.Transparency = lerp(D.logoReflect.Transparency, 1, fv)
            D.logoTitle.Transparency = fv
            D.logoSub.Transparency = lerp(D.logoSub.Transparency, 1, fv)
            D.barProgress.Transparency = fv
            D.barGlow.Transparency = lerp(D.barGlow.Transparency, 1, fv)
            D.barShine.Transparency = lerp(D.barShine.Transparency, 1, fv)
            D.barBG.Transparency = lerp(D.barBG.Transparency, 1, fv)
            D.barGlowBG.Transparency = lerp(D.barGlowBG.Transparency, 1, fv)
            D.barBorder.Transparency = lerp(D.barBorder.Transparency, 1, fv)
            D.percent.Transparency = fv
            D.loadText.Transparency = fv
            D.tip.Transparency = lerp(D.tip.Transparency, 1, fv)
            D.panel.Transparency = lerp(D.panel.Transparency, 1, fv)
            D.panelBorder.Transparency = lerp(D.panelBorder.Transparency, 1, fv)
            D.panelGlass.Transparency = lerp(D.panelGlass.Transparency, 1, fv)
            D.panelGlow.Transparency = lerp(D.panelGlow.Transparency, 1, fv)
            D.panelShadow.Transparency = lerp(D.panelShadow.Transparency, 1, fv)
            state.bgDarkness = lerp(state.bgDarkness, 0, fv)

            for i = 1, Config.StatusCount do
                D.statIcon[i].Transparency = lerp(D.statIcon[i].Transparency, 1, fv)
                D.statText[i].Transparency = lerp(D.statText[i].Transparency, 1, fv)
            end

            for i = 1, state.segs do
                D.ringOuter[i].Transparency = lerp(D.ringOuter[i].Transparency, 1, fv)
                D.ringInner[i].Transparency = lerp(D.ringInner[i].Transparency, 1, fv)
                D.ringGlow[i].Transparency = lerp(D.ringGlow[i].Transparency, 1, fv)
                D.ringTrail[i].Transparency = lerp(D.ringTrail[i].Transparency, 1, fv)
            end

            if fp >= 1 then
                state.menuPhase = 2
            end
        end
    end

    -- Notification animation
    if state.notif and state.notif.active then
        local n = state.notif
        n.timer = n.timer + dt

        if n.slide < 1 then
            n.slide = math.min(n.slide + dt * 2.8, 1)
        end
        if n.alpha < 1 then
            n.alpha = math.min(n.alpha + dt * 3.5, 1)
        end

        local ns = outBack(n.slide)
        local nw, nh = state.nw, state.nh
        local nx, ny = state.nx, state.ny
        local sx = S.X + nw - (S.X + nw - nx) * ns

        D.notif.Position = Vector2.new(sx, ny)
        D.notifBorder.Position = Vector2.new(sx, ny)
        D.notifGlow.Position = Vector2.new(sx - 4, ny - 4)

        D.notif.Transparency = lerp(1, 0.15, n.alpha)
        D.notifBorder.Transparency = lerp(1, 0.5, n.alpha)
        D.notifGlow.Transparency = lerp(1, 0.88, n.alpha)
        D.notifIcon.Transparency = lerp(1, 0, n.alpha)
        D.notifTitle.Transparency = lerp(1, 0, n.alpha)
        D.notifDesc.Transparency = lerp(1, 0, n.alpha)
        D.notifTimer.Transparency = lerp(1, 0, n.alpha)

        local tp = 1 - (n.timer / Config.NotificationTime)
        D.notifTimer.Size = Vector2.new(math.max((nw - PctX(2)) * tp, 0), 2)

        if n.timer >= Config.NotificationTime then
            n.alpha = n.alpha - dt * 3
            if n.alpha <= 0 then
                D.notif.Visible = false
                D.notifBorder.Visible = false
                D.notifGlow.Visible = false
                D.notifIcon.Visible = false
                D.notifTitle.Visible = false
                D.notifDesc.Visible = false
                D.notifTimer.Visible = false
                n.active = false
            end
        end
    end
end

-- ============================================================================
-- INTRO ANIMATION
-- ============================================================================
function AnimateIntro()
    local t = 0
    local dur = Config.IntroDuration
    while t < dur and state.running do
        local dt = task.wait(1 / Config.FrameRate)
        t = t + dt
        local p = clamp(t / dur, 0, 1)

        state.bgDarkness = lerp(0, 0.7, cubic(clamp(p * 2, 0, 1)))
        state.fadeIn = lerp(0, 1, quart(clamp((p - 0.08) / 0.55, 0, 1)))
        state.logoScale = lerp(0, 1, quint(clamp((p - 0.05) / 0.5, 0, 1)))
        state.panelSlide = lerp(0, 1, outBack(clamp((p - 0.18) / 0.65, 0, 1)))

        UpdateFrame(dt)
    end
    state.introDone = true
end

-- ============================================================================
-- MAIN MENU - Hansz Hub Premium UI
-- ============================================================================

-- Menu Drawing table
local M = {}

-- Menu state
local MenuSt = {
    visible = false, alpha = 0, scale = 0, bounce = 0, glowAlpha = 0,
    activeTab = "Home",
    sidebarHover = false, sidebarHoverItem = nil, sidebarHoverTimer = 0,
    sidebarWidth = MenuConfig.SidebarWidth, sidebarTargetWidth = MenuConfig.SidebarWidth,
    sidebarAnimatedWidth = MenuConfig.SidebarWidth,
    windowPos = Vector2.new(CX - MenuConfig.WindowWidth / 2, CY - MenuConfig.WindowHeight / 2),
    windowSize = Vector2.new(MenuConfig.WindowWidth, MenuConfig.WindowHeight),
    dragging = false, dragOffset = Vector2.new(0, 0),
    toggles = {}, notifs = {}, time = 0,
}
MenuSt.sidebarTargetWidth = MenuConfig.SidebarWidth

-- Helpers
local function PtIn(px, py, rx, ry, rw, rh)
    return px >= rx and px <= rx + rw and py >= ry and py <= ry + rh
end

local function MRect(k, p)
    M[k] = Drawing.new("Square")
    for kk, vv in pairs(p) do M[k][kk] = vv end
    return M[k]
end

local function MText(k, p)
    M[k] = Drawing.new("Text")
    for kk, vv in pairs(p) do M[k][kk] = vv end
    return M[k]
end

local function MCircle(k, p)
    M[k] = Drawing.new("Circle")
    for kk, vv in pairs(p) do M[k][kk] = vv end
    return M[k]
end

local function WX() return MenuSt.windowPos.X end
local function WY() return MenuSt.windowPos.Y end
local function WW() return MenuSt.windowSize.X end
local function WH() return MenuSt.windowSize.Y end

-- ============================================================================
-- CREATE TOGGLE
-- ============================================================================
function CreateToggle(tag, x, y, key)
    local tw, th = 34, 20
    if MenuSt.toggles[key] == nil then
        MenuSt.toggles[key] = { on = false, slide = 0, targetSlide = 0 }
    end
    local ts = MenuSt.toggles[key]
    MRect(tag.."tr", {Size=Vector2.new(tw,th), Position=Vector2.new(x,y), Color=Theme.Gray, Transparency=0.65, Visible=false, ZIndex=48})
    MRect(tag.."gl", {Size=Vector2.new(tw+6,th+6), Position=Vector2.new(x-3,y-3), Color=Theme.Primary, Transparency=1, Visible=false, ZIndex=47})
    MCircle(tag.."kn", {Radius=7, Position=Vector2.new(x+th/2,y+th/2), Color=Theme.White, Transparency=0.15, Visible=false, ZIndex=49, NumSides=20})
    ts.draw = {tr=tag.."tr", gl=tag.."gl", kn=tag.."kn"}
    ts.x, ts.y, ts.w, ts.h, ts.key = x, y, tw, th, key
end

-- ============================================================================
-- CREATE WINDOW
-- ============================================================================
function CreateWindow()
    local wx, wy, ww, wh = WX(), WY(), WW(), WH()
    MRect("winSh", {Size=Vector2.new(ww+8,wh+8), Position=Vector2.new(wx-4+4,wy-4+4), Color=Color3.new(0,0,0), Transparency=0.85, Visible=false, ZIndex=20})
    MRect("winBg", {Size=Vector2.new(ww,wh), Position=Vector2.new(wx,wy), Color=Color3.fromRGB(6,8,22), Transparency=0.08, Visible=false, ZIndex=21})
    MRect("winBrd", {Size=Vector2.new(ww,wh), Position=Vector2.new(wx,wy), Color=Color3.fromRGB(30,35,60), Transparency=0.55, Visible=false, ZIndex=22, Thickness=1})
    MRect("winGlw", {Size=Vector2.new(ww+12,wh+12), Position=Vector2.new(wx-6,wy-6), Color=Theme.Primary, Transparency=0.92, Visible=false, ZIndex=19})
    MRect("winHl", {Size=Vector2.new(ww-4,2), Position=Vector2.new(wx+2,wy+2), Color=Theme.Primary, Transparency=0.45, Visible=false, ZIndex=23})
end

-- ============================================================================
-- CREATE SIDEBAR
-- ============================================================================
function CreateSidebar()
    local wx, wy, ww, wh = WX(), WY(), WW(), WH()
    local sw = MenuConfig.SidebarWidth
    MRect("sb", {Size=Vector2.new(sw,wh), Position=Vector2.new(wx,wy), Color=Color3.fromRGB(8,10,24), Transparency=0.12, Visible=false, ZIndex=25})
    MRect("sbd", {Size=Vector2.new(1,wh-10), Position=Vector2.new(wx+sw-1,wy+5), Color=Theme.Primary, Transparency=0.8, Visible=false, ZIndex=26})

    local items = {{"⌂","Home"},{"▶","Main"},{"⚡","Player"},{"▣","Vehicle"},{"⊕","Teleport"},{"☰","Utility"},{"⚙","Settings"},{"ℹ","About"}}
    M.si = {}
    for i, v in ipairs(items) do
        local iy = wy + 48 + (i-1) * 38
        local idx = "si"..i
        M.si[i] = {idx=idx, nm=v[2], ic=v[1], y=iy, ha=0, aa=0}
        MRect(idx.."bg", {Size=Vector2.new(sw-4,34), Position=Vector2.new(wx+2,iy+2), Color=Color3.fromRGB(20,25,50), Transparency=1, Visible=false, ZIndex=26})
        MRect(idx.."ac", {Size=Vector2.new(3,30), Position=Vector2.new(wx+1,iy+4), Color=Theme.Primary, Transparency=1, Visible=false, ZIndex=27})
        MText(idx.."ic", {Text=v[1], Size=18, Position=Vector2.new(wx+sw/2,iy+19), Color=Color3.fromRGB(170,178,210), Transparency=1, Visible=false, ZIndex=28, Center=true})
        MText(idx.."lb", {Text=v[2], Size=13, Position=Vector2.new(wx+sw+12,iy+19), Color=Color3.fromRGB(170,178,210), Transparency=1, Visible=false, ZIndex=28})
    end
end

-- ============================================================================
-- CREATE HEADER
-- ============================================================================
function CreateHeader()
    local wx, wy, ww, wh = WX(), WY(), WW(), WH()
    local sw, hh = MenuConfig.SidebarWidth, 40
    MRect("hd", {Size=Vector2.new(ww-sw,hh), Position=Vector2.new(wx+sw,wy), Color=Color3.fromRGB(10,12,28), Transparency=0.15, Visible=false, ZIndex=30})
    MRect("hdd", {Size=Vector2.new(ww-sw-20,1), Position=Vector2.new(wx+sw+10,wy+hh), Color=Theme.Primary, Transparency=0.85, Visible=false, ZIndex=30})
    MText("hdT", {Text="Hansz Hub", Size=16, Position=Vector2.new(wx+sw+14,wy+hh/2), Color=Theme.White, Transparency=1, Visible=false, ZIndex=31})
    MText("hdS", {Text="Premium Executor Script", Size=10, Position=Vector2.new(wx+sw+100,wy+hh/2), Color=Color3.fromRGB(110,118,155), Transparency=1, Visible=false, ZIndex=31})
    local cx = wx + ww - 10
    MText("mn", {Text="—", Size=16, Position=Vector2.new(cx-44,wy+hh/2), Color=Color3.fromRGB(110,118,155), Transparency=1, Visible=false, ZIndex=32, Center=true})
    MText("mx", {Text="□", Size=14, Position=Vector2.new(cx-22,wy+hh/2), Color=Color3.fromRGB(110,118,155), Transparency=1, Visible=false, ZIndex=32, Center=true})
    MText("cl", {Text="✕", Size=16, Position=Vector2.new(cx,wy+hh/2), Color=Color3.fromRGB(110,118,155), Transparency=1, Visible=false, ZIndex=32, Center=true})
end

-- ============================================================================
-- CREATE HOME PAGE
-- ============================================================================
function CreateHomePage(px, py, pw, ph)
    MText("hmT", {Text="Welcome Back,", Size=22, Position=Vector2.new(px+pw/2,py+20), Color=Theme.White, Transparency=1, Visible=false, ZIndex=40, Center=true})
    MText("hmS", {Text="Hansz Hub Ready", Size=14, Position=Vector2.new(px+pw/2,py+42), Color=Color3.fromRGB(96,165,250), Transparency=1, Visible=false, ZIndex=40, Center=true})
    local status = {{"✔","Executor Connected",Theme.Success},{"✔","Script Loaded",Theme.Success},{"✔","UI Ready",Theme.Success},{"✔","Security Active",Theme.Success}}
    local cw, ch = (pw-30)/2, 36
    for i, v in ipairs(status) do
        local col, row = (i-1)%2, math.floor((i-1)/2)
        local cx, cy = px+5+col*(cw+10), py+62+row*(ch+8)
        MRect("hc"..i.."bg", {Size=Vector2.new(cw,ch), Position=Vector2.new(cx,cy), Color=Color3.fromRGB(14,18,38), Transparency=0.2, Visible=false, ZIndex=40})
        MRect("hc"..i.."br", {Size=Vector2.new(cw,ch), Position=Vector2.new(cx,cy), Color=Color3.fromRGB(30,35,60), Transparency=0.6, Visible=false, ZIndex=41, Thickness=1})
        MText("hc"..i.."ic", {Text=v[1], Size=14, Position=Vector2.new(cx+16,cy+ch/2), Color=v[3], Transparency=1, Visible=false, ZIndex=42, Center=true})
        MText("hc"..i.."tx", {Text=v[2], Size=12, Position=Vector2.new(cx+32,cy+ch/2), Color=Theme.White, Transparency=1, Visible=false, ZIndex=42})
    end
end

-- ============================================================================
-- CREATE FEATURE CARDS
-- ============================================================================
function MakeCards(pageKey, px, py, pw, ph, features)
    local cw, ch, gap = (pw-15)/2, 70, 10
    M[pageKey.."Cd"] = {}
    for i, feat in ipairs(features) do
        local col, row = (i-1)%2, math.floor((i-1)/2)
        local cx, cy = px+col*(cw+gap), py+row*(ch+gap)
        local idx = pageKey.."c"..i
        local tk = pageKey.."_"..feat.name
        M[pageKey.."Cd"][i] = {x=cx, y=cy, w=cw, h=ch, nm=feat.name, tk=tk}
        MRect(idx.."bg", {Size=Vector2.new(cw,ch), Position=Vector2.new(cx,cy), Color=Color3.fromRGB(14,18,38), Transparency=0.2, Visible=false, ZIndex=45})
        MRect(idx.."br", {Size=Vector2.new(cw,ch), Position=Vector2.new(cx,cy), Color=Color3.fromRGB(30,35,60), Transparency=0.6, Visible=false, ZIndex=46, Thickness=1})
        MRect(idx.."gl", {Size=Vector2.new(cw+4,ch+4), Position=Vector2.new(cx-2,cy-2), Color=Theme.Primary, Transparency=1, Visible=false, ZIndex=44})
        MText(idx.."ic", {Text=feat.icon, Size=20, Position=Vector2.new(cx+22,cy+ch/2-6), Color=Color3.fromRGB(96,165,250), Transparency=1, Visible=false, ZIndex=47, Center=true})
        MText(idx.."nm", {Text=feat.name, Size=13, Position=Vector2.new(cx+48,cy+18), Color=Theme.White, Transparency=1, Visible=false, ZIndex=47})
        MText(idx.."ds", {Text=feat.desc, Size=10, Position=Vector2.new(cx+48,cy+38), Color=Color3.fromRGB(110,118,155), Transparency=1, Visible=false, ZIndex=47})
        CreateToggle(idx.."tg", cx+cw-32, cy+ch/2-8, tk)
    end
end

-- ============================================================================
-- CREATE PAGES
-- ============================================================================
function CreatePages()
    local wx, wy, ww, wh = WX(), WY(), WW(), WH()
    local sw, hh, fh = MenuConfig.SidebarWidth, 40, 28
    local px, py = wx+sw+10, wy+hh+8
    local pw, ph = ww-sw-20, wh-hh-fh-16

    CreateHomePage(px, py, pw, ph)
    MakeCards("m", px, py, pw, ph, {
        {icon="⚡", name="Auto Farm", desc="Auto collect & farm"},
        {icon="📦", name="Auto Collect", desc="Auto collect items"},
        {icon="💰", name="Auto Sell", desc="Auto sell items"},
        {icon="⬆", name="Auto Upgrade", desc="Auto upgrade gear"},
        {icon="👁", name="ESP", desc="See targets through walls"},
        {icon="📍", name="Teleport", desc="Quick teleport mode"},
        {icon="🛡", name="Auto Shield", desc="Auto activate shield"},
        {icon="🎯", name="Auto Quest", desc="Auto complete quests"},
    })
    MakeCards("p", px, py, pw, ph, {
        {icon="⚡", name="Speed Boost", desc="Increase walk speed"},
        {icon="🛡", name="God Mode", desc="Become invincible"},
        {icon="👁", name="Wall Hack", desc="See through walls"},
        {icon="💨", name="Jump Power", desc="Super jump"},
        {icon="🎯", name="Aimbot", desc="Auto aim at targets"},
        {icon="🔄", name="Reset Char", desc="Respawn character"},
    })
    MakeCards("v", px, py, pw, ph, {
        {icon="🚗", name="Car Spawn", desc="Spawn a vehicle"},
        {icon="⚡", name="V-Speed", desc="Vehicle speed hack"},
        {icon="🛩", name="Fly Mode", desc="Make vehicle fly"},
        {icon="🔧", name="Auto Repair", desc="Auto repair vehicle"},
        {icon="💎", name="Unlock All", desc="Unlock all vehicles"},
        {icon="🎨", name="Custom Paint", desc="Change vehicle color"},
    })
    MakeCards("t", px, py, pw, ph, {
        {icon="📍", name="TP Tool", desc="Click to teleport"},
        {icon="🏠", name="To Spawn", desc="Teleport to spawn"},
        {icon="⭐", name="Save Loc", desc="Save current pos"},
        {icon="📋", name="Load Loc", desc="Load saved pos"},
        {icon="🎲", name="Random TP", desc="Random teleport"},
        {icon="🔄", name="Last Pos", desc="Go back to last pos"},
    })
    MakeCards("u", px, py, pw, ph, {
        {icon="🔄", name="Rejoin", desc="Rejoin the server"},
        {icon="🔐", name="Anti AFK", desc="Prevent auto kick"},
        {icon="📊", name="FPS Boost", desc="Optimize performance"},
        {icon="🔇", name="Mute Game", desc="Mute all sounds"},
        {icon="🧹", name="Clear Debris", desc="Remove map debris"},
        {icon="📁", name="Backup Cfg", desc="Save your settings"},
    })
    MakeCards("s", px, py, pw, ph, {
        {icon="🎨", name="Theme", desc="Dark / Light mode"},
        {icon="🔍", name="UI Scale", desc="Adjust interface size"},
        {icon="⚡", name="Anim Speed", desc="Smooth / Fast"},
        {icon="🌀", name="Blur", desc="Background blur effect"},
        {icon="🔔", name="Notification", desc="Show notifications"},
        {icon="🔊", name="Sound", desc="Toggle sound effects"},
    })
    CreateAboutPage(px, py, pw, ph)
end

-- ============================================================================
-- CREATE ABOUT PAGE
-- ============================================================================
function CreateAboutPage(px, py, pw, ph)
    local cx = px + pw/2
    MText("abTT", {Text="Hansz Hub", Size=26, Position=Vector2.new(cx,py+30), Color=Theme.White, Transparency=1, Visible=false, ZIndex=55, Center=true})
    MText("abST", {Text="Premium Roblox Script", Size=13, Position=Vector2.new(cx,py+58), Color=Color3.fromRGB(96,165,250), Transparency=1, Visible=false, ZIndex=55, Center=true})
    MText("abVR", {Text="Version 2.0.0", Size=12, Position=Vector2.new(cx,py+80), Color=Color3.fromRGB(110,118,155), Transparency=1, Visible=false, ZIndex=55, Center=true})
    MText("abDV", {Text="Developer: Hansz Hub Team", Size=12, Position=Vector2.new(cx,py+102), Color=Color3.fromRGB(110,118,155), Transparency=1, Visible=false, ZIndex=55, Center=true})
    MText("abCP", {Text="© 2024 Hansz Hub. All rights reserved.", Size=11, Position=Vector2.new(cx,py+124), Color=Color3.fromRGB(55,60,82), Transparency=1, Visible=false, ZIndex=55, Center=true})
end

-- ============================================================================
-- CREATE SEARCH
-- ============================================================================
function CreateSearch()
    local wx, wy, ww = WX(), WY(), WW()
    local sw, hh = MenuConfig.SidebarWidth, 40
    local sx, sy = wx+sw+12, wy+hh+8
    local sw2, sh2 = ww-sw-24, 28
    MRect("srBg", {Size=Vector2.new(sw2,sh2), Position=Vector2.new(sx,sy), Color=Color3.fromRGB(12,15,32), Transparency=0.15, Visible=false, ZIndex=50})
    MRect("srBr", {Size=Vector2.new(sw2,sh2), Position=Vector2.new(sx,sy), Color=Color3.fromRGB(30,35,60), Transparency=0.6, Visible=false, ZIndex=51, Thickness=1})
    MRect("srGl", {Size=Vector2.new(sw2+6,sh2+6), Position=Vector2.new(sx-3,sy-3), Color=Theme.Primary, Transparency=1, Visible=false, ZIndex=49})
    MText("srIc", {Text="⌕", Size=16, Position=Vector2.new(sx+14,sy+sh2/2), Color=Color3.fromRGB(110,118,155), Transparency=1, Visible=false, ZIndex=52, Center=true})
    MText("srPh", {Text="Search Feature...", Size=12, Position=Vector2.new(sx+30,sy+sh2/2), Color=Color3.fromRGB(110,118,155), Transparency=0.5, Visible=false, ZIndex=52})
    MText("srTx", {Text="", Size=12, Position=Vector2.new(sx+30,sy+sh2/2), Color=Theme.White, Transparency=1, Visible=false, ZIndex=52})
end

-- ============================================================================
-- CREATE FOOTER
-- ============================================================================
function CreateFooter()
    local wx, wy, ww, wh = WX(), WY(), WW(), WH()
    local sw, fh = MenuConfig.SidebarWidth, 28
    local fy = wy + wh - fh
    MRect("ftBg", {Size=Vector2.new(ww-sw,fh), Position=Vector2.new(wx+sw,fy), Color=Color3.fromRGB(8,10,22), Transparency=0.2, Visible=false, ZIndex=30})
    MRect("ftDv", {Size=Vector2.new(ww-sw-20,1), Position=Vector2.new(wx+sw+10,fy), Color=Theme.Primary, Transparency=0.85, Visible=false, ZIndex=30})
    local labels = {"Executor: Synapse","FPS: 60","Ping: 15ms","v2.0.0","Status: ✔"}
    for i, lbl in ipairs(labels) do
        local segW = (ww-sw) / #labels
        MText("fl"..i, {Text=lbl, Size=10, Position=Vector2.new(wx+sw+segW*(i-0.5),fy+fh/2), Color=Color3.fromRGB(110,118,155), Transparency=1, Visible=false, ZIndex=32, Center=true})
    end
end

-- ============================================================================
-- CREATE NOTIFICATION SYSTEM
-- ============================================================================
function CreateNotifSystem()
    M.notifObjs = {}
end

-- ============================================================================
-- SHOW MENU NOTIFICATION
-- ============================================================================
function ShowNotif(text, icon)
    icon = icon or "✔"
    local idx = #MenuSt.notifs + 1
    local nw, nh = 200, 32
    local nx, ny = S.X - nw - 12, 10 + (idx-1) * 38
    local tag = "nf"..idx
    local ns = {idx=idx, tag=tag, alpha=0, slide=0, timer=0, x=nx, y=ny, w=nw, h=nh, done=false}
    table.insert(MenuSt.notifs, ns)
    MRect(tag.."bg", {Size=Vector2.new(nw,nh), Position=Vector2.new(S.X+nw,ny), Color=Color3.fromRGB(14,18,38), Transparency=0.1, Visible=true, ZIndex=100})
    MRect(tag.."br", {Size=Vector2.new(nw,nh), Position=Vector2.new(S.X+nw,ny), Color=Theme.Success, Transparency=0.5, Visible=true, ZIndex=101, Thickness=1})
    MRect(tag.."gl", {Size=Vector2.new(nw+6,nh+6), Position=Vector2.new(S.X+nw-3,ny-3), Color=Theme.Success, Transparency=0.88, Visible=true, ZIndex=99})
    MText(tag.."ic", {Text=icon, Size=14, Position=Vector2.new(S.X+nw+16,ny+nh/2), Color=Theme.Success, Transparency=1, Visible=true, ZIndex=102, Center=true})
    MText(tag.."tx", {Text=text, Size=11, Position=Vector2.new(S.X+nw+34,ny+nh/2), Color=Theme.White, Transparency=1, Visible=true, ZIndex=102})
    MRect(tag.."tm", {Size=Vector2.new(nw-6,2), Position=Vector2.new(S.X+nw+3,ny+nh-3), Color=Theme.Success, Transparency=1, Visible=true, ZIndex=102})
end

-- ============================================================================
-- PAGE VISIBILITY PREFIXES
-- ============================================================================
local PagePrefixes = {
    Home     = {"hm", "hc"},
    Main     = {"m"},
    Player   = {"p"},
    Vehicle  = {"v"},
    Teleport = {"t"},
    Utility  = {"u"},
    Settings = {"s"},
    About    = {"ab"},
}

local function IsPageTag(tag, prefixes)
    for _, prefix in ipairs(prefixes) do
        if tag:sub(1, #prefix:match("^%a+")) == prefix:match("^%a+") then
            return true
        end
    end
    return false
end

-- Fixed tags that should always be visible
local FixedTags = {
    "winSh","winBg","winBrd","winGlw","winHl",
    "sb","sbd","si1","si2","si3","si4","si5","si6","si7","si8",
    "hd","hdd","hdT","hdS","mn","mx","cl",
    "srBg","srBr","srGl","srIc","srPh","srTx",
    "ftBg","ftDv", "fl1","fl2","fl3","fl4","fl5",
    "nf",
}

local function ShowPage(name)
    -- Hide all page-specific elements
    for tag, obj in pairs(M) do
        if type(obj) == "userdata" then
            local isFixed = false
            for _, ft in ipairs(FixedTags) do
                if tag == ft or tag:sub(1, #ft) == ft then
                    isFixed = true
                    break
                end
            end
            if not isFixed then
                -- Check if it belongs to any page
                for pn, prefixes in pairs(PagePrefixes) do
                    if IsPageTag(tag, prefixes) then
                        pcall(function() obj.Visible = false end)
                        break
                    end
                end
            end
        end
    end

    -- Show only the active page elements
    local activePrefixes = PagePrefixes[name]
    if activePrefixes then
        for tag, obj in pairs(M) do
            if type(obj) == "userdata" then
                if IsPageTag(tag, activePrefixes) then
                    pcall(function() obj.Visible = true end)
                end
            end
        end
    end
end

-- ============================================================================
-- SWITCH TAB
-- ============================================================================
function SwitchTab(name)
    MenuSt.activeTab = name
    ShowPage(name)
    ShowNotif("Switched to " .. name, "▶")
end

-- ============================================================================
-- TOGGLE TOGGLE
-- ============================================================================
function ToggleIt(key)
    local ts = MenuSt.toggles[key]
    if not ts then return end
    ts.on = not ts.on
    ts.targetSlide = ts.on and 1 or 0
    ShowNotif(key.." "..(ts.on and "Enabled" or "Disabled"), ts.on and "✔" or "✕")
end

-- ============================================================================
-- SHOW ALL MENU OBJECTS
-- ============================================================================
local function ShowAllMenuObjs()
    for _, v in pairs(M) do
        if type(v) == "userdata" then
            pcall(function() v.Visible = true end)
        end
    end
end

-- ============================================================================
-- HIDE ALL MENU OBJECTS
-- ============================================================================
local function HideAllMenuObjs()
    for _, v in pairs(M) do
        if type(v) == "userdata" then
            pcall(function() v.Visible = false end)
        end
    end
end

-- ============================================================================
-- ANIMATE MENU IN
-- ============================================================================
function AnimateMenuIn()
    MenuSt.visible = true
    ShowAllMenuObjs()
    local dur = MenuConfig.TransitionTime
    local t = 0
    while t < dur do
        local dt = task.wait(1/60)
        t = t + dt
        local p = clamp(t / dur, 0, 1)
        MenuSt.alpha = cubic(p)
        MenuSt.scale = outBack(clamp(p * 1.1, 0, 1))
        MenuSt.glowAlpha = clamp(p * 1.5, 0, 1)
        for _, v in pairs(M) do
            if type(v) == "userdata" and v.Transparency ~= nil then
                v.Transparency = 1 - MenuSt.alpha
            end
        end
    end
    for _, v in pairs(M) do
        if type(v) == "userdata" and v.Transparency ~= nil then
            v.Transparency = 0
        end
    end
end

-- ============================================================================
-- UPDATE TOGGLES
-- ============================================================================
function UpdateTog(dt)
    for _, ts in pairs(MenuSt.toggles) do
        local d = ts.draw
        if d then
            ts.slide = lerp(ts.slide, ts.targetSlide, dt * 5)
            local onVal = ts.slide
            if M[d.tr] then
                M[d.tr].Color = lerpC(Theme.Gray, Theme.Primary, onVal)
            end
            if M[d.kn] then
                local kx = ts.x + ts.h/2 + (ts.w - ts.h) * onVal
                M[d.kn].Position = Vector2.new(kx, ts.y + ts.h/2)
            end
            if M[d.gl] then
                M[d.gl].Transparency = 0.85 + (1 - onVal) * 0.15
            end
        end
    end
end

-- ============================================================================
-- UPDATE SIDEBAR
-- ============================================================================
function UpdateSide(dt)
    local wx, sw = WX(), MenuConfig.SidebarWidth
    for _, item in ipairs(M.si or {}) do
        local isAct = MenuSt.activeTab == item.nm
        local isHov = MenuSt.sidebarHoverItem == item.nm
        item.ha = lerp(item.ha, isHov and 1 or 0, dt * 6)
        item.aa = lerp(item.aa, isAct and 1 or 0, dt * 5)
        if M[item.idx.."bg"] then M[item.idx.."bg"].Transparency = 1 - item.ha * 0.7 end
        if M[item.idx.."ac"] then M[item.idx.."ac"].Transparency = 1 - item.aa end
        if M[item.idx.."lb"] then
            local la = clamp(item.ha + item.aa * 0.5, 0, 1)
            M[item.idx.."lb"].Transparency = 1 - la * 0.85
        end
    end
end

-- ============================================================================
-- UPDATE NOTIFICATIONS
-- ============================================================================
function UpdateNotifs(dt)
    local rem = {}
    for i, n in ipairs(MenuSt.notifs) do
        if n.done then table.insert(rem, i)
        else
            n.timer = n.timer + dt
            if n.slide < 1 then n.slide = math.min(n.slide + dt * 3.5, 1) end
            if n.alpha < 1 then n.alpha = math.min(n.alpha + dt * 4, 1) end
            local sx = S.X + n.w - (S.X + n.w - n.x) * outBack(n.slide)
            local tag = n.tag
            for _, o in ipairs({"bg","br","gl"}) do
                if M[tag..o] then M[tag..o].Position = Vector2.new(sx, n.y) end
            end
            if M[tag.."ic"] then M[tag.."ic"].Position = Vector2.new(sx+16, n.y+n.h/2) end
            if M[tag.."tx"] then M[tag.."tx"].Position = Vector2.new(sx+34, n.y+n.h/2) end
            if M[tag.."tm"] then M[tag.."tm"].Position = Vector2.new(sx+3, n.y+n.h-3) end
            for _, o in ipairs({"bg","br","gl"}) do
                if M[tag..o] then M[tag..o].Transparency = lerp(1, 0.12, n.alpha) end
            end
            if M[tag.."ic"] then M[tag.."ic"].Transparency = lerp(1, 0, n.alpha) end
            if M[tag.."tx"] then M[tag.."tx"].Transparency = lerp(1, 0, n.alpha) end
            if M[tag.."tm"] then
                M[tag.."tm"].Transparency = lerp(1, 0.3, n.alpha)
                local tp = 1 - (n.timer / MenuConfig.NotifDuration)
                M[tag.."tm"].Size = Vector2.new(math.max((n.w-6)*tp, 0), 2)
            end
            if n.timer >= MenuConfig.NotifDuration then
                n.alpha = n.alpha - dt * 4
                if n.alpha <= 0 then
                    for _, o in ipairs({"bg","br","gl","ic","tx","tm"}) do
                        if M[tag..o] then pcall(function() M[tag..o]:Destroy() end); M[tag..o] = nil end
                    end
                    n.done = true
                end
            end
        end
    end
    for i = #rem, 1, -1 do table.remove(MenuSt.notifs, rem[i]) end
end

-- ============================================================================
-- UPDATE MENU POSITIONS
-- ============================================================================
function UpdateMenuPos()
    local wx, wy, ww, wh = WX(), WY(), WW(), WH()
    local sw, hh, fh = MenuSt.sidebarAnimatedWidth, 40, 28

    if M.winSh then M.winSh.Position = Vector2.new(wx-4+4,wy-4+4) end
    if M.winBg then M.winBg.Position = Vector2.new(wx,wy) end
    if M.winBrd then M.winBrd.Position = Vector2.new(wx,wy) end
    if M.winGlw then M.winGlw.Position = Vector2.new(wx-6,wy-6); M.winGlw.Transparency = 0.9 + math.sin(MenuSt.time*0.5)*0.03 end
    if M.winHl then M.winHl.Position = Vector2.new(wx+2,wy+2); M.winHl.Transparency = 0.4 + math.sin(MenuSt.time*0.7)*0.15 end

    if M.sb then M.sb.Position = Vector2.new(wx,wy); M.sb.Size = Vector2.new(sw, wh) end
    if M.sbd then M.sbd.Position = Vector2.new(wx+sw-1,wy+5) end
    for _, item in ipairs(M.si or {}) do
        local iy = wy + 48 + (tonumber(item.idx:match("%d+"))-1) * 38
        if M[item.idx.."bg"] then M[item.idx.."bg"].Position = Vector2.new(wx+2, iy+2); M[item.idx.."bg"].Size = Vector2.new(sw-4, 34) end
        if M[item.idx.."ac"] then M[item.idx.."ac"].Position = Vector2.new(wx+1, iy+4) end
        if M[item.idx.."ic"] then M[item.idx.."ic"].Position = Vector2.new(wx+sw/2, iy+19) end
        if M[item.idx.."lb"] then M[item.idx.."lb"].Position = Vector2.new(wx+sw+12, iy+19) end
    end

    if M.hd then M.hd.Position = Vector2.new(wx+sw,wy) end
    if M.hdd then M.hdd.Position = Vector2.new(wx+sw+10,wy+hh) end
    if M.hdT then M.hdT.Position = Vector2.new(wx+sw+14,wy+hh/2) end
    if M.hdS then M.hdS.Position = Vector2.new(wx+sw+100,wy+hh/2) end
    local cx = wx + ww - 10
    if M.mn then M.mn.Position = Vector2.new(cx-44,wy+hh/2) end
    if M.mx then M.mx.Position = Vector2.new(cx-22,wy+hh/2) end
    if M.cl then M.cl.Position = Vector2.new(cx,wy+hh/2) end

    local sx, sy = wx+sw+12, wy+hh+8
    local sw2, sh2 = ww-sw-24, 28
    if M.srBg then M.srBg.Position = Vector2.new(sx,sy) end
    if M.srBr then M.srBr.Position = Vector2.new(sx,sy) end
    if M.srGl then M.srGl.Position = Vector2.new(sx-3,sy-3) end
    if M.srIc then M.srIc.Position = Vector2.new(sx+14,sy+sh2/2) end
    if M.srPh then M.srPh.Position = Vector2.new(sx+30,sy+sh2/2) end
    if M.srTx then M.srTx.Position = Vector2.new(sx+30,sy+sh2/2) end

    local fy = wy + wh - fh
    if M.ftBg then M.ftBg.Position = Vector2.new(wx+sw,fy) end
    if M.ftDv then M.ftDv.Position = Vector2.new(wx+sw+10,fy) end
    local labels = {"Executor: Synapse","FPS: "..tostring(math.floor(60+math.sin(MenuSt.time*0.5)*2)),"Ping: "..tostring(math.floor(15+math.sin(MenuSt.time*0.7)*3)).."ms","v2.0.0","Status: ✔"}
    for i, lbl in ipairs(labels) do
        local segW = (ww-sw) / 5
        if M["fl"..i] then M["fl"..i].Position = Vector2.new(wx+sw+segW*(i-0.5),fy+fh/2); M["fl"..i].Text = lbl end
    end
end

-- ============================================================================
-- UPDATE MENU
-- ============================================================================
function UpdateMenu(dt)
    MenuSt.time = MenuSt.time + dt
    if not MenuSt.visible then return end
    AnimateBackground(dt)
    -- Animate sidebar width
    MenuSt.sidebarAnimatedWidth = lerp(MenuSt.sidebarAnimatedWidth, MenuSt.sidebarTargetWidth, dt * 6)
    UpdateMenuPos()
    UpdateTog(dt)
    UpdateSide(dt)
    UpdateNotifs(dt)
end

-- ============================================================================
-- SETUP INPUT
-- ============================================================================
local inputSetupDone = false
function SetupInput()
    if inputSetupDone then return end
    inputSetupDone = true
    local ok, UIS = pcall(function() return game:GetService("UserInputService") end)
    if not ok then return end
    UIS.InputBegan:Connect(function(input, gpe)
        if gpe then return end
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            state.mouseDown = true
            state.mouseClicked = true
        end
    end)
    UIS.InputEnded:Connect(function(input, gpe)
        if gpe then return end
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            state.mouseDown = false
            MenuSt.dragging = false
        end
    end)
    UIS.InputChanged:Connect(function(input, gpe)
        if gpe then return end
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            state.mousePos = UIS:GetMouseLocation()
        end
    end)
end

-- ============================================================================
-- HANDLE CLICK
-- ============================================================================
function HandleClick()
    if not MenuSt.visible then return end
    local mx, my = state.mousePos.X, state.mousePos.Y
    local wx, wy, ww, wh = WX(), WY(), WW(), WH()
    local sw, hh = MenuSt.sidebarAnimatedWidth, 40

    -- Drag header
    if PtIn(mx, my, wx+sw, wy, ww-sw, hh) then
        MenuSt.dragging = true
        MenuSt.dragOffset = Vector2.new(mx-wx, my-wy)
        return
    end
    -- Close button
    local cx, cy = wx+ww-10, wy+hh/2
    if math.abs(mx-cx) < 12 and math.abs(my-cy) < 12 then
        return
    end
    -- Sidebar
    for _, item in ipairs(M.si or {}) do
        local iy = wy + 48 + (tonumber(item.idx:match("%d+"))-1) * 38
        if PtIn(mx, my, wx+2, iy+2, sw-4, 34) then
            SwitchTab(item.nm)
            return
        end
    end
    -- Toggles
    for _, ts in pairs(MenuSt.toggles) do
        if PtIn(mx, my, ts.x, ts.y, ts.w, ts.h) then
            ToggleIt(ts.key)
            return
        end
    end
end

-- ============================================================================
-- HANDLE HOVER
-- ============================================================================
function HandleHover()
    if not MenuSt.visible then return end
    local mx, my = state.mousePos.X, state.mousePos.Y
    local wx, wy = WX(), WY()
    local sw = MenuSt.sidebarAnimatedWidth

    -- Sidebar area hover (expand)
    MenuSt.sidebarHover = PtIn(mx, my, wx, wy, sw, WH())
    MenuSt.sidebarTargetWidth = MenuSt.sidebarHover and MenuConfig.SidebarExpanded or MenuConfig.SidebarWidth

    -- Sidebar item hover
    MenuSt.sidebarHoverItem = nil
    for _, item in ipairs(M.si or {}) do
        local iy = wy + 48 + (tonumber(item.idx:match("%d+"))-1) * 38
        if PtIn(mx, my, wx+2, iy+2, sw-4, 34) then
            MenuSt.sidebarHoverItem = item.nm
            break
        end
    end
end

-- ============================================================================
-- DRAG HANDLING
-- ============================================================================
function HandleDrag()
    if not MenuSt.dragging then return end
    local mx, my = state.mousePos.X, state.mousePos.Y
    local doff = MenuSt.dragOffset
    MenuSt.windowPos = Vector2.new(
        clamp(mx - doff.X, 10, S.X - WW() - 10),
        clamp(my - doff.Y, 10, S.Y - WH() - 10)
    )
end

-- ============================================================================
-- MENU UPDATE LOOP
-- ============================================================================
local menuRunning = false
function MenuLoop()
    if menuRunning then return end
    menuRunning = true
    state.menuRunning = true
    SetupInput()
    while state.menuRunning do
        local dt = task.wait(1/60)
        if state.mouseClicked then
            state.mouseClicked = false
            HandleClick()
        end
        HandleDrag()
        HandleHover()
        UpdateMenu(dt)
    end
    DestroyMenu()
end

-- ============================================================================
-- DESTROY MENU
-- ============================================================================
function DestroyMenu()
    for _, v in pairs(M) do
        if type(v) == "userdata" then pcall(function() v:Destroy() end)
        elseif type(v) == "table" then
            for _, sub in pairs(v) do if type(sub) == "userdata" then pcall(function() sub:Destroy() end) end end
        end
    end
    for k in pairs(M) do M[k] = nil end
end

-- ============================================================================
-- START MAIN MENU (called after loading completes)
-- ============================================================================
function StartMainMenu()
    DestroyLoadingOnly()
    CreateWindow()
    CreateSidebar()
    CreateHeader()
    CreatePages()
    CreateSearch()
    CreateFooter()
    CreateNotifSystem()
    ShowNotif("Hansz Hub Loaded Successfully", "✔")
    AnimateMenuIn()
    ShowPage("Home")
    ShowNotif("Menu Ready - Premium Mode", "✔")
    MenuLoop()
end

-- ============================================================================
-- MAIN EXECUTION
-- ============================================================================
CreateLoader()
LoadLogo()
AnimateIntro()

while state.running do
    local dt = task.wait(1 / Config.FrameRate)
    if state.introDone and not state.finishing then
        UpdateProgress(dt)
        UpdateStatus(dt)
    end
    UpdateFrame(dt)

    -- Transition to menu when loading finishes
    if state.menuPhase == 2 and not state.menuCreated then
        state.menuCreated = true
        break
    end
end

-- Start menu directly (keeps main thread alive) or cleanup
if state.menuCreated then
    task.wait(0.3)
    StartMainMenu()
else
    DestroyLoader()
end

print("Hansz Hub loaded successfully!")
