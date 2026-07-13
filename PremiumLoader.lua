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
                state.running = false
            end
        end
    end

    -- Notification animation
    if state.notification.active then
        local n = state.notification
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
end

DestroyLoader()

-- ============================================================================
-- EXECUTE MAIN SCRIPT AFTER LOADING
-- ============================================================================
print("Hansz Hub loaded successfully!")
