--[[
    ShitHax.lua
    The ultimate script for Project Delta.
    Authors: @daccesnet @heavydebt (Acid)
    Developers: @dacces @oxyhax @getpaul @networph @dema
]]--

do
    local env = getgenv and getgenv() or _G
    if not env.__bt_client_bypass and hookmetamethod and getnamecallmethod then
        env.__bt_client_bypass = true
        local traceback = debug.traceback
        local wrap = newcclosure or function(f)
            return f
        end
        local namecall
        namecall = hookmetamethod(game, "__namecall", wrap(function(self, ...)
            if getnamecallmethod() == "FireServer" and self.Name == "ProjectileInflict" and traceback():find("CharacterController") then
                return coroutine.yield()
            end
            return namecall(self, ...)
        end))
    end
end

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local TextChatService = game:GetService("TextChatService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local Debris = game:GetService("Debris")

while not Players.LocalPlayer do
    task.wait()
end

local lp = Players.LocalPlayer
local rgb = Color3.fromRGB
local v2 = Vector2.new
local v3 = Vector3.new
local dim2 = UDim2.new
local dim = UDim.new
local cseq = ColorSequence.new
local ckey = ColorSequenceKeypoint.new
local nseq = NumberSequence.new
local nkey = NumberSequenceKeypoint.new

local function merge(dst, src)
    for k, v in src do
        if type(v) == "table" and type(dst[k]) == "table" then
            merge(dst[k], v)
        elseif dst[k] == nil then
            dst[k] = type(v) == "table" and merge({}, v) or v
        end
    end
    return dst
end

local function esp_profile(bot)
    local white = rgb(255, 255, 255)
    local black = rgb(0, 0, 0)
    local function outline()
        return { enabled = true, color = black, transparency = 0 }
    end
    return {
        enabled = false,
        render_distance = 1300,
        box_enabled = false,
        box_gradient_1 = white,
        box_gradient_2 = white,
        box_gradient_transparency_1 = 0,
        box_gradient_transparency_2 = 0,
        box_rotation = 90,
        box_glow = false,
        box_glow_gradient_1 = white,
        box_glow_gradient_2 = white,
        box_glow_transparency_1 = 0.5,
        box_glow_transparency_2 = 0.5,
        box_fill_enabled = false,
        box_fill_gradient_1 = white,
        box_fill_gradient_2 = white,
        box_fill_transparency_1 = 0.5,
        box_fill_transparency_2 = 0.5,
        box_fill_rotation = 90,
        health_bar_enabled = false,
        bar_color_1 = rgb(0, 255, 0),
        bar_color_2 = rgb(255, 255, 0),
        bar_color_3 = rgb(255, 0, 0),
        bar_transparency_1 = 0,
        bar_transparency_2 = 0,
        bar_transparency_3 = 0,
        health_bar_glow_enabled = false,
        bar_glow_color_1 = rgb(0, 255, 0),
        bar_glow_color_2 = rgb(255, 255, 0),
        bar_glow_color_3 = rgb(255, 0, 0),
        bar_glow_transparency_1 = 0.7,
        bar_glow_transparency_2 = 0.7,
        bar_glow_transparency_3 = 0.7,
        health_bar_background_enabled = false,
        bar_background_color_1 = rgb(0, 51, 0),
        bar_background_color_2 = rgb(51, 51, 0),
        bar_background_color_3 = rgb(51, 0, 0),
        bar_background_transparency_1 = 0,
        bar_background_transparency_2 = 0,
        bar_background_transparency_3 = 0,
        bar_gradient_value = 3,
        bar_thickness = 1,
        health_flag_enabled = false,
        damaged_only = false,
        health_flag_position = "Left",
        health_flag_color = white,
        health_flag_transparency = 0,
        health_bar_tweening = false,
        health_bar_tween_time = 0.2,
        health_bar_style = Enum.EasingStyle.Circular,
        health_bar_direction = Enum.EasingDirection.InOut,
        name_enabled = false,
        name_color = white,
        name_transparency = 0,
        distance_enabled = false,
        distance_color = white,
        distance_transparency = 0,
        weapon_enabled = false,
        weapon_color = white,
        weapon_transparency = 0,
        weapon_icon_enabled = false,
        weapon_icon_color = white,
        weapon_icon_transparency = 0,
        weapon_icon_size = 22,
        weapon_icon_sampling = "Default",
        kd_enabled = false,
        kd_color = white,
        kd_transparency = 0,
        invisible_enabled = false,
        invisible_color = white,
        invisible_transparency = 0,
        desyncing_enabled = false,
        desyncing_threshold = 3,
        desyncing_color = white,
        desyncing_transparency = 0,
        visible_enabled = false,
        visible_color = white,
        visible_transparency = 0,
        chams_enabled = false,
        chams_color = white,
        chams_transparency = 0,
        chams_glow_enabled = false,
        chams_glow_color = white,
        chams_glow_transparency = 0,
        chams_glow_factor = 1,
        chams_glow_type = "Default",
        highlight = {
            enabled = false,
            depthmode = "AlwaysOnTop",
            fill = { color = white, transparency = 0.5 },
            outline = { color = white, transparency = 0 },
        },
        fonts = {
            name = { font = "Tahoma" },
            distance = { font = "Tahoma" },
            weapon = { font = "Tahoma" },
            health = { font = "Tahoma" },
            flags = { font = "Tahoma" },
        },
        outlines = {
            box = outline(),
            health_bar = outline(),
            health_flag = outline(),
            name_label = outline(),
            distance_label = outline(),
            weapon_label = outline(),
            visible_label = outline(),
            kd_label = outline(),
            invisible_label = outline(),
            desyncing_label = outline(),
        },
    }
end

local function other_profile()
    return {
        enabled = false,
        outline = true,
        outline_color = rgb(0, 0, 0),
        outline_transparency = 0,
        icon = false,
        icon_color = rgb(255, 255, 255),
        icon_transparency = 0,
        distance = false,
        font = "Tahoma",
        color = rgb(255, 255, 255),
        transparency = 0,
    }
end

local defaults = {
    ui_path = nil,
    stream_sync = { enabled = false, last_requested = {} },
    targeting = { current_target = nil, manipulated_direction = nil },
    framework = {
        data = nil,
        fps = nil,
        old = {
            springs = {
                leanAlpha = { Speed = 4, Force = 50 },
                jumpTilt = { Speed = 4, Force = 90 },
                walkCycle = { Speed = 4, Force = 50 },
                sprintCycle = { Speed = 4, Force = 50 },
                strafeTilt = { Speed = 4, Force = 50 },
                recoilRot = { Speed = 3, Force = 35 },
                cameraRecoil = { Speed = 6, Force = 100 },
                sway = { Speed = 4, Force = 100 },
                wallTouchTilt = { Speed = 4, Force = 50 },
            },
        },
    },
    resolver_connections = { resolver = {}, resolver_signals = {} },
    admins = {},
    clan_data = { last_refresh = 0, teammates = {} },
    part_cache = {},
    item_textures = {},
    reports = { attribute = 1 },
    character_cache = { transparency = {}, color = {}, material = {}, surface_appearances = {} },
    stored_surface_appearances = { weapon = {}, clothing = {} },
    original_arm_colors = {},
    viewmodel_cache = {},
    terrain = {},
    desync = { old = {} },
    session_data_map = {
        ["Player Count"] = "players_text",
        ["Server Time"] = "time_text",
        Weather = "weather_text",
        Visor = "visor_text",
        KD = "kd_text",
        Kills = "kills_text",
        Deaths = "deaths_text",
    },
    combat = {
        aiming = {
            silent_aim = false,
            hitchance = 100,
            hitboxes = { "Head" },
            existing_hitboxes = {
                "Head", "HeadTopHitBox", "FaceHitBox", "UpperTorso", "LowerTorso", "LeftUpperArm", "RightUpperArm",
                "LeftLowerArm", "RightLowerArm", "LeftHand", "RightHand", "LeftUpperLeg", "RightUpperLeg",
                "LeftLowerLeg", "RightLowerLeg", "LeftFoot", "RightFoot",
            },
            fov_radius = 150,
            ignore_fov = false,
            wall_check = false,
            dead_check = false,
            max_distance = { enabled = false, value = 1300 },
            targeting_type = "closest_to_mouse",
            prioritize_enemies = true,
            target_friendlies = false,
            target_players = true,
            target_ai = true,
            target_heli = true,
            aim_assist = { enabled = false, bind = false, type = "Camera", smoothness = 0.2 },
            auto_shoot = { enabled = false, delay = 0.01, interval = 0.2 },
        },
        visualization = {
            fov_enabled = false,
            fov_color_1 = rgb(45, 209, 235),
            fov_color_2 = rgb(203, 79, 104),
            fov_transparency_1 = 0,
            fov_transparency_2 = 0,
            thickness = 1,
            fov_outline = false,
            fov_outline_color = rgb(0, 0, 0),
            fov_outline_transparency = 0,
            fov_fill = false,
            fov_fill_color_1 = rgb(45, 209, 235),
            fov_fill_color_2 = rgb(203, 79, 104),
            fov_fill_transparency_1 = 0.5,
            fov_fill_transparency_2 = 0.5,
            fov_fill_glow = false,
            fill_glow_color_1 = rgb(45, 209, 235),
            fill_glow_color_2 = rgb(203, 79, 104),
            fill_glow_transparency_1 = 0.5,
            fill_glow_transparency_2 = 0.5,
            spin_gradients = false,
            spin_speed = 1,
            snapline_enabled = false,
            snapline_color_1 = rgb(45, 209, 235),
            snapline_color_2 = rgb(203, 79, 104),
            snapline_transparency_1 = 0,
            snapline_transparency_2 = 0,
            snapline_outline = false,
            snapline_outline_color = rgb(0, 0, 0),
            snapline_outline_transparency = 0,
            snapline_thickness = 1,
            bullet_tracers = {
                enabled = false,
                color_1 = rgb(45, 209, 235),
                color_2 = rgb(203, 79, 104),
                transparency_1 = 0,
                transparency_2 = 0,
                texture = "Neon",
                texture_speed = 3,
                randomize_curve = false,
                curve_1 = 0,
                curve_2 = 0,
                segments = 10,
                width = 0.1,
                lifetime = 1.5,
                bullet_textures = {
                    DNA = "rbxassetid://119094363918228",
                    Energy = "rbxassetid://6091329339",
                    Laser = "rbxassetid://7136858729",
                    Lightning = "rbxassetid://7151778302",
                    Neon = "rbxassetid://2950987173",
                    Pulsing = "rbxassetid://5889875399",
                },
            },
            bullet_impacts = { enabled = false, color = rgb(45, 209, 235), transparency = 0, material = "ForceField", lifetime = 1.5 },
            hitmarkers = {
                enabled = false,
                image = "Arrow",
                color = rgb(45, 209, 235),
                transparency = 0,
                outline = true,
                outline_color = rgb(0, 0, 0),
                outline_transparency = 0,
                lifetime = 1.5,
            },
            hit_vfx = { enabled = false, particles = { "Shards" }, rate = 40, lifetime = 0.3, color = rgb(45, 209, 235) },
            hitsounds = {
                hitsound_index = {
                    "Amongus", "Ara", "Cod", "Coin", "Csgo", "Fatality", "Gamesense", "Landing", "Neverlose",
                    "Noname", "Parry", "Rifk7", "Rust", "Snap", "Uwu",
                },
                head = { enabled = false, sound = "Neverlose", volume = 1, pitch = 1 },
                body = { enabled = false, sound = "Cod", volume = 1, pitch = 1 },
                kill = { enabled = false, sound = "Landing", volume = 1, pitch = 1 },
            },
            custom_shoot_sound = {
                enabled = false,
                sound = "M4A1 Suppressed",
                volume = 1,
                pitch = 1,
                sound_index = { "AWP", "Bonk", "Bow", "Deagle", "G3SG1", "M4A1 Suppressed", "MK23-S", "MSR", "R8 Revolver", "SCAR 20", "SPAS-12", "Scout" },
                sounds = {
                    AWP = "2753888131",
                    Bonk = "140110603417819",
                    Bow = "135482046225041",
                    Deagle = "18302188791",
                    G3SG1 = "18512294165",
                    ["M4A1 Suppressed"] = "8922741062",
                    ["MK23-S"] = "6117082165",
                    MSR = "2546411325",
                    ["R8 Revolver"] = "18302097184",
                    ["SCAR 20"] = "91510933153450",
                    ["SPAS-12"] = "6163224960",
                    Scout = "2476571739",
                },
            },
        },
        gun_mods = {
            remove_spread = false,
            remove_obstructions = false,
            remove_sprint_animation = false,
            remove_muzzle_effects = false,
            unlock_firemodes = false,
            double_tap = false,
            rapid_fire = { enabled = false, value = 1 },
            rapid_knife = { enabled = false, rate = 1 },
            wallbang = false,
            instant_bullet = false,
            instant_aim = false,
            instant_equip = false,
            instant_lean = false,
            no_recoil = false,
            no_sway = false,
            no_bobbing = false,
        },
        manipulation = { enabled = false, distance = 5 },
        resolvers = {
            use_sit = false,
            server_desync_resolver = { enabled = false },
            underground_resolver = { enabled = false, depth = 15, timeout = 1, method = "Classic", bind = false },
            peek = { enabled = false, height = 30, timeout = 1, method = "Classic", bind = false },
            tp_peek = { enabled = false, height = 50, timeout = 1, method = "Classic", bind = false },
        },
    },
    esp = merge(esp_profile(false), {
        box_type = "Static",
        dynamic_padding = 1.1,
        box_size = Vector2.new(3.6, 5),
        show_distance_format = true,
        distance_unit = "meters",
        distance_format = "m",
        text_case = "Lowercase",
        update_rate = 240,
        last_update = 0,
        selected_font = "Tahoma",
        character_added_connections = {},
        bots = esp_profile(true),
        other = {
            enabled = false,
            render_distance = 1300,
            exit = other_profile(),
            uaz = other_profile(),
            body = merge(other_profile(), { highlight_self_body = false, self_color = rgb(255, 255, 255), self_transparency = 0, self_color_image = rgb(255, 255, 255), self_transparency_image = 0 }),
            item = other_profile(),
            heli = other_profile(),
        },
    }),
    misc = {
        movement = {
            flyhack = { enabled = false, speed_horizontal = 20, speed_vertical = 20, multiplier = 1 },
            long_jump = { enabled = false, forward_force = 10, upward_force = 2, cooldown = 1, using = false },
            speedhack = { enabled = false, value = 20 },
            jumphack = { enabled = false, value = 3 },
            gravity = { enabled = false, value = workspace.Gravity },
            max_slope_angle = { enabled = false, value = 89 },
            remove_jump_cooldown = false,
            jesus = false,
            no_drown = false,
            remove_water_physics = false,
        },
        nofall = { enabled = false },
        multi_use = { enabled = false, times = 2, using = false },
        trash_talk = {
            enabled = false,
            tt_type = "Backtrack",
            trash_talking = false,
            phrases = {
                backtrack = {
                    "Forgot to set ur delay to 200ms? Nice backtrack bud.",
                    "ur backtrack isnt delayed enough for me 🤷",
                    "not even csgo gamesense backtrack is saving you. unlike my backtrack, yours sucks",
                    "i could beat you with only backtrack turned on 1ms buddy.",
                    "Imagine still being backtrack-less in 2025.",
                    "No backtrack, No talk",
                    "backtrack is the only thing keeping you relevant, bud",
                    "even my grandma’s reaction time is faster than your backtrack",
                    "your backtrack delay is so bad it feels like you're lagging IRL",
                    "without backtrack, you wouldn’t even win against bots",
                    "your aim relies on backtrack harder than training wheels on a bike",
                    "funny how your confidence disappears the second backtrack is off",
                    "all that backtrack, still can’t top frag",
                },
                casual = {
                    "backtrack is just like that. 🍿",
                    "oops, missed me again 😅",
                    "chasing shadows is my cardio 🤷",
                    "you tried! 😎",
                    "Imagine still being backtrack-less in 2025.",
                    "plot twist: I’m still alive 😏",
                    "that shot was optional 😜",
                    "trying to hit me? good luck! 🍀",
                    "missed again, huh? 😅",
                    "my angles are on vacation 🏖️",
                    "not even mad, just impressed 😏",
                    "you’ll get me next time… maybe 🤔",
                    "backtracking level: expert 👀",
                    "too slow, buddy! 🐢",
                    "my fake angles are a lifestyle 😎",
                    "just vibin’ here, don’t mind me 😌",
                },
                exploit = {
                    "u cant hit my fake angles (◣_◢)",
                    "keep dumping my fakes nn (◣_◢)",
                    "you’re chasing shadows again",
                    "missed me by a mile (◣_◢)",
                    "that shot was for decoration (◣_◢)",
                    "fake angles too strong (◣_◢)",
                    "i can tell by your kd that you are not cheating (◣_◢)",
                    "try hitting the real server now ◥▶_◀◤",
                    "your aim.exe has stopped responding (◣_◢)",
                    "don’t worry, my fakes are friendly ◥▶_◀◤",
                    "is your ragebot even on? (◣_◢)",
                    "peekaboo! (◣_◢)",
                    "can’t touch this",
                    "guess where I am? (◣_◢)",
                    "shadow strike activated",
                    "you’re too slow (◣_◢)",
                },
                passive = {
                    "oh wow, you actually hit that? good for you 🙂",
                    "must be nice having all that time to practice.",
                    "i guess everyone contributes in their own way…",
                    "wow, that was… definitely a strategy.",
                    "don’t worry, not everyone can be consistent.",
                    "huh, interesting choice… bold, even.",
                    "well, at least you tried… right?",
                    "impressive… if we’re measuring by effort alone.",
                    "oh, you did that? i hadn’t noticed.",
                    "that’s… certainly one way to do it.",
                },
            },
        },
        desync = {
            desync_toggle = false,
            freeze_delay = 2.5,
            client_desync = false,
            smooth = false,
            position_spoofer = { enabled = false, x = 0, y = 0, z = 0 },
            rotation_spoofer = {
                enabled = false,
                roll = 0,
                pitch = 0,
                yaw = 0,
                spin = {
                    roll = { enabled = false, speed = 1, value = 0 },
                    pitch = { enabled = false, speed = 1, value = 0 },
                    yaw = { enabled = false, speed = 1, value = 0 },
                },
            },
            animations = { enabled = false, animation = "rbxassetid://0", time_position = 0, speed = 0 },
            visualization = {
                server = {
                    enabled = false,
                    cham_type = "Default",
                    third_person_only = false,
                    use_tween = false,
                    visualize_animations = true,
                    color = { c = rgb(45, 209, 235), t = 0, f = 1.5 },
                },
            },
        },
        pitch = { enabled = false, value = 0 },
        detonation_mode = "All",
        uaz_spawn_type = "Nearest",
        selected_npcs = { "Blaze", "Mihkel", "Nurse", "Seryozha" },
        notifications = {
            flashing = false,
            join = { enabled = false, kd = false, hours_played = false, duration = 3 },
            leave = { enabled = false, duration = 3 },
            report = { enabled = false, sound = false, volume = 1, flashing = false, duration = 3 },
        },
    },
    visuals = {
        world = {
            remove_foliage = false,
            remove_trees = false,
            terrain_colors = {},
            notifications = { flare_fired = false, airdrop_dropped = false, flashing = false, duration = 3, sound = false, volume = 1 },
        },
        lighting = {
            override_ambient = false,
            ambient = rgb(0, 0, 0),
            outdoor_ambient = rgb(70, 70, 70),
            override_brightness = false,
            brightness = 2,
            override_clocktime = false,
            clock_time = 22.9,
            atmosphere = {
                override_fog = false,
                density = 0,
                offset = 0,
                override_fog_colors = false,
                color = rgb(255, 255, 255),
                decay = rgb(255, 255, 255),
                override_glare = false,
                glare = 0,
                override_haze = false,
                haze = 0,
            },
            bloom = { override_bloom = false, intensity = 0.5, size = 56, threshold = 0.8 },
        },
        viewmodel = {
            enabled = false,
            remove_clothing = false,
            weapon_enabled = false,
            weapon_material = "ForceField",
            weapon_color = rgb(45, 209, 235),
            weapon_transparency = 0,
            arms_enabled = false,
            arms_material = "ForceField",
            arms_color = rgb(45, 209, 235),
            arms_transparency = 0,
            offset = { enabled = false, x = 0, y = 0, z = 0 },
            highlight = {
                enabled = false,
                fill = { color = rgb(45, 209, 235), transparency = 0, multiplier = 1 },
                outline = { color = rgb(45, 209, 235), transparency = 0, multiplier = 1 },
            },
        },
        local_self = {
            third_person = false,
            third_person_value = 2,
            visualize_pitch = false,
            player_chams = false,
            player_material = "ForceField",
            player_color = rgb(45, 209, 235),
            player_transparency = 0,
            remove_clothing = false,
            aspect_ratio = { enabled = false, vertical = 50, horizontal = 50 },
            override_fov = false,
            default_fov = lp:WaitForChild("PlayerGui") and ReplicatedStorage:WaitForChild("Players"):WaitForChild(lp.Name):WaitForChild("Settings"):WaitForChild("GameplaySettings"):GetAttribute("DefaultFOV"),
            fov_value = 90,
            override_whiz = false,
            whiz_volume = 0.5,
        },
        crosshair = {
            enabled = false,
            color_1 = rgb(45, 209, 235),
            color_2 = rgb(45, 209, 235),
            color_transparency_1 = 0,
            color_transparency_2 = 0,
            gap = 18,
            length = 37,
            width = 1,
            outline = false,
            outline_color = rgb(0, 0, 0),
            outline_transparency = 0,
            rotation = 0,
            spin = false,
            spin_speed = 1,
            position = "Center",
            animation = {
                resize = false,
                speed = 1,
                t = 0,
                going_out = true,
                length = { resize = false, value = 19 },
                gap = { resize = false, value = 36 },
            },
        },
        ui_hide = { enabled = false, hide = false, elements = { "MainGui", "ServerInfo" } },
        ui_removals = { enabled = false, elements = { "Visor" } },
    },
}

getgenv().Backtrack = merge(getgenv().Backtrack or {}, defaults)
local config = getgenv().Backtrack
local settings = config

local function module(name, impl)
    return impl or {}
end

local library, themes
local character, humanoid, root_part, animator
local camera = workspace.CurrentCamera
local gui_parent = gethui and gethui() or game:GetService("CoreGui")
local terrain = workspace.Terrain
local terrain_defaults = {}
local default_gravity = workspace.Gravity
local current_target_part
local player_gui = lp:WaitForChild("PlayerGui")
local main_gui = player_gui:FindFirstChild("MainGui")

local function find(parent, name)
    return parent and parent:FindFirstChild(name)
end

local function new(class, props)
    local obj = Instance.new(class)
    local parent = props.Parent
    props.Parent = nil
    for k, v in props do
        obj[k] = v
    end
    if not props.Name then
        obj.Name = "\0"
    end
    if parent then
        obj.Parent = parent
    end
    return obj
end

local function player_data()
    return ReplicatedStorage:FindFirstChild("Players")
end

local function player_node(player)
    return find(player_data(), (player or lp).Name)
end

local function gameplay_settings()
    return find(find(player_node(), "Settings"), "GameplaySettings")
end

local function uac_node(player)
    local node = player_node(player)
    local status = find(node, "Status")
    local uac = find(status, "UAC") or find(find(find(node, "Journey"), "Status"), "UAC")
    if not uac and node then
        uac = node:FindFirstChild("UAC", true)
    end
    return uac
end

local world_cache = {}
local function world(name)
    local folder = world_cache[name]
    if folder and folder.Parent then
        return folder
    end
    if name == "Foliage" then
        folder = find(world("SpawnerZones"), "Foliage")
    else
        folder = workspace:FindFirstChild(name) or workspace:FindFirstChild(name, true)
    end
    world_cache[name] = folder
    return folder
end

local util = module("util")

function util:set_property(obj, prop, value)
    if obj and value ~= nil and obj[prop] ~= value then
        obj[prop] = value
    end
end

function util:set_visible(obj, visible)
    if obj and obj.Visible ~= visible then
        obj.Visible = visible
    end
end

function util:set_enabled(obj, enabled)
    if obj and obj.Enabled ~= enabled then
        obj.Enabled = enabled
    end
end

function util:set_property_group(obj, props)
    if not obj then
        return
    end
    for k, v in props do
        if v ~= nil and obj[k] ~= v then
            obj[k] = v
        end
    end
end

function util.get_world_pos(obj)
    if not obj then
        return nil
    end
    if obj:IsA("Model") then
        return obj:GetModelCFrame().Position
    elseif obj:IsA("BasePart") then
        return obj.Position
    end
    return nil
end

function util.get_root_cframe(part)
    local desync = settings.misc.desync
    if (desync.position_spoofer.enabled or desync.rotation_spoofer.enabled) and settings.desync.old.position then
        return settings.desync.old.position
    end
    return part and part.CFrame
end

function util.get_screen_pos(position)
    local point, visible = camera:WorldToViewportPoint(position)
    return Vector2.new(point.X, point.Y), visible
end

function util.get_head_pos()
    return character and find(character, "Head")
end

function util.get_hitboxes(model)
    local out = {}
    for _, name in settings.combat.aiming.hitboxes do
        local part = find(model, name)
        if part then
            table.insert(out, part)
        end
    end
    if settings.combat.aiming.target_heli then
        local pilot = find(find(find(find(world("AiZones"), "HeliAirfield"), "MI24V"), "Pilots"), "CollisionPilot")
        if pilot then
            table.insert(out, pilot)
        end
    end
    return out
end

local visibility_params = RaycastParams.new()
visibility_params.FilterType = Enum.RaycastFilterType.Exclude
visibility_params.IgnoreWater = true

function util.is_visible(origin, model, part)
    local filter = { camera }
    if character then
        table.insert(filter, character)
    end
    local no_collision = world("NoCollision")
    if no_collision then
        table.insert(filter, no_collision)
    end
    visibility_params.FilterDescendantsInstances = filter
    local result = workspace:Raycast(origin, part.Position - origin, visibility_params)
    return result ~= nil and result.Instance ~= nil and result.Instance:IsDescendantOf(model), result
end

function util.calculate_kd(stats)
    if not stats then
        return 0
    end
    local kills = stats:GetAttribute("Kills") or 0
    local deaths = stats:GetAttribute("Deaths") or 0
    if kills == 0 then
        return 0
    end
    return kills / (deaths == 0 and 1 or deaths)
end

function util.calculate_chance(percent)
    return math.random(1, 100) <= percent
end

function util.refresh_teammates()
    local clan = settings.clan_data
    local now = tick()
    if now - clan.last_refresh < 2 then
        return
    end
    clan.last_refresh = now
    clan.teammates = {}
    local clans = find(ReplicatedStorage, "Clans")
    if not clans then
        return
    end
    local me = lp.Name
    for _, squad in clans:GetChildren() do
        if squad:GetAttribute("Owner") == me or find(squad, me) ~= nil then
            local owner = squad:GetAttribute("Owner")
            if owner and owner ~= me then
                clan.teammates[owner] = true
            end
            for _, member in squad:GetChildren() do
                if member.Name ~= me then
                    clan.teammates[member.Name] = true
                end
            end
            break
        end
    end
end

function util.simulate_click()
    task.spawn(function()
        task.wait(settings.combat.aiming.auto_shoot.delay)
        if mouse1press then
            mouse1press()
            task.wait(0.05)
            mouse1release()
        end
    end)
end

function util.get_rank(player, group)
    local ok, rank = pcall(function()
        return player:GetRankInGroup(group)
    end)
    return ok and rank or 0
end

function util.is_admin(player)
    local ok, friends = pcall(function()
        return player:IsFriendsWith(17953224)
    end)
    local friend = ok and friends or false
    return util.get_rank(player, 4502303) >= 100 or util.get_rank(player, 13810797) >= 1 or util.get_rank(player, 3765739) >= 5 or friend
end

function util.on_admin_joined(name)
    library:notification({ text = "[!] Admin " .. name .. " has joined the server", flashing = true, time = 5, sound = true, sound_type = 2, volume = 1.5 })
    library.output.create_output({ text = "Admin " .. name .. " has joined the server", prefix = "WARN", color = library.colors.warning })
end

function util.on_admin_left(name)
    library:notification({ text = "[!] Admin " .. name .. " has left the server", flashing = true, time = 5, sound = true, sound_type = 2, volume = 1.5 })
    library.output.create_output({ text = "Admin " .. name .. " has left the server", prefix = "WARN", color = library.colors.warning })
end

function util.add_admin(player)
    if settings.admins[player] then
        return
    end
    settings.admins[player] = true
    util.on_admin_joined(player.Name)
end

function util.remove_admin(player)
    if settings.admins[player] then
        settings.admins[player] = nil
        util.on_admin_left(player.Name)
    end
end

local function log(text, prefix, color)
    if library and library.output and library.output.create_output then
        library.output.create_output({ text = text, prefix = prefix or "INFO", color = color })
    end
end

local function notify(text, flashing, time)
    if library then
        library:notification({ text = text, flashing = flashing or false, time = time or 5 })
    end
end

local function font_of(name)
    return library and (library.fonts[name] or library.font) or Font.fromEnum(Enum.Font.Code)
end

local font_sizes = {
    Tahoma = { size = 12, layout = 12, top = 3, label_padding = { name_label = -6, distance_label = 14, weapon_label = 26, health_flag = 9 } },
    Verdana = { size = 12, layout = 12, top = 3, label_padding = { name_label = -6, distance_label = 14, weapon_label = 26, health_flag = 9 } },
    ["Smallest Pixel"] = { size = 9, layout = 8, top = 1, label_padding = { name_label = -6, distance_label = 14, weapon_label = 26, health_flag = 9 } },
    Micro = { size = 7, layout = 8, top = 2, label_padding = { name_label = -2, distance_label = 13, weapon_label = 21, health_flag = 8 } },
    Minecraftia = { size = 10, layout = 10, top = 3, label_padding = { name_label = -4, distance_label = 14, weapon_label = 24, health_flag = 9 } },
    Monaco = { size = 9, layout = 10, top = 3, label_padding = { name_label = -5, distance_label = 14, weapon_label = 24, health_flag = 9 } },
    Nokia = { size = 9, layout = 10, top = 4, label_padding = { name_label = -3, distance_label = 15, weapon_label = 25, health_flag = 10 } },
}

local function font_size(name)
    return font_sizes[name] or font_sizes.Tahoma
end

local font_names = { "Micro", "Minecraftia", "Monaco", "Nokia", "Smallest Pixel", "Tahoma", "Verdana" }

local esp = module("esp")
local esp_cache = {}
local instance_state = { tracked = {} }
local esp_gui

esp.glow_shading_map = {
    Default = Enum.AdornShading.XRay,
    Occluded = Enum.AdornShading.Default,
    Shaded = Enum.AdornShading.XRayShaded,
}

esp.gradient_positions = { [1] = { 0, 1 }, [2] = { 0, 1 }, [3] = { 0, 0.5, 1 } }

function esp.format_text(text, case)
    if text == "" then
        return nil
    end
    if case == "Lowercase" then
        return text:lower()
    elseif case == "Uppercase" then
        return text:upper()
    elseif case == "Titlecase" then
        return (text:gsub("(%a)([%w']*)", function(first, rest)
            return first:upper() .. rest:lower()
        end))
    end
    return text
end

function esp.get_distance(distance)
    if settings.esp.show_distance_format then
        return distance .. settings.esp.distance_format
    end
    return tostring(distance)
end

function esp.path(path, value)
    local node = settings
    local keys = path:split(".")
    for i = 1, #keys - 1 do
        node = node[keys[i]]
    end
    node[keys[#keys]] = value
end

local function screen_gui()
    if not esp_gui or not esp_gui.Parent then
        esp_gui = new("ScreenGui", {
            Enabled = true,
            DisplayOrder = 9999999,
            IgnoreGuiInset = true,
            ZIndexBehavior = Enum.ZIndexBehavior.Global,
            ResetOnSpawn = false,
            Parent = gui_parent,
        })
    end
    return esp_gui
end

local function label_stroke(parent)
    return new("UIStroke", { Color = rgb(0, 0, 0), Thickness = 1, LineJoinMode = Enum.LineJoinMode.Miter, Parent = parent })
end

local function white_sequence()
    return cseq({ ckey(0, rgb(255, 255, 255)), ckey(1, rgb(255, 255, 255)) })
end

local function health_sequence(r, g, b)
    return cseq({ ckey(0, rgb(0, g, 0)), ckey(0.5, rgb(r, g, 0)), ckey(1, rgb(r, 0, 0)) })
end

local function glow_transparency()
    return nseq({ nkey(0, 0.7), nkey(1, 0.7) })
end

function esp.cache(model)
    local parts = {}
    if model:IsA("Model") then
        local wanted = {
            HeadTopHitBox = true,
            LeftUpperArm = true,
            RightUpperArm = true,
            LeftFoot = true,
            RightFoot = true,
            LeftHand = true,
            RightHand = true,
        }
        for _, part in model:GetChildren() do
            if part:IsA("BasePart") and wanted[part.Name] then
                parts[#parts + 1] = part
            end
        end
    end
    settings.part_cache[model] = parts
end

function esp.get_bounding_box(position, model)
    local options = settings.esp
    if options.box_type ~= "Dynamic" then
        local height = options.box_size.Y
        local half = height * 0.5
        local top, top_visible = util.get_screen_pos(position + Vector3.new(0, half, 0))
        if top_visible then
            local bottom = util.get_screen_pos(position - Vector3.new(0, half, 0))
            local box_height = math.max(4, math.abs(top.Y - bottom.Y) * 1.2)
            return true, (top.X + bottom.X) * 0.5, (top.Y + bottom.Y) * 0.5 + 2, math.max(1, box_height * options.box_size.X / height), box_height
        end
        return false
    end
    local min_x, min_y = math.huge, math.huge
    local max_x, max_y = -math.huge, -math.huge
    local any = false
    local padding = options.dynamic_padding
    local parts = settings.part_cache[model]
    if not parts then
        esp.cache(model)
        parts = settings.part_cache[model]
    end
    local function add(point, visible)
        if visible then
            any = true
            if point.X < min_x then
                min_x = point.X
            end
            if max_x < point.X then
                max_x = point.X
            end
            if point.Y < min_y then
                min_y = point.Y
            end
            if max_y < point.Y then
                max_y = point.Y
            end
        end
    end
    for i = 1, #parts do
        local part = parts[i]
        local cframe = part.CFrame
        local size = part.Size
        local x = size.X * 0.5 * padding
        local y = size.Y * 0.5 * padding
        local z = size.Z * 0.5 * padding
        add(camera:WorldToViewportPoint(cframe:PointToWorldSpace(Vector3.new(x, y, z))))
        add(camera:WorldToViewportPoint(cframe:PointToWorldSpace(Vector3.new(-x, y, z))))
        add(camera:WorldToViewportPoint(cframe:PointToWorldSpace(Vector3.new(x, -y, z))))
        add(camera:WorldToViewportPoint(cframe:PointToWorldSpace(Vector3.new(-x, -y, z))))
        add(camera:WorldToViewportPoint(cframe:PointToWorldSpace(Vector3.new(x, y, -z))))
        add(camera:WorldToViewportPoint(cframe:PointToWorldSpace(Vector3.new(-x, y, -z))))
        add(camera:WorldToViewportPoint(cframe:PointToWorldSpace(Vector3.new(x, -y, -z))))
        add(camera:WorldToViewportPoint(cframe:PointToWorldSpace(Vector3.new(-x, -y, -z))))
    end
    if any then
        return true, (min_x + max_x) * 0.5, (min_y + max_y) * 0.5, math.max(1, max_x - min_x), math.max(4, max_y - min_y)
    end
    return false
end

function esp.model_template(bot)
    local t = { screen_gui = screen_gui() }
    t.holder = new("Frame", { BackgroundTransparency = 1, Parent = t.screen_gui })
    t.box = new("Frame", { BackgroundTransparency = 1, Size = dim2(1, 0, 1, 0), Parent = t.holder })
    t.box_outline = new("UIStroke", { BorderOffset = dim(0, 2), Color = rgb(0, 0, 0), Thickness = 1, LineJoinMode = Enum.LineJoinMode.Miter, Parent = t.box })
    t.box_bg_fill = new("Frame", { BackgroundTransparency = 1, BorderSizePixel = 0, Size = dim2(1, 0, 1, 0), BackgroundColor3 = rgb(255, 255, 255), ZIndex = 2, Parent = t.box })
    t.box_inline_stroke = new("UIStroke", { Color = rgb(0, 0, 0), Thickness = 1, LineJoinMode = Enum.LineJoinMode.Miter, Parent = t.box })
    t.box_bg_fill_gradient = new("UIGradient", { Color = white_sequence(), Transparency = glow_transparency(), Rotation = 90, Parent = t.box_bg_fill })
    t.box_fill_stroke = new("UIStroke", { BorderOffset = dim(0, 1), Color = rgb(255, 255, 255), Thickness = 1, LineJoinMode = Enum.LineJoinMode.Miter, Parent = t.box })
    t.box_fill_gradient = new("UIGradient", { Color = white_sequence(), Rotation = 90, Parent = t.box_fill_stroke })
    t.box_glow = new("ImageLabel", {
        BackgroundTransparency = 1,
        Size = dim2(1, 41, 1, 41),
        Position = dim2(0.5, -1, 0.5, -1),
        AnchorPoint = Vector2.new(0.5, 0.5),
        Image = library.images.Glow4,
        ImageColor3 = rgb(255, 255, 255),
        ScaleType = Enum.ScaleType.Slice,
        SliceCenter = Rect.new(21, 21, 79, 79),
        SliceScale = 1,
        ZIndex = 0,
        Parent = t.box,
    })
    t.box_glow_gradient = new("UIGradient", { Color = white_sequence(), Transparency = glow_transparency(), Rotation = 90, Parent = t.box_glow })

    t.health_bar = new("Frame", {
        AnchorPoint = Vector2.new(1, 1),
        BorderSizePixel = 0,
        BackgroundColor3 = rgb(0, 0, 0),
        Position = dim2(0, -4, 1, 3),
        Size = dim2(0, 3, 1, 6),
        ZIndex = 1,
        Parent = t.holder,
    })
    t.bar = new("Frame", {
        AnchorPoint = Vector2.new(0, 1),
        BorderSizePixel = 0,
        BackgroundColor3 = rgb(255, 255, 255),
        Position = dim2(1, -2, 1, -1),
        Size = dim2(1, -2, 1, -2),
        ZIndex = 3,
        Parent = t.health_bar,
    })
    t.bar_gradient = new("UIGradient", { Color = health_sequence(255, 255, 255), Rotation = 90, Parent = t.bar })
    t.background_bar = new("Frame", {
        AnchorPoint = Vector2.new(0, 1),
        BorderSizePixel = 0,
        BackgroundColor3 = rgb(255, 255, 255),
        Position = dim2(1, -2, 1, -1),
        Size = dim2(1, -2, 1, -2),
        ZIndex = 2,
        Parent = t.health_bar,
    })
    t.background_bar_gradient = new("UIGradient", { Color = health_sequence(51, 51, 51), Rotation = 90, Parent = t.background_bar })
    t.health_flag = new("TextLabel", {
        BackgroundTransparency = 1,
        TextSize = 12,
        Text = "100",
        TextXAlignment = Enum.TextXAlignment.Right,
        AnchorPoint = Vector2.new(0, 1),
        Position = dim2(0, -3, 0, 9),
        Size = dim2(1, 0, 0, 12),
        TextColor3 = rgb(255, 255, 255),
        FontFace = library.font,
        ZIndex = 3,
        Parent = t.bar,
    })
    t.health_flag_stroke = label_stroke(t.health_flag)
    t.health_bar_glow = new("ImageLabel", {
        BackgroundTransparency = 1,
        Size = dim2(1, 41, 1, 41),
        Position = dim2(0.5, -1, 0.5, -1),
        AnchorPoint = Vector2.new(0.5, 0.5),
        Image = library.images.Glow4,
        ImageColor3 = rgb(255, 255, 255),
        ScaleType = Enum.ScaleType.Slice,
        SliceCenter = Rect.new(21, 21, 79, 79),
        SliceScale = 1,
        ZIndex = 0,
        Parent = t.health_bar,
    })
    t.health_bar_glow_gradient = new("UIGradient", { Color = health_sequence(255, 255, 255), Transparency = glow_transparency(), Rotation = 90, Parent = t.health_bar_glow })

    t.name_label = new("TextLabel", {
        BackgroundTransparency = 1,
        TextSize = 12,
        AnchorPoint = Vector2.new(0, 1),
        Position = dim2(0, 0, 0, -6),
        Size = dim2(1, 0, 0, 12),
        TextColor3 = rgb(255, 255, 255),
        FontFace = library.font,
        Parent = t.holder,
    })
    t.name_label_stroke = label_stroke(t.name_label)
    t.distance_label = new("TextLabel", {
        BackgroundTransparency = 1,
        TextSize = 12,
        AnchorPoint = Vector2.new(0, 1),
        Position = dim2(0, 0, 1, 14),
        Size = dim2(1, 0, 0, 12),
        TextColor3 = rgb(255, 255, 255),
        FontFace = library.font,
        Parent = t.holder,
    })
    t.distance_label_stroke = label_stroke(t.distance_label)
    t.weapon_label = new("TextLabel", {
        BackgroundTransparency = 1,
        TextSize = 12,
        AnchorPoint = Vector2.new(0, 1),
        Position = dim2(0, 0, 1, 26),
        Size = dim2(1, 0, 0, 12),
        TextColor3 = rgb(255, 255, 255),
        FontFace = library.font,
        Parent = t.holder,
    })
    t.weapon_label_stroke = label_stroke(t.weapon_label)
    t.weapon_icon = new("ImageLabel", {
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = dim2(0.5, 0, 0.5, 18),
        Size = dim2(0, 22, 0, 22),
        BackgroundTransparency = 1,
        Image = "",
        ImageColor3 = rgb(255, 255, 255),
        Parent = t.weapon_label,
    })

    t.flags_holder = new("Frame", {
        BackgroundTransparency = 1,
        AnchorPoint = Vector2.new(1, 0),
        Position = dim2(1, 6, 0, -2),
        Size = dim2(0, 1, 1, 4),
        Parent = t.holder,
    })
    t.flag_layout = new("UIListLayout", { Padding = dim(0, 12), SortOrder = Enum.SortOrder.LayoutOrder, Parent = t.flags_holder })
    t.flag_padding = new("UIPadding", { PaddingTop = dim(0, 3), Parent = t.flags_holder })

    local function flag_label(order, y)
        return new("TextLabel", {
            BackgroundTransparency = 1,
            TextSize = 12,
            TextXAlignment = Enum.TextXAlignment.Left,
            AnchorPoint = Vector2.new(1, 0),
            Position = dim2(1, 57, 0, y),
            Size = dim2(0, 0, 0, 0),
            Text = "",
            LayoutOrder = order,
            TextColor3 = rgb(255, 255, 255),
            FontFace = library.font,
            Parent = t.flags_holder,
        })
    end

    t.visible_label = flag_label(2, 47)
    t.visible_label_stroke = label_stroke(t.visible_label)
    if bot then
        return t
    end
    t.kd_label = flag_label(1, -5)
    t.kd_label_stroke = label_stroke(t.kd_label)
    t.invisible_label = flag_label(3, 8)
    t.invisible_label_stroke = label_stroke(t.invisible_label)
    t.desyncing_label = flag_label(4, 34)
    t.desyncing_label_stroke = label_stroke(t.desyncing_label)
    return t
end

function esp.chams(model, parent)
    if not model:FindFirstChildOfClass("Humanoid") then
        return
    end
    local body = {
        Head = true, Torso = true, UpperTorso = true, LowerTorso = true,
        LeftUpperArm = true, LeftLowerArm = true, LeftHand = true, RightUpperArm = true, RightLowerArm = true, RightHand = true,
        LeftUpperLeg = true, LeftLowerLeg = true, LeftFoot = true, RightUpperLeg = true, RightLowerLeg = true, RightFoot = true,
        ["Left Arm"] = true, ["Right Arm"] = true, ["Left Leg"] = true, ["Right Leg"] = true,
    }
    local sizes = {
        head = { glow = Vector3.new(1.251, 1.42, 1.251), main = Vector3.new(1.252, 1.43, 1.252) },
        default = { glow = Vector3.new(0.15, 0.15, 0.15), main = Vector3.new(0.17, 0.17, 0.17) },
    }
    local out = { highlight = nil }
    for _, part in model:GetChildren() do
        if part:IsA("BasePart") and body[part.Name] then
            local is_head = part.Name == "Head"
            local size = is_head and sizes.head or sizes.default
            local glow = {
                Visible = false,
                Adornee = part,
                AlwaysOnTop = true,
                Transparency = 0,
                Color3 = rgb(255, 255, 255),
                Parent = parent,
            }
            local main = table.clone(glow)
            if is_head then
                glow.Size = size.glow
                main.Size = size.main
            else
                glow.Size = part.Size + size.glow
                main.Size = part.Size + size.main
            end
            glow.ZIndex = -1
            glow.Shading = Enum.AdornShading.XRay
            main.ZIndex = 0
            out[part] = { glow = new("BoxHandleAdornment", glow), main = new("BoxHandleAdornment", main) }
        end
    end
    out.highlight = new("Highlight", {
        Adornee = model,
        FillColor = rgb(255, 255, 255),
        FillTransparency = 0.5,
        OutlineColor = rgb(255, 255, 255),
        OutlineTransparency = 0,
        DepthMode = Enum.HighlightDepthMode.AlwaysOnTop,
        Parent = parent,
    })
    return out
end

function esp.healthbar(model, t, bot)
    local hum = model:FindFirstChildOfClass("Humanoid")
    if not hum then
        return
    end
    local options = bot and settings.esp.bots or settings.esp
    local function apply(health)
        local size = dim2(1, -2, math.clamp(health / hum.MaxHealth, 0, 1), -2)
        local text
        if options.damaged_only and hum.MaxHealth <= health then
            text = ""
        else
            text = math.round(health)
        end
        if options.health_bar_tweening then
            local info = TweenInfo.new(options.health_bar_tween_time, options.health_bar_style, options.health_bar_direction)
            TweenService:Create(t.bar, info, { Size = size }):Play()
            TweenService:Create(t.bar_gradient, info, { Offset = Vector2.new(0, size.Y.Scale - 1) }):Play()
            TweenService:Create(t.health_bar_glow_gradient, info, { Offset = Vector2.new(0, size.Y.Scale - 1) }):Play()
        else
            t.bar.Size = size
            t.bar_gradient.Offset = Vector2.new(0, size.Y.Scale - 1)
            t.health_bar_glow_gradient.Offset = Vector2.new(0, size.Y.Scale - 1)
        end
        t.health_flag.Text = text
    end
    apply(hum.Health)
    library:connection(hum.HealthChanged, function(health)
        if health <= 0 then
            local entry = esp_cache[model]
            if entry and entry.handle_remove then
                entry.handle_remove()
            end
            return
        end
        apply(health)
    end)
end

function esp.weapon(model, t)
    if not model then
        return
    end
    local function texture(name)
        return name and settings.item_textures[name] or nil
    end
    local function apply(tool)
        if tool then
            local name = tostring(tool)
            t.weapon_label.Text = esp.format_text(name, settings.esp.text_case)
            t.weapon_icon.Image = texture(name) or ""
            return
        end
        t.weapon_label.Text = ""
        t.weapon_icon.Image = ""
    end
    local holding = model:WaitForChild("Holding")
    apply(holding.Value)
    library:connection(holding:GetPropertyChangedSignal("Value"), function()
        apply(holding.Value)
    end)
end

function esp.kd_flag(model, t)
    local node = find(player_data(), model.Name)
    if not node then
        return
    end
    local stats = find(node, "Status") and find(node.Status, "Journey") and find(node.Status.Journey, "Statistics")
    if not stats then
        return
    end
    local function apply()
        local kd = util.calculate_kd(stats)
        util:set_property(t.kd_label, "Text", string.format("%.2f", kd) .. " " .. esp.format_text("kd", settings.esp.text_case))
    end
    apply()
    library:connection(stats:GetAttributeChangedSignal("Kills"), apply)
    library:connection(stats:GetAttributeChangedSignal("Deaths"), apply)
end

function esp.invisible_flag(model, t)
    local options = settings.esp
    local head = find(model, "Head")
    if not head then
        return
    end
    local function apply()
        if head.Transparency ~= 1 then
            util:set_property(t.invisible_label, "Text", "")
            util:set_visible(t.invisible_label, false)
        else
            util:set_property(t.invisible_label, "Text", esp.format_text("Invisible", settings.esp.text_case))
            util:set_visible(t.invisible_label, options.invisible_enabled)
        end
    end
    apply()
    library:connection(head:GetPropertyChangedSignal("Transparency"), apply)
end

function esp.visible_flag(_, t)
    util:set_property(t.visible_label, "Text", "")
    util:set_visible(t.visible_label, false)
end

function esp.desyncing_flag(model, hrp)
    local options = settings.esp
    local node = find(player_data(), model.Name)
    local uac = node and find(node, "Status") and find(node.Status, "UAC")
    if not uac then
        return
    end
    local t = esp_cache[model] and esp_cache[model].directory
    if not t then
        return
    end
    local function apply()
        local verified = uac:GetAttribute("LastVerifiedPos")
        if verified then
            local distance = (hrp.Position - verified).Magnitude
            if options.desyncing_threshold <= distance then
                util:set_property(t.desyncing_label, "Text", esp.format_text(("Desyncing (%.1f)"):format(distance), options.text_case))
                util:set_visible(t.desyncing_label, options.desyncing_enabled)
                return
            end
        end
        util:set_property(t.desyncing_label, "Text", "")
        util:set_visible(t.desyncing_label, false)
    end
    apply()
    library:connection(uac:GetAttributeChangedSignal("LastVerifiedPos"), apply)
end

function esp.new_model(model, bot)
    if esp_cache[model] then
        return
    end
    bot = bot or false
    local hrp = find(model, "HumanoidRootPart")
    local hum = find(model, "Humanoid")
    if not (hrp and hum) then
        local waiter
        waiter = library:connection(model.ChildAdded, function()
            if find(model, "HumanoidRootPart") and find(model, "Humanoid") then
                waiter:Disconnect()
                esp.new_model(model, bot)
            end
        end)
        return
    end
    if model == lp.Character then
        return
    end
    if hum.Health <= 0 then
        return
    end
    local t = esp.model_template(bot)
    t.name_label.Text = model.Name
    esp_cache[model] = {
        hrp = hrp,
        hum = hum,
        gui = t.screen_gui,
        holder = t.holder,
        bot = bot,
        directory = t,
        chams = esp.chams(model, t.screen_gui),
    }
    esp.healthbar(model, t, bot)
    task.spawn(esp.weapon, model, t)
    esp.visible_flag(hrp, t, bot)
    if not bot then
        esp.kd_flag(model, t)
        esp.invisible_flag(model, t)
        esp.desyncing_flag(model, hrp)
    end
    esp.refresh(bot)
    local function handle_remove()
        local entry = esp_cache[model]
        if not entry then
            return
        end
        if entry.chams then
            if entry.chams.highlight then
                entry.chams.highlight.Adornee = nil
                entry.chams.highlight:Destroy()
            end
            for key, pair in entry.chams do
                if key ~= "highlight" then
                    if pair.glow then
                        pair.glow:Destroy()
                    end
                    if pair.main then
                        pair.main:Destroy()
                    end
                end
            end
            entry.chams = nil
        end
        if entry.holder then
            entry.holder:Destroy()
            entry.holder = nil
        end
        esp_cache[model] = nil
    end
    esp_cache[model].handle_remove = handle_remove
    library:connection(model.AncestryChanged, function(_, parent)
        if not parent then
            handle_remove()
        end
    end)
    library:connection(hrp.AncestryChanged, function(_, parent)
        if not parent then
            handle_remove()
        end
    end)
end

function esp.refresh(bot)
    local options = bot and settings.esp.bots or settings.esp
    local outlines = options.outlines
    local flag_metrics = font_size(options.fonts.flags.font)
    local fonts = options.fonts
    local label_fonts = {
        name_label = fonts.name.font,
        distance_label = fonts.distance.font,
        weapon_label = fonts.weapon.font,
        health_flag = fonts.health.font,
        visible_label = fonts.flags.font,
        kd_label = fonts.flags.font,
        invisible_label = fonts.flags.font,
        desyncing_label = fonts.flags.font,
    }
    local function make_seq(prefix, key_fn, seq_fn)
        local layers = options.bar_gradient_value
        if layers == 1 then
            local value = options[prefix .. "_1"]
            return seq_fn({ key_fn(0, value), key_fn(1, value) })
        elseif layers == 2 then
            return seq_fn({ key_fn(0, options[prefix .. "_1"]), key_fn(1, options[prefix .. "_2"]) })
        end
        return seq_fn({ key_fn(0, options[prefix .. "_1"]), key_fn(0.5, options[prefix .. "_2"]), key_fn(1, options[prefix .. "_3"]) })
    end
    for _, entry in esp_cache do
        if entry.bot ~= bot then
            continue
        end
        local hum = entry.hum
        local t = entry.directory
        if not (hum and t) then
            continue
        end
        local highlight = entry.chams and entry.chams.highlight
        local elements = {
            { element = t.name_label, key = "name_label" },
            { element = t.distance_label, key = "distance_label" },
            { element = t.weapon_label, key = "weapon_label" },
            { element = t.health_flag, key = "health_flag" },
            { element = t.visible_label, key = "visible_label" },
        }
        if not bot then
            elements[#elements + 1] = { element = t.kd_label, key = "kd_label" }
            elements[#elements + 1] = { element = t.invisible_label, key = "invisible_label" }
            elements[#elements + 1] = { element = t.desyncing_label, key = "desyncing_label" }
        end
        local strokes = {
            health_flag_stroke = outlines.health_flag,
            name_label_stroke = outlines.name_label,
            distance_label_stroke = outlines.distance_label,
            weapon_label_stroke = outlines.weapon_label,
            visible_label_stroke = outlines.visible_label,
            kd_label_stroke = not bot and outlines.kd_label or nil,
            invisible_label_stroke = not bot and outlines.invisible_label or nil,
            desyncing_label_stroke = not bot and outlines.desyncing_label or nil,
        }
        local texts = {
            { key = "name_label", enabled = options.name_enabled, color = options.name_color, transparency = options.name_transparency },
            { key = "distance_label", enabled = options.distance_enabled, color = options.distance_color, transparency = options.distance_transparency },
            { key = "visible_label", enabled = options.visible_enabled, color = options.visible_color, transparency = options.visible_transparency },
            not bot and { key = "kd_label", enabled = options.kd_enabled, color = options.kd_color, transparency = options.kd_transparency } or false,
            not bot and { key = "invisible_label", enabled = options.invisible_enabled, color = options.invisible_color, transparency = options.invisible_transparency } or false,
            not bot and { key = "desyncing_label", enabled = options.desyncing_enabled, color = options.desyncing_color, transparency = options.desyncing_transparency } or false,
        }

        util:set_visible(t.box, options.box_enabled)
        util:set_enabled(t.box_outline, outlines.box.enabled)
        util:set_property_group(t.box_outline, { Color = outlines.box.color, Transparency = outlines.box.transparency })
        util:set_enabled(t.box_inline_stroke, outlines.box.enabled)
        util:set_property_group(t.box_inline_stroke, { Color = outlines.box.color, Transparency = outlines.box.transparency })
        util:set_property_group(t.box_fill_gradient, {
            Color = cseq({ ckey(0, options.box_gradient_1), ckey(1, options.box_gradient_2) }),
            Transparency = nseq({ nkey(0, options.box_gradient_transparency_1), nkey(1, options.box_gradient_transparency_2) }),
            Rotation = options.box_rotation,
        })
        util:set_property(t.box_bg_fill, "BackgroundTransparency", options.box_fill_enabled and 0 or 1)
        util:set_property_group(t.box_bg_fill_gradient, {
            Color = cseq({ ckey(0, options.box_fill_gradient_1), ckey(1, options.box_fill_gradient_2) }),
            Transparency = nseq({ nkey(0, options.box_fill_transparency_1), nkey(1, options.box_fill_transparency_2) }),
            Rotation = options.box_fill_rotation,
        })
        util:set_visible(t.box_glow, options.box_glow)
        util:set_property_group(t.box_glow_gradient, {
            Color = cseq({ ckey(0, options.box_glow_gradient_1), ckey(1, options.box_glow_gradient_2) }),
            Transparency = nseq({ nkey(0, options.box_glow_transparency_1), nkey(1, options.box_glow_transparency_2) }),
            Rotation = options.box_rotation,
        })

        util:set_visible(t.health_bar, options.health_bar_enabled)
        util:set_property_group(t.health_bar, {
            BackgroundColor3 = outlines.health_bar.color,
            BackgroundTransparency = outlines.health_bar.enabled and outlines.health_bar.transparency or 1,
            Size = dim2(0, 2 + options.bar_thickness, 1, 6),
        })
        util:set_property_group(t.bar_gradient, {
            Color = make_seq("bar_color", ckey, cseq),
            Transparency = make_seq("bar_transparency", nkey, nseq),
        })
        util:set_visible(t.health_bar_glow, options.health_bar_glow_enabled)
        util:set_property_group(t.health_bar_glow_gradient, {
            Color = make_seq("bar_glow_color", ckey, cseq),
            Transparency = make_seq("bar_glow_transparency", nkey, nseq),
        })
        util:set_visible(t.health_flag, options.health_flag_enabled)
        util:set_property_group(t.health_flag, {
            TextColor3 = options.health_flag_color,
            TextTransparency = options.health_flag_transparency,
            Position = dim2(0, (options.health_flag_position == "Left" and -3 or 0) - options.bar_thickness - 1, 0, 9),
            TextXAlignment = options.health_flag_position == "Left" and Enum.TextXAlignment.Right or Enum.TextXAlignment.Center,
        })
        util:set_visible(t.background_bar, options.health_bar_background_enabled)
        util:set_property_group(t.background_bar_gradient, {
            Color = make_seq("bar_background_color", ckey, cseq),
            Transparency = make_seq("bar_background_transparency", nkey, nseq),
        })
        local bar_position = dim2(1, -t.health_bar.Size.X.Offset + 1, 1, -1)
        util:set_property(t.bar, "Position", bar_position)
        util:set_property(t.background_bar, "Position", bar_position)
        if options.health_flag_enabled then
            local health = hum.Health or 0
            local text
            if options.damaged_only and hum.MaxHealth <= health then
                text = ""
            else
                text = math.round(health)
            end
            util:set_property(t.health_flag, "Text", text)
        end

        for key, outline in strokes do
            local stroke = t[key]
            if stroke then
                util:set_enabled(stroke, outline.enabled)
                util:set_property_group(stroke, { Color = outline.color, Transparency = outline.transparency })
            end
        end
        for _, item in texts do
            if item then
                local element = t[item.key]
                if element then
                    util:set_visible(element, element.Text ~= "" and item.enabled)
                    util:set_property_group(element, { TextColor3 = item.color, TextTransparency = item.transparency })
                end
            end
        end

        util:set_visible(t.weapon_label, options.weapon_enabled)
        util:set_property_group(t.weapon_label, {
            TextColor3 = options.weapon_color,
            TextTransparency = options.weapon_transparency,
            Position = options.distance_enabled and dim2(0, 0, 1, 29) or dim2(0, 0, 1, 16),
        })
        util:set_visible(t.weapon_icon, options.weapon_icon_enabled)
        util:set_property_group(t.weapon_icon, {
            ImageColor3 = options.weapon_icon_color,
            ImageTransparency = options.weapon_icon_transparency,
            Size = dim2(0, options.weapon_icon_size, 0, options.weapon_icon_size),
            ResampleMode = Enum.ResamplerMode[options.weapon_icon_sampling],
        })
        if not bot then
            util:set_property(t.kd_label, "Text", esp.format_text(t.kd_label.Text, settings.esp.text_case))
            util:set_property(t.invisible_label, "Text", esp.format_text(t.invisible_label.Text, settings.esp.text_case))
            util:set_property(t.desyncing_label, "Text", esp.format_text(t.desyncing_label.Text, settings.esp.text_case))
        end

        for key, pair in entry.chams or {} do
            if key ~= "highlight" then
                if pair.main then
                    util:set_visible(pair.main, options.chams_enabled)
                    util:set_property(pair.main, "Color3", options.chams_color)
                    util:set_property(pair.main, "Transparency", options.chams_transparency)
                end
                if pair.glow then
                    util:set_visible(pair.glow, options.chams_glow_enabled)
                    local color = options.chams_glow_color
                    local factor = options.chams_glow_factor
                    util:set_property(pair.glow, "Color3", rgb(color.R * 255 * factor, color.G * 255 * factor, color.B * 255 * factor))
                    util:set_property(pair.glow, "Transparency", options.chams_glow_transparency)
                    local shading = esp.glow_shading_map[options.chams_glow_type]
                    if shading then
                        util:set_property(pair.glow, "Shading", shading)
                    end
                end
            end
        end
        if highlight then
            util:set_property(highlight, "Enabled", options.highlight.enabled)
            util:set_property(highlight, "FillColor", options.highlight.fill.color)
            util:set_property(highlight, "FillTransparency", options.highlight.fill.transparency)
            util:set_property(highlight, "OutlineColor", options.highlight.outline.color)
            util:set_property(highlight, "OutlineTransparency", options.highlight.outline.transparency)
            util:set_property(highlight, "DepthMode", Enum.HighlightDepthMode[options.highlight.depthmode])
        end

        for _, item in elements do
            local element = item.element
            local key = item.key
            if element then
                local font_name = label_fonts[key]
                if font_name then
                    local metrics = font_size(font_name)
                    local pad_key = key
                    if key == "weapon_label" and not options.distance_enabled then
                        pad_key = "distance_label"
                    end
                    local padding = metrics.label_padding[pad_key]
                    local position = element.Position
                    util:set_property_group(element, {
                        FontFace = font_of(font_name),
                        TextSize = metrics.size,
                        Position = padding and dim2(position.X.Scale, position.X.Offset, position.Y.Scale, padding) or position,
                    })
                end
            end
        end
        util:set_property(t.flag_layout, "Padding", dim(0, flag_metrics.layout))
        util:set_property(t.flag_padding, "PaddingTop", dim(0, flag_metrics.top))
        util:set_property(t.name_label, "Text", esp.format_text(t.name_label.Text, settings.esp.text_case))
        util:set_property(t.weapon_label, "Text", esp.format_text(t.weapon_label.Text, settings.esp.text_case))
        util:set_property(t.visible_label, "Text", esp.format_text(t.visible_label.Text, settings.esp.text_case))
    end
end

function esp.update_model(position, holder, distance_label, distance, model)
    local on_screen, x, y, width, height = esp.get_bounding_box(position, model)
    if on_screen then
        width, height = math.round(width), math.round(height)
        util:set_property(holder, "Size", dim2(0, width, 0, height))
        util:set_property(holder, "Position", dim2(0, math.round(x - width * 0.5), 0, math.round(y - height * 0.5)))
        util:set_property(distance_label, "Text", esp.get_distance(distance))
        if not holder.Visible then
            util:set_visible(holder, true)
        end
    elseif holder.Visible then
        util:set_visible(holder, false)
    end
end

function esp.instance_template(kind)
    local t = {}
    local key = kind .. "_ui"
    if not instance_state[key] then
        instance_state[key] = new("ScreenGui", { IgnoreGuiInset = true, Parent = gui_parent })
    end
    t.label = new("TextLabel", {
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundTransparency = 1,
        Size = dim2(0, 100, 0, 12),
        Text = "",
        TextColor3 = rgb(255, 255, 255),
        FontFace = font_of(settings.esp.selected_font),
        TextXAlignment = Enum.TextXAlignment.Center,
        TextSize = 12,
        Parent = instance_state[key],
    })
    t.label_stroke = new("UIStroke", { Color = rgb(0, 0, 0), LineJoinMode = Enum.LineJoinMode.Miter, Parent = t.label })
    local images = {
        uaz = library.images.Uaz,
        exit = library.images.Exit,
        body = library.images.Body,
        item = library.images.Item,
        heli = library.images.Heli,
    }
    t.icon = new("ImageLabel", {
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundTransparency = 1,
        Position = dim2(0.5, 0, 0.5, 25),
        Size = dim2(0, 15, 0, 15),
        Image = images[kind] or "",
        ResampleMode = Enum.ResamplerMode.Pixelated,
        Parent = t.label,
    })
    return t
end

function esp.heli(model)
    local entry = instance_state.tracked[model]
    if not entry then
        return
    end
    local gui = entry.gui
    local base = entry.base_text
    local pilots = find(model, "Pilots")
    if not pilots then
        return
    end
    local pilot = find(pilots, "CollisionPilot")
    if not pilot then
        return
    end
    local function apply()
        local health = pilot:GetAttribute("Health") or 0
        local max_health = pilot:GetAttribute("MaxHealth") or 1
        local text = esp.format_text(base .. " " .. math.round(health) .. "/" .. max_health .. " hp", settings.esp.text_case)
        entry.base_text = text
        gui.label.Text = text
    end
    apply()
    library:connection(pilot:GetAttributeChangedSignal("Health"), apply)
    library:connection(pilot:GetAttributeChangedSignal("MaxHealth"), apply)
end

function esp.new_instance(obj, kind)
    local t = esp.instance_template(kind)
    local base
    if kind == "body" then
        base = obj.Name .. "'s corpse"
    elseif kind == "uaz" then
        base = "uaz"
    elseif kind == "exit" then
        base = "exit"
    elseif kind == "heli" then
        base = "MI24V"
    elseif kind == "item" then
        base = obj.Name
    else
        base = ""
    end
    instance_state.tracked[obj] = { gui = t, base_text = base, element_type = kind }
    if kind == "heli" then
        esp.heli(obj)
    else
        t.label.Text = esp.format_text(base, settings.esp.text_case) or ""
    end
    esp.refresh_custom()
    library:connection(obj.AncestryChanged, function(_, parent)
        if not parent then
            t.label:Destroy()
            instance_state.tracked[obj] = nil
        end
    end)
end

function esp.refresh_custom()
    for obj, entry in instance_state.tracked do
        if not (entry and entry.gui and entry.gui.label) then
            continue
        end
        local gui = entry.gui
        local label = gui.label
        local options = settings.esp.other[entry.element_type]
        local own_body = entry.element_type == "body" and obj.Name == lp.Name
        if own_body and options.highlight_self_body then
            util:set_property(label, "TextColor3", options.self_color)
            util:set_property(label, "TextTransparency", options.self_transparency)
            util:set_property(gui.icon, "ImageColor3", options.self_color_image)
            util:set_property(gui.icon, "ImageTransparency", options.self_transparency_image)
            util:set_visible(gui.icon, options.icon)
        elseif options then
            util:set_property(label, "TextColor3", options.color)
            util:set_property(label, "TextTransparency", options.transparency)
            util:set_property(gui.icon, "ImageColor3", options.icon_color)
            util:set_property(gui.icon, "ImageTransparency", options.icon_transparency)
            util:set_visible(gui.icon, options.icon)
        end
        util:set_enabled(gui.label_stroke, options.outline)
        util:set_property(gui.label_stroke, "Color", options.outline_color)
        util:set_property(gui.label_stroke, "Transparency", options.outline_transparency)
        util:set_property(label, "FontFace", font_of(options.font))
        util:set_property(label, "TextSize", font_size(options.font).size)
        entry.base_text = esp.format_text(entry.base_text, settings.esp.text_case) or entry.base_text
    end
end

function esp.update_instance(obj, text_label, options, base, distance)
    local point, visible = util.get_screen_pos(util.get_world_pos(obj))
    if visible then
        util:set_property(text_label, "Position", dim2(0, point.X, 0, point.Y - 15))
        if options.distance then
            util:set_property(text_label, "Text", base .. " [" .. esp.get_distance(distance) .. "]")
        else
            util:set_property(text_label, "Text", base)
        end
        if not text_label.Visible then
            util:set_visible(text_label, true)
        end
    elseif text_label.Visible then
        util:set_visible(text_label, false)
    end
end

function esp.render()
    if not esp_cache or not camera then
        return
    end
    local options = settings.esp
    local origin = lp.Character and root_part and util.get_world_pos(root_part)
    if not origin then
        return
    end
    if tick() - options.last_update < 1 / options.update_rate then
        return
    end
    options.last_update = tick()
    local scale = options.distance_unit == "meters" and 0.333 or 1
    local other = options.other
    for model, entry in esp_cache do
        local hrp = entry.hrp
        if not hrp then
            continue
        end
        local holder = entry.holder
        if not holder then
            continue
        end
        local profile = entry.bot and options.bots or options
        if not profile.enabled then
            util:set_visible(holder, false)
            continue
        end
        local distance = math.floor((origin - hrp.Position).Magnitude * scale)
        if distance > profile.render_distance then
            util:set_visible(holder, false)
            continue
        end
        esp.update_model(hrp.Position, holder, entry.directory.distance_label, distance, model)
    end
    for obj, entry in instance_state.tracked do
        local text_label = entry and entry.gui and entry.gui.label
        if not text_label then
            continue
        end
        if not other.enabled then
            util:set_visible(text_label, false)
            continue
        end
        local kind_options = other[entry.element_type]
        if not (kind_options and kind_options.enabled) then
            util:set_visible(text_label, false)
            continue
        end
        local distance = math.floor((origin - util.get_world_pos(obj)).Magnitude * scale)
        if distance > other.render_distance then
            util:set_visible(text_label, false)
            continue
        end
        esp.update_instance(obj, text_label, kind_options, entry.base_text, distance)
    end
end

function esp.visible_loop()
    while task.wait(0.2) do
        if not root_part then
            continue
        end
        for model, entry in esp_cache do
            local hrp = entry.hrp
            local t = entry.directory
            if not hrp or not hrp.Parent then
                if entry.visible_last ~= false then
                    entry.visible_last = false
                    util:set_property(t.visible_label, "Text", "")
                    util:set_visible(t.visible_label, false)
                end
                continue
            end
            local profile = entry.bot and settings.esp.bots or settings.esp
            if not profile.visible_enabled then
                continue
            end
            local visible = util.is_visible(root_part.Position, model, entry.hrp)
            if visible ~= entry.visible_last then
                entry.visible_last = visible
                if visible then
                    util:set_property(t.visible_label, "Text", esp.format_text("Visible", settings.esp.text_case))
                    util:set_visible(t.visible_label, true)
                else
                    util:set_property(t.visible_label, "Text", "")
                    util:set_visible(t.visible_label, false)
                end
            end
        end
    end
end

local function animate_healthbar(t, options, hum)
    local health = hum.Health
    local target = dim2(1, -2, math.clamp(health / hum.MaxHealth, 0, 1), -2)
    t.bar.Size = dim2(1, -2, 0, -2)
    t.bar_gradient.Offset = Vector2.new(0, -1)
    t.health_bar_glow_gradient.Offset = Vector2.new(0, -1)
    if options.damaged_only and hum.MaxHealth <= health then
        util:set_property(t.health_flag, "Text", "")
    else
        util:set_property(t.health_flag, "Text", math.round(health))
    end
    if options.health_bar_tweening then
        local info = TweenInfo.new(options.health_bar_tween_time, options.health_bar_style, options.health_bar_direction)
        TweenService:Create(t.bar, info, { Size = target }):Play()
        TweenService:Create(t.bar_gradient, info, { Offset = Vector2.new(0, target.Y.Scale - 1) }):Play()
        TweenService:Create(t.health_bar_glow_gradient, info, { Offset = Vector2.new(0, target.Y.Scale - 1) }):Play()
        local duration = info.Time
        task.spawn(function()
            local started = tick()
            local progress
            repeat
                progress = math.clamp((tick() - started) / duration, 0, 1)
                local value = math.round(health * progress)
                if options.damaged_only and value >= hum.MaxHealth then
                    util:set_property(t.health_flag, "Text", "")
                else
                    util:set_property(t.health_flag, "Text", value)
                end
                task.wait(0.1)
            until progress >= 1
        end)
    else
        t.bar.Size = target
        t.bar_gradient.Offset = Vector2.new(0, target.Y.Scale - 1)
        t.health_bar_glow_gradient.Offset = Vector2.new(0, target.Y.Scale - 1)
    end
end

function esp.test_animation()
    for _, entry in esp_cache do
        local options = entry.bot and settings.esp.bots or settings.esp
        local t = entry.directory
        local hum = entry.hum
        if t and hum then
            task.spawn(animate_healthbar, t, options, hum)
        end
    end
end

function esp.tab(section, path, bot)
    section:toggle({
        name = "ESP Enabled",
        flag = path .. "_enabled",
        callback = function(enabled)
            esp.path(path .. ".enabled", enabled)
            esp.refresh(bot)
        end,
    }):configuration({ name = "ESP Options" }, function(options)
        options:slider({
            name = "Render Distance",
            max = 3000,
            default = 1300,
            suffix = "m",
            interval = 1,
            flag = path .. "_render_distance",
            callback = function(value)
                esp.path(path .. ".render_distance", value)
            end,
        })
    end):keybind({
        name = (path == "esp" and "Player" or path == "esp.bots" and "NPC") .. " ESP",
        flag = path .. "_enabled_bind",
        callback = function(enabled)
            esp.path(path .. ".enabled", enabled)
            esp.refresh(bot)
        end,
    })

    section:splitter()

    section:toggle({
        name = "Bounding Box",
        flag = path .. "_bounding_box",
        callback = function(enabled)
            esp.path(path .. ".box_enabled", enabled)
            esp.refresh(bot)
        end,
    }):configuration({ name = "Bounding Box Options" }, function(options)
        options:label({ name = "Color" }):colorpicker({
            name = "Gradient Top",
            flag = path .. "_gradient_top_color",
            color = rgb(255, 255, 255),
            callback = function(color, alpha)
                esp.path(path .. ".box_gradient_1", color)
                esp.path(path .. ".box_gradient_transparency_1", 1 - alpha)
                esp.refresh(bot)
            end,
        }):colorpicker({
            name = "Gradient Bottom",
            flag = path .. "_gradient_bottom_color",
            color = rgb(255, 255, 255),
            callback = function(color, alpha)
                esp.path(path .. ".box_gradient_2", color)
                esp.path(path .. ".box_gradient_transparency_2", 1 - alpha)
                esp.refresh(bot)
            end,
        })

        options:slider({
            slider_type = "normal",
            min = 0,
            max = 180,
            default = 90,
            suffix = "°",
            interval = 1,
            flag = path .. "_bounding_box_gradient_rotation",
            callback = function(value)
                esp.path(path .. ".box_rotation", value)
                esp.refresh(bot)
            end,
        })

        options:toggle({
            name = "Render Outline",
            flag = path .. "_box_outline",
            default = true,
            callback = function(enabled)
                esp.path(path .. ".outlines.box.enabled", enabled)
                esp.refresh(bot)
            end,
        }):colorpicker({
            name = "Outline Color",
            flag = path .. "_box_outline_color",
            color = rgb(0, 0, 0),
            callback = function(color, alpha)
                esp.path(path .. ".outlines.box.color", color)
                esp.path(path .. ".outlines.box.transparency", 1 - alpha)
                esp.refresh(bot)
            end,
        })

        options:toggle({
            name = "Glow",
            flag = path .. "_box_glow",
            callback = function(enabled)
                esp.path(path .. ".box_glow", enabled)
                esp.refresh(bot)
            end,
        }):colorpicker({
            name = "Gradient Top",
            flag = path .. "_box_glow_gradient_top_color",
            alpha = 0.5,
            color = rgb(255, 255, 255),
            callback = function(color, alpha)
                esp.path(path .. ".box_glow_gradient_1", color)
                esp.path(path .. ".box_glow_transparency_1", 1 - alpha)
                esp.refresh(bot)
            end,
        }):colorpicker({
            name = "Gradient Bottom",
            flag = path .. "_box_glow_gradient_bottom_color",
            alpha = 0.5,
            color = rgb(255, 255, 255),
            callback = function(color, alpha)
                esp.path(path .. ".box_glow_gradient_2", color)
                esp.path(path .. ".box_glow_transparency_2", 1 - alpha)
                esp.refresh(bot)
            end,
        })

        options:toggle({
            name = "Fill",
            flag = path .. "_box_fill",
            callback = function(enabled)
                esp.path(path .. ".box_fill_enabled", enabled)
                esp.refresh(bot)
            end,
        }):colorpicker({
            name = "Gradient Top",
            flag = path .. "_box_fill_gradient_top_color",
            alpha = 0.5,
            color = rgb(255, 255, 255),
            callback = function(color, alpha)
                esp.path(path .. ".box_fill_gradient_1", color)
                esp.path(path .. ".box_fill_transparency_1", 1 - alpha)
                esp.refresh(bot)
            end,
        }):colorpicker({
            name = "Gradient Bottom",
            flag = path .. "_box_fill_gradient_bottom_color",
            alpha = 0.5,
            color = rgb(255, 255, 255),
            callback = function(color, alpha)
                esp.path(path .. ".box_fill_gradient_2", color)
                esp.path(path .. ".box_fill_transparency_2", 1 - alpha)
                esp.refresh(bot)
            end,
        })

        options:slider({
            slider_type = "normal",
            min = 0,
            max = 180,
            default = 90,
            suffix = "°",
            interval = 1,
            flag = path .. "_bounding_box_fill_gradient_rotation",
            callback = function(value)
                esp.path(path .. ".box_fill_rotation", value)
                esp.refresh(bot)
            end,
        })
    end)

    section:toggle({
        name = "Health Bar",
        flag = path .. "_health_bar",
        callback = function(enabled)
            esp.path(path .. ".health_bar_enabled", enabled)
            esp.refresh(bot)
        end,
    }):configuration({ name = "Health Bar Options" }, function(options)
        options:label({ name = "Color" }):colorpicker({
            name = "Color 1",
            flag = path .. "_health_bar_1",
            color = rgb(0, 255, 0),
            callback = function(color, alpha)
                esp.path(path .. ".bar_color_1", color)
                esp.path(path .. ".bar_transparency_1", 1 - alpha)
                esp.refresh(bot)
            end,
        }):colorpicker({
            name = "Color 2",
            flag = path .. "_health_bar_2",
            color = rgb(255, 255, 0),
            callback = function(color, alpha)
                esp.path(path .. ".bar_color_2", color)
                esp.path(path .. ".bar_transparency_2", 1 - alpha)
                esp.refresh(bot)
            end,
        }):colorpicker({
            name = "Color 3",
            flag = path .. "_health_bar_3",
            color = rgb(255, 0, 0),
            callback = function(color, alpha)
                esp.path(path .. ".bar_color_3", color)
                esp.path(path .. ".bar_transparency_3", 1 - alpha)
                esp.refresh(bot)
            end,
        })

        options:toggle({
            name = "Render Outline",
            flag = path .. "_health_bar_outline",
            default = true,
            callback = function(enabled)
                esp.path(path .. ".outlines.health_bar.enabled", enabled)
                esp.refresh(bot)
            end,
        }):colorpicker({
            name = "Outline Color",
            flag = path .. "_health_bar_outline_color",
            color = rgb(0, 0, 0),
            callback = function(color, alpha)
                esp.path(path .. ".outlines.health_bar.color", color)
                esp.path(path .. ".outlines.health_bar.transparency", 1 - alpha)
                esp.refresh(bot)
            end,
        })

        options:toggle({
            name = "Glow",
            flag = path .. "_health_bar_glow",
            callback = function(enabled)
                esp.path(path .. ".health_bar_glow_enabled", enabled)
                esp.refresh(bot)
            end,
        }):colorpicker({
            name = "Color 1",
            flag = path .. "_health_bar_glow_1",
            alpha = 0.5,
            color = rgb(0, 255, 0),
            callback = function(color, alpha)
                esp.path(path .. ".bar_glow_color_1", color)
                esp.path(path .. ".bar_glow_transparency_1", 1 - alpha)
                esp.refresh(bot)
            end,
        }):colorpicker({
            name = "Color 2",
            flag = path .. "_health_bar_glow_2",
            alpha = 0.5,
            color = rgb(255, 255, 0),
            callback = function(color, alpha)
                esp.path(path .. ".bar_glow_color_2", color)
                esp.path(path .. ".bar_glow_transparency_2", 1 - alpha)
                esp.refresh(bot)
            end,
        }):colorpicker({
            name = "Color 3",
            flag = path .. "_health_bar_glow_3",
            alpha = 0.5,
            color = rgb(255, 0, 0),
            callback = function(color, alpha)
                esp.path(path .. ".bar_glow_color_3", color)
                esp.path(path .. ".bar_glow_transparency_3", 1 - alpha)
                esp.refresh(bot)
            end,
        })

        options:toggle({
            name = "Background",
            flag = path .. "_health_bar_background",
            callback = function(enabled)
                esp.path(path .. ".health_bar_background_enabled", enabled)
                esp.refresh(bot)
            end,
        }):colorpicker({
            name = "Color 1",
            flag = path .. "_health_bar_background_1",
            color = rgb(0, 51, 0),
            callback = function(color, alpha)
                esp.path(path .. ".bar_background_color_1", color)
                esp.path(path .. ".bar_background_transparency_1", 1 - alpha)
                esp.refresh(bot)
            end,
        }):colorpicker({
            name = "Color 2",
            flag = path .. "_health_bar_background_2",
            color = rgb(51, 51, 0),
            callback = function(color, alpha)
                esp.path(path .. ".bar_background_color_2", color)
                esp.path(path .. ".bar_background_transparency_2", 1 - alpha)
                esp.refresh(bot)
            end,
        }):colorpicker({
            name = "Color 3",
            flag = path .. "_health_bar_background_3",
            color = rgb(51, 0, 0),
            callback = function(color, alpha)
                esp.path(path .. ".bar_background_color_3", color)
                esp.path(path .. ".bar_background_transparency_3", 1 - alpha)
                esp.refresh(bot)
            end,
        })

        options:splitter({ offset = 1 })

        options:toggle({
            name = "Health Flag",
            flag = path .. "_health_value",
            callback = function(enabled)
                esp.path(path .. ".health_flag_enabled", enabled)
                esp.refresh(bot)
            end,
        }):configuration({ name = "Health Flag Options" }, function(flag_options)
            flag_options:toggle({
                name = "Damaged Only",
                flag = path .. "_damaged_only",
                callback = function(enabled)
                    esp.path(path .. ".damaged_only", enabled)
                    esp.refresh(bot)
                end,
            })

            flag_options:dropdown({
                name = "Position",
                flag = path .. "_health_value_position",
                items = { "Center", "Left" },
                default = "Left",
                callback = function(position)
                    esp.path(path .. ".health_flag_position", position)
                    esp.refresh(bot)
                end,
            })

            flag_options:splitter({ offset = 1 })

            flag_options:dropdown({
                name = "Font",
                scrolling = true,
                flag = path .. "_health_font",
                items = font_names,
                default = "Tahoma",
                callback = function(font)
                    esp.path(path .. ".fonts.health.font", font)
                    esp.refresh(bot)
                end,
            })

            flag_options:toggle({
                name = "Render Outline",
                flag = path .. "_health_outline",
                default = true,
                callback = function(enabled)
                    esp.path(path .. ".outlines.health_flag.enabled", enabled)
                    esp.refresh(bot)
                end,
            }):colorpicker({
                name = "Outline Color",
                flag = path .. "_health_outline_color",
                color = rgb(0, 0, 0),
                callback = function(color, alpha)
                    esp.path(path .. ".outlines.health_flag.color", color)
                    esp.path(path .. ".outlines.health_flag.transparency", 1 - alpha)
                    esp.refresh(bot)
                end,
            })
        end):colorpicker({
            name = "Text Color",
            flag = path .. "_health_value_color",
            color = rgb(255, 255, 255),
            callback = function(color, alpha)
                esp.path(path .. ".health_flag_color", color)
                esp.path(path .. ".health_flag_transparency", 1 - alpha)
                esp.refresh(bot)
            end,
        })

        options:splitter({ offset = 1 })

        options:slider({
            name = "Gradient Layers",
            min = 1,
            max = 3,
            default = 3,
            interval = 1,
            flag = path .. "_health_bar_gradient_layers",
            callback = function(value)
                esp.path(path .. ".bar_gradient_value", value)
                esp.refresh(bot)
            end,
        })

        options:slider({
            name = "Thickness",
            min = 1,
            max = 4,
            default = 1,
            suffix = "px",
            interval = 1,
            flag = path .. "_health_bar_thickness",
            callback = function(value)
                esp.path(path .. ".bar_thickness", value)
                esp.refresh(bot)
            end,
        })

        options:splitter({ offset = 1 })

        options:toggle({
            name = "Animate",
            flag = path .. "_animate_health_bar",
            callback = function(enabled)
                esp.path(path .. ".health_bar_tweening", enabled)
            end,
        })

        options:slider({
            slider_type = "normal",
            min = 0.1,
            max = 1,
            default = 0.2,
            suffix = "s",
            interval = 0.01,
            flag = path .. "_health_bar_tween_time",
            callback = function(value)
                esp.path(path .. ".health_bar_tween_time", value)
            end,
        })

        options:dropdown({
            name = "Easing Style",
            scrolling = true,
            flag = path .. "_animation_easing_style",
            items = library.easing_style_index,
            default = "Circular",
            callback = function(style)
                esp.path(path .. ".health_bar_style", Enum.EasingStyle[style])
            end,
        })

        options:dropdown({
            name = "Direction",
            flag = path .. "_animation_direction",
            items = library.easing_direction_index,
            default = "InOut",
            callback = function(direction)
                esp.path(path .. ".health_bar_direction", Enum.EasingDirection[direction])
            end,
        })
    end)

    section:splitter()

    section:toggle({
        name = "Name",
        flag = path .. "_name",
        callback = function(enabled)
            esp.path(path .. ".name_enabled", enabled)
            esp.refresh(bot)
        end,
    }):configuration({ name = "Name Options" }, function(options)
        options:dropdown({
            name = "Font",
            scrolling = true,
            flag = path .. "_name_font",
            items = font_names,
            default = "Tahoma",
            callback = function(font)
                esp.path(path .. ".fonts.name.font", font)
                esp.refresh(bot)
            end,
        })

        options:toggle({
            name = "Render Outline",
            flag = path .. "_name_outline",
            default = true,
            callback = function(enabled)
                esp.path(path .. ".outlines.name_label.enabled", enabled)
                esp.refresh(bot)
            end,
        }):colorpicker({
            name = "Outline Color",
            flag = path .. "_name_outline_color",
            color = rgb(0, 0, 0),
            callback = function(color, alpha)
                esp.path(path .. ".outlines.name_label.color", color)
                esp.path(path .. ".outlines.name_label.transparency", 1 - alpha)
                esp.refresh(bot)
            end,
        })
    end):colorpicker({
        name = "Text Color",
        flag = path .. "_name_color",
        color = rgb(255, 255, 255),
        callback = function(color, alpha)
            esp.path(path .. ".name_color", color)
            esp.path(path .. ".name_transparency", 1 - alpha)
            esp.refresh(bot)
        end,
    })

    section:toggle({
        name = "Distance",
        flag = path .. "_distance",
        callback = function(enabled)
            esp.path(path .. ".distance_enabled", enabled)
            esp.refresh(bot)
        end,
    }):configuration({ name = "Distance Options" }, function(options)
        options:dropdown({
            name = "Font",
            scrolling = true,
            flag = path .. "_distance_font",
            items = font_names,
            default = "Tahoma",
            callback = function(font)
                esp.path(path .. ".fonts.distance.font", font)
                esp.refresh(bot)
            end,
        })

        options:toggle({
            name = "Render Outline",
            flag = path .. "_distance_outline",
            default = true,
            callback = function(enabled)
                esp.path(path .. ".outlines.distance_label.enabled", enabled)
                esp.refresh(bot)
            end,
        }):colorpicker({
            name = "Outline Color",
            flag = path .. "_distance_outline_color",
            color = rgb(0, 0, 0),
            callback = function(color, alpha)
                esp.path(path .. ".outlines.distance_label.color", color)
                esp.path(path .. ".outlines.distance_label.transparency", 1 - alpha)
                esp.refresh(bot)
            end,
        })
    end):colorpicker({
        name = "Text Color",
        flag = path .. "_distance_color",
        color = rgb(255, 255, 255),
        callback = function(color, alpha)
            esp.path(path .. ".distance_color", color)
            esp.path(path .. ".distance_transparency", 1 - alpha)
            esp.refresh(bot)
        end,
    })

    section:toggle({
        name = "Weapon",
        flag = path .. "_weapon",
        callback = function(enabled)
            esp.path(path .. ".weapon_enabled", enabled)
            esp.refresh(bot)
        end,
    }):configuration({ name = "Weapon Options" }, function(options)
        options:toggle({
            name = "Icon",
            flag = path .. "_weapon_icon",
            callback = function(enabled)
                esp.path(path .. ".weapon_icon_enabled", enabled)
                esp.refresh(bot)
            end,
        }):colorpicker({
            name = "Image Color",
            flag = path .. "_weapon_icon_color",
            color = rgb(255, 255, 255),
            callback = function(color, alpha)
                esp.path(path .. ".weapon_icon_color", color)
                esp.path(path .. ".weapon_icon_transparency", 1 - alpha)
                esp.refresh(bot)
            end,
        })

        options:slider({
            name = "Size",
            min = 15,
            max = 25,
            default = 22,
            interval = 1,
            flag = path .. "_weapon_icon_size",
            callback = function(value)
                esp.path(path .. ".weapon_icon_size", value)
                esp.refresh(bot)
            end,
        })

        options:dropdown({
            name = "Sampling",
            flag = path .. "_weapon_icon_sampling",
            items = { "Default", "Pixelated" },
            default = "Default",
            callback = function(sampling)
                esp.path(path .. ".weapon_icon_sampling", sampling)
                esp.refresh(bot)
            end,
        })

        options:splitter({ offset = 1 })

        options:dropdown({
            name = "Font",
            scrolling = true,
            flag = path .. "_weapon_font",
            items = font_names,
            default = "Tahoma",
            callback = function(font)
                esp.path(path .. ".fonts.weapon.font", font)
                esp.refresh(bot)
            end,
        })

        options:toggle({
            name = "Render Outline",
            flag = path .. "_weapon_outline",
            default = true,
            callback = function(enabled)
                esp.path(path .. ".outlines.weapon_label.enabled", enabled)
                esp.refresh(bot)
            end,
        }):colorpicker({
            name = "Outline Color",
            flag = path .. "_weapon_outline_color",
            color = rgb(0, 0, 0),
            callback = function(color, alpha)
                esp.path(path .. ".outlines.weapon_label.color", color)
                esp.path(path .. ".outlines.weapon_label.transparency", 1 - alpha)
                esp.refresh(bot)
            end,
        })
    end):colorpicker({
        name = "Text Color",
        flag = path .. "_weapon_color",
        color = rgb(255, 255, 255),
        callback = function(color, alpha)
            esp.path(path .. ".weapon_color", color)
            esp.path(path .. ".weapon_transparency", 1 - alpha)
            esp.refresh(bot)
        end,
    })

    section:splitter()

    if not bot then
        section:toggle({
            name = "KD",
            flag = path .. "_kd",
            callback = function(enabled)
                esp.path(path .. ".kd_enabled", enabled)
                esp.refresh(bot)
            end,
        }):configuration({ name = "KD Options" }, function(options)
            options:toggle({
                name = "Render Outline",
                flag = path .. "_kd_outline",
                default = true,
                callback = function(enabled)
                    esp.path(path .. ".outlines.kd_label.enabled", enabled)
                    esp.refresh(bot)
                end,
            }):colorpicker({
                name = "Outline Color",
                flag = path .. "_kd_outline_color",
                color = rgb(0, 0, 0),
                callback = function(color, alpha)
                    esp.path(path .. ".outlines.kd_label.color", color)
                    esp.path(path .. ".outlines.kd_label.transparency", 1 - alpha)
                    esp.refresh(bot)
                end,
            })
        end):colorpicker({
            name = "Text Color",
            flag = path .. "_kd_color",
            color = rgb(255, 255, 255),
            callback = function(color, alpha)
                esp.path(path .. ".kd_color", color)
                esp.path(path .. ".kd_transparency", 1 - alpha)
                esp.refresh(bot)
            end,
        })

        section:toggle({
            name = "Invisible",
            tooltip = "Displays if the player is invisible",
            flag = path .. "_invisible",
            callback = function(enabled)
                esp.path(path .. ".invisible_enabled", enabled)
                esp.refresh(bot)
            end,
        }):configuration({ name = "Invisible Options" }, function(options)
            options:toggle({
                name = "Render Outline",
                flag = path .. "_invisible_outline",
                default = true,
                callback = function(enabled)
                    esp.path(path .. ".outlines.invisible_label.enabled", enabled)
                    esp.refresh(bot)
                end,
            }):colorpicker({
                name = "Outline Color",
                flag = path .. "_invisible_outline_color",
                color = rgb(0, 0, 0),
                callback = function(color, alpha)
                    esp.path(path .. ".outlines.invisible_label.color", color)
                    esp.path(path .. ".outlines.invisible_label.transparency", 1 - alpha)
                    esp.refresh(bot)
                end,
            })
        end):colorpicker({
            name = "Text Color",
            flag = path .. "_invisible_color",
            color = rgb(255, 255, 255),
            callback = function(color, alpha)
                esp.path(path .. ".invisible_color", color)
                esp.path(path .. ".invisible_transparency", 1 - alpha)
                esp.refresh(bot)
            end,
        })

        section:toggle({
            name = "Desyncing",
            tooltip = "Displays if the player is desyncing",
            flag = path .. "_desyncing",
            callback = function(enabled)
                esp.path(path .. ".desyncing_enabled", enabled)
                esp.refresh(bot)
            end,
        }):configuration({ name = "Desyncing Options" }, function(options)
            options:slider({
                name = "Threshold",
                min = 2,
                max = 6,
                default = 3,
                suffix = "st",
                interval = 0.1,
                flag = path .. "_desyncing_threshold",
                tooltip = "Adjusts the sensitivity of desync detection based on player movement in studs",
                callback = function(value)
                    esp.path(path .. ".desyncing_threshold", value)
                end,
            })

            options:splitter({ offset = 1 })

            options:toggle({
                name = "Render Outline",
                flag = path .. "_desyncing_outline",
                default = true,
                callback = function(enabled)
                    esp.path(path .. ".outlines.desyncing_label.enabled", enabled)
                    esp.refresh(bot)
                end,
            }):colorpicker({
                name = "Outline Color",
                flag = path .. "_desyncing_outline_color",
                color = rgb(0, 0, 0),
                callback = function(color, alpha)
                    esp.path(path .. ".outlines.desyncing_label.color", color)
                    esp.path(path .. ".outlines.desyncing_label.transparency", 1 - alpha)
                    esp.refresh(bot)
                end,
            })
        end):colorpicker({
            name = "Text Color",
            flag = path .. "_desyncing_color",
            color = rgb(255, 255, 255),
            callback = function(color, alpha)
                esp.path(path .. ".desyncing_color", color)
                esp.path(path .. ".desyncing_transparency", 1 - alpha)
                esp.refresh(bot)
            end,
        })
    end

    section:toggle({
        name = "Visible",
        tooltip = "Displays if the models HumanoidRootPart is visible",
        flag = path .. "_visible",
        callback = function(enabled)
            esp.path(path .. ".visible_enabled", enabled)
            esp.refresh(bot)
        end,
    }):configuration({ name = "Visible Options" }, function(options)
        options:toggle({
            name = "Render Outline",
            flag = path .. "_visible_outline",
            default = true,
            callback = function(enabled)
                esp.path(path .. ".outlines.visible_label.enabled", enabled)
                esp.refresh(bot)
            end,
        }):colorpicker({
            name = "Outline Color",
            flag = path .. "_visible_outline_color",
            color = rgb(0, 0, 0),
            callback = function(color, alpha)
                esp.path(path .. ".outlines.visible_label.color", color)
                esp.path(path .. ".outlines.visible_label.transparency", 1 - alpha)
                esp.refresh(bot)
            end,
        })
    end):colorpicker({
        name = "Text Color",
        flag = path .. "_visible_color",
        color = rgb(255, 255, 255),
        callback = function(color, alpha)
            esp.path(path .. ".visible_color", color)
            esp.path(path .. ".visible_transparency", 1 - alpha)
            esp.refresh(bot)
        end,
    })

    section:dropdown({
        name = "Flag Font",
        scrolling = true,
        flag = path .. "_flags_font",
        items = font_names,
        default = "Tahoma",
        callback = function(font)
            esp.path(path .. ".fonts.flags.font", font)
            esp.refresh(bot)
        end,
    })

    section:splitter()

    section:toggle({
        name = "Chams",
        flag = path .. "_chams",
        callback = function(enabled)
            esp.path(path .. ".chams_enabled", enabled)
            esp.refresh(bot)
        end,
    }):colorpicker({
        name = "Cham Color",
        flag = path .. "_chams_color",
        color = rgb(255, 255, 255),
        callback = function(color, alpha)
            esp.path(path .. ".chams_color", color)
            esp.path(path .. ".chams_transparency", 1 - alpha)
            esp.refresh(bot)
        end,
    })

    section:toggle({
        name = "Glow Chams",
        flag = path .. "_glow_chams",
        callback = function(enabled)
            esp.path(path .. ".chams_glow_enabled", enabled)
        end,
    }):configuration({ name = "Glow Cham Options" }, function(options)
        options:dropdown({
            name = "Type",
            flag = path .. "_glow_cham_type",
            items = { "Default", "Occluded", "Shaded" },
            default = "Default",
            callback = function(kind)
                esp.path(path .. ".chams_glow_type", kind)
                esp.refresh(bot)
            end,
        })

        options:slider({
            name = "Intensity",
            min = 1,
            max = 5,
            default = 1.5,
            interval = 0.01,
            flag = path .. "_glow_intensity",
            callback = function(value)
                esp.path(path .. ".chams_glow_factor", value)
                esp.refresh(bot)
            end,
        })
    end):colorpicker({
        name = "Cham Color",
        flag = path .. "_glow_chams_color",
        color = rgb(255, 255, 255),
        callback = function(color, alpha)
            esp.path(path .. ".chams_glow_color", color)
            esp.path(path .. ".chams_glow_transparency", 1 - alpha)
            esp.refresh(bot)
        end,
    })

    section:toggle({
        name = "Highlight Chams",
        flag = path .. "_highlight_chams",
        callback = function(enabled)
            esp.path(path .. ".highlight.enabled", enabled)
            esp.refresh(bot)
        end,
    }):configuration({ name = "Highlight Options" }, function(options)
        options:dropdown({
            name = "Type",
            flag = path .. "_highlight_depthmode",
            items = { "AlwaysOnTop", "Occluded" },
            default = "AlwaysOnTop",
            callback = function(mode)
                esp.path(path .. ".highlight.depthmode", mode)
                esp.refresh(bot)
            end,
        })
    end):colorpicker({
        name = "Fill Color",
        flag = path .. "_highlight_fill_color",
        color = rgb(255, 255, 255),
        alpha = 0.5,
        callback = function(color, alpha)
            esp.path(path .. ".highlight.fill.color", color)
            esp.path(path .. ".highlight.fill.transparency", 1 - alpha)
            esp.refresh(bot)
        end,
    }):colorpicker({
        name = "Outline Color",
        flag = path .. "_highlight_outline_color",
        color = rgb(255, 255, 255),
        alpha = 1,
        callback = function(color, alpha)
            esp.path(path .. ".highlight.outline.color", color)
            esp.path(path .. ".highlight.outline.transparency", 1 - alpha)
            esp.refresh(bot)
        end,
    })
end

local visuals = module("visuals")

function visuals.update_lighting()
    local l = config.visuals.lighting
    if l.override_ambient then
        util:set_property(Lighting, "Ambient", l.ambient)
        util:set_property(Lighting, "OutdoorAmbient", l.outdoor_ambient)
    end
    if l.override_brightness then
        util:set_property(Lighting, "Brightness", l.brightness)
    end
    if l.override_clocktime then
        util:set_property(Lighting, "ClockTime", l.clock_time)
    end
end

function visuals.update_atmosphere()
    local atmosphere = Lighting:FindFirstChildOfClass("Atmosphere")
    if not atmosphere then
        return
    end
    local a = config.visuals.lighting.atmosphere
    if a.override_fog then
        util:set_property(atmosphere, "Density", a.density)
        util:set_property(atmosphere, "Offset", a.offset)
    end
    if a.override_fog_colors then
        util:set_property(atmosphere, "Color", a.color)
        util:set_property(atmosphere, "Decay", a.decay)
    end
    if a.override_glare then
        util:set_property(atmosphere, "Glare", a.glare)
    end
    if a.override_haze then
        util:set_property(atmosphere, "Haze", a.haze)
    end
end

function visuals.update_bloom()
    local bloom = Lighting:FindFirstChildOfClass("BloomEffect")
    local b = config.visuals.lighting.bloom
    if not bloom or not b.override_bloom then
        return
    end
    util:set_property(bloom, "Intensity", b.intensity)
    util:set_property(bloom, "Size", b.size)
    util:set_property(bloom, "Threshold", b.threshold)
end

function visuals.update_terrain()
    for material, entry in config.visuals.world.terrain_colors do
        local default = terrain_defaults[material]
        if default then
            if entry.enabled and entry.color then
                terrain:SetMaterialColor(Enum.Material[material], entry.color)
            else
                terrain:SetMaterialColor(Enum.Material[material], default)
            end
        end
    end
end

function visuals.update_camera()
    local ar = config.visuals.local_self.aspect_ratio
    if ar.enabled then
        local camera = workspace.CurrentCamera
        local x, y, z, r00, r01, r02, r10, r11, r12, r20, r21, r22 = camera.CFrame:GetComponents()
        local h, v = ar.horizontal / 100, ar.vertical / 100
        camera.CFrame = CFrame.new(x, y, z, r00 * h, r01 * v, r02, r10, r11 * v, r12, r20 * h, r21 * v, r22)
    end
end

function visuals.update_water_blur()
    local blur = Lighting:FindFirstChild("WaterBlur")
    if blur then
        blur.Size = config.misc.movement.no_drown and 0 or 24
    end
end

function visuals.check_foliage(obj)
    if obj and obj:IsA("MeshPart") then
        local world_settings = config.visuals.world
        if obj.Color == rgb(108, 88, 75) then
            util:set_property(obj, "Transparency", world_settings.remove_trees and 1 or 0)
        else
            util:set_property(obj, "Transparency", world_settings.remove_foliage and 1 or 0)
        end
    end
end

function visuals.update_foliage()
    local foliage = find(world("SpawnerZones"), "Foliage")
    if foliage then
        for _, obj in foliage:GetDescendants() do
            visuals.check_foliage(obj)
        end
    end
end

function visuals.update_character()
    local char = lp.Character
    if not char then
        return
    end
    local cache = config.character_cache
    local ls = config.visuals.local_self
    local function remember(part)
        if cache.transparency[part] == nil then
            cache.transparency[part] = part.Transparency
            cache.color[part] = part.Color
            cache.material[part] = part.Material
        end
    end
    if ls.player_chams then
        local material = Enum.Material[ls.player_material]
        for _, part in char:GetChildren() do
            if part:IsA("MeshPart") and part.Name ~= "FaceHitBox" and part.Name ~= "HeadTopHitBox" then
                remember(part)
                util:set_property(part, "Transparency", ls.player_transparency)
                util:set_property(part, "Color", ls.player_color)
                util:set_property(part, "Material", material or part.Material)
            end
        end
        for _, model in char:GetChildren() do
            if model:IsA("Model") and model:GetAttribute("ItemType") then
                for _, part in model:GetChildren() do
                    if part:IsA("MeshPart") then
                        remember(part)
                        if ls.remove_clothing then
                            util:set_property(part, "Transparency", 1)
                            util:set_property(char:FindFirstChild("Pants"), "PantsTemplate", "rbxassetid://0")
                            util:set_property(char:FindFirstChild("Shirt"), "ShirtTemplate", "rbxassetid://0")
                        else
                            util:set_property(part, "Transparency", ls.player_transparency)
                            util:set_property(part, "Color", ls.player_color)
                            util:set_property(part, "Material", material or part.Material)
                            util:set_property(char:FindFirstChild("Pants"), "PantsTemplate", "rbxassetid://224941104")
                            util:set_property(char:FindFirstChild("Shirt"), "ShirtTemplate", "rbxassetid://5812338094")
                        end
                        local surface = part:FindFirstChildOfClass("SurfaceAppearance")
                        if surface then
                            cache.surface_appearances[part] = surface
                            surface.Parent = gui_parent
                        end
                    end
                end
            end
        end
        return
    end
    for part in cache.transparency do
        if part and part.Parent then
            util:set_property(part, "Transparency", cache.transparency[part])
            util:set_property(part, "Color", cache.color[part])
            util:set_property(part, "Material", cache.material[part])
        end
    end
    for part, surface in cache.surface_appearances do
        if surface and part then
            surface.Parent = part
        end
    end
    cache.surface_appearances = {}
end

function visuals.update_viewmodel()
    local camera = workspace.CurrentCamera
    local viewmodel_model = find(camera, "ViewModel")
    if not viewmodel_model then
        return
    end
    local highlight = viewmodel_model:FindFirstChildOfClass("Highlight")
    local vm = config.visuals.viewmodel
    local stored = config.stored_surface_appearances
    local arm_colors = config.original_arm_colors
    local vm_cache = config.viewmodel_cache
    if vm.offset.enabled then
        local hrp = find(viewmodel_model, "HumanoidRootPart")
        if hrp then
            for _, motor in hrp:GetChildren() do
                if motor:IsA("Motor6D") then
                    if not vm_cache[motor] then
                        vm_cache[motor] = motor.C0
                    end
                    motor.C0 = vm_cache[motor] + Vector3.new(vm.offset.x, vm.offset.y, vm.offset.z)
                end
            end
        end
    end
    if not vm.enabled then
        for _, group in stored do
            for part, entry in group do
                if part and part.Parent then
                    entry.surface.Parent = entry.parent
                    util:set_property(part, "Material", Enum.Material.Plastic)
                    util:set_property(part, "Color", rgb(255, 255, 255))
                    if part.Transparency ~= 1 then
                        util:set_property(part, "Transparency", 0)
                        part:SetAttribute("OriginalTransparency", part.Transparency)
                    end
                end
            end
        end
        stored.weapon = {}
        stored.clothing = {}
        for part, entry in arm_colors do
            if part and part.Parent then
                util:set_property(part, "Material", entry.material or Enum.Material.Plastic)
                util:set_property(part, "Color", entry.color or rgb(255, 255, 255))
                util:set_property(part, "Transparency", entry.transparency or 0)
                part:SetAttribute("OriginalTransparency", part.Transparency)
            end
        end
        if highlight then
            highlight:Destroy()
        end
        return
    end
    local arms_material = Enum.Material[vm.arms_material] or Enum.Material.ForceField
    local weapon_material = Enum.Material[vm.weapon_material] or Enum.Material.ForceField
    local function remember(part)
        if not arm_colors[part] then
            arm_colors[part] = { color = part.Color, material = part.Material, transparency = part.Transparency }
        end
    end
    local function paint_arm(part)
        remember(part)
        if vm.arms_enabled then
            util:set_property(part, "Material", arms_material)
            util:set_property(part, "Color", vm.arms_color)
            util:set_property(part, "Transparency", vm.arms_transparency)
        else
            util:set_property(part, "Material", arm_colors[part].material)
            util:set_property(part, "Color", arm_colors[part].color)
            util:set_property(part, "Transparency", arm_colors[part].transparency or 0)
        end
        part:SetAttribute("OriginalTransparency", part.Transparency)
    end
    local function paint_clothing(model)
        for _, part in model:GetDescendants() do
            if part:IsA("MeshPart") then
                local surface = part:FindFirstChildOfClass("SurfaceAppearance")
                remember(part)
                if vm.remove_clothing then
                    util:set_property(part, "Transparency", 1)
                elseif vm.arms_enabled then
                    util:set_property(part, "Material", arms_material)
                    util:set_property(part, "Color", vm.arms_color)
                    util:set_property(part, "Transparency", vm.arms_transparency)
                    if surface and not stored.clothing[part] then
                        stored.clothing[part] = { surface = surface, parent = surface.Parent }
                        surface.Parent = gui_parent
                    end
                else
                    util:set_property(part, "Color", arm_colors[part].color)
                    util:set_property(part, "Transparency", arm_colors[part].transparency or 0)
                    if stored.clothing[part] then
                        stored.clothing[part].surface.Parent = stored.clothing[part].parent
                        stored.clothing[part] = nil
                    end
                end
                part:SetAttribute("OriginalTransparency", part.Transparency)
            end
        end
    end
    local shirt, gloves
    for _, model in viewmodel_model:GetChildren() do
        if model:IsA("Model") then
            local item_type = model:GetAttribute("ItemType")
            if item_type == "Shirt" then
                shirt = model
            elseif item_type == "Gloves" then
                gloves = model
            end
        end
    end
    if shirt then
        paint_clothing(shirt)
        if shirt.Name == "GhillieTorso" then
            for _, name in { "LL", "LU", "RL", "RU" } do
                local part = find(shirt, name)
                if part and part:IsA("MeshPart") then
                    util:set_property(part, "TextureID", "")
                end
            end
        end
    end
    if gloves then
        paint_clothing(gloves)
    end
    for _, part in viewmodel_model:GetChildren() do
        if part:IsA("MeshPart") then
            paint_arm(part)
        end
    end
    local item = find(viewmodel_model, "Item")
    if item and vm.weapon_enabled then
        local function paint_weapon(part)
            if part:IsA("MeshPart") and part.MeshId ~= "" and part.Transparency ~= 1 then
                local surface = part:FindFirstChildOfClass("SurfaceAppearance")
                if surface and not stored.weapon[part] then
                    stored.weapon[part] = { surface = surface, parent = surface.Parent }
                    surface.Parent = gui_parent
                end
                util:set_property(part, "Material", weapon_material)
                util:set_property(part, "Color", vm.weapon_color)
                util:set_property(part, "Transparency", vm.weapon_transparency)
                part:SetAttribute("OriginalTransparency", part.Transparency)
            elseif part:IsA("BasePart") and part.Transparency ~= 1 then
                util:set_property(part, "Material", weapon_material)
                util:set_property(part, "Color", vm.weapon_color)
                util:set_property(part, "Transparency", vm.weapon_transparency)
                part:SetAttribute("OriginalTransparency", part.Transparency)
            end
        end
        for _, part in item:GetDescendants() do
            paint_weapon(part)
        end
        local attachments = find(item, "Attachments")
        if attachments and attachments:IsA("Folder") then
            task.wait(0.1)
            for _, part in attachments:GetDescendants() do
                paint_weapon(part)
            end
        end
    else
        for part, entry in stored.weapon do
            if part and part.Parent then
                entry.surface.Parent = entry.parent
                util:set_property(part, "Material", Enum.Material.Plastic)
                util:set_property(part, "Color", rgb(255, 255, 255))
                util:set_property(part, "Transparency", part:GetAttribute("OriginalTransparency") or 0)
            end
        end
        stored.weapon = {}
    end
    if not highlight then
        highlight = Instance.new("Highlight")
        highlight.Enabled = false
        highlight.DepthMode = Enum.HighlightDepthMode.Occluded
        highlight.FillColor = rgb(45, 209, 235)
        highlight.OutlineColor = rgb(45, 209, 235)
        highlight.Parent = viewmodel_model
    end
    local hl = vm.highlight
    util:set_enabled(highlight, hl.enabled)
    util:set_property(highlight, "FillColor", hl.fill.color)
    util:set_property(highlight, "FillTransparency", hl.fill.transparency * hl.fill.multiplier)
    util:set_property(highlight, "OutlineColor", hl.outline.color)
    util:set_property(highlight, "OutlineTransparency", hl.outline.transparency * hl.outline.multiplier)
end

local crosshair_state = {}
local fov_state = {}
local snapline_state = {}
local animation_state = { by_track = {} }
local hud_parent = gethui and gethui() or gui_parent

function visuals.create_crosshair()
    crosshair_state.screen_gui = new("ScreenGui", {
        Enabled = true,
        DisplayOrder = 9999999,
        IgnoreGuiInset = true,
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Global,
        Parent = hud_parent,
    })
    crosshair_state.crosshair_holder = new("Frame", {
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundTransparency = 1,
        Position = dim2(0.5, 0, 0.5, 0),
        Size = dim2(0, 50, 0, 50),
        Parent = crosshair_state.screen_gui,
    })
    local spokes = {
        { name = "top", position = dim2(0.5, 0, 0, 0), size = dim2(0, 1, 0, 38), rotation = 90 },
        { name = "right", position = dim2(1, 0, 0.5, 0), size = dim2(0, 38, 0, 1), rotation = -180 },
        { name = "bottom", position = dim2(0.5, 0, 1, 0), size = dim2(0, 1, 0, 38), rotation = -90 },
        { name = "left", position = dim2(0, 0, 0.5, 0), size = dim2(0, 38, 0, 1), rotation = 0 },
    }
    for _, spec in spokes do
        local spoke = new("Frame", {
            AnchorPoint = Vector2.new(0.5, 0.5),
            BorderSizePixel = 0,
            BackgroundColor3 = rgb(255, 255, 255),
            Position = spec.position,
            Size = spec.size,
            ZIndex = 5,
            Parent = crosshair_state.crosshair_holder,
        })
        crosshair_state["spoke_" .. spec.name] = spoke
        crosshair_state["spoke_gradient_" .. spec.name] = new("UIGradient", {
            Color = cseq({ ckey(0, rgb(255, 72, 118)), ckey(1, rgb(255, 72, 118)) }),
            Rotation = spec.rotation,
            Parent = spoke,
        })
        crosshair_state[spec.name .. "_outline"] = new("UIStroke", {
            Color = rgb(0, 0, 0),
            Thickness = 1,
            LineJoinMode = Enum.LineJoinMode.Miter,
            Parent = spoke,
        })
    end
end

function visuals.update_crosshair()
    local c = settings.visuals.crosshair
    util:set_enabled(crosshair_state.screen_gui, c.enabled)
    local gap = c.gap
    local length = c.length
    local width = c.width
    local holder = crosshair_state.crosshair_holder
    util:set_property(holder, "Size", dim2(0, length + gap, 0, length + gap))
    if not c.spin then
        util:set_property(holder, "Rotation", c.rotation)
    end
    if c.position == "Center" then
        util:set_property(holder, "Position", dim2(0.5, 0, 0.5, 0))
    end
    local color = cseq({ ckey(0, c.color_1), ckey(1, c.color_2) })
    local transparency = nseq({ nkey(0, c.color_transparency_1), nkey(1, c.color_transparency_2) })
    for _, name in { "top", "right", "bottom", "left" } do
        util:set_property(crosshair_state["spoke_gradient_" .. name], "Color", color)
        util:set_property(crosshair_state["spoke_gradient_" .. name], "Transparency", transparency)
    end
    util:set_property(crosshair_state.spoke_top, "Size", dim2(0, width, 0, length))
    util:set_property(crosshair_state.spoke_bottom, "Size", dim2(0, width, 0, length))
    util:set_property(crosshair_state.spoke_left, "Size", dim2(0, length, 0, width))
    util:set_property(crosshair_state.spoke_right, "Size", dim2(0, length, 0, width))
    for _, name in { "top", "right", "bottom", "left" } do
        local outline = crosshair_state[name .. "_outline"]
        util:set_enabled(outline, c.outline)
        util:set_property(outline, "Color", c.outline_color)
        util:set_property(outline, "Transparency", c.outline_transparency)
    end
end

function visuals.animate_crosshair(dt)
    local c = settings.visuals.crosshair
    local animation = c.animation
    if animation.resize then
        local length = c.length
        local gap = c.gap
        if animation.length.resize or animation.gap.resize then
            local t = (animation.t or 0) + animation.speed * dt
            if t >= 1 then
                t = 0
                animation.going_out = not animation.going_out
            end
            animation.t = t
            local k = animation.going_out and t or (1 - t)
            if animation.length.resize then
                length = c.length + (animation.length.value - c.length) * k
            end
            if animation.gap.resize then
                gap = c.gap + (animation.gap.value - c.gap) * k
            end
        end
        util:set_property(crosshair_state.crosshair_holder, "Size", dim2(0, length + gap, 0, length + gap))
        util:set_property(crosshair_state.spoke_top, "Size", dim2(0, c.width, 0, length))
        util:set_property(crosshair_state.spoke_bottom, "Size", dim2(0, c.width, 0, length))
        util:set_property(crosshair_state.spoke_left, "Size", dim2(0, length, 0, c.width))
        util:set_property(crosshair_state.spoke_right, "Size", dim2(0, length, 0, c.width))
    end
    if c.spin then
        local holder = crosshair_state.crosshair_holder
        util:set_property(holder, "Rotation", (holder.Rotation + c.spin_speed) % 360)
    end
    if c.position == "Mouse" then
        local mouse = UserInputService:GetMouseLocation()
        util:set_property(crosshair_state.crosshair_holder, "Position", dim2(0, mouse.X, 0, mouse.Y))
    elseif c.position == "Target" then
        if current_target_part then
            local point, visible = util.get_screen_pos(current_target_part.Position)
            util:set_property(crosshair_state.crosshair_holder, "Position", visible and dim2(0, point.X, 0, point.Y) or dim2(0.5, 0, 0.5, 0))
        else
            util:set_property(crosshair_state.crosshair_holder, "Position", dim2(0.5, 0, 0.5, 0))
        end
    end
end

function visuals.create_fov()
    fov_state.screen_gui = new("ScreenGui", {
        Enabled = true,
        IgnoreGuiInset = true,
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Global,
        Parent = hud_parent,
    })
    fov_state.fov_holder = new("Frame", {
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundTransparency = 1,
        Position = dim2(0.5, 0, 0.5, 0),
        Size = dim2(0, 150, 0, 150),
        Parent = fov_state.screen_gui,
    })
    fov_state.fov_fill = new("Frame", {
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundTransparency = 1,
        Position = dim2(0.5, 0, 0.5, 0),
        Size = dim2(1, 2, 1, 2),
        ZIndex = 2,
        Parent = fov_state.fov_holder,
    })
    fov_state.fov_fill_gradient = new("UIGradient", {
        Color = cseq({ ckey(0, rgb(45, 209, 235)), ckey(1, rgb(203, 79, 104)) }),
        Parent = fov_state.fov_fill,
    })
    fov_state.fill_ui_corner = new("UICorner", { CornerRadius = dim(0, 1000), Parent = fov_state.fov_fill })
    fov_state.fill_ui_stroke = new("UIStroke", { Enabled = true, Color = rgb(255, 255, 255), Thickness = 1, Parent = fov_state.fov_fill })
    fov_state.fill_gradient = new("UIGradient", {
        Color = cseq({ ckey(0, rgb(45, 209, 235)), ckey(1, rgb(203, 79, 104)) }),
        Parent = fov_state.fill_ui_stroke,
    })
    fov_state.fov_outline = new("Frame", {
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundTransparency = 1,
        Position = dim2(0.5, 0, 0.5, 0),
        Size = dim2(1, 0, 1, 0),
        Parent = fov_state.fov_holder,
    })
    fov_state.outline_ui_corner = new("UICorner", { CornerRadius = dim(0, 1000), Parent = fov_state.fov_outline })
    fov_state.outline_ui_stroke = new("UIStroke", { Color = rgb(0, 0, 0), Thickness = 3, Parent = fov_state.fov_outline })
    fov_state.glow = new("ImageLabel", {
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundTransparency = 1,
        Position = dim2(0.5, 0, 0.5, 0),
        Size = dim2(1.245, 0, 1.245, 0),
        ImageColor3 = rgb(255, 255, 255),
        Image = library.images["Fov Glow"],
        ZIndex = 0,
        Parent = fov_state.fov_holder,
    })
    fov_state.glow_gradient = new("UIGradient", {
        Color = cseq({ ckey(0, rgb(45, 209, 235)), ckey(1, rgb(203, 79, 104)) }),
        Transparency = nseq({ nkey(0, 0.5), nkey(1, 0.5) }),
        Parent = fov_state.glow,
    })
end

function visuals.update_fov()
    local v = settings.combat.visualization
    local radius = settings.combat.aiming.fov_radius
    util:set_enabled(fov_state.screen_gui, v.fov_enabled)
    util:set_property(fov_state.fov_holder, "Size", dim2(0, radius * 2, 0, radius * 2))
    util:set_property(fov_state.fov_fill, "BackgroundTransparency", v.fov_fill and 0 or 1)
    util:set_property(fov_state.fov_fill_gradient, "Color", cseq({ ckey(0, v.fov_fill_color_1), ckey(1, v.fov_fill_color_2) }))
    util:set_property(fov_state.fov_fill_gradient, "Transparency", nseq({ nkey(0, v.fov_fill_transparency_1), nkey(1, v.fov_fill_transparency_2) }))
    util:set_property(fov_state.fill_gradient, "Color", cseq({ ckey(0, v.fov_color_1), ckey(1, v.fov_color_2) }))
    util:set_property(fov_state.fill_gradient, "Transparency", nseq({ nkey(0, v.fov_transparency_1), nkey(1, v.fov_transparency_2) }))
    util:set_property(fov_state.fill_ui_stroke, "Thickness", v.thickness)
    util:set_enabled(fov_state.outline_ui_stroke, v.fov_outline)
    util:set_property(fov_state.outline_ui_stroke, "Thickness", v.thickness + 2)
    util:set_property(fov_state.outline_ui_stroke, "Color", v.fov_outline_color)
    util:set_property(fov_state.outline_ui_stroke, "Transparency", v.fov_outline_transparency)
    util:set_visible(fov_state.glow, v.fov_fill_glow)
    util:set_property(fov_state.glow_gradient, "Color", cseq({ ckey(0, v.fill_glow_color_1), ckey(1, v.fill_glow_color_2) }))
    util:set_property(fov_state.glow_gradient, "Transparency", nseq({ nkey(0, v.fill_glow_transparency_1), nkey(1, v.fill_glow_transparency_2) }))
    if not v.spin_gradients then
        util:set_property(fov_state.fill_gradient, "Rotation", 0)
        util:set_property(fov_state.fov_fill_gradient, "Rotation", 0)
        util:set_property(fov_state.glow_gradient, "Rotation", 0)
    end
end

function visuals.spin_fov()
    local v = settings.combat.visualization
    if v.spin_gradients then
        local rotation = (fov_state.fov_fill_gradient.Rotation + v.spin_speed) % 360
        util:set_property(fov_state.fov_fill_gradient, "Rotation", rotation)
        util:set_property(fov_state.fill_gradient, "Rotation", rotation)
        util:set_property(fov_state.glow_gradient, "Rotation", rotation)
    end
end

function visuals.create_sline()
    snapline_state.screen_gui = new("ScreenGui", {
        Enabled = true,
        DisplayOrder = 9999999,
        IgnoreGuiInset = true,
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Global,
        Parent = hud_parent,
    })
    snapline_state.snapline_holder = new("Frame", {
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = rgb(255, 255, 255),
        BorderSizePixel = 0,
        Position = dim2(0.5, 0, 0.5, 0),
        Size = UDim2.fromOffset(0, settings.combat.visualization.snapline_thickness),
        Visible = false,
        Parent = snapline_state.screen_gui,
    })
    snapline_state.snapline_gradient = new("UIGradient", {
        Color = cseq({ ckey(0, rgb(45, 209, 235)), ckey(1, rgb(203, 79, 104)) }),
        Parent = snapline_state.snapline_holder,
    })
    snapline_state.snapline_stroke = new("UIStroke", {
        Enabled = true,
        Color = rgb(0, 0, 0),
        Thickness = 1,
        LineJoinMode = Enum.LineJoinMode.Miter,
        Parent = snapline_state.snapline_holder,
    })
end

function visuals.update_snapline()
    local v = settings.combat.visualization
    util:set_enabled(snapline_state.screen_gui, v.snapline_enabled)
    util:set_visible(snapline_state.snapline_holder, settings.combat.aiming.silent_aim)
    if v.snapline_enabled then
        util:set_property(snapline_state.snapline_gradient, "Color", cseq({ ckey(0, v.snapline_color_1), ckey(1, v.snapline_color_2) }))
        util:set_property(snapline_state.snapline_gradient, "Transparency", nseq({ nkey(0, v.snapline_transparency_1), nkey(1, v.snapline_transparency_2) }))
        util:set_enabled(snapline_state.snapline_stroke, v.snapline_outline)
        util:set_property(snapline_state.snapline_stroke, "Color", v.snapline_outline_color)
        util:set_property(snapline_state.snapline_stroke, "Transparency", v.snapline_outline_transparency)
    end
end

function visuals.draw_snapline(part)
    local holder = snapline_state.snapline_holder
    if settings.combat.visualization.snapline_enabled and part then
        local viewport = camera.ViewportSize
        local center = Vector2.new(viewport.X / 2, viewport.Y / 2)
        local point, visible = util.get_screen_pos(part.Position)
        if visible then
            local target = Vector2.new(point.X, point.Y)
            if (target - center).Magnitude <= settings.combat.aiming.fov_radius then
                local delta = target - center
                local mid = (center + target) / 2
                local length = delta.Magnitude
                local angle = math.deg(math.atan2(delta.Y, delta.X))
                util:set_property(holder, "Position", UDim2.fromOffset(mid.X, mid.Y))
                util:set_property(holder, "Rotation", angle)
                util:set_property(holder, "Size", UDim2.fromOffset(length, settings.combat.visualization.snapline_thickness))
                util:set_property(holder, "Visible", true)
                return
            end
        end
        util:set_property(holder, "Visible", false)
        return
    end
    util:set_property(holder, "Visible", false)
end

function visuals.create_tracer(hit_position)
    task.spawn(function()
        local head = util.get_head_pos()
        if not head then
            return
        end
        local tracers = settings.combat.visualization.bullet_tracers
        local origin = new("Part", {
            Anchored = true,
            Size = Vector3.new(0.01, 0.01, 0.01),
            Position = head.Position,
            CanCollide = false,
            CanQuery = false,
            Transparency = 1,
            Parent = world("NoCollision"),
        })
        local target = new("Part", {
            Anchored = true,
            Size = Vector3.new(0.01, 0.01, 0.01),
            Position = hit_position,
            CanCollide = false,
            CanQuery = false,
            Transparency = 1,
            Parent = world("NoCollision"),
        })
        local a0 = new("Attachment", { Parent = origin })
        local a1 = new("Attachment", { Parent = target })
        local curve_1 = tracers.randomize_curve and (math.random(0, 1) == 0 and -math.abs(tracers.curve_1) or math.abs(tracers.curve_1)) or tracers.curve_1
        local curve_2 = tracers.randomize_curve and (math.random(0, 1) == 0 and -math.abs(tracers.curve_2) or math.abs(tracers.curve_2)) or tracers.curve_2
        local beam = new("Beam", {
            Attachment0 = a0,
            Attachment1 = a1,
            Color = cseq({ ckey(0, tracers.color_1), ckey(1, tracers.color_2) }),
            Width0 = tracers.width,
            Width1 = tracers.width,
            FaceCamera = true,
            Transparency = nseq({ nkey(0, tracers.transparency_1), nkey(1, tracers.transparency_2) }),
            LightEmission = 1,
            Texture = tracers.bullet_textures[tracers.texture],
            TextureSpeed = tracers.texture_speed,
            TextureLength = (hit_position - head.Position).Magnitude,
            Segments = tracers.segments,
            CurveSize0 = curve_1,
            CurveSize1 = curve_2,
            Parent = origin,
        })
        task.wait(tracers.lifetime)
        for i = 0, 1, 0.1 do
            beam.Transparency = nseq(i)
            task.wait()
        end
        origin:Destroy()
        target:Destroy()
    end)
end

function visuals.create_impact(position)
    task.spawn(function()
        local impacts = settings.combat.visualization.bullet_impacts
        local part = new("Part", {
            Anchored = true,
            Material = Enum.Material[impacts.material],
            Color = impacts.color,
            Size = Vector3.new(0.5, 0.5, 0.5),
            Position = position,
            CanCollide = false,
            CanQuery = false,
            Transparency = impacts.transparency,
            Parent = world("NoCollision"),
        })
        task.wait(impacts.lifetime)
        for i = part.Transparency + 0.1, 1, 0.1 do
            part.Transparency = i
            task.wait()
        end
        part.Transparency = 1
        part:Destroy()
    end)
end

function visuals.create_hitmarker(position)
    task.spawn(function()
        local hitmarkers = settings.combat.visualization.hitmarkers
        local part = new("Part", {
            Anchored = true,
            Size = Vector3.new(0.1, 0.1, 0.1),
            Position = position,
            CanCollide = false,
            CanQuery = false,
            Transparency = 1,
            Parent = world("NoCollision"),
        })
        local billboard = new("BillboardGui", {
            Size = dim2(0, 10, 0, 10),
            AlwaysOnTop = true,
            Enabled = true,
            LightInfluence = 0,
            Adornee = part,
            Parent = part,
        })
        local image = new("ImageLabel", {
            Size = dim2(1, 0, 1, 0),
            BackgroundTransparency = 1,
            Image = library.images.hitmarkers[hitmarkers.image],
            ImageTransparency = hitmarkers.transparency,
            ImageColor3 = hitmarkers.color,
            ResampleMode = Enum.ResamplerMode.Pixelated,
            ZIndex = 99999,
            Parent = billboard,
        })
        local outline = new("ImageLabel", {
            Visible = hitmarkers.outline,
            Size = dim2(1, 0, 1, 0),
            BackgroundTransparency = 1,
            Image = library.images.hitmarkers["Outline " .. hitmarkers.image],
            ImageTransparency = hitmarkers.outline_transparency,
            ImageColor3 = hitmarkers.outline_color,
            ResampleMode = Enum.ResamplerMode.Pixelated,
            ZIndex = 99999,
            Parent = image,
        })
        task.wait(hitmarkers.lifetime)
        for i = image.ImageTransparency + 0.1, 1, 0.1 do
            image.ImageTransparency = i
            outline.ImageTransparency = i
            task.wait()
        end
        image.ImageTransparency = 1
        outline.ImageTransparency = 1
        part:Destroy()
    end)
end

local vfx_textures = {
    glow = "rbxassetid://15153511168",
    shards = "rbxassetid://12130244331",
    shine = "rbxassetid://14960943986",
    star = "rbxassetid://10399834408",
}

function visuals.create_vfx(position)
    task.spawn(function()
        local hit_vfx = settings.combat.visualization.hit_vfx
        local part = new("Part", {
            Anchored = true,
            Size = Vector3.new(0.1, 0.1, 0.1),
            Position = position,
            CanCollide = false,
            CanQuery = false,
            Transparency = 1,
            Parent = world("NoCollision"),
        })
        local emitters = {}
        for _, name in hit_vfx.particles or {} do
            local emitter = new("ParticleEmitter", {
                Texture = vfx_textures[name:lower()] or vfx_textures.shards,
                Lifetime = NumberRange.new(0.6, 1),
                Speed = NumberRange.new(50, 75),
                SpreadAngle = Vector2.new(180, 180),
                Drag = 20,
                Brightness = 8,
                LightEmission = 1,
                LightInfluence = 0,
                ZOffset = 2,
                Parent = part,
            })
            emitter.Enabled = true
            if hit_vfx.rate then
                emitter.Rate = hit_vfx.rate
            end
            if hit_vfx.color then
                emitter.Color = cseq(hit_vfx.color)
            end
            table.insert(emitters, emitter)
        end
        task.wait(hit_vfx.lifetime or 0.3)
        for _, emitter in emitters do
            emitter.Enabled = false
        end
        task.wait(0.75)
        part:Destroy()
    end)
end

function visuals.preview_sound(sound_id, volume, pitch)
    local connection
    local sound = new("Sound", { SoundId = sound_id, Volume = volume, PlaybackSpeed = pitch, Parent = hud_parent })
    sound:Play()
    connection = library:connection(sound.Ended, function()
        sound:Destroy()
        library:disconnect(connection)
    end)
end

function visuals.update_whiz()
    local whiz = find(find(ReplicatedStorage, "SFX"), "Whiz")
    if not whiz then
        return
    end
    local ls = settings.visuals.local_self
    local volume = ls.override_whiz and ls.whiz_volume or 2
    for _, sound in whiz:GetChildren() do
        util:set_property(sound, "Volume", volume)
    end
end

local hitsound_ids = {
    head = { ["rbxassetid://4585351098"] = true, ["rbxassetid://4585382589"] = true },
    body = { ["rbxassetid://4585382046"] = true, ["rbxassetid://4585364605"] = true },
    kill = { ["rbxassetid://9120454415"] = true },
}

function visuals.replace_hitsound(sound)
    if not sound:IsA("Sound") then
        return
    end
    local sounds = settings.combat.visualization.hitsounds
    local head, body, kill = sounds.head, sounds.body, sounds.kill
    local id = sound.SoundId
    if head.enabled and hitsound_ids.head[id] then
        util:set_property(sound, "SoundId", library.hitsounds[head.sound])
        util:set_property(sound, "Volume", head.volume)
        util:set_property(sound, "PlaybackSpeed", head.pitch)
    elseif body.enabled and hitsound_ids.body[id] then
        util:set_property(sound, "SoundId", library.hitsounds[body.sound])
        util:set_property(sound, "Volume", body.volume)
        util:set_property(sound, "PlaybackSpeed", body.pitch)
    elseif kill.enabled and hitsound_ids.kill[id] then
        util:set_property(sound, "SoundId", library.hitsounds[kill.sound])
        util:set_property(sound, "Volume", kill.volume)
        util:set_property(sound, "PlaybackSpeed", kill.pitch)
    end
end

function visuals.hitsounds()
    library:connection(main_gui.ChildAdded, visuals.replace_hitsound)
end

local gas_mask_conn

function visuals.update_ui()
    local player_gui = lp:FindFirstChildOfClass("PlayerGui")
    local hide = settings.visuals.ui_hide
    for _, name in hide.elements do
        util:set_enabled(find(player_gui, name), not (hide.enabled and hide.hide))
    end
    local removals = settings.visuals.ui_removals
    if not removals then
        return
    end
    local blur = find(Lighting, "InventoryBlur")
    local hidden = hide.enabled and hide.hide and table.find(hide.elements, "MainGui")
    local removed = removals.enabled and table.find(removals.elements, "Inventory Blur")
    if blur then
        util:set_enabled(blur, not (hidden or removed))
    end
    local main_frame = find(find(player_gui, "NoInsetGui"), "MainFrame")
    if not main_frame then
        return
    end
    local backpack = find(find(find(player_gui, "MainGui"), "MainFrame"), "BackpackFrame")
    if not backpack then
        return
    end
    local effects = find(main_frame, "ScreenEffects")
    if not effects then
        return
    end
    local groups = {
        Visor = { find(effects, "HelmetMask"), find(effects, "Visor"), find(effects, "Mask") },
        Flashbang = { find(find(effects, "Flashbang"), "ImageLabel") },
        Parallax = { find(find(effects, "Parallax"), "Parallax") },
    }
    for name, objects in groups do
        local enabled = removals.enabled and table.find(removals.elements, name)
        for _, obj in objects do
            if obj then
                util:set_visible(obj, not enabled)
            end
        end
    end
    local background = table.find(removals.elements, "Inventory Background")
    local decoration = table.find(removals.elements, "Inventory Decoration")
    for _, child in backpack:GetChildren() do
        if child:IsA("Frame") then
            if removals.enabled and background then
                util:set_property(child, "BackgroundTransparency", 1)
            else
                util:set_property(child, "BackgroundTransparency", 0.05)
            end
            local decor = find(child, "Decor")
            if removals.enabled and decoration then
                util:set_visible(decor, false)
            else
                util:set_visible(decor, true)
            end
        end
    end
    local gas_removed = removals.enabled and table.find(removals.elements, "Gas Mask")
    local gas_mask = find(find(find(effects, "Mask"), "GP5"), "GasMask")
    if gas_mask then
        if gas_removed then
            if gas_mask.IsPlaying then
                gas_mask:Stop()
            end
            if not gas_mask_conn then
                gas_mask_conn = gas_mask:GetPropertyChangedSignal("Playing"):Connect(function()
                    if gas_removed then
                        gas_mask:Stop()
                    end
                end)
            end
        elseif gas_mask_conn then
            gas_mask_conn:Disconnect()
            gas_mask_conn = nil
        end
    end
end

local function reports_node()
    return find(find(find(player_node(), "Status"), "UAC"), "Reports")
end

function visuals.update_reports()
    local report = settings.misc.notifications.report
    local reports = reports_node()
    if report.enabled and reports then
        library:notification({
            text = "You have been reported! Current report count: " .. (reports:GetAttribute(settings.reports.attribute) or 1),
            flashing = report.flashing,
            time = report.duration,
            sound = report.sound,
            volume = report.volume,
        })
    end
end

function visuals.update_report_count()
    local reports = reports_node()
    local count = reports and reports:GetAttribute(settings.reports.attribute) or 0
    local text
    if count > 0 then
        text = "You have been reported " .. count .. " time" .. (count == 1 and "" or "s") .. "!"
    else
        text = "You have not been reported"
    end
    library:notification({
        text = text,
        flashing = settings.misc.notifications.report.flashing,
        time = settings.misc.notifications.report.duration,
    })
end

function visuals.log_player_action(player, action)
    local entry = settings.misc.notifications[action]
    if not entry.enabled then
        return
    end
    local text
    if action == "join" then
        local kd, hours
        local node = player_data():WaitForChild(player.Name, 15)
        local status = node and node:WaitForChild("Status", 15)
        local journey = status and status:WaitForChild("Journey", 15)
        local statistics = journey and journey:WaitForChild("Statistics", 15)
        if statistics then
            task.wait(1)
            local kills = statistics:GetAttribute("Kills")
            local deaths = statistics:GetAttribute("Deaths")
            local played = statistics:GetAttribute("TimePlayed")
            if kills and deaths and played then
                if entry.kd then
                    kd = string.format("%.2f", kills == 0 and 0 or kills / (deaths == 0 and 1 or deaths))
                end
                if entry.hours_played then
                    hours = tostring(math.round(played / 3600 * 100) / 100)
                end
            end
        end
        text = player.Name .. " has joined the game"
        if kd and hours then
            text ..= " (KD: " .. kd .. " / Time Played: " .. hours .. "h)"
        elseif kd then
            text ..= " (KD: " .. kd .. ")"
        elseif hours then
            text ..= " (Time Played: " .. hours .. "h)"
        end
    else
        text = player.Name .. " has left the game"
    end
    library:notification({ text = text, flashing = entry.flashing, time = entry.duration })
end

function visuals.desync_visualizer()
    visuals.joint_map = nil
    if settings.server_character then
        settings.server_character:Destroy()
        settings.server_character = nil
    end
    character:WaitForChild("HumanoidRootPart")
    local adornments = {}
    settings.server_character = new("Model", { Name = "server", Parent = character })
    local clones = {}
    for _, part in character:GetChildren() do
        if part:IsA("BasePart") and part.Name ~= "FaceHitBox" and part.Name ~= "HeadTopHitBox" then
            local clone = new("Part", {
                Name = part.Name,
                Size = part.Size,
                CFrame = part.CFrame,
                Anchored = false,
                CanCollide = false,
                Transparency = 1,
                Parent = settings.server_character,
            })
            clones[part] = clone
            if part.Name ~= "HumanoidRootPart" then
                table.insert(adornments, new("BoxHandleAdornment", {
                    Adornee = clone,
                    Size = part.Size,
                    Color3 = rgb(45, 209, 235),
                    Transparency = 0,
                    AlwaysOnTop = true,
                    ZIndex = 1,
                    Shading = Enum.AdornShading.XRay,
                    Parent = clone,
                }))
            end
        end
    end
    local joint_map = {}
    for real_part, clone in clones do
        for _, joint in real_part:GetChildren() do
            if joint:IsA("Motor6D") and joint.Part0 and joint.Part1 and clones[joint.Part0] and clones[joint.Part1] then
                table.insert(joint_map, {
                    real = joint,
                    clone = new("Motor6D", {
                        Name = joint.Name,
                        Part0 = clones[joint.Part0],
                        Part1 = clones[joint.Part1],
                        C0 = joint.C0,
                        C1 = joint.C1,
                        Parent = clone,
                    }),
                })
            end
        end
    end
    local root = clones[character.HumanoidRootPart]
    root.Anchored = true
    settings.server_character.PrimaryPart = root
    new("Humanoid", { Parent = settings.server_character })
    visuals.joint_map = joint_map
    visuals.visualizer_adornments = adornments
    return adornments
end

function visuals.update_visualizer()
    local adornments = visuals.visualizer_adornments
    if not adornments then
        return
    end
    local server = settings.misc.desync.visualization.server
    local color = server.color
    local c, f, t = color.c, color.f, color.t
    local r, g, b = c.R * 255 * f, c.G * 255 * f, c.B * 255 * f
    local shading = ({
        Default = Enum.AdornShading.XRay,
        Flat = Enum.AdornShading.Default,
        Shaded = Enum.AdornShading.XRayShaded,
    })[server.cham_type]
    for _, adornment in adornments do
        local visible = server.enabled
        if visible then
            visible = not (server.third_person_only and not settings.visuals.local_self.third_person)
        end
        util:set_visible(adornment, visible)
        util:set_property(adornment, "Color3", rgb(r, g, b))
        util:set_property(adornment, "Transparency", t)
        if shading then
            util:set_property(adornment, "Shading", shading)
        end
    end
end

function visuals.update_visualizer_cframe()
    local model = settings.server_character
    local server = settings.misc.desync.visualization.server
    if not (model and server.enabled and model.PrimaryPart) then
        return
    end
    local uac = find(find(player_node(), "Status"), "UAC")
    if not uac then
        return
    end
    local verified = uac:GetAttribute("LastVerifiedPos")
    if not verified then
        return
    end
    local hrp = find(character, "HumanoidRootPart")
    if not hrp then
        return
    end
    local rotation = hrp.Rotation
    local target = CFrame.new(verified) * CFrame.Angles(math.rad(rotation.X), math.rad(rotation.Y), math.rad(rotation.Z))
    local spoofer = settings.misc.desync.rotation_spoofer
    if spoofer.enabled then
        local spin = spoofer.spin
        target *= CFrame.Angles(
            math.rad(spin.pitch.enabled and spin.pitch.value or spoofer.pitch or 0),
            math.rad(spin.yaw.enabled and spin.yaw.value or spoofer.yaw or 0),
            math.rad(spin.roll.enabled and spin.roll.value or spoofer.roll or 0)
        )
    end
    local primary = model.PrimaryPart
    if server.use_tween then
        if settings.current_visualizer_tween then
            settings.current_visualizer_tween:Cancel()
        end
        settings.current_visualizer_tween = TweenService:Create(primary, TweenInfo.new(0.15, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut), { CFrame = target })
        settings.current_visualizer_tween:Play()
    else
        util:set_property(primary, "CFrame", target)
    end
end

function visuals.fix_visualizer_clones()
    local function walk(root, path)
        for i = 1, #path do
            root = root and find(root, path[i])
            if not root then
                return nil
            end
        end
        return root
    end
    local function strip(viewport)
        if not viewport then
            return
        end
        local model = viewport:FindFirstChildWhichIsA("Model")
        if model then
            local server = find(model, "server")
            if server then
                server:Destroy()
            end
        end
    end
    local function watch(viewport)
        if not viewport then
            return
        end
        strip(viewport)
        library:connection(viewport.ChildAdded, function()
            strip(viewport)
        end)
    end
    local gui = find(player_gui, "MainGui")
    watch(walk(gui, { "MainFrame", "BackpackFrame", "CharacterFrame", "Apparance", "ViewportFrame" }))
    watch(walk(gui, { "MainFrame", "CharacterCreationFrame", "Frame", "ViewportFrame" }))
end

local combat = module("combat")
local panels = {}

local priority_rank = { Enemy = 0, Neutral = 1, Friendly = 2 }

function combat.get_closest_target()
    if not lp.Character or not root_part then
        return nil
    end
    local viewport = camera.ViewportSize
    local center = Vector2.new(viewport.X / 2, viewport.Y / 2)
    local origin = util.get_world_pos(root_part)
    local aiming = settings.combat.aiming
    local best = { hitbox = nil, character = nil, player = nil, value = math.huge, priority = math.huge }
    settings.targeting.current_target = nil
    util.refresh_teammates()

    local function rank(player)
        if aiming.prioritize_enemies then
            local data = library.playerlist_data[tostring(player)]
            return priority_rank[data and data.priority or "Neutral"] or 1
        end
        return nil
    end

    local function consider(part, model, player, priority)
        local position = util.get_world_pos(part)
        local distance = math.floor((origin - position).Magnitude * 0.333)
        local current = settings.combat.aiming
        if current.max_distance.enabled and current.max_distance.value < distance then
            return
        end
        local point, on_screen = camera:WorldToViewportPoint(position)
        if not current.ignore_fov and not on_screen then
            return
        end
        if current.wall_check and not util.is_visible(root_part.Position, model, part) then
            return
        end
        local offset = (Vector2.new(point.X, point.Y) - center).Magnitude
        if not current.ignore_fov and current.fov_radius < offset then
            return
        end
        local value = current.targeting_type == "closest_to_mouse" and offset or current.targeting_type == "distance" and distance or math.huge
        if priority < best.priority or priority == best.priority and value < best.value then
            best = { hitbox = part, character = model, player = player, value = value, priority = priority }
            settings.targeting.current_target = model
        end
    end

    local function scan(model, player)
        if not model then
            return
        end
        local target_humanoid = find(model, "Humanoid")
        if target_humanoid and target_humanoid.Health <= 0 then
            return
        end
        local priority = 1
        if typeof(player) == "Instance" and player:IsA("Player") then
            priority = rank(player)
            local data = library.playerlist_data[tostring(player)]
            local relation = data and data.priority or "Neutral"
            if not aiming.target_friendlies and relation == "Friendly" then
                return
            end
            if not aiming.target_friendlies and settings.clan_data.teammates[player.Name] and relation ~= "Enemy" then
                return
            end
        end
        local hitboxes = util.get_hitboxes(model)
        if hitboxes then
            for _, part in hitboxes do
                consider(part, model, player, priority)
            end
        end
    end

    if aiming.target_players then
        for _, player in Players:GetPlayers() do
            if player ~= lp and player.Character then
                scan(player.Character, player)
            end
        end
    end

    local zones = world("AiZones")
    if aiming.target_ai and zones then
        for _, zone in zones:GetChildren() do
            for _, npc in zone:GetChildren() do
                if find(npc, "HumanoidRootPart") then
                    scan(npc, npc)
                end
            end
        end
    end

    if aiming.target_heli then
        local heli = find(find(zones, "HeliAirfield"), "MI24V")
        if heli and find(heli, "Pilots") then
            scan(heli, heli)
        end
    end

    if library.inv_configuration.enabled then
        panels.inventory_viewer.view(best.character and best.character.Name or "")
    end
    if panels.indicator.enabled then
        panels.target_viewer.update_target(best.character)
    end

    if best.hitbox then
        return best.hitbox, best.character, best.player
    end
    return nil
end

function combat.emulate_tick()
    return tick() + math.random(-100000, 100000)
end

function combat.new_framework()
    local found
    for _, value in getgc(true) do
        if type(value) == "table" then
            local springs = rawget(value, "springs")
            if type(springs) == "table" and rawget(springs, "sway") and typeof(rawget(rawget(springs, "sway"), "Position")) == "Vector3" then
                found = value
                break
            end
        end
    end
    settings.framework.data = found
end

function combat.find_fps()
    for _, value in getgc(true) do
        if type(value) == "table" and rawget(value, "updateClient") then
            settings.framework.fps = value
        end
    end
end

function combat.apply_weapon_mods(weapon)
    local mods = settings.combat.gun_mods
    if mods.rapid_fire.enabled then
        weapon.FireRate = 1 / mods.rapid_fire.value
    end
    if mods.instant_aim and rawget(weapon, "AimInSpeed") and rawget(weapon, "AimOutSpeed") then
        weapon.AimInSpeed = 0
        weapon.AimOutSpeed = 0
    end
    if mods.unlock_firemodes and rawget(weapon, "FireModes") then
        weapon.FireModes = { "Auto", "Semi" }
    end
    if mods.remove_obstructions and rawget(weapon, "TouchWallPosY") then
        weapon.TouchWallPosY = 0
        weapon.TouchWallPosZ = 0
        weapon.TouchWallRotX = 0
        weapon.TouchWallRotY = 0
    end
    if not settings.framework.data then
        return
    end
    local springs = settings.framework.data.springs
    local old = settings.framework.old.springs
    if mods.instant_lean then
        springs.leanAlpha.Force = 25
        springs.leanAlpha.Speed = 50
    else
        springs.leanAlpha.Force = 50
        springs.leanAlpha.Speed = 4
    end
    for _, name in { "jumpTilt", "walkCycle", "sprintCycle", "strafeTilt" } do
        if mods.no_bobbing then
            springs[name].Force = 0
            springs[name].Speed = 0
        else
            springs[name].Force = old[name].Force
            springs[name].Speed = old[name].Speed
        end
    end
    for _, name in { "cameraRecoil", "recoilRot" } do
        if mods.no_recoil then
            springs[name].Force = 0
            springs[name].Speed = 0
        else
            springs[name].Force = old[name].Force
            springs[name].Speed = old[name].Speed
        end
    end
    if mods.no_sway then
        springs.sway.Position = Vector3.new(0, 0, 0)
        springs.sway.Force = 0
        springs.sway.Speed = 0
    else
        springs.sway.Force = old.sway.Force
        springs.sway.Speed = old.sway.Speed
    end
    if mods.remove_obstructions then
        springs.wallTouchTilt.Force = 0
        springs.wallTouchTilt.Speed = 0
    else
        springs.wallTouchTilt.Force = old.wallTouchTilt.Force
        springs.wallTouchTilt.Speed = old.wallTouchTilt.Speed
    end
end

function combat.update_humanoid(h)
    local m = settings.misc.movement
    if m.speedhack.enabled then
        util:set_property(h, "WalkSpeed", m.speedhack.value)
    end
    if m.jumphack.enabled then
        util:set_property(h, "JumpHeight", m.jumphack.value)
    end
    if m.gravity.enabled then
        util:set_property(workspace, "Gravity", m.gravity.value)
    end
    if m.max_slope_angle.enabled then
        util:set_property(h, "MaxSlopeAngle", m.max_slope_angle.value)
    end
end

function combat.update_humanoid_state()
    if humanoid then
        humanoid:SetStateEnabled(Enum.HumanoidStateType.Swimming, not settings.misc.movement.remove_water_physics)
    end
end

function combat.update_pitch()
    local waist = find(find(character, "UpperTorso"), "Waist")
    if not waist then
        return
    end
    local ls = settings.visuals.local_self
    if not ls.third_person then
        util:set_property(waist, "C0", CFrame.Angles(0, 0, 0))
        return
    end
    local pitch = settings.misc.pitch
    local angle = 0
    if ls.visualize_pitch then
        angle = pitch.enabled and pitch.value or character:GetAttribute("UpAngle") or 0
    end
    util:set_property(waist, "C0", CFrame.Angles(angle, 0, 0))
    local server_waist = find(find(find(character, "server"), "UpperTorso"), "Waist")
    if server_waist then
        util:set_property(server_waist, "C0", CFrame.Angles(pitch.enabled and pitch.value or character:GetAttribute("UpAngle") or 0, 0, 0))
    end
end

function combat.fly(dt)
    local flyhack = settings.misc.movement.flyhack
    if not flyhack.enabled or not root_part then
        return
    end
    local look = camera.CFrame.LookVector
    local right = camera.CFrame.RightVector
    local forward = Vector3.new(look.X, 0, look.Z)
    local side = Vector3.new(right.X, 0, right.Z)
    forward = forward.Magnitude > 0 and forward.Unit or Vector3.zero
    side = side.Magnitude > 0 and side.Unit or Vector3.zero
    local direction = Vector3.zero
    if UserInputService:IsKeyDown(Enum.KeyCode.W) then
        direction += forward
    end
    if UserInputService:IsKeyDown(Enum.KeyCode.S) then
        direction -= forward
    end
    if UserInputService:IsKeyDown(Enum.KeyCode.D) then
        direction += side
    end
    if UserInputService:IsKeyDown(Enum.KeyCode.A) then
        direction -= side
    end
    if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
        direction += Vector3.new(0, 1, 0)
    end
    if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
        direction -= Vector3.new(0, 1, 0)
    end
    local horizontal = flyhack.speed_horizontal * flyhack.multiplier * dt
    local vertical = flyhack.speed_vertical * flyhack.multiplier * dt
    if direction.X ~= 0 or direction.Z ~= 0 then
        root_part.CFrame += Vector3.new(direction.X, 0, direction.Z).Unit * horizontal
    end
    if direction.Y ~= 0 then
        root_part.CFrame += Vector3.new(0, direction.Y, 0).Unit * vertical
    end
    root_part.Velocity = Vector3.zero
end

function combat.toggle_fly(enabled)
    settings.misc.movement.flyhack.enabled = enabled
    if root_part then
        root_part.Velocity = Vector3.zero
        root_part.Anchored = false
    end
end

function combat.long_jump()
    local long_jump = settings.misc.movement.long_jump
    if long_jump.using or not humanoid or not root_part then
        return
    end
    long_jump.using = true
    humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    local mass = root_part.AssemblyMass
    local direction = humanoid.MoveDirection
    if direction.Magnitude == 0 then
        direction = root_part.CFrame.LookVector
    end
    root_part:ApplyImpulse(direction.Unit * long_jump.forward_force * mass * 5 + Vector3.new(0, long_jump.upward_force * mass, 0))
    task.delay(long_jump.cooldown, function()
        long_jump.using = false
    end)
end

local function hold_resolve(options, offset_of)
    local method = options.method or "Classic"
    local original = util.get_root_cframe(root_part)
    local flip = false
    options.using = true
    if settings.combat.resolvers.use_sit then
        util:set_property(humanoid, "Sit", true)
    end
    local connection = library:connection(RunService.RenderStepped, function()
        if not options.using then
            return
        end
        flip = not flip
        local offset = offset_of(flip)
        if method == "CFrame" and root_part then
            root_part.CFrame = original * offset
            humanoid:ChangeState(Enum.HumanoidStateType.Running)
            RunService.RenderStepped:Wait()
            root_part.CFrame = original
        else
            character:PivotTo(original * offset)
            humanoid:ChangeState(Enum.HumanoidStateType.Running)
            RunService.RenderStepped:Wait()
            character:PivotTo(original)
        end
    end)
    task.wait(options.timeout)
    util:set_property(humanoid, "Sit", false)
    options.using = false
    connection:Disconnect()
end

function combat.peek_resolve()
    local peek = settings.combat.resolvers.peek
    if not peek.enabled or not peek.bind then
        return
    end
    hold_resolve(peek, function(flip)
        return CFrame.new(0, flip and peek.height + 5 or peek.height, 0)
    end)
end

function combat.underground_resolve()
    local underground = settings.combat.resolvers.underground_resolver
    if not underground.enabled or not underground.bind then
        return
    end
    hold_resolve(underground, function(flip)
        return CFrame.new(0, -(flip and underground.depth + 10 or underground.depth), 0)
    end)
end

function combat.tp_peek_resolve()
    local tp_peek = settings.combat.resolvers.tp_peek
    local target = settings.targeting.current_target
    if not (tp_peek.bind and target and find(target, "HumanoidRootPart")) then
        return
    end
    local target_root = target.HumanoidRootPart
    local hrp = find(character, "HumanoidRootPart")
    if not hrp then
        return
    end
    local method = tp_peek.method or "Classic"
    local height = tp_peek.height
    local flip = false
    local original = util.get_root_cframe(hrp)
    tp_peek.using = true
    if settings.combat.resolvers.use_sit then
        util:set_property(humanoid, "Sit", true)
    end
    local connection = library:connection(RunService.RenderStepped, function()
        if not tp_peek.using then
            return
        end
        local offset = height
        if method == "CFrame" then
            flip = not flip
            offset = flip and height + 5 or height
        end
        local above = CFrame.new(target_root.Position.X, target_root.Position.Y + offset, target_root.Position.Z)
        camera.CFrame = CFrame.new(above.Position, target_root.Position)
        if method == "CFrame" and hrp then
            hrp.CFrame = above
            humanoid:ChangeState(Enum.HumanoidStateType.Running)
            RunService.RenderStepped:Wait()
            hrp.CFrame = original
        else
            character:PivotTo(above)
            humanoid:ChangeState(Enum.HumanoidStateType.Running)
            RunService.RenderStepped:Wait()
            hrp.CFrame = original
        end
    end)
    task.wait(tp_peek.timeout)
    util:set_property(humanoid, "Sit", false)
    tp_peek.using = false
    connection:Disconnect()
end

function combat.position_connection(player)
    if player == lp then
        return
    end
    local uac = uac_node(player)
    if not uac then
        return
    end
    local connections = settings.resolver_connections
    local function snap()
        local verified = uac:GetAttribute("LastVerifiedPos")
        local hrp = player.Character and find(player.Character, "HumanoidRootPart")
        if typeof(verified) == "Vector3" and hrp then
            util:set_property(hrp, "CFrame", CFrame.new(verified))
        end
    end
    snap()
    connections.resolver_signals[player] = connections.resolver_signals[player] or snap
    if settings.combat.resolvers.server_desync_resolver.enabled and not connections.resolver[player] then
        connections.resolver[player] = library:connection(uac:GetAttributeChangedSignal("LastVerifiedPos"), connections.resolver_signals[player])
    end
end

function combat.position_verify()
    local connections = settings.resolver_connections
    if settings.combat.resolvers.server_desync_resolver.enabled then
        for _, player in Players:GetPlayers() do
            if not connections.resolver[player] then
                combat.position_connection(player)
            end
        end
        return
    end
    for player, connection in connections.resolver do
        connection:Disconnect()
        connections.resolver[player] = nil
    end
end

function combat.explode_landmines()
    local landmines = world("OutpostLandmines")
    local children = landmines and landmines:GetChildren() or {}
    if #children == 0 or not root_part then
        notify("Couldn't find any landmines.", false, 3)
        return
    end
    local mode = settings.misc.detonation_mode or "All"
    local count = 0
    for _, mine in children do
        local trigger = find(mine, "Trigger")
        if trigger and trigger:IsA("BasePart") then
            firetouchinterest(root_part, trigger, 0)
            task.wait()
            firetouchinterest(root_part, trigger, 1)
            count += 1
            if mode == "One" then
                break
            end
        end
    end
    if mode == "One" then
        notify("Successfully exploded a landmine.", false, 3)
    else
        notify("Successfully exploded " .. tostring(count) .. " landmines.", false, 3)
    end
end

function combat.spawn_uaz()
    if not character or not humanoid then
        return notify("Couldn't find local character", true, 3)
    end
    local hrp = find(character, "HumanoidRootPart")
    local folder = world("Vehicles")
    if not hrp or not folder then
        return
    end
    local spawn_type = settings.misc.uaz_spawn_type or "Nearest"
    local vehicles = {}
    for _, vehicle in folder:GetChildren() do
        local body = find(vehicle, "Body")
        if body and body:FindFirstChildOfClass("MeshPart") then
            table.insert(vehicles, vehicle)
        end
    end
    if #vehicles == 0 then
        return notify("Couldn't find a UAZ nearby", true, 8)
    end
    local chosen
    if spawn_type == "Random" then
        chosen = vehicles[math.random(1, #vehicles)]
    else
        local best = spawn_type == "Nearest" and math.huge or -math.huge
        for _, vehicle in vehicles do
            local mesh = vehicle.Body:FindFirstChildOfClass("MeshPart")
            if mesh then
                local distance = (mesh.Position - hrp.Position).Magnitude
                if spawn_type == "Nearest" and distance < best or spawn_type == "Farthest" and distance > best then
                    best = distance
                    chosen = vehicle
                end
            end
        end
    end
    if not chosen then
        return notify("Couldn't select a UAZ", true, 8)
    end
    local door = chosen.Body.FRdoor.FR_Door
    local seat = find(find(chosen, "Chassis"), "SeatFR")
    if seat then
        seat:Sit(humanoid)
    end
    local remotes = ReplicatedStorage:FindFirstChild("Remotes")
    local function interact(action)
        remotes.VehicleInteractions:FireServer({ Vehicle = chosen, Action = action, Door = door })
    end
    interact("Enter")
    task.wait(0.2)
    interact("Enter")
    task.wait(0.2)
    chosen.Remotes.ExitSeat:FireServer()
    task.wait(0.1)
    interact("Exit")
    chosen.Remotes.ExitSeat:FireServer()
    task.wait(1)
    humanoid:Move(Vector3.new(0, 10, 0))
    notify("Successfully spawned a UAZ (" .. spawn_type .. ")", false, 5)
end

function combat.teleport_npcs()
    if not root_part then
        return
    end
    local selected = settings.misc.selected_npcs
    local radius = 6
    for i, name in selected do
        local npc = workspace:FindFirstChild(name)
        local hrp = find(npc, "HumanoidRootPart")
        if hrp then
            local angle = i / #selected * math.pi * 2
            hrp.CFrame = CFrame.lookAt(root_part.Position + Vector3.new(math.cos(angle) * radius, 0, math.sin(angle) * radius), root_part.Position)
            for _, part in npc:GetDescendants() do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                end
            end
        end
    end
end

combat.teleport_traders = combat.teleport_npcs

local desync = module("desync")
local desync_anim = {}

function desync.get_axis(spoofer, axis)
    local spin = spoofer.spin[axis]
    return spin.enabled and spin.value or spoofer[axis]
end

function desync.set_psr()
end

function desync.set_ss()
end

function desync.toggle()
    local options = settings.misc.desync
    if not options.desync_toggle then
        return
    end
    if setfpscap then
        setfpscap(9e9)
    end
    if settings.desync_connection then
        settings.desync_connection:Disconnect()
        settings.desync_connection = nil
        desync.set_psr(60)
        desync.set_ss(false)
        notify("❌ Undesynced", false, 5)
        return
    end
    notify("🕒 Desyncing...", true, 5)
    if not root_part then
        return
    end
    local state = { step_counter = 1, toggle_rate = 2 }
    settings.desync_connection = library:connection(RunService.Heartbeat, function()
        state.step_counter = state.step_counter % state.toggle_rate + 1
        desync.set_ss(state.step_counter % state.toggle_rate ~= 0)
    end)
    desync.set_psr(32767)
    for _ = 1, 3 do
        root_part.AssemblyLinearVelocity += Vector3.new(0, 1, 0)
        RunService.Heartbeat:Wait()
    end
    local started = tick()
    while tick() - started < (options.freeze_delay or 0) do
    end
    task.wait()
    state.toggle_rate = options.smooth and 4 or state.toggle_rate
    desync.set_psr(15)
    notify("✅ Desynced", false, 5)
end

function desync.think()
    if not character or not root_part then
        return
    end
    local options = settings.misc.desync
    local position = options.position_spoofer
    local rotation = options.rotation_spoofer
    if not position.enabled and not rotation.enabled then
        settings.desync.old.position = nil
        return
    end
    local original = root_part.CFrame
    local velocity = root_part.AssemblyLinearVelocity
    settings.desync.old.position = original
    local spoofed = original
    if position.enabled then
        spoofed += original:VectorToWorldSpace(Vector3.new(position.x, position.y, position.z))
    end
    if rotation.enabled then
        spoofed *= CFrame.Angles(
            math.rad(desync.get_axis(rotation, "pitch")),
            math.rad(desync.get_axis(rotation, "yaw")),
            math.rad(desync.get_axis(rotation, "roll"))
        )
    end
    root_part.CFrame = spoofed
    RunService.RenderStepped:Wait()
    root_part.CFrame = settings.desync.old.position
    root_part.AssemblyLinearVelocity = Vector3.new(velocity.X, math.clamp(velocity.Y, -99999, 19), velocity.Z)
end

function desync.update_animation()
    if not humanoid then
        return
    end
    local options = settings.misc.desync.animations
    local id = options.animation
    if not id or id == "" then
        return
    end
    if desync_anim.animation_id ~= id or not desync_anim.track then
        if desync_anim.track then
            desync_anim.track:Stop()
            desync_anim.track:Destroy()
        end
        desync_anim.object = new("Animation", { AnimationId = id })
        desync_anim.track = humanoid:LoadAnimation(desync_anim.object)
        desync_anim.track.Looped = true
        desync_anim.animation_id = id
    end
    if options.enabled then
        desync_anim.track:Play()
        desync.update_time_position()
        desync.update_animation_speed()
    else
        desync_anim.track:Stop()
    end
end

function desync.update_animation_speed()
    local speed = settings.misc.desync.animations.speed
    if desync_anim.track and speed then
        desync_anim.track:AdjustSpeed(speed)
    end
end

function desync.update_time_position()
    local position = settings.misc.desync.animations.time_position
    if desync_anim.track and position then
        desync_anim.track.TimePosition = position
    end
end

function desync.reset_animation()
    if desync_anim.track then
        desync_anim.track:Stop()
        desync_anim.track:Destroy()
    end
    desync_anim.track = nil
    desync_anim.animation_id = nil
end

local sorter = {
    category_order = {
        "Keys",
        "Weapons",
        "Attachments",
        "Ammo",
        "Magazines",
        "Armor",
        "Clothing",
        "Backpacks",
        "Fabrics",
        "Utility",
        "Medical",
        "Treasure",
        "Trash",
        "Rubles",
    },
}

function sorter.get_rank(category)
    for i, v in sorter.category_order do
        if v == category then
            return i
        end
    end
    return 999
end

function sorter.get_item_props(name)
    local props = find(find(ReplicatedStorage:FindFirstChild("ItemsList"), name), "ItemProperties")
    if not props then
        return nil
    end
    local item_type = props:GetAttribute("ItemType")
    if not item_type then
        local value = find(props, "ItemType")
        item_type = value and value.Value
    end
    local slot_value = find(props, "SlotType")
    return {
        ItemType = item_type or "",
        SlotType = props:GetAttribute("SlotType") or slot_value and slot_value.Value or "",
        Cost = tonumber(props:GetAttribute("Cost") or props:GetAttribute("Price")) or 0,
    }
end

function sorter.get_category(name, props)
    if not props then
        return "Trash"
    end
    local item_type, slot_type = props.ItemType, props.SlotType
    if item_type == "Material" and name == "Rubles" then
        return "Rubles"
    elseif item_type == "Key" or item_type == "Keycard" then
        return "Keys"
    elseif item_type == "Ammo" then
        return "Ammo"
    elseif item_type == "Magazine" then
        return "Magazines"
    elseif item_type == "RangedWeapon" and slot_type ~= "FlareGun" or item_type == "Grenade" then
        return "Weapons"
    elseif table.find({ "Handle", "Stock", "Front", "Muzzle", "Sight", "Extra" }, item_type) then
        return "Attachments"
    elseif item_type == "Clothing" and table.find({ "ClothingChestRig", "ClothingHeadware", "ClothingLegArmor" }, slot_type) or item_type == "Visor" then
        return "Armor"
    elseif item_type == "Clothing" and table.find({ "ClothingMask", "ClothingShirt", "ClothingPants", "ClothingGloves" }, slot_type) or item_type == "Filter" then
        return "Clothing"
    elseif item_type == "Clothing" and slot_type == "ClothingBackpack" then
        return "Backpacks"
    elseif item_type == "Barter" and string.find(name, "Fabric") then
        return "Fabrics"
    elseif item_type == "Medical" then
        return "Medical"
    elseif item_type == "Equipment" or item_type == "Buildable" or item_type == "RepairKit" then
        return "Utility"
    end
    return props.Cost > 1000 and "Treasure" or "Trash"
end

function sorter.sort_items(entries)
    local main, rubles = {}, {}
    for _, entry in entries do
        table.insert(entry.cat == "Rubles" and rubles or main, entry)
    end
    table.sort(main, function(a, b)
        if a.cat ~= b.cat then
            return sorter.get_rank(a.cat) < sorter.get_rank(b.cat)
        end
        if a.cat == "Treasure" and a.cost ~= b.cost then
            return a.cost > b.cost
        end
        return a.name < b.name
    end)
    table.sort(rubles, function(a, b)
        return a.amount > b.amount
    end)
    local ordered = {}
    for _, entry in main do
        table.insert(ordered, entry.obj)
    end
    for _, entry in rubles do
        table.insert(ordered, entry.obj)
    end
    return ordered, #rubles
end

function sorter.sort_folder(folder, capacity)
    local inventory_move = find(ReplicatedStorage:FindFirstChild("Remotes"), "InventoryMove")
    if not inventory_move or not folder then
        return
    end
    local items, by_slot, slot_of = {}, {}, {}
    local prefix, highest = nil, 0
    for _, item in folder:GetChildren() do
        local slot = item:GetAttribute("Slot")
        local name, number = (slot or ""):match("^([a-zA-Z]+)(%d+)$")
        if name and number then
            prefix = name
            highest = math.max(highest, tonumber(number))
            table.insert(items, item)
            by_slot[slot] = item
            slot_of[item] = slot
        end
    end
    if #items == 0 or not prefix then
        return
    end
    local limit = capacity or highest
    local entries = {}
    for _, item in items do
        local props = sorter.get_item_props(item.Name)
        table.insert(entries, {
            obj = item,
            name = item.Name,
            slot = slot_of[item],
            cat = sorter.get_category(item.Name, props),
            cost = props and props.Cost or 0,
            durability = item:GetAttribute("Durability") or 0,
            skin = item:GetAttribute("Skin") or "",
            loadedAmmo = item:GetAttribute("LoadedAmmo") or 0,
            amount = item:GetAttribute("Amount") or 1,
        })
    end
    local ordered, rubles = sorter.sort_items(entries)
    local main = #ordered - rubles
    local target = {}
    for i = 1, main do
        target[ordered[i]] = prefix .. i
    end
    for i = 1, rubles do
        target[ordered[main + i]] = prefix .. (limit - rubles + i)
    end
    for _, item in ordered do
        local dest, src = target[item], slot_of[item]
        if dest and src ~= dest then
            local occupant = by_slot[dest]
            inventory_move:FireServer(src, dest, folder, folder, nil)
            task.wait(0.02)
            by_slot[dest] = item
            slot_of[item] = dest
            if occupant then
                by_slot[src] = occupant
                slot_of[occupant] = src
            else
                by_slot[src] = nil
            end
        end
    end
end

function sorter.sort_inventory()
    local inventory = find(player_node(), "Inventory")
    if not inventory then
        return
    end
    for _, container in inventory:GetChildren() do
        local sub = find(container, "Inventory")
        if sub then
            sorter.sort_folder(sub)
        end
    end
    library:notification({ text = "Inventory sorted successfully", flashing = true, time = 5 })
end

function sorter.sort_vault()
    local inventory = find(find(player_node(), "VaultStorage"), "Inventory")
    if inventory then
        sorter.sort_folder(inventory, 200)
        library:notification({ text = "Vault sorted successfully", flashing = true, time = 5 })
        return
    end
    library:notification({ text = "Vault not found", flashing = true, time = 5 })
end

local hooks = { installed = false, calls = {}, old = {}, effects = {} }

local function count(name)
    hooks.calls[name] = (hooks.calls[name] or 0) + 1
end

local function report(name, err)
    hooks.errors = hooks.errors or {}
    if not hooks.errors[name] then
        hooks.errors[name] = true
        warn(name .. " hook error: " .. tostring(err))
    end
end

local function replace(tbl, key, fn)
    if type(tbl) ~= "table" or type(tbl[key]) ~= "function" then
        return nil, "missing " .. tostring(key)
    end
    local original = tbl[key]
    local readonly = (isreadonly and isreadonly(tbl)) or table.isfrozen(tbl)
    if readonly and setreadonly then
        pcall(setreadonly, tbl, false)
    end
    local ok, err = pcall(function()
        tbl[key] = fn
    end)
    if readonly and setreadonly then
        pcall(setreadonly, tbl, true)
    end
    if not ok then
        return nil, err
    end
    if rawget(tbl, key) ~= fn then
        return nil, "assignment did not stick"
    end
    return original
end

function hooks.queue_effects(position)
    table.insert(hooks.effects, position)
end

function hooks.flush_effects()
    if #hooks.effects == 0 then
        return
    end
    local queued = hooks.effects
    hooks.effects = {}
    local v = settings.combat.visualization
    for _, position in queued do
        if v.bullet_tracers.enabled then
            pcall(visuals.create_tracer, position)
        end
        if v.bullet_impacts.enabled then
            pcall(visuals.create_impact, position)
        end
        if v.hitmarkers.enabled then
            pcall(visuals.create_hitmarker, position)
        end
        if v.hit_vfx.enabled then
            pcall(visuals.create_vfx, position)
        end
    end
end

local function bullet_hook(...)
    count("CreateBullet")
    local args = table.pack(...)
    local ok, err = pcall(function()
        local target = current_target_part
        if not target then
            return
        end
        local aiming = settings.combat.aiming
        local origin = camera.CFrame.Position
        if aiming.silent_aim and settings.targeting.current_target and util.calculate_chance(aiming.hitchance) then
            args[8] = { ClassName = "Part", CFrame = CFrame.new(origin, target.Position) }
        end
        settings.targeting.manipulated_direction = (target.Position - origin).Unit
        hooks.queue_effects(target.Position)
    end)
    if not ok then
        report("CreateBullet", err)
    end
    if settings.combat.gun_mods.double_tap then
        hooks.old.bullet(table.unpack(args, 1, args.n))
    end
    return hooks.old.bullet(table.unpack(args, 1, args.n))
end

local function underwater_hook(...)
    count("IsCharacterUnderWater")
    if settings.misc.movement.remove_water_physics then
        return false
    end
    return hooks.old.underwater(...)
end

local function update_client_hook(...)
    count("updateClient")
    local ok, err = pcall(combat.apply_weapon_mods, (...))
    if not ok then
        report("updateClient", err)
    end
    return hooks.old.update_client(...)
end

local function try_module_hooks()
    local folder = find(ReplicatedStorage, "Modules")
    if not hooks.old.bullet then
        local ok, bullet = pcall(require, find(find(folder, "FPS"), "Bullet"))
        if ok and type(bullet) == "table" then
            local original, err = replace(bullet, "CreateBullet", bullet_hook)
            hooks.old.bullet = original
            if not original then
                report("CreateBullet install", err)
            end
        end
    end
    if not hooks.old.underwater then
        local ok, library_ext = pcall(require, find(folder, "FunctionLibraryExtension"))
        if ok and type(library_ext) == "table" then
            local original, err = replace(library_ext, "IsCharacterUnderWater", underwater_hook)
            hooks.old.underwater = original
            if not original then
                report("IsCharacterUnderWater install", err)
            end
        end
    end
    if not hooks.old.update_client then
        if not settings.framework.fps then
            combat.find_fps()
        end
        local fps = settings.framework.fps
        if fps then
            local original, err = replace(fps, "updateClient", update_client_hook)
            hooks.old.update_client = original
            if not original then
                report("updateClient install", err)
            end
        end
    end
    return hooks.old.bullet and hooks.old.underwater and hooks.old.update_client
end

function hooks.install_modules()
    task.spawn(function()
        if not game:IsLoaded() then
            game.Loaded:Wait()
        end
        local started = tick()
        while not try_module_hooks() and tick() - started < 60 do
            task.wait(1)
        end
        if not settings.framework.data then
            combat.new_framework()
        end
    end)
end

local function sprinting_value()
    return find(find(find(player_node(), "Status"), "GameplayVariables"), "Sprinting")
end

function hooks.install()
    if hooks.installed then
        return
    end
    if not hookmetamethod or not getnamecallmethod then
        warn("hookmetamethod is not supported by this executor")
        return
    end
    hooks.sprinting = sprinting_value()
    local caller = checkcaller or function()
        return false
    end
    local wrap = newcclosure or function(f)
        return f
    end
    local namecall
    namecall = hookmetamethod(game, "__namecall", wrap(function(self, ...)
        local method = getnamecallmethod()
        if method == "FireServer" then
            local name = self.Name
            if name == "Drowning" and settings.misc.movement.no_drown and not caller() then
                return
            end
            local multi = settings.misc.multi_use
            if name == "Consume" and multi.enabled and not multi.using and not caller() then
                multi.using = true
                for _ = 1, multi.times do
                    task.spawn(function()
                        self:FireServer()
                    end)
                end
                task.spawn(function()
                    task.wait(0.05)
                    multi.using = false
                end)
            end
            if name == "UpdateTilt" and settings.misc.pitch.enabled then
                count("UpdateTilt")
                local args = { ... }
                args[1] = settings.misc.pitch.value
                args[2] = nil
                args[3] = 0
                args[4] = 0
                return namecall(self, unpack(args, 1, 4))
            end
            if name == "ProjectileInflict" then
                if debug.traceback():find("CharacterController") then
                    return coroutine.yield()
                end
                if settings.combat.gun_mods.instant_bullet then
                    count("ProjectileInflict")
                    local args = table.pack(...)
                    if type(args[3]) == "number" and args[3] >= 0 and args[3] <= 10 then
                        return nil
                    end
                    args[4] = combat.emulate_tick()
                    return namecall(self, table.unpack(args, 1, math.max(args.n, 4)))
                end
            end
        elseif method == "InvokeServer" then
            if self.Name == "FireProjectile" and settings.targeting.manipulated_direction and settings.targeting.current_target then
                count("FireProjectile")
                local args = table.pack(...)
                args[1] = settings.targeting.manipulated_direction
                return namecall(self, table.unpack(args, 1, args.n))
            end
        elseif method == "Raycast" then
            local target = current_target_part
            if settings.combat.aiming.silent_aim and target and debug.traceback():find("Bullet") then
                count("Raycast")
                local args = table.pack(...)
                local position = target.Position
                if settings.combat.gun_mods.wallbang then
                    return { Instance = target, Position = position, Distance = (position - args[1]).Magnitude, Normal = Vector3.new(1, 0, 0), Material = target.Material }
                end
                args[2] = position - args[1]
                return namecall(self, table.unpack(args, 1, args.n))
            end
        elseif method == "GetAttribute" then
            local key = ...
            local mods = settings.combat.gun_mods
            if key == "Value" and self == hooks.sprinting and mods.remove_sprint_animation then
                return false
            elseif key == "AccuracyDeviation" and mods.remove_spread then
                return 0.1
            elseif key == "ArmorPen" and mods.wallbang then
                return 100
            elseif key == "MuzzleEffect" and mods.remove_muzzle_effects then
                return false
            end
        elseif method == "Clone" and self.ClassName == "Sound" then
            local clone = namecall(self, ...)
            local shoot = settings.combat.visualization.custom_shoot_sound
            if shoot.enabled and (self.Name == "FireSound" or self.Name == "FireSoundSupressed") then
                task.defer(function()
                    clone.SoundId = "rbxassetid://" .. shoot.sounds[shoot.sound]
                    clone.Pitch = shoot.pitch or 1
                    clone.Volume = shoot.volume or 1
                end)
            end
            return clone
        end
        return namecall(self, ...)
    end))
    local newindex
    newindex = hookmetamethod(game, "__newindex", wrap(function(self, key, value)
        if self == Lighting and key == "ClockTime" and settings.visuals.lighting.override_clocktime and settings.visuals.lighting.clock_time then
            value = settings.visuals.lighting.clock_time
        elseif self == camera and key == "CFrame" and not caller() and settings.visuals.local_self.third_person then
            value += value.LookVector * -settings.visuals.local_self.third_person_value
        end
        return newindex(self, key, value)
    end))
    local index
    index = hookmetamethod(game, "__index", wrap(function(self, key)
        if key == "CFrame" and self == root_part and not caller() then
            local spoofer = settings.misc.desync
            local old = settings.desync.old.position
            if old and (spoofer.position_spoofer.enabled or spoofer.rotation_spoofer.enabled) then
                return old
            end
        end
        return index(self, key)
    end))
    hooks.installed = true
end

local runtime = { connections = {} }

local function connect(signal, callback)
    local connection = library:connection(signal, callback)
    table.insert(runtime.connections, connection)
    return connection
end

local function wipe_statistics()
    return find(find(find(player_node(), "Status"), "Journey"), "WipeStatistics")
end

function util.update_session_data()
    local panel = panels.session_data
    if not panel then
        return
    end
    local stats = wipe_statistics()
    local kills = stats and stats:GetAttribute("Kills") or "n/a"
    local deaths = stats and stats:GetAttribute("Deaths") or "n/a"
    local kd = util.calculate_kd(stats)
    local players = string.format("%d/%d", #Players:GetPlayers(), Players.MaxPlayers)
    local weather = "unknown"
    local time = "12:00:00"
    local status = find(Lighting, "WeatherStatus")
    if status then
        weather = tostring(status:GetAttribute("Weather") or "unknown")
        local minutes = find(status, "MinutesAfterMidnight")
        if minutes and minutes:IsA("NumberValue") then
            local value = minutes.Value
            time = string.format("%02d:%02d:%02d", math.floor(value / 60), math.floor(value % 60), math.floor((value * 60) % 60))
        end
    end
    panel.update_flag("players_value", "Text", players)
    panel.update_flag("kd_value", "Text", string.format("%.2f", kd))
    panel.update_flag("kills_value", "Text", kills)
    panel.update_flag("deaths_value", "Text", deaths)
    panel.update_flag("time_value", "Text", time)
    panel.update_flag("weather_value", "Text", weather)
end

local function on_character(char)
    task.spawn(function()
        settings.framework.data = nil
        task.wait(3)
        combat.new_framework()
    end)
    if runtime.pitch_connection then
        runtime.pitch_connection:Disconnect()
    end
    character = char
    humanoid = char:WaitForChild("Humanoid", 15)
    root_part = char:WaitForChild("HumanoidRootPart", 15)
    animator = humanoid and humanoid:WaitForChild("Animator", 15)
    if not humanoid or not root_part then
        return
    end
    settings.desync.old.position = nil
    visuals.desync_visualizer()
    local m = settings.misc.movement
    connect(humanoid:GetPropertyChangedSignal("WalkSpeed"), function()
        if m.speedhack.enabled then
            combat.update_humanoid(humanoid)
        end
    end)
    connect(humanoid:GetPropertyChangedSignal("JumpHeight"), function()
        if m.jumphack.enabled and humanoid.JumpHeight ~= 0 then
            combat.update_humanoid(humanoid)
        end
    end)
    connect(humanoid:GetAttributeChangedSignal("JumpCooldown"), function()
        if m.remove_jump_cooldown and humanoid:GetAttribute("JumpCooldown") ~= 0 then
            humanoid:SetAttribute("JumpCooldown", 0)
        end
    end)
    connect(humanoid.StateChanged, function(_, new)
        if settings.misc.nofall.enabled and (new == Enum.HumanoidStateType.FallingDown or new == Enum.HumanoidStateType.Freefall) then
            humanoid:ChangeState(Enum.HumanoidStateType.Landed)
        end
    end)
    runtime.pitch_connection = connect(char:GetAttributeChangedSignal("UpAngle"), combat.update_pitch)
    local player_gui = lp:FindFirstChildOfClass("PlayerGui")
    if find(player_gui, "MainGui") or (player_gui and player_gui:WaitForChild("MainGui", 10)) then
        visuals.fix_visualizer_clones()
        visuals.hitsounds()
        visuals.update_ui()
    end
    combat.update_humanoid(humanoid)
    combat.update_humanoid_state()
    visuals.update_visualizer()
    visuals.update_character()
    if runtime.child_added then
        runtime.child_added:Disconnect()
    end
    runtime.child_added = connect(char.ChildAdded, function()
        if settings.visuals.ui_removals.enabled then
            visuals.update_ui()
        end
        if settings.visuals.local_self.player_chams then
            task.wait(0.1)
            visuals.update_character()
        end
    end)
    if settings.misc.desync.animations.enabled then
        desync.reset_animation()
        desync.update_animation()
    end
end

local function watch_viewmodel(child)
    visuals.update_viewmodel()
    if not (child:IsA("Model") and child.Name == "ViewModel") then
        return
    end
    local vm_humanoid = find(child, "Humanoid")
    local vm_animator = find(vm_humanoid, "Animator")
    if not vm_animator then
        return
    end
    local mods = settings.combat.gun_mods
    if runtime.viewmodel_connection then
        runtime.viewmodel_connection:Disconnect()
    end
    if runtime.use_connection then
        runtime.use_connection:Disconnect()
    end
    if mods.instant_equip then
        for _, track in vm_animator:GetPlayingAnimationTracks() do
            if track.Animation.Name == "Equip" then
                track:AdjustSpeed(15)
                track.TimePosition = track.Length - 0.01
            end
        end
    end
    runtime.use_connection = connect(vm_humanoid.AnimationPlayed, function(track)
        local animation = track.Animation
        if not animation then
            return
        end
        local name = animation.Name
        if mods.no_recoil and name == "Use" then
            track:AdjustSpeed(9e9)
        end
        if mods.rapid_knife.enabled and (name == "Use" or name == "UseAlt" or name == "Stab") then
            track:AdjustSpeed(mods.rapid_knife.rate)
        end
    end)
    runtime.viewmodel_connection = connect(child.DescendantAdded, function()
        visuals.update_viewmodel()
    end)
end

local water_params = RaycastParams.new()
water_params.FilterType = Enum.RaycastFilterType.Include
water_params.FilterDescendantsInstances = { terrain }

local function tick_targeting()
    local aiming = settings.combat.aiming
    if aiming.silent_aim or aiming.aim_assist.bind then
        current_target_part = combat.get_closest_target()
        visuals.draw_snapline(current_target_part)
    else
        current_target_part = nil
    end
    if aiming.aim_assist.bind then
        if not current_target_part then
            return false
        end
        local smoothness = aiming.aim_assist.smoothness
        if aiming.aim_assist.type == "Camera" then
            camera.CFrame = camera.CFrame:Lerp(CFrame.lookAt(camera.CFrame.Position, current_target_part.Position), smoothness)
        elseif aiming.aim_assist.type == "Mouse" then
            local point, visible = util.get_screen_pos(current_target_part.Position)
            if visible then
                local mouse = UserInputService:GetMouseLocation()
                mousemoverel((point.X - mouse.X) * smoothness, (point.Y - mouse.Y) * smoothness)
            end
        end
    end
    return true
end

local function tick_world()
    if settings.misc.movement.jesus and root_part then
        local hit = workspace:Raycast(root_part.Position, Vector3.new(0, -10, 0), water_params)
        if hit and hit.Material == Enum.Material.Water then
            if not runtime.water_part or not runtime.water_part.Parent then
                runtime.water_part = new("Part", {
                    Transparency = 1,
                    Size = Vector3.new(10, 1, 10),
                    CanCollide = true,
                    Anchored = true,
                    Parent = world("NoCollision") or workspace,
                })
            end
            util:set_property(runtime.water_part, "Position", hit.Position)
        end
    end
    local d = settings.misc.desync
    if visuals.joint_map and d.visualization.server.visualize_animations then
        for _, joint in visuals.joint_map do
            joint.clone.Transform = joint.real.Transform
        end
    end
    if d.animations.enabled and animator then
        for _, track in animator:GetPlayingAnimationTracks() do
            local animation = track.Animation
            if animation and animation.AnimationId ~= d.animations.animation then
                track:Stop()
            end
        end
    end
end

local function render_step(dt)
    visuals.update_camera()
    visuals.spin_fov()
    visuals.animate_crosshair(dt)
    combat.fly(dt)
    hooks.flush_effects()
    local spoofer = settings.misc.desync.rotation_spoofer
    if spoofer.enabled then
        for _, axis in { "roll", "pitch", "yaw" } do
            local spin = spoofer.spin[axis]
            if spin.enabled then
                spin.value = (spin.value + spin.speed) % 360
            end
        end
    end
    runtime.tick_time += dt
    runtime.shoot_time += dt
    if runtime.tick_time >= 0.0125 then
        if not tick_targeting() then
            return
        end
        tick_world()
        runtime.tick_time = 0
    end
    local auto_shoot = settings.combat.aiming.auto_shoot
    if runtime.shoot_time >= auto_shoot.interval then
        runtime.shoot_time = 0
        local target = settings.targeting.current_target
        if settings.combat.aiming.silent_aim and auto_shoot.enabled and root_part and target and current_target_part and not library.menu_opened and util.is_visible(root_part.Position, target, current_target_part) then
            util.simulate_click()
        end
    end
end

local function track_player(player)
    if settings.combat.resolvers.server_desync_resolver.enabled then
        combat.position_connection(player)
    end
    if util.is_admin(player) then
        util.add_admin(player)
    end
    if player == lp then
        return
    end
    if player.Character then
        esp.new_model(player.Character)
    end
    settings.esp.character_added_connections[player] = connect(player.CharacterAdded, function(char)
        esp.new_model(char)
    end)
end

local function untrack_player(player)
    local connections = settings.resolver_connections
    if connections.resolver[player] then
        connections.resolver[player]:Disconnect()
        connections.resolver[player] = nil
    end
    connections.resolver_signals[player] = nil
    if settings.admins[player] then
        util.remove_admin(player)
    end
    local added = settings.esp.character_added_connections[player]
    if added then
        added:Disconnect()
        settings.esp.character_added_connections[player] = nil
    end
    util.update_session_data()
    visuals.log_player_action(player, "leave")
end

local function track_ai(model)
    if not model:IsA("Model") then
        return
    end
    if find(model, "Humanoid") then
        esp.new_model(model, true)
    else
        task.delay(0.25, function()
            if model.Parent and find(model, "Humanoid") then
                esp.new_model(model, true)
            end
        end)
    end
end

local function track_drop(model)
    if not model:IsA("Model") then
        return
    end
    local function classify()
        if find(model, "Humanoid") then
            esp.new_instance(model, "body")
            return true
        elseif model:GetAttribute("Collectable") then
            esp.new_instance(model, "item")
            return true
        end
    end
    if not classify() then
        task.delay(0.25, function()
            if model.Parent then
                classify()
            end
        end)
    end
end

local function watch_folder(folder, callback)
    if not folder then
        return
    end
    for _, child in folder:GetChildren() do
        callback(child)
    end
    connect(folder.ChildAdded, callback)
end

local function watch_reports()
    local uac = find(find(find(player_node(), "Status"), "UAC"), "Reports")
    if not uac then
        return
    end
    local attribute = settings.reports.attribute
    if uac:GetAttribute(attribute) ~= nil then
        connect(uac:GetAttributeChangedSignal(attribute), visuals.update_reports)
        return
    end
    local pending
    pending = uac.AttributeChanged:Connect(function(name)
        if name == attribute then
            pending:Disconnect()
            connect(uac:GetAttributeChangedSignal(attribute), visuals.update_reports)
        end
    end)
end

local function world_notifications()
    local notifications = settings.visuals.world.notifications
    local effects = find(world("NoCollision"), "Effects")
    if effects then
        connect(effects.ChildAdded, function(child)
            if not notifications.flare_fired then
                return
            end
            task.wait(0.1)
            local names = { FlareGun = "EDF", SPSh44 = "SPSh44" }
            if names[child.Name] then
                library:notification({ text = "Someone has just fired an " .. names[child.Name] .. " Flare!", flashing = notifications.flashing, time = notifications.duration, sound = notifications.sound, volume = notifications.volume })
            end
        end)
    end
    local containers = world("Containers")
    if containers then
        connect(containers.ChildAdded, function(child)
            if not notifications.airdrop_dropped then
                return
            end
            task.wait(0.1)
            local names = { SupplyDropMilitary = "SPSh44", SupplyDropEDF = "EDF" }
            if names[child.Name] then
                library:notification({ text = "An airplane has just dropped an " .. names[child.Name] .. " Flare!", flashing = notifications.flashing, time = notifications.duration })
            end
        end)
    end
end

local function background_loops()
    task.spawn(esp.visible_loop)
    task.spawn(function()
        while task.wait(0.5) do
            local sync = settings.stream_sync
            local origin = sync.enabled and util.get_root_cframe(root_part)
            if origin then
                local now = tick()
                for _, player in Players:GetPlayers() do
                    if player ~= lp and not (player.Character and find(player.Character, "HumanoidRootPart")) then
                        local uac = uac_node(player)
                        local verified = uac and uac:GetAttribute("LastVerifiedPos")
                        if typeof(verified) == "Vector3" and (verified - origin.Position).Magnitude <= 12000 and (not sync.last_requested[player] or now - sync.last_requested[player] > 1.5) then
                            sync.last_requested[player] = now
                            task.spawn(pcall, lp.RequestStreamAroundAsync, lp, verified, 0.5)
                            task.wait(0.2)
                        end
                    end
                end
            end
        end
    end)
    task.spawn(function()
        while task.wait(10) do
            if settings.visuals.world.remove_foliage or settings.visuals.world.remove_trees then
                visuals.update_foliage()
            end
        end
    end)
    task.spawn(function()
        while task.wait(20) do
            for _, player in Players:GetPlayers() do
                if player ~= lp and player.Character then
                    esp.new_model(player.Character, false)
                end
            end
        end
    end)
end

local function start_runtime()
    runtime.tick_time = 0
    runtime.shoot_time = 0
    hooks.install_modules()
    if lp.Character then
        task.spawn(on_character, lp.Character)
    end
    connect(lp.CharacterAdded, on_character)
    RunService:BindToRenderStep("update_esp", 0, function()
        esp.render()
    end)
    connect(RunService.RenderStepped, render_step)
    connect(RunService.Heartbeat, desync.think)
    connect(camera.ChildAdded, watch_viewmodel)
    world_notifications()
    watch_reports()
    local stats = wipe_statistics()
    if stats then
        connect(stats:GetAttributeChangedSignal("Kills"), util.update_session_data)
        connect(stats:GetAttributeChangedSignal("Deaths"), util.update_session_data)
    end
    connect(Lighting.Changed, visuals.update_lighting)
    local atmosphere = Lighting:FindFirstChildOfClass("Atmosphere")
    if atmosphere then
        connect(atmosphere.Changed, visuals.update_atmosphere)
    end
    local bloom = Lighting:FindFirstChildOfClass("BloomEffect")
    if bloom then
        connect(bloom.Changed, visuals.update_bloom)
    end
    connect(workspace:GetPropertyChangedSignal("Gravity"), function()
        if settings.misc.movement.gravity.enabled then
            combat.update_humanoid(humanoid)
        end
    end)
    local uac = uac_node()
    if uac then
        connect(uac:GetAttributeChangedSignal("LastVerifiedPos"), visuals.update_visualizer_cframe)
    end
    connect(Players.PlayerAdded, function(player)
        track_player(player)
        util.update_session_data()
        visuals.log_player_action(player, "join")
    end)
    connect(Players.PlayerRemoving, untrack_player)
    for _, player in Players:GetPlayers() do
        track_player(player)
    end
    local zones = world("AiZones")
    if zones then
        for _, zone in zones:GetChildren() do
            watch_folder(zone, track_ai)
        end
    end
    watch_folder(world("DroppedItems"), track_drop)
    watch_folder(world("Vehicles"), function(vehicle)
        esp.new_instance(vehicle, "uaz")
    end)
    watch_folder(find(world("NoCollision"), "ExitLocations"), function(exit)
        esp.new_instance(exit, "exit")
    end)
    watch_folder(find(zones, "HeliAirfield"), function(heli)
        if heli:IsA("Model") then
            esp.new_instance(heli, "heli")
        end
    end)
    background_loops()
    util.update_session_data()
    hooks.install()
end


local function embedded_ui()

	local uis = cloneref(game:GetService("UserInputService"))
	local players = cloneref(game:GetService("Players"))
	local ws = cloneref(game:GetService("Workspace"))
	local http_service = cloneref(game:GetService("HttpService"))
	local gui_service = cloneref(game:GetService("GuiService"))
	local lighting = cloneref(game:GetService("Lighting"))
	local run = cloneref(game:GetService("RunService"))
	local stats = cloneref(game:GetService("Stats"))
	local coregui = cloneref(game:GetService("CoreGui"))
	local debris = cloneref(game:GetService("Debris"))
	local tween_service = cloneref(game:GetService("TweenService"))
	local replicated_storage = cloneref(game:GetService("ReplicatedStorage"))
	local sound_service = cloneref(game:GetService("SoundService"))
	local starter_gui = cloneref(game:GetService("StarterGui"))
	local rs = cloneref(game:GetService("ReplicatedStorage"))

	local vec2 = Vector2.new
	local vec3 = Vector3.new
	local dim2 = UDim2.new
	local dim = UDim.new
	local rect = Rect.new
	local cfr = CFrame.new
	local empty_cfr = cfr()
	local point_object_space = empty_cfr.PointToObjectSpace
	local angle = CFrame.Angles
	local dim_offset = UDim2.fromOffset

	local color = Color3.new
	local hsv = Color3.fromHSV
	local rgb = Color3.fromRGB
	local hex = Color3.fromHex
	local rgbseq = ColorSequence.new
	local rgbkey = ColorSequenceKeypoint.new
	local numseq = NumberSequence.new
	local numkey = NumberSequenceKeypoint.new

	local camera = ws.CurrentCamera
	local lp = players.LocalPlayer
	local mouse = lp:GetMouse()
	local gui_offset = gui_service:GetGuiInset().Y

	local max = math.max
	local floor = math.floor
	local min = math.min
	local abs = math.abs
	local noise = math.noise
	local rad = math.rad
	local random = math.random
	local pow = math.pow
	local sin = math.sin
	local pi = math.pi
	local tan = math.tan
	local atan2 = math.atan2
	local cos = math.cos
	local round = math.round;
	local clamp = math.clamp;
	local ceil = math.ceil;
	local sqrt = math.sqrt;
	local acos = math.acos;

	local insert = table.insert
	local find = table.find
	local remove = table.remove
	local concat = table.concat

	local library = {
		directory = "ShitHax",
		folders = {
			"/fonts",
			"/configs",
			"/sounds",
			"/images",
			"/hitmarkers",
			"/hitsounds"
		},
		flags = {},
		config_flags = {},
		visible_flags = {},
		guis = {},
		connections = {},
		notifications = {},
		playerlist_data = {},
		watermark_options = {
			watermark_text = "ShitHax.cc",
			private = true,
			version = true,
			fps = true,
			ping = true,
			uid = true,
			current_game = true,
			current_date = true,
			current_time = true,
		},
		user_stats = {fps = 0},
		user_info = {},
		script_version = "1.6a",

		indicator_settings = {
			enabled = false,
			delay = 0.2,
			use_tween = true,
			time = 0.15,
			style = Enum.EasingStyle.Circular,
			direction = Enum.EasingDirection.InOut,
			high = Color3.fromRGB(124, 255, 139),
			low = Color3.fromRGB(255, 72, 118),
		},

		inv_configuration = {
			enabled = false,
			delay = 0.15,
			sections = {"Hotbar", "Armor", "Miscellaneous", "Containers"},
			colors = {
				stack = "#FFFFFF",
				amount = "#FFFFFF",
				item_name = "#FFFFFF",
				section_title = "#FFFFFF",
			},
		},

		binds = {},

		instances = {};
		drawings = {};

		display_orders = 0;

		images = {
			Glow4 = "http://www.roblox.com/asset/?id=18245826428",
		},
		active = {
			slider = nil,
			color = nil,
			pending_bind = nil,
			keybind_handlers = {},
			keybind_hold_handlers = {},
			slider_handlers = {},
			tween_left = nil,
			tween_right = nil
		},
		color_animations = {},
		flash_data = {},
		windows = {},
		last_update = 0,
		last_update_slider = 0,
		last_update_pointer = 0,
		pointer_design = true,
		window_snap_left = false,
		window_snap_right = false,
		easing_style_index = {"Linear", "Sine", "Back", "Quad", "Quart", "Quint", "Bounce", "Elastic", "Exponential", "Circular", "Cubic"},
		easing_direction_index = {"In", "Out", "InOut"},
		drag_enabled = true,
		aerosnap = true,
		pointer_enabled = true,
		animation_frequency = 60,
		animation_speed = 1,
		blur_size = 20,
		click_sound_ids = {
			Default = "rbxassetid://4585382046",
			Pride = "rbxassetid://4585382589",
			Halloween = "rbxassetid://4585351098",
			Wood = "rbxassetid://4585364605",
			Experience = "rbxassetid://9120454415",
		},
		tweening_style = Enum.EasingStyle.Circular,
		tweening_direction = Enum.EasingDirection.InOut,
		tweening_speed = 0.15,
		sound_settings = {sound_type = "Default", sound_volume = 10},
		colors = {
			success = rgb(122, 255, 117),
			warning = rgb(247, 215, 98),
			information = rgb(154, 135, 254),
			fail = rgb(255, 117, 129),
		},
	}

	local flags = library.flags
	local config_flags = library.config_flags

	local themes = {
		preset = {
			["outline"] = hex("#0A0A0A"),
			["inline"] = hex("#222222"),
			["accent"] = hex("#2dd1eb"),
			["high_contrast"] = hex("#0D0D0D"),
			["low_contrast"] = hex("#101010"),
			["text"] = hex("#E0E0E0"),
			["text_outline"] = hex("#000000"),
			["glow"] = hex("#cc00ff"),
		},

		utility = {
			["outline"] = {
				["BackgroundColor3"] = {},
				["Color"] = {},
			},
			["inline"] = {
				["BackgroundColor3"] = {},
				["ImageColor3"] = {},
			},
			["accent"] = {
				["BackgroundColor3"] = {},
				["TextColor3"] = {},
				["ImageColor3"] = {},
				["ScrollBarImageColor3"] = {}
			},
			["contrast"] = {
				["Color"] = {},
			},
			["text"] = {
				["TextColor3"] = {},
			},
			["text_outline"] = {
				["Color"] = {},
			},
			["glow"] = {
				["ImageColor3"] = {},
			},
			["high_contrast"] = {
				["BackgroundColor3"] = {},
			},
			["low_contrast"] = {
				["BackgroundColor3"] = {},
			}
		},

		find = {
			["Frame"] = "BackgroundColor3",
			["TextLabel"] = "TextColor3",
			["UIGradient"] = "Color",
			["UIStroke"] = "Color",
			["ImageLabel"] = "ImageColor3",
			["TextButton"] = "BackgroundColor3",
			["ScrollingFrame"] = "ScrollBarImageColor3"
		}
	}

	local keys = {
		[Enum.KeyCode.LeftShift] = "LS",
		[Enum.KeyCode.RightShift] = "RS",
		[Enum.KeyCode.LeftControl] = "LC",
		[Enum.KeyCode.RightControl] = "RC",
		[Enum.KeyCode.Insert] = "INS",
		[Enum.KeyCode.Backspace] = "BS",
		[Enum.KeyCode.Return] = "Ent",
		[Enum.KeyCode.LeftAlt] = "LA",
		[Enum.KeyCode.RightAlt] = "RA",
		[Enum.KeyCode.CapsLock] = "CAPS",
		[Enum.KeyCode.One] = "1",
		[Enum.KeyCode.Two] = "2",
		[Enum.KeyCode.Three] = "3",
		[Enum.KeyCode.Four] = "4",
		[Enum.KeyCode.Five] = "5",
		[Enum.KeyCode.Six] = "6",
		[Enum.KeyCode.Seven] = "7",
		[Enum.KeyCode.Eight] = "8",
		[Enum.KeyCode.Nine] = "9",
		[Enum.KeyCode.Zero] = "0",
		[Enum.KeyCode.KeypadOne] = "Num1",
		[Enum.KeyCode.KeypadTwo] = "Num2",
		[Enum.KeyCode.KeypadThree] = "Num3",
		[Enum.KeyCode.KeypadFour] = "Num4",
		[Enum.KeyCode.KeypadFive] = "Num5",
		[Enum.KeyCode.KeypadSix] = "Num6",
		[Enum.KeyCode.KeypadSeven] = "Num7",
		[Enum.KeyCode.KeypadEight] = "Num8",
		[Enum.KeyCode.KeypadNine] = "Num9",
		[Enum.KeyCode.KeypadZero] = "Num0",
		[Enum.KeyCode.Minus] = "-",
		[Enum.KeyCode.Equals] = "=",
		[Enum.KeyCode.Tilde] = "~",
		[Enum.KeyCode.LeftBracket] = "[",
		[Enum.KeyCode.RightBracket] = "]",
		[Enum.KeyCode.RightParenthesis] = ")",
		[Enum.KeyCode.LeftParenthesis] = "(",
		[Enum.KeyCode.Semicolon] = ",",
		[Enum.KeyCode.Quote] = "'",
		[Enum.KeyCode.BackSlash] = "\\",
		[Enum.KeyCode.Comma] = ",",
		[Enum.KeyCode.Period] = ".",
		[Enum.KeyCode.Slash] = "/",
		[Enum.KeyCode.Asterisk] = "*",
		[Enum.KeyCode.Plus] = "+",
		[Enum.KeyCode.Period] = ".",
		[Enum.KeyCode.Backquote] = "`",
		[Enum.UserInputType.MouseButton1] = "MB1",
		[Enum.UserInputType.MouseButton2] = "MB2",
		[Enum.UserInputType.MouseButton3] = "MB3",
		[Enum.KeyCode.Escape] = "ESC",
		[Enum.KeyCode.Space] = "SPC",
	}

	library.__index = library
	library.pending_logs = {}
	library.checks = {first_time = not isfolder("ShitHax")}

	for _, path in next, library.folders do
		makefolder(library.directory .. path)
	end

	library.asset_base = "https://raw.githubusercontent.com/backtrack-tech/backtrack.tech/main/"
	library.hitsounds = {}
	library.click_sounds = {}
	library.fonts = {}
	library.images.hitmarkers = {}

	local function title_case(name)
		return (name:gsub("_", " "):gsub("(%a)([%w_']*)", function(first, rest)
			return first:upper() .. rest:lower()
		end))
	end

	local function fetch(remote, path)
		if isfile(path) then
			return true
		end
		insert(library.pending_logs, string.format("Caching asset '%s' for first-time import...", remote:match("[^/]+$") or remote))
		local ok, body = pcall(game.HttpGet, game, library.asset_base .. remote)
		if ok and type(body) == "string" and #body > 64 and not body:find("^404") then
			local wrote = pcall(writefile, path, body)
			return wrote
		end
		return false
	end

	local function custom_asset(path)
		local ok, id = pcall(getcustomasset, path)
		if ok then
			return id
		end
		return nil
	end

	local downloads = {}
	local function queue(remote, path, done)
		table.insert(downloads, {remote = remote, path = path, done = done})
	end

	-- fonts are queued first: the ui default font depends on them and the
	-- shared download timeout can expire before the last queued assets land
	local font_files = {
		Tahoma = "fs-tahoma-8px.ttf",
		Verdana = "verdana.ttf",
		Micro = "micro.ttf",
		Minecraftia = "minecraftia.ttf",
		Monaco = "monaco.ttf",
		Nokia = "nokia.ttf",
		["Smallest Pixel"] = "smallest_pixel-7.ttf",
	}
	library.font_names = {"Micro", "Minecraftia", "Monaco", "Nokia", "Smallest Pixel", "Tahoma", "Verdana"}

	for name, file in font_files do
		queue("fonts/" .. file, library.directory .. "/fonts/" .. file, function(path)
			local face = custom_asset(path)
			if not face then
				-- the cached file is unusable, drop it so the next run re-fetches
				pcall(delfile, path)
				insert(library.pending_logs, string.format("Font '%s' failed to import and was cleared for retry.", name))
				return
			end
			local descriptor = library.directory .. "/fonts/" .. file:gsub("%.ttf$", "") .. ".font"
			local ok = pcall(writefile, descriptor, http_service:JSONEncode({
				name = name,
				faces = {{name = "Regular", weight = 400, style = "normal", assetId = face}},
			}))
			local id = ok and custom_asset(descriptor)
			if id then
				library.fonts[name] = Font.new(id, Enum.FontWeight.Regular)
			else
				insert(library.pending_logs, string.format("Font '%s' descriptor could not be imported.", name))
			end
		end)
	end

	for _, name in {"pointer", "configurations", "glow4", "logo", "main", "output", "playerlist", "scroll", "style", "transparency", "fov_glow", "uaz", "heli", "exit", "body", "item"} do
		queue("storage/" .. name .. ".png", library.directory .. "/images/" .. name .. ".png", function(path)
			local id = custom_asset(path)
			if id then
				library.images[title_case(name)] = id
			end
		end)
	end

	for _, name in {"arrow", "box", "cross", "diamond", "heart", "plus"} do
		for _, variant in {name, "outline_" .. name} do
			queue("hitmarkers/" .. variant .. ".png", library.directory .. "/hitmarkers/" .. variant .. ".png", function(path)
				local id = custom_asset(path)
				if id then
					library.images.hitmarkers[title_case(variant)] = id
					library.images.hitmarkers[title_case(variant):gsub(" ", "")] = id
				end
			end)
		end
	end

	for _, name in {"amongus", "ara", "cod", "coin", "csgo", "fatality", "gamesense", "landing", "neverlose", "noname", "parry", "rifk7", "rust", "snap", "uwu"} do
		queue("hitsounds/" .. name .. ".mp3", library.directory .. "/hitsounds/" .. name .. ".mp3", function(path)
			local id = custom_asset(path)
			if id then
				library.hitsounds[title_case(name)] = id
			end
		end)
	end

	for _, name in {"default", "experience", "halloween", "pride", "wood", "notification", "warning"} do
		queue("storage/" .. name .. ".mp3", library.directory .. "/sounds/" .. name .. ".mp3", function(path)
			local id = custom_asset(path)
			if id then
				library.click_sounds[title_case(name)] = id
			end
		end)
	end

	local remaining = #downloads
	for _, item in downloads do
		task.spawn(function()
			local ok = fetch(item.remote, item.path)
			if ok then
				pcall(item.done, item.path)
			end
			remaining -= 1
		end)
	end

	local started = os.clock()
	while remaining > 0 and os.clock() - started < 20 do
		task.wait()
	end

	library.images.Glow4 = library.images.Glow4 or "http://www.roblox.com/asset/?id=18245826428"
	library.images["Fov Glow"] = library.images["Fov Glow"] or library.images.Glow4
	library.font = library.fonts.Tahoma or Font.fromEnum(Enum.Font.Code)
	for _, name in library.font_names do
		library.fonts[name] = library.fonts[name] or library.font
	end

	local config_holder

		function library:hoverify(hover, parent)
			local hover_instance = library:create("Frame", {
				Parent = parent,
				BackgroundTransparency = 1,
				BorderColor3 = rgb(0, 0, 0),
				Size = dim2(1, 0, 1, 0),
				BorderSizePixel = 0,
				BackgroundColor3 = themes.preset.accent,
				ZIndex = 1
			}) library:apply_theme(hover_instance, "accent", "BackgroundColor3")

			library:connection(hover.MouseEnter, function()
				library:tween(hover_instance, {BackgroundTransparency = 0})
			end)

			library:connection(hover.MouseLeave, function()
				library:tween(hover_instance, {BackgroundTransparency = 1})
			end)

			return hover_instance
		end

		function library:hovering(Object)
			if type(Object) == "table" then
				local Pass = false;

				for _,obj in Object do
					if library:hovering(obj) then
						Pass = true
						return Pass
					end
				end
			else
				local y_cond = Object.AbsolutePosition.Y <= mouse.Y and mouse.Y <= Object.AbsolutePosition.Y + Object.AbsoluteSize.Y
				local x_cond = Object.AbsolutePosition.X <= mouse.X and mouse.X <= Object.AbsolutePosition.X + Object.AbsoluteSize.X

				return (y_cond and x_cond)
			end
		end

		function library:make_resizable(frame)
			local Frame = library:create("TextButton", {
				Size = dim2(0, 10, 0, 10),
				Position = dim2(1, -10, 1, -10),
				BorderSizePixel = 0,
				BackgroundTransparency = 1,
				Text = "",
				Parent = frame
			})

			local resizing = false
			local start_size
			local start
			local og_size = frame.Size

			Frame.InputBegan:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 and library.drag_enabled then
					resizing = true
					start = input.Position
					start_size = frame.Size
				end
			end)

			Frame.InputEnded:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 then
					resizing = false
				end
			end)

			library:connection(uis.InputChanged, function(input, game_event)
				if resizing and input.UserInputType == Enum.UserInputType.MouseMovement then
					local viewport_x = camera.ViewportSize.X
					local viewport_y = camera.ViewportSize.Y

					local current_size = dim2(
						start_size.X.Scale,
						math.clamp(
							start_size.X.Offset + (input.Position.X - start.X),
							og_size.X.Offset,
							viewport_x
						),
						start_size.Y.Scale,
						math.clamp(
							start_size.Y.Offset + (input.Position.Y - start.Y),
							og_size.Y.Offset,
							viewport_y
						)
					)
					frame.Size = current_size
				end
			end)
		end

		function library:draggify(frame)
			local dragging = false
			local start_position = frame.Position
			local start
			local snapped = false

			library:connection(frame.InputBegan, function(input)
				if input.UserInputType ~= Enum.UserInputType.MouseButton1 or not library.drag_enabled then
					return
				end

				dragging = true
				library.active.drag = frame
				start = input.Position
				start_position = frame.Position

				if library.current_element_open then
					library.current_element_open.set_visible(false)
					library.current_element_open.open = false
					library.current_element_open = nil
				end

				if frame.Parent:IsA("ScreenGui") and frame.Parent.DisplayOrder ~= 999999 then
					library.display_orders += 1
					frame.Parent.DisplayOrder = library.display_orders
				end
			end)

			library:connection(frame.InputEnded, function(input)
				if input.UserInputType ~= Enum.UserInputType.MouseButton1 or not dragging then
					return
				end

				dragging = false

				if library.active.drag == frame then
					library.active.drag = nil
				end

				if snapped then
					snapped = false
					library:animate_snapline(false)
				end
			end)

			library:connection(uis.InputChanged, function(input)
				if not dragging or input.UserInputType ~= Enum.UserInputType.MouseMovement then
					return
				end

				local viewport_size = camera.ViewportSize
				local size = frame.AbsoluteSize

				local x = clamp(start_position.X.Offset + (input.Position.X - start.X), 0, viewport_size.X - size.X)
				local y = clamp(start_position.Y.Offset + (input.Position.Y - start.Y), 0, viewport_size.Y - size.Y)

				if library.aerosnap then
					local center_x = (viewport_size.X - size.X) / 2
					local center_y = (viewport_size.Y - size.Y) / 2

					x = library:snap(x, center_x)
					y = library:snap(y, center_y)

					local is_snapped = x == center_x or y == center_y

					if is_snapped ~= snapped then
						snapped = is_snapped
						library:animate_snapline(is_snapped)
					end
				end

				frame.Position = dim2(0, x, 0, y)
			end)
		end

		function library:new_drawing(class, properties)
			local ins = Drawing.new(class)

			for _, v in next, properties do
				ins[_] = v
			end

			insert(library.drawings, ins)

			return ins
		end

		function library:new_item(class, properties)
			local ins = Instance.new(class)

			for _, v in next, properties do
				ins[_] = v
			end

			insert(library.instances, ins)

			return ins
		end

		function library:convert_enum(enum)
			local enum_parts = {}

			for part in string.gmatch(enum, "[%w_]+") do
				insert(enum_parts, part)
			end

			local enum_table = Enum
			for i = 2, #enum_parts do
				local enum_item = enum_table[enum_parts[i]]

				enum_table = enum_item
			end

			return enum_table
		end

		function library:to_hex(color)
			return string.format("#%02X%02X%02X", math.floor(color.R * 255), math.floor(color.G * 255), math.floor(color.B * 255))
		end

		function library:tween(obj, properties, time)
			local tween = tween_service:Create(obj, TweenInfo.new(time or library.tweening_speed, library.tweening_style, library.tweening_direction, 0, false, 0), properties)
			tween:Play()

			return tween
		end

		function library:config_list_update()
			if not config_holder then return end

			local list = {}
			local ok, files = pcall(listfiles, library.directory .. "/configs")

			if ok and type(files) == "table" then
				for _, file in ipairs(files) do
					local name = file:gsub(".*[\\/]", "")
					if name:sub(-4):lower() == ".cfg" then
						list[#list + 1] = name:sub(1, -5)
					end
				end
			end

			table.sort(list)
			config_holder.refresh_options(list)
		end

		function library:get_config()
			local config = {}

			for flag, value in pairs(flags) do
				if type(value) == "table" and value.key then
					config[flag] = { active = value.active, mode = value.mode, key = tostring(value.key) }
				elseif type(value) == "table" and value.Transparency and value.Color then
					config[flag] = { Transparency = value.Transparency, Color = value.Color:ToHex() }
				else
					config[flag] = value
				end
			end

			local ui_positions = {}

			for name, frame in pairs({
				main = library.windows.main_window.items.main_holder,
				style = library.windows.style.get_main_holder(),
				config = library.windows.configurations_holder.get_main_holder(),
				player = library.windows.playerlist_holder.get_main_holder(),
				output = library.windows.output.get_main_holder(),
				hotbar = library.hotbar_checker,
				armor = library.armor_checker,
				watermark = library.watermark_outline,
				indicator = library.indicator_main,
				keybind = library.keybind_list_frame,
				session_data = library.session_data_frame,
				player_indicator = library.player_indicator_frame,
				inventory_viewer = library.inventory_viewer_frame
			}) do
				ui_positions[name .. "_position"] = library:serialize_udim2(frame.Position)

				if name ~= "watermark" and name ~= "hotbar" and name ~= "indicator" then
					ui_positions[name .. "_size"] = library:serialize_udim2(frame.Size)
				end
			end

			config.ui_positions = ui_positions

			return http_service:JSONEncode(config)
		end

		function library:load_config(config_json)
			if type(config_json) ~= "string" or config_json == "" then
				return false, "configuration is empty or invalid"
			end

			local decoded, config = pcall(http_service.JSONDecode, http_service, config_json)
			if not decoded or type(config) ~= "table" then
				return false, "configuration is not valid JSON"
			end

			local loaded, skipped = 0, 0
			for flag, value in pairs(config) do
				local set = library.config_flags[flag]
				if set then
					local ok
					if type(value) == "table" and type(value.Color) == "string" and type(value.Transparency) == "number" then
						ok = pcall(function()
							set(hex(value.Color), value.Transparency)
						end)
					else
						ok = pcall(set, value)
					end

					if ok then
						loaded = loaded + 1
					else
						skipped = skipped + 1
					end
				end
			end

			if type(config.ui_positions) == "table" then
				for _, transform in ipairs({
					{ "main", library.windows.main_window.items.main_holder, true },
					{ "style", library.windows.style.get_main_holder(), true },
					{ "config", library.windows.configurations_holder.get_main_holder(), true },
					{ "player", library.windows.playerlist_holder.get_main_holder(), true },
					{ "output", library.windows.output.get_main_holder(), true },
					{ "hotbar", library.hotbar_checker, false },
					{ "armor", library.armor_checker, false },
					{ "watermark", library.watermark_outline, false },
					{ "indicator", library.indicator_main, false },
					{ "keybind", library.keybind_list_frame, true },
					{ "session_data", library.session_data_frame, false },
					{ "player_indicator", library.player_indicator_frame, false },
					{ "inventory_viewer", library.inventory_viewer_frame, true },
				}) do
					pcall(library.set_ui_transform, library, config, transform[1], transform[2], transform[3])
				end
			end

			if loaded == 0 and not config.ui_positions then
				return false, "configuration contains no supported settings"
			end

			return true, skipped > 0 and ("skipped " .. skipped .. " incompatible setting(s)") or nil
		end

		function library:load_config_file(name)
			if type(name) ~= "string" or name == "" or name:find("[\\/:*?\"<>|]") then
				return false, "select a valid configuration"
			end

			local path = library.directory .. "/configs/" .. name .. ".cfg"
			if not isfile(path) then
				return false, "configuration file was not found"
			end

			local read_ok, contents = pcall(readfile, path)
			if not read_ok then
				return false, "could not read configuration file"
			end

			return library:load_config(contents)
		end

		function library:round(number, float)
			local multiplier = 1 / (float or 1)

			return floor(number * multiplier + 0.5) / multiplier
		end

		function library:apply_theme(instance, theme, property)
			local bucket = themes.utility[theme]
			if not bucket then
				bucket = {}
				themes.utility[theme] = bucket
			end
			if not bucket[property] then
				bucket[property] = {}
			end
			insert(bucket[property], instance)
		end

		function library:update_theme(theme, color)
			for _, property in next, themes.utility[theme] do

				for m, object in next, property do
					if object[_] == themes.preset[theme] or object.ClassName == "UIGradient" then
						object[_] = color
					end
				end
			end

			themes.preset[theme] = color
		end

		function library:log_result(success, past, verb, name, err)
			past = past or "<unknown>"
			verb = verb or "<unknown>"
			name = name or "<unknown>"
			local message = not success and (err and tostring(err):gsub("\n", " "):gsub("%s+", " "):match("[^:]+: (.+)") or "Unknown error") or nil
			if success then
				library:notification({text = past .. " Configuration: " .. name, time = 3, flashing = past == "Saved" or past == "Deleted"})
				library.output.create_output({text = "Successfully " .. past:lower() .. " configuration: " .. name, prefix = "SUCCESS", color = library.colors.success})
			else
				library:notification({text = "Failed to " .. verb .. " configuration: " .. name, time = 3})
				library.output.create_output({text = "Failed to " .. verb .. " configuration: " .. name .. " (" .. tostring(message) .. ")", prefix = "FAIL", color = library.colors.fail})
			end
		end

		function library:refresh_contrast()
			if flags["low_contrast"] and flags["high_contrast"] then
				library:update_theme("contrast", rgbseq{
					rgbkey(0, flags["low_contrast"].Color),
					rgbkey(1, flags["high_contrast"].Color)
				})
			end
		end

		function library:disconnect(connection)
			if connection then
				connection:Disconnect()
				for index, stored in ipairs(library.connections) do
					if stored == connection then
						table.remove(library.connections, index)
						break
					end
				end
			end
		end

		function library:set_ui_transform(config, name, frame, has_size)
			if not frame then
				return
			end

			local viewport_size = camera.ViewportSize
			local size = frame.Size

			if has_size then
				local saved_size = config.ui_positions[name .. "_size"]

				if saved_size then
					local new_size = library:deserialize_udim2(saved_size)

					if new_size then
						size = new_size
						frame.Size = new_size
					end
				end
			end

			local saved_position = config.ui_positions[name .. "_position"]

			if saved_position then
				local position = library:deserialize_udim2(saved_position)

				if position then
					local x = clamp(position.X.Offset, 0, viewport_size.X - size.X.Offset)
					local y = clamp(position.Y.Offset, 0, viewport_size.Y - size.Y.Offset)
					frame.Position = dim2(0, x, 0, y)
				end
			end
		end

		function library:serialize_udim2(udim2)
			return { ScaleX = udim2.X.Scale, OffsetX = udim2.X.Offset, ScaleY = udim2.Y.Scale, OffsetY = udim2.Y.Offset }
		end

		function library:deserialize_udim2(data)
			return dim2(data.ScaleX, data.OffsetX, data.ScaleY, data.OffsetY)
		end

		function library:snap(position, target)
			if math.abs(position - target) < 16 then
				return target
			end

			return position
		end

		function library:create_snapline()
			local snap_gui = library:create("ScreenGui", {
				Parent = gethui(),
				IgnoreGuiInset = true,
				DisplayOrder = 9999999,
				ZIndexBehavior = Enum.ZIndexBehavior.Sibling
			})

			library.window_snap_left = library:create("Frame", {
				Parent = snap_gui,
				Position = dim2(0.5, -1, 0, 0),
				Size = dim2(0, 1, 0, 0),
				BorderSizePixel = 1,
				BorderColor3 = rgb(0, 0, 0),
				BackgroundTransparency = 1,
				BackgroundColor3 = themes.preset.accent,
				Visible = false
			})

			library:apply_theme(library.window_snap_left, "accent", "BackgroundColor3")

			library.window_snap_right = library:create("Frame", {
				Parent = snap_gui,
				Position = dim2(0, 0, 0.5, -1),
				Size = dim2(0, 0, 0, 1),
				BorderSizePixel = 1,
				BorderColor3 = rgb(0, 0, 0),
				BackgroundTransparency = 1,
				BackgroundColor3 = themes.preset.accent,
				Visible = false
			})

			library:apply_theme(library.window_snap_right, "accent", "BackgroundColor3")
		end

		function library:animate_snapline(show)
			if library.active.tween_left then
				library.active.tween_left:Cancel()
			end

			if library.active.tween_right then
				library.active.tween_right:Cancel()
			end

			local left = library.window_snap_left
			local right = library.window_snap_right

			if show then
				left.Size = dim2(0, 1, 0, 0)
				right.Size = dim2(0, 0, 0, 1)
				left.Visible = true
				right.Visible = true
				left.BackgroundTransparency = 1
				right.BackgroundTransparency = 1

				library.active.tween_left = tween_service:Create(left, TweenInfo.new(0.1, library.tweening_style, library.tweening_direction), { BackgroundTransparency = 0 })
				library.active.tween_right = tween_service:Create(right, TweenInfo.new(0.1, library.tweening_style, library.tweening_direction), { BackgroundTransparency = 0 })
				library.active.tween_left:Play()
				library.active.tween_right:Play()

				task.delay(0.1, function()
					library.active.tween_left = tween_service:Create(left, TweenInfo.new(0.2, library.tweening_style, library.tweening_direction), { Size = dim2(0, 1, 1, 0) })
					library.active.tween_right = tween_service:Create(right, TweenInfo.new(0.2, library.tweening_style, library.tweening_direction), { Size = dim2(1, 0, 0, 1) })
					library.active.tween_left:Play()
					library.active.tween_right:Play()
				end)

				return
			end

			library.active.tween_left = tween_service:Create(left, TweenInfo.new(0.2, library.tweening_style, library.tweening_direction), { Size = dim2(0, 1, 0, 0) })
			library.active.tween_right = tween_service:Create(right, TweenInfo.new(0.2, library.tweening_style, library.tweening_direction), { Size = dim2(0, 0, 0, 1) })
			library.active.tween_left:Play()
			library.active.tween_right:Play()

			task.delay(0.2, function()
				library.active.tween_left = tween_service:Create(left, TweenInfo.new(0.1, library.tweening_style, library.tweening_direction), { BackgroundTransparency = 1 })
				library.active.tween_right = tween_service:Create(right, TweenInfo.new(0.1, library.tweening_style, library.tweening_direction), { BackgroundTransparency = 1 })
				library.active.tween_left:Play()
				library.active.tween_right:Play()
			end)

			task.delay(0.3, function()
				if library.active.drag then
					return
				end

				left.Visible = false
				right.Visible = false
			end)
		end

		function library:connection(signal, callback)
			local connection = signal:Connect(callback)

			insert(library.connections, connection)

			return connection
		end

		function library:apply_stroke(parent)
			local stroke = library:create("UIStroke", {
				Parent = parent,
				Color = themes.preset.text_outline,
				LineJoinMode = Enum.LineJoinMode.Miter
			})

			library:apply_theme(stroke, "text_outline", "Color")
		end

		function library:create(instance, options)
			local ins = Instance.new(instance)

			for prop, value in next, options do
				ins[prop] = value
			end

			if instance == "TextLabel" or instance == "TextButton" or instance == "TextBox" then
				library:apply_theme(ins, "text", "TextColor3")
				library:apply_stroke(ins)
			elseif instance == "ScreenGui" then
				insert(library.guis, ins)
			end

			return ins
		end

		local tooltip_sgui = library:create("ScreenGui", {
			Enabled = true,
			Parent = gethui(),
			Name = "",
			DisplayOrder = 500,
		})

		function library:tool_tip(options)
			local cfg = {
				name = options.name or "n/a",
				path = options.path
			}

			if not cfg.path then
				return cfg
			end

			local outline = library:create("Frame", {
				Parent = tooltip_sgui,
				Size = dim2(0, 0, 0, 22),
				Position = dim2(0, 500, 0, 300),
				BorderSizePixel = 0,
				Visible = false,
				AutomaticSize = Enum.AutomaticSize.X,
				BackgroundColor3 = themes.preset.outline,
				ZIndex = 999999995
			})

			local inline = library:create("Frame", {
				Parent = outline,
				Position = dim2(0, 1, 0, 1),
				BorderSizePixel = 0,
				Size = dim2(1, -2, 1, -2),
				BackgroundColor3 = themes.preset.inline,
				ZIndex = 999999996
			})

			local background = library:create("Frame", {
				Parent = inline,
				Position = dim2(0, 1, 0, 1),
				BorderSizePixel = 0,
				Size = dim2(1, -2, 1, -2),
				BackgroundColor3 = rgb(255, 255, 255),
				ZIndex = 999999997
			})

			library:apply_theme(library:create("UIGradient", {
				Parent = background,
				Color = rgbseq({
					rgbkey(0, rgb(41, 41, 55)),
					rgbkey(1, rgb(35, 35, 47))
				})
			}), "contrast", "Color")

			local text = library:create("TextLabel", {
				Parent = background,
				FontFace = library.font,
				TextColor3 = themes.preset.text,
				Text = " " .. cfg.name .. " ",
				Size = dim2(0, 0, 1, 0),
				Position = dim2(0, 0, 0, -1),
				AutomaticSize = Enum.AutomaticSize.X,
				BackgroundTransparency = 1,
				TextSize = 12,
				ZIndex = 999999997
			})

			library:create("UIPadding", {
				Parent = background,
				PaddingRight = dim(0, 3)
			})

			library:create("UIStroke", {
				Parent = text,
				LineJoinMode = Enum.LineJoinMode.Miter
			})

			library:connection(cfg.path.MouseEnter, function()
				outline.Visible = true
			end)

			library:connection(cfg.path.MouseLeave, function()
				outline.Visible = false
			end)

			library:connection(uis.InputChanged, function(input)
				if outline.Visible and input.UserInputType == Enum.UserInputType.MouseMovement then
					outline.Position = dim_offset(input.Position.X + 10, input.Position.Y + 10)
				end
			end)

			return cfg
		end

		function library:panel(options)
			local cfg = {
				name = options.text or options.name or "Window",
				size = options.size or dim2(0, 530, 0, 590),
				position = options.position or dim2(0, 500, 0, 500),
				anchor_point = options.anchor_point or vec2(0, 0),
				default_position = nil,
				image = options.image or "rbxassetid://0",
				open = options.open or true,
				items = {}
			}

			local items = cfg.items

			items.sgui = library:create("ScreenGui", {
				Enabled = true,
				Parent = gethui()
			})

			items.main_holder = library:create("Frame", {
				Parent = items.sgui,
				AnchorPoint = cfg.anchor_point,
				Position = cfg.position,
				Active = true,
				Size = cfg.size,
				BorderSizePixel = 0,
				BackgroundColor3 = themes.preset.outline
			})

			library:apply_theme(items.main_holder, "outline", "BackgroundColor3")
			library:draggify(items.main_holder)
			library:make_resizable(items.main_holder)

			local close = library:create("TextButton", {
				Parent = items.main_holder,
				FontFace = library.font,
				AnchorPoint = vec2(1, 0),
				Text = "X",
				Size = dim2(0, 0, 0, 0),
				Position = dim2(1, -7, 0, 5),
				BorderSizePixel = 0,
				BackgroundTransparency = 1,
				TextXAlignment = Enum.TextXAlignment.Right,
				AutomaticSize = Enum.AutomaticSize.XY,
				TextColor3 = themes.preset.text,
				TextSize = 12,
				ZIndex = 100
			})

			library:create("UIStroke", {
				Parent = close
			})

			library:connection(close.MouseButton1Click, function()
				items.sgui.Enabled = false
			end)

			items.window_inline = library:create("Frame", {
				Parent = items.main_holder,
				Position = dim2(0, 1, 0, 1),
				Size = dim2(1, -2, 1, -2),
				BorderSizePixel = 0,
				BackgroundColor3 = themes.preset.accent
			})

			library:apply_theme(items.window_inline, "accent", "BackgroundColor3")

			items.window_holder = library:create("Frame", {
				Parent = items.window_inline,
				Position = dim2(0, 1, 0, 1),
				Size = dim2(1, -2, 1, -2),
				BorderSizePixel = 0,
				BackgroundColor3 = rgb(255, 255, 255)
			})

			library:apply_theme(library:create("UIGradient", {
				Parent = items.window_holder,
				Rotation = 90,
				Color = rgbseq({
					rgbkey(0, rgb(41, 41, 55)),
					rgbkey(1, rgb(35, 35, 47))
				})
			}), "contrast", "Color")

			items.text = library:create("TextLabel", {
				Parent = items.window_holder,
				FontFace = library.font,
				TextColor3 = themes.preset.accent,
				Text = cfg.name,
				BackgroundTransparency = 1,
				Position = dim2(0, 2, 0, 4),
				AutomaticSize = Enum.AutomaticSize.XY,
				TextSize = 12
			})

			library:apply_theme(items.text, "accent", "TextColor3")

			library:create("UIStroke", {
				Parent = items.text,
				LineJoinMode = Enum.LineJoinMode.Miter
			})

			library:create("UIPadding", {
				Parent = items.window_holder,
				PaddingBottom = dim(0, 4),
				PaddingRight = dim(0, 4),
				PaddingLeft = dim(0, 4)
			})

			items.outline = library:create("Frame", {
				Parent = items.window_holder,
				Position = dim2(0, 0, 0, 18),
				Size = dim2(1, 0, 1, -18),
				BorderSizePixel = 0,
				BackgroundColor3 = themes.preset.inline
			})

			library:apply_theme(items.outline, "inline", "BackgroundColor3")

			items.inline = library:create("Frame", {
				Parent = items.outline,
				Position = dim2(0, 1, 0, 1),
				Size = dim2(1, -2, 1, -2),
				BorderSizePixel = 0,
				BackgroundColor3 = themes.preset.outline
			})

			library:apply_theme(items.inline, "outline", "BackgroundColor3")

			items.holder = library:create("Frame", {
				Parent = items.inline,
				Position = dim2(0, 1, 0, 1),
				Size = dim2(1, -2, 1, -2),
				BorderSizePixel = 0,
				BackgroundColor3 = rgb(255, 255, 255)
			})

			library:apply_theme(library:create("UIGradient", {
				Parent = items.holder,
				Rotation = 90,
				Color = rgbseq({
					rgbkey(0, rgb(41, 41, 55)),
					rgbkey(1, rgb(35, 35, 47))
				})
			}), "contrast", "Color")

			library:create("UIPadding", {
				Parent = items.holder,
				PaddingTop = dim(0, 5),
				PaddingBottom = dim(0, 5),
				PaddingRight = dim(0, 5),
				PaddingLeft = dim(0, 5)
			})

			items.glow = library:create("ImageLabel", {
				Parent = items.main_holder,
				ImageColor3 = themes.preset.glow,
				Image = library.images.Glow4,
				ScaleType = Enum.ScaleType.Slice,
				SliceCenter = rect(vec2(21, 21), vec2(79, 79)),
				BackgroundTransparency = 1,
				ImageTransparency = 0.8,
				Position = dim2(0, -20, 0, -20),
				Size = dim2(1, 40, 1, 40),
				ZIndex = 0
			})

			library:apply_theme(items.glow, "glow", "ImageColor3")

			items.button = library:create("TextButton", {
				Parent = library.dock_holder,
				Text = "",
				Size = dim2(0, 25, 0, 25),
				BorderSizePixel = 0,
				TextColor3 = rgb(0, 0, 0),
				BackgroundColor3 = themes.preset.inline
			})

			library:apply_theme(items.button, "inline", "BackgroundColor3")

			local button_outline = library:create("Frame", {
				Parent = items.button,
				Position = dim2(0, 1, 0, 1),
				Size = dim2(1, -2, 1, -2),
				BorderSizePixel = 0,
				BackgroundColor3 = themes.preset.outline
			})

			library:apply_theme(button_outline, "outline", "BackgroundColor3")

			local button_inline = library:create("Frame", {
				Parent = button_outline,
				Position = dim2(0, 1, 0, 1),
				Size = dim2(1, -2, 1, -2),
				BorderSizePixel = 0,
				BackgroundColor3 = themes.preset.inline
			})

			library:apply_theme(button_inline, "inline", "BackgroundColor3")

			library:apply_theme(library:create("UIGradient", {
				Parent = button_inline,
				Rotation = 90,
				Color = rgbseq({
					rgbkey(0, rgb(35, 35, 47)),
					rgbkey(1, rgb(41, 41, 55))
				})
			}), "contrast", "Color")

			items.Icon = library:create("ImageLabel", {
				Parent = button_inline,
				ImageColor3 = themes.preset.accent,
				Image = cfg.image,
				ResampleMode = Enum.ResamplerMode.Pixelated,
				BackgroundTransparency = 1,
				Size = dim2(1, 0, 1, 0)
			})

			library:apply_theme(items.Icon, "accent", "ImageColor3")

			library:create("UIPadding", {
				Parent = button_inline,
				PaddingTop = dim(0, 3),
				PaddingBottom = dim(0, 3),
				PaddingRight = dim(0, 3),
				PaddingLeft = dim(0, 3)
			})

			library:tool_tip({ name = cfg.name, path = items.button })

			cfg.default_position = items.main_holder.Position

			function cfg.get_main_holder()
				return items.main_holder
			end

			function cfg.get_default_position()
				return cfg.default_position
			end

			library:connection(items.sgui:GetPropertyChangedSignal("Enabled"), function()
				util:set_property(items.Icon, "ImageColor3", items.sgui.Enabled and themes.preset.accent or themes.preset.inline)
			end)

			library:connection(items.button.MouseButton1Click, function()
				items.sgui.Enabled = not items.sgui.Enabled
				library:sound(library.sound_settings.sound_type, library.sound_settings.sound_volume)
			end)

			return setmetatable(cfg, library)
		end

		local sgui = library:create("ScreenGui", {
			Enabled = true,
			Parent = gethui(),
			Name = "",
			DisplayOrder = 999999,
		})

		local notif_holder = library:create("ScreenGui", {
			Parent = gethui(),
			Name = "",
			IgnoreGuiInset = true,
			DisplayOrder = 999999,
			ZIndexBehavior = Enum.ZIndexBehavior.Sibling
		})

		local function input_key(input)
			return input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode or input.UserInputType
		end

		library:connection(uis.InputBegan, function(input, game_processed)
			local key = input_key(input)

			local armed_now = library.active.pending_bind ~= library.active.seen_bind
			if library.active.pending_bind and not (armed_now and input.UserInputType == Enum.UserInputType.MouseButton1) then
				local bind = library.active.pending_bind
				library.active.pending_bind = nil
				bind(key)
				return
			end

			if input.UserInputType == Enum.UserInputType.MouseButton1 then
				for _, handler in library.active.slider_handlers do
					handler(true)
				end
			end

			if game_processed then
				return
			end

			for _, handler in library.active.keybind_handlers do
				handler(key)
			end
		end)

		library:connection(uis.InputEnded, function(input)
			local key = input_key(input)

			if input.UserInputType == Enum.UserInputType.MouseButton1 then
				for _, handler in library.active.slider_handlers do
					handler(false)
				end

				library.active.slider = nil
			end

			for _, handler in library.active.keybind_hold_handlers do
				handler(key)
			end
		end)

		library:connection(run.RenderStepped, function()
			library.active.seen_bind = library.active.pending_bind
			local now = os.clock()
			local rate = 1 / library.animation_frequency

			if now - library.last_update_slider >= rate then
				library.last_update_slider = now

				local active = library.active.slider
				if active then
					local mouse_location = uis:GetMouseLocation()
					local size_x = (mouse_location.X - active.slider.AbsolutePosition.X) / active.slider.AbsoluteSize.X
					active.cfg.set(((active.cfg.max - active.cfg.min) * size_x) + active.cfg.min)
				end

				if library.active.color then
					library.active.color()
				end
			end

			if now - library.last_update >= rate then
				library.last_update = now

				for _, animate in library.color_animations do
					animate(now)
				end
			end

			for key, data in library.flash_data do
				if now >= data.end_time then
					for _, object in data.objects do
						object.BackgroundTransparency = 0
					end
					library.flash_data[key] = nil
				elseif now - data.last >= 0.5 / data.speed then
					data.last = now
					data.state = 1 - data.state
					for _, object in data.objects do
						object.BackgroundTransparency = data.state
					end
				end
			end
		end)

		function library:fold_elements(origin, elements)
			for _, x in next, elements do
				local flag = library.visible_flags[x]

				if flag then
					flag(flags[origin])
				end
			end
		end

		function library:indicator()
			local cfg = {
				items = {};
			}

			local items = cfg.items; do
				items.Window = library:create( "Frame" , {
					Parent = sgui;
					Name = "\0";
					Position = dim2(0, 400, 0, 500);
					BorderColor3 = rgb(0, 0, 0);
					Size = dim2(0, 322, 0, 147);
					BorderSizePixel = 0;
					BackgroundColor3 = themes.preset.outline
				});	library:apply_theme(items.Window, "outline", "BackgroundColor3"); library:draggify(items.Window)

				items.InfoTitle = library:create( "TextLabel" , {
					FontFace = library.font;
					TextColor3 = themes.preset.text;
					BorderColor3 = rgb(0, 0, 0);
					Text = "Indicators";
					Parent = items.Window;
					Name = "\0";
					Size = dim2(1, 0, 0, 0);
					Position = dim2(0, 7, 0, 5);
					BackgroundTransparency = 1;
					TextXAlignment = Enum.TextXAlignment.Left;
					BorderSizePixel = 0;
					ZIndex = 5;
					AutomaticSize = Enum.AutomaticSize.Y;
					TextSize = 12;
				});

				items.Accent = library:create( "Frame" , {
					Parent = items.Window;
					Name = "\0";
					Position = dim2(0, 1, 0, 1);
					BorderColor3 = rgb(0, 0, 0);
					Size = dim2(1, -2, 1, -2);
					BorderSizePixel = 0;
					BackgroundColor3 = themes.preset.accent
				});	library:apply_theme(items.Accent, "accent", "BackgroundColor3")

				items.Background = library:create( "Frame" , {
					Parent = items.Accent;
					Name = "\0";
					Position = dim2(0, 1, 0, 1);
					BorderColor3 = rgb(0, 0, 0);
					Size = dim2(1, -2, 1, -2);
					BorderSizePixel = 0;
					BackgroundColor3 = themes.preset.high_contrast
				});	library:apply_theme(items.Background, "high_contrast", "BackgroundColor3")

				items.Inline = library:create( "Frame" , {
					Parent = items.Background;
					Name = "\0";
					Position = dim2(0, 4, 0, 18);
					BorderColor3 = rgb(0, 0, 0);
					Size = dim2(1, -8, 1, -22);
					BorderSizePixel = 0;
					BackgroundColor3 = themes.preset.outline
				});	library:apply_theme(items.Inline, "outline", "BackgroundColor3")

				items.Outline = library:create( "Frame" , {
					Parent = items.Inline;
					Name = "\0";
					Position = dim2(0, 1, 0, 1);
					BorderColor3 = rgb(0, 0, 0);
					Size = dim2(1, -2, 1, -2);
					BorderSizePixel = 0;
					BackgroundColor3 = themes.preset.inline
				});	library:apply_theme(items.Outline, "inline", "BackgroundColor3")

				items.LowContrast = library:create( "Frame" , {
					Parent = items.Outline;
					Name = "\0";
					Position = dim2(0, 1, 0, 1);
					BorderColor3 = rgb(0, 0, 0);
					Size = dim2(1, -2, 1, -2);
					BorderSizePixel = 0;
					BackgroundColor3 = themes.preset.low_contrast
				});	library:apply_theme(items.LowContrast, "low_contrast", "BackgroundColor3")

				items.Inline = library:create( "Frame" , {
					Parent = items.LowContrast;
					Name = "\0";
					Position = dim2(0, 4, 0, 4);
					BorderColor3 = rgb(0, 0, 0);
					Size = dim2(1, -8, 1, -8);
					BorderSizePixel = 0;
					BackgroundColor3 = themes.preset.inline
				});	library:apply_theme(items.Inline, "inline", "BackgroundColor3")

				items.Outline = library:create( "Frame" , {
					Parent = items.Inline;
					Name = "\0";
					Position = dim2(0, 1, 0, 1);
					BorderColor3 = rgb(0, 0, 0);
					Size = dim2(1, -2, 1, -2);
					BorderSizePixel = 0;
					BackgroundColor3 = themes.preset.outline
				});	library:apply_theme(items.Outline, "outline", "BackgroundColor3")

				items.LowContrast = library:create( "Frame" , {
					Parent = items.Outline;
					Name = "\0";
					Position = dim2(0, 1, 0, 1);
					BorderColor3 = rgb(0, 0, 0);
					Size = dim2(1, -2, 1, -2);
					BorderSizePixel = 0;
					BackgroundColor3 = themes.preset.low_contrast
				});	library:apply_theme(items.LowContrast, "low_contrast", "BackgroundColor3"); local image_holder = items.LowContrast;

				items.Inline = library:create( "Frame" , {
					Parent = items.LowContrast;
					Name = "\0";
					Position = dim2(0, 4, 0, 4);
					BorderColor3 = rgb(0, 0, 0);
					Size = dim2(1, -8, 1, -8);
					BorderSizePixel = 0;
					BackgroundColor3 = themes.preset.inline
				});	library:apply_theme(items.Inline, "inline", "BackgroundColor3")

				items.Outline = library:create( "Frame" , {
					Parent = items.Inline;
					Name = "\0";
					Position = dim2(0, 1, 0, 1);
					BorderColor3 = rgb(0, 0, 0);
					Size = dim2(1, -2, 1, -2);
					BorderSizePixel = 0;
					BackgroundColor3 = themes.preset.outline
				});	library:apply_theme(items.Outline, "outline", "BackgroundColor3")

				items.LowContrast = library:create( "Frame" , {
					Parent = items.Outline;
					Name = "\0";
					Position = dim2(0, 1, 0, 1);
					BorderColor3 = rgb(0, 0, 0);
					Size = dim2(1, -2, 1, -2);
					BorderSizePixel = 0;
					BackgroundColor3 = themes.preset.low_contrast
				});	library:apply_theme(items.LowContrast, "low_contrast", "BackgroundColor3")

				items.InfoTitle = library:create( "TextLabel" , {
					FontFace = library.font;
					TextColor3 = themes.preset.text;
					BorderColor3 = rgb(0, 0, 0);
					Text = "Info";
					Parent = items.Outline;
					Name = "\0";
					Size = dim2(1, 0, 0, 0);
					Position = dim2(0, 7, 0, 5);
					BackgroundTransparency = 1;
					TextXAlignment = Enum.TextXAlignment.Left;
					BorderSizePixel = 0;
					ZIndex = 5;
					AutomaticSize = Enum.AutomaticSize.Y;
					TextSize = 12;
				});

				library:create( "UIStroke" , {
					Parent = items.InfoTitle
				});

				items.Accent = library:create( "Frame" , {
					Name = "\0";
					Parent = items.LowContrast;
					BorderColor3 = rgb(0, 0, 0);
					Size = dim2(1, 0, 0, 2);
					BackgroundColor3 = themes.preset.accent;
					BorderSizePixel = 0;
				});	library:apply_theme(items.Accent, "accent", "BackgroundColor3");

				items.Shadow = library:create( "Frame" , {
					AnchorPoint = vec2(0, 1);
					Parent = items.Accent;
					Name = "\0";
					Position = dim2(0, 0, 1, 0);
					BorderColor3 = rgb(0, 0, 0);
					Size = dim2(1, 0, 0, 1);
					BorderSizePixel = 0;
					BackgroundColor3 = themes.preset.accent;
				}); library:apply_theme(items.Shadow, "accent", "BackgroundColor3");

				library:create( "UIGradient" , {
					Rotation = 90;
					Parent = items.Shadow;
					Color = rgbseq{rgbkey(0, rgb(150, 150, 150)), rgbkey(1, rgb(150, 150, 150))}
				});

				items.holder = library:create( "Frame" , {
					Parent = items.LowContrast;
					Name = "\0";
					Position = dim2(0, 76, 0, 21);
					BorderColor3 = rgb(0, 0, 0);
					Size = dim2(1, -80, 0, 0);
					BorderSizePixel = 0;
				});

				library:create("UIListLayout", {
					Parent = items.holder,
					Padding = dim(0, 4),
					HorizontalAlignment = Enum.HorizontalAlignment.Center,
					SortOrder = Enum.SortOrder.LayoutOrder
				})

				items.Inline = library:create( "Frame" , {
					Parent = image_holder;
					Name = "\0";
					Position = dim2(0, 10, 0, 28);
					BorderColor3 = rgb(0, 0, 0);
					Size = dim2(0, 68, 0, 67);
					BorderSizePixel = 0;
					BackgroundColor3 = themes.preset.outline
				});	library:apply_theme(items.Inline, "outline", "BackgroundColor3")

				items.Outline = library:create( "Frame" , {
					Parent = items.Inline;
					Name = "\0";
					Position = dim2(0, 1, 0, 1);
					BorderColor3 = rgb(0, 0, 0);
					Size = dim2(1, -2, 1, -2);
					BorderSizePixel = 0;
					BackgroundColor3 = themes.preset.inline
				});	library:apply_theme(items.Outline, "inline", "BackgroundColor3")

				items.LowContrast = library:create( "Frame" , {
					Parent = items.Outline;
					Name = "\0";
					Position = dim2(0, 1, 0, 1);
					BorderColor3 = rgb(0, 0, 0);
					Size = dim2(1, -2, 1, -2);
					BorderSizePixel = 0;
					BackgroundColor3 = themes.preset.low_contrast
				});	library:apply_theme(items.LowContrast, "low_contrast", "BackgroundColor3")

				items.Profile = library:create( "ImageLabel" , {
					BorderColor3 = rgb(0, 0, 0);
					Parent = items.LowContrast;
					Image = "rbxasset://textures/ui/GuiImagePlaceholder.png";
					BackgroundTransparency = 1;
					Name = "\0";
					Size = dim2(1, 0, 1, 0);
					BorderSizePixel = 0;
				});

				local section = setmetatable(items, library)
				items.label = section:label({name = "Player: "})
				items.slider = section:slider({name = "Health", custom = rgb(255, 0, 0), min = 0, max = 100, default = 50, input = true})

				library:create( "UIStroke" , {
					Parent = items.InfoTitle
				});
			end

			function cfg.set_visible(bool)
				items.Window.Visible = bool
			end

			function cfg.change_health(int)
				items.slider.set(int)
			end

			function cfg.change_profile(player)
				items.label.set(string.format("Player: %s (%s)", player.Name, player.DisplayName))
				items.Profile.Image = "https://www.roblox.com/headshot-thumbnail/image?userId=".. player.UserId .."&width=420&height=420&format=png"
			end

			return setmetatable(cfg, library)
		end

		function library:sound(sound_type, volume)
			local sound = new("Sound", {
				SoundId = library.click_sounds[sound_type],
				Volume = volume,
				Parent = gethui()
			})
			sound:Play()

			library:connection(sound.Ended, function()
				sound:Destroy()
			end)
		end

		function library:output(options)
			local cfg = {
				callback = options and options.callback or function() end,
				total_outputs = 0
			}

			local holder = library:create("TextLabel", {
				Parent = self.holder,
				FontFace = library.font,
				TextColor3 = themes.preset.text,
				BorderColor3 = rgb(0, 0, 0),
				Text = "",
				ZIndex = 2,
				Size = dim2(1, -6, 0, 12),
				BorderSizePixel = 0,
				BackgroundTransparency = 1,
				TextXAlignment = Enum.TextXAlignment.Left,
				AutomaticSize = Enum.AutomaticSize.Y,
				TextYAlignment = Enum.TextYAlignment.Top,
				TextSize = 12,
				BackgroundColor3 = rgb(255, 255, 255)
			})

			library:create("UIPadding", {
				Parent = holder,
				PaddingBottom = dim(0, -2),
				PaddingLeft = dim(0, 1)
			})

			library:create("UIStroke", {
				Parent = holder
			})

			local bottom_components = library:create("Frame", {
				Parent = holder,
				BorderColor3 = rgb(0, 0, 0),
				Size = dim2(1, 26, 0, 0),
				BorderSizePixel = 0,
				BackgroundColor3 = rgb(255, 255, 255)
			})

			library:create("UIListLayout", {
				Parent = bottom_components,
				Padding = dim(0, 10),
				SortOrder = Enum.SortOrder.LayoutOrder
			})

			local outline = library:create("Frame", {
				Parent = bottom_components,
				AutomaticSize = Enum.AutomaticSize.Y,
				Position = dim2(0, 0, 0, 2),
				BorderColor3 = rgb(0, 0, 0),
				Size = dim2(1, -27, 1, 173),
				BorderSizePixel = 0,
				BackgroundColor3 = themes.preset.outline
			})

			library:apply_theme(outline, "outline", "BackgroundColor3")

			local inline = library:create("Frame", {
				Parent = outline,
				Position = dim2(0, 1, 0, 1),
				BorderColor3 = rgb(0, 0, 0),
				Size = dim2(1, -2, 1, -2),
				BorderSizePixel = 0,
				BackgroundColor3 = themes.preset.inline
			})

			library:apply_theme(inline, "inline", "BackgroundColor3")

			local accent = library:create("Frame", {
				Parent = inline,
				Position = dim2(0, 1, 0, 1),
				BorderColor3 = rgb(0, 0, 0),
				Size = dim2(1, -2, 1, -2),
				BorderSizePixel = 0,
				BackgroundColor3 = themes.preset.accent
			})

			library:apply_theme(library:create("UIGradient", {
				Parent = accent,
				Rotation = 90,
				Color = rgbseq({
					rgbkey(0, rgb(255, 255, 255)),
					rgbkey(1, rgb(167, 167, 167))
				})
			}), "contrast", "Color")

			local background = library:create("Frame", {
				Parent = accent,
				BorderColor3 = rgb(0, 0, 0),
				Size = dim2(1, 0, 1, 0),
				BorderSizePixel = 0,
				BackgroundColor3 = rgb(255, 255, 255)
			})

			library:apply_theme(library:create("UIGradient", {
				Parent = background,
				Rotation = 90,
				Color = rgbseq({
					rgbkey(0, rgb(41, 41, 55)),
					rgbkey(1, rgb(35, 35, 47))
				})
			}), "contrast", "Color")

			local scroll = library:create("ScrollingFrame", {
				Parent = background,
				ScrollBarImageColor3 = themes.preset.accent,
				Active = true,
				MidImage = library.images.Scroll,
				TopImage = library.images.Scroll,
				BottomImage = library.images.Scroll,
				AutomaticCanvasSize = Enum.AutomaticSize.Y,
				ScrollBarThickness = 2,
				BackgroundTransparency = 1,
				Size = dim2(1, 0, 1, 0),
				BackgroundColor3 = rgb(255, 255, 255),
				BorderColor3 = rgb(0, 0, 0),
				BorderSizePixel = 0,
				CanvasSize = dim2(0, 0, 0, 0)
			})

			library:apply_theme(scroll, "accent", "ScrollBarImageColor3")

			library:create("UIPadding", {
				Parent = scroll,
				PaddingTop = dim(0, 4),
				PaddingBottom = dim(0, 4),
				PaddingRight = dim(0, 4),
				PaddingLeft = dim(0, 4)
			})

			library:create("UIListLayout", {
				Parent = scroll,
				Padding = dim(0, 4),
				SortOrder = Enum.SortOrder.LayoutOrder
			})

			function cfg.create_output(data)
				cfg.total_outputs = cfg.total_outputs + 1

				local prefix = data.prefix or "INFO"
				local output_color = data.color or themes.preset.text

				local button = library:create("TextButton", {
					Parent = scroll,
					FontFace = library.font,
					TextColor3 = themes.preset.text,
					BorderColor3 = rgb(0, 0, 0),
					Text = "",
					Size = dim2(1, 0, 0, 0),
					BorderSizePixel = 0,
					BackgroundTransparency = 1,
					AutomaticSize = Enum.AutomaticSize.Y,
					TextSize = 12,
					BackgroundColor3 = rgb(255, 255, 255)
				})

				local label = library:create("TextLabel", {
					Parent = button,
					FontFace = library.font,
					TextColor3 = output_color,
					BorderColor3 = rgb(0, 0, 0),
					RichText = true,
					Text = string.format("[%s] [%s] %s", os.date("%X"), tostring(prefix), tostring(data.text)),
					BorderSizePixel = 0,
					BackgroundTransparency = 1,
					TextXAlignment = Enum.TextXAlignment.Left,
					TextTruncate = Enum.TextTruncate.AtEnd,
					AutomaticSize = Enum.AutomaticSize.Y,
					TextSize = 12,
					LayoutOrder = -9,
					BackgroundColor3 = rgb(255, 255, 255),
					TextTransparency = 1
				})

				library:create("UIListLayout", {
					Parent = button,
					FillDirection = Enum.FillDirection.Horizontal,
					HorizontalFlex = Enum.UIFlexAlignment.Fill,
					SortOrder = Enum.SortOrder.LayoutOrder,
					VerticalFlex = Enum.UIFlexAlignment.Fill
				})

				library:create("UIPadding", {
					Parent = button,
					PaddingRight = dim(0, 2),
					PaddingLeft = dim(0, 2)
				})

				tween_service:Create(label, TweenInfo.new(library.tweening_speed * 1.5, library.tweening_style, library.tweening_direction), { TextTransparency = 0 }):Play()

				library:connection(button.MouseButton1Click, function()
					if cfg.selected_button and cfg.selected_button ~= label then
						cfg.selected_button.TextColor3 = cfg.selected_button_color
					end

					library:sound(library.sound_settings.sound_type, library.sound_settings.sound_volume)

					cfg.selected_button = label
					cfg.selected_button_color = output_color
					label.TextColor3 = themes.preset.accent
				end)
			end

			function cfg.clear_output()
				local removed = 0

				for _, child in pairs(scroll:GetChildren()) do
					if child:IsA("TextButton") then
						child:Destroy()
						removed += 1
					end
				end

				if removed == 0 then
					library:notification({ text = "Output is already empty", flashing = true, time = 5 })
					return
				end

				library:notification({ text = "Cleared output, removed " .. removed .. " instances", flashing = true, time = 5 })
			end

			return setmetatable(cfg, library)
		end

		function library:window(properties)
			local window = { opened = true }
			local opened = {}

			local blur = library:create("BlurEffect", {
				Parent = lighting,
				Enabled = true,
				Size = 0
			})

			library.cache = library:create("ScreenGui", {
				Enabled = false,
				Parent = gethui()
			})

			library:create_snapline()

			local pointer_gui = library:create("ScreenGui", {
				Enabled = true,
				DisplayOrder = 99999999,
				IgnoreGuiInset = true,
				ZIndexBehavior = Enum.ZIndexBehavior.Global,
				ResetOnSpawn = false,
				Parent = gethui()
			})

			local modal = library:create("TextButton", {
				BackgroundTransparency = 1,
				Size = dim2(0, 0, 0, 0),
				Text = "",
				Modal = true,
				Visible = false,
				Parent = pointer_gui
			})

			library.pointer = library:create("ImageLabel", {
				Image = library.images.Pointer,
				ZIndex = 999999999,
				ResampleMode = Enum.ResamplerMode.Pixelated,
				Position = dim2(0, 0, 0, 0),
				BorderColor3 = rgb(0, 0, 0),
				ImageColor3 = themes.preset.accent,
				Size = dim2(0, 14, 0, 14),
				BorderSizePixel = 0,
				BackgroundTransparency = 1,
				Visible = false,
				Parent = pointer_gui
			})

			library:apply_theme(library.pointer, "accent", "ImageColor3")

			library:connection(mouse.Move, function()
				if library.menu_opened and library.pointer_design then
					util:set_property(uis, "MouseIconEnabled", false)
					util:set_visible(library.pointer, true)
					local mouse_location = uis:GetMouseLocation()
					util:set_property(library.pointer, "Position", dim2(0, mouse_location.X, 0, mouse_location.Y))
				elseif library.menu_opened then
					util:set_property(uis, "MouseIconEnabled", true)
					util:set_visible(library.pointer, false)
				else
					util:set_visible(library.pointer, false)
				end
			end)

			local dock_outline

			function window.set_menu_visibility(bool)
				window.opened = bool
				library.menu_opened = bool

				if library.current_element_open then
					library.current_element_open.set_visible(false)
					library.current_element_open.open = false
					library.current_element_open = nil
				end

				if bool then
					for _, gui in opened do
						gui.Enabled = true
					end
					opened = {}
				else
					for _, gui in library.guis do
						if gui.Enabled and gui ~= pointer_gui then
							gui.Enabled = false
							insert(opened, gui)
						end
					end
				end

				dock_outline.Visible = bool
				sgui.Enabled = true
				notif_holder.Enabled = true
				tooltip_sgui.Enabled = true
				pointer_gui.Enabled = true
				library.cache.Enabled = false

				for _, tooltip in tooltip_sgui:GetChildren() do
					tooltip.Visible = false
				end

				if not bool and library.config_stack and library.config_stack[1] then
					library.config_stack[1].set_visible(false)
				end

				library:tween(blur, { Size = bool and (flags["menu_blur_size"] or 15) or 0 })

				modal.Visible = bool

				if bool then
					if window.mouse_icon == nil then
						window.mouse_icon = uis.MouseIconEnabled
					end

					if library.pointer_design then
						util:set_property(uis, "MouseIconEnabled", false)
						util:set_visible(library.pointer, true)
						local mouse_location = uis:GetMouseLocation()
						util:set_property(library.pointer, "Position", dim2(0, mouse_location.X, 0, mouse_location.Y))
					end
				else
					util:set_visible(library.pointer, false)

					if window.mouse_icon ~= nil then
						util:set_property(uis, "MouseIconEnabled", window.mouse_icon)
						window.mouse_icon = nil
					end
				end
			end

			dock_outline = library:create("Frame", {
				Parent = sgui,
				Visible = true,
				BorderColor3 = rgb(0, 0, 0),
				AnchorPoint = vec2(0.5, 0),
				Position = dim2(0.5, 0, 1, -120),
				Size = dim2(0, 157, 0, 39),
				BorderSizePixel = 0,
				BackgroundColor3 = themes.preset.outline
			})

			library.dock_glow = library:create("ImageLabel", {
				Parent = dock_outline,
				ImageColor3 = themes.preset.glow,
				ScaleType = Enum.ScaleType.Slice,
				BorderColor3 = rgb(0, 0, 0),
				BackgroundColor3 = rgb(255, 255, 255),
				Visible = true,
				Image = library.images.Glow4,
				BackgroundTransparency = 1,
				ImageTransparency = 0.8,
				Position = dim2(0, -20, 0, -20),
				Size = dim2(1, 40, 1, 40),
				ZIndex = 0,
				BorderSizePixel = 0,
				SliceCenter = rect(vec2(21, 21), vec2(79, 79))
			})

			library:apply_theme(library.dock_glow, "glow", "ImageColor3")
			library:apply_theme(dock_outline, "outline", "BackgroundColor3")

			dock_outline.Position = dim2(0, dock_outline.AbsolutePosition.X, 0, dock_outline.AbsolutePosition.Y)
			dock_outline.AnchorPoint = vec2(0, 0)
			library:draggify(dock_outline)

			local dock_inline = library:create("Frame", {
				Parent = dock_outline,
				Position = dim2(0, 1, 0, 1),
				BorderColor3 = rgb(0, 0, 0),
				Size = dim2(1, -2, 1, -2),
				BorderSizePixel = 0,
				BackgroundColor3 = themes.preset.inline
			})

			library:apply_theme(dock_inline, "inline", "BackgroundColor3")

			local dock_holder = library:create("Frame", {
				Parent = dock_inline,
				Size = dim2(1, -2, 1, -2),
				Position = dim2(0, 1, 0, 1),
				BorderColor3 = themes.preset.outline,
				BorderSizePixel = 0,
				BackgroundColor3 = rgb(255, 255, 255)
			})

			local dock_accent = library:create("Frame", {
				Parent = dock_holder,
				Size = dim2(1, 0, 0, 2),
				BorderColor3 = rgb(0, 0, 0),
				BorderSizePixel = 0,
				BackgroundColor3 = themes.preset.accent
			})

			library:apply_theme(dock_accent, "accent", "BackgroundColor3")

			library:create("UIGradient", {
				Parent = dock_accent,
				Rotation = 90,
				Color = rgbseq({
					rgbkey(0, rgb(255, 255, 255)),
					rgbkey(1, rgb(167, 167, 167))
				})
			})

			library.dock_holder = library:create("Frame", {
				Parent = dock_holder,
				BackgroundTransparency = 1,
				Size = dim2(1, 0, 1, 0),
				BorderColor3 = rgb(0, 0, 0),
				BorderSizePixel = 0,
				BackgroundColor3 = rgb(255, 255, 255)
			})

			library:create("UIListLayout", {
				Parent = library.dock_holder,
				Padding = dim(0, 5),
				FillDirection = Enum.FillDirection.Horizontal,
				SortOrder = Enum.SortOrder.LayoutOrder
			})

			library:create("UIPadding", {
				Parent = library.dock_holder,
				PaddingTop = dim(0, 6),
				PaddingBottom = dim(0, 4),
				PaddingRight = dim(0, 4),
				PaddingLeft = dim(0, 4)
			})

			library:apply_theme(library:create("UIGradient", {
				Parent = dock_holder,
				Rotation = 90,
				Color = rgbseq({
					rgbkey(0, rgb(41, 41, 55)),
					rgbkey(1, rgb(35, 35, 47))
				})
			}), "contrast", "Color")

			local keybind_outline = library:create("Frame", {
				Parent = sgui,
				Visible = false,
				Active = true,
				Position = dim2(0, 50, 0, 269),
				BorderColor3 = rgb(0, 0, 0),
				Size = dim2(0, 200, 0, 25),
				BorderSizePixel = 0,
				BackgroundColor3 = themes.preset.outline
			})

			library:apply_theme(keybind_outline, "outline", "BackgroundColor3")
			library:draggify(keybind_outline)
			library:make_resizable(keybind_outline)
			library.keybind_list_frame = keybind_outline

			library.keybind_glow = library:create("ImageLabel", {
				Parent = keybind_outline,
				ImageColor3 = themes.preset.glow,
				ScaleType = Enum.ScaleType.Slice,
				BorderColor3 = rgb(0, 0, 0),
				BackgroundColor3 = rgb(255, 255, 255),
				Visible = true,
				Image = library.images.Glow4,
				BackgroundTransparency = 1,
				ImageTransparency = 0.8,
				Position = dim2(0, -20, 0, -20),
				Size = dim2(1, 40, 1, 40),
				ZIndex = 0,
				BorderSizePixel = 0,
				SliceCenter = rect(vec2(21, 21), vec2(79, 79))
			})

			library:apply_theme(library.keybind_glow, "glow", "ImageColor3")

			local keybind_inline = library:create("Frame", {
				Parent = keybind_outline,
				Position = dim2(0, 1, 0, 1),
				BorderColor3 = rgb(0, 0, 0),
				Size = dim2(1, -2, 1, -2),
				BorderSizePixel = 0,
				BackgroundColor3 = themes.preset.inline
			})

			library:apply_theme(keybind_inline, "inline", "BackgroundColor3")

			local keybind_background = library:create("Frame", {
				Parent = keybind_inline,
				Position = dim2(0, 1, 0, 1),
				BorderColor3 = rgb(0, 0, 0),
				Size = dim2(1, -2, 1, -2),
				BorderSizePixel = 0,
				BackgroundColor3 = rgb(255, 255, 255)
			})

			library:apply_theme(library:create("UIGradient", {
				Parent = keybind_background,
				Rotation = 90,
				Color = rgbseq({
					rgbkey(0, themes.preset.high_contrast),
					rgbkey(1, themes.preset.low_contrast)
				})
			}), "contrast", "Color")

			local keybind_accent = library:create("Frame", {
				Parent = keybind_background,
				BorderColor3 = rgb(0, 0, 0),
				Size = dim2(1, 0, 0, 2),
				BorderSizePixel = 0,
				BackgroundColor3 = themes.preset.accent
			})

			library:apply_theme(keybind_accent, "accent", "BackgroundColor3")

			library:create("UIGradient", {
				Parent = keybind_accent,
				Enabled = true,
				Rotation = 90,
				Color = rgbseq({
					rgbkey(0, rgb(255, 255, 255)),
					rgbkey(1, rgb(167, 167, 167))
				})
			})

			local keybind_title = library:create("TextLabel", {
				Parent = keybind_background,
				FontFace = library.font,
				TextColor3 = themes.preset.text,
				BorderColor3 = rgb(0, 0, 0),
				Text = "Keybinds",
				BackgroundTransparency = 1,
				TextTruncate = Enum.TextTruncate.AtEnd,
				Size = dim2(1, 0, 1, 0),
				BorderSizePixel = 0,
				TextSize = 12,
				BackgroundColor3 = themes.preset.text
			}, "text")

			library:create("UIStroke", {
				Parent = keybind_title,
				LineJoinMode = Enum.LineJoinMode.Miter
			})

			local keybind_text_holder = library:create("Frame", {
				Parent = keybind_background,
				Position = dim2(0, -2, 1, 1),
				Size = dim2(1, 4, 0, 0),
				BorderColor3 = rgb(0, 0, 0),
				BorderSizePixel = 0,
				AutomaticSize = Enum.AutomaticSize.Y,
				BackgroundColor3 = themes.preset.outline
			})

			library:apply_theme(keybind_text_holder, "outline", "BackgroundColor3")

			local keybind_text_inline = library:create("Frame", {
				Parent = keybind_text_holder,
				Size = dim2(1, -2, 1, -2),
				Position = dim2(0, 1, 0, 1),
				BorderColor3 = rgb(0, 0, 0),
				BorderSizePixel = 0,
				BackgroundColor3 = themes.preset.inline
			})

			library:apply_theme(keybind_text_inline, "inline", "BackgroundColor3")

			library.keybind_list = library:create("Frame", {
				Parent = keybind_text_inline,
				Size = dim2(1, -2, 1, -2),
				Position = dim2(0, 1, 0, 1),
				BorderColor3 = rgb(0, 0, 0),
				BorderSizePixel = 0,
				BackgroundColor3 = rgb(255, 255, 255)
			})

			library:apply_theme(library:create("UIGradient", {
				Parent = library.keybind_list,
				Rotation = 90,
				Color = rgbseq({
					rgbkey(0, themes.preset.high_contrast),
					rgbkey(1, themes.preset.low_contrast)
				})
			}), "contrast", "Color")

			library:create("UIListLayout", {
				Parent = library.keybind_list,
				Padding = dim(0, -1),
				SortOrder = Enum.SortOrder.LayoutOrder
			})

			library:create("UIPadding", {
				Parent = library.keybind_list,
				PaddingBottom = dim(0, 4),
				PaddingLeft = dim(0, 5)
			})

			library.windows.main_window = library:panel({
				name = properties.name or properties.Name,
				size = properties.size or dim2(0, 604, 0, 631),
				position = dim2(0, (camera.ViewportSize.X / 2) - 302 - 96, 0, (camera.ViewportSize.Y / 2) - 421 - 12),
				image = library.images.Main
			})

			local main_window = library.windows.main_window

			local items = main_window.items

			window["tab_holder"] = library:create("Frame", {
				Parent = items.holder,
				BackgroundTransparency = 1,
				Size = dim2(1, 0, 0, 22),
				BorderColor3 = rgb(0, 0, 0),
				ZIndex = 5,
				BorderSizePixel = 0,
				BackgroundColor3 = rgb(255, 255, 255)
			})

			library:create("UIListLayout", {
				Parent = window["tab_holder"],
				FillDirection = Enum.FillDirection.Horizontal,
				HorizontalFlex = Enum.UIFlexAlignment.Fill,
				Padding = dim(0, 2),
				SortOrder = Enum.SortOrder.LayoutOrder
			})

			local section_holder = library:create("Frame", {
				Parent = items.holder,
				BackgroundTransparency = 1,
				Position = dim2(0, -1, 0, 19),
				BorderColor3 = rgb(0, 0, 0),
				Size = dim2(1, 0, 1, -22),
				BorderSizePixel = 0,
				BackgroundColor3 = rgb(255, 255, 255)
			})
			window["section_holder"] = section_holder

			local outline = library:create("Frame", {
				Parent = section_holder,
				Position = dim2(0, 1, 0, 1),
				BorderColor3 = rgb(0, 0, 0),
				Size = dim2(1, 0, 1, 2),
				BorderSizePixel = 0,
				BackgroundColor3 = themes.preset.outline
			})

			library:apply_theme(outline, "outline", "BackgroundColor3")

			local inline = library:create("Frame", {
				Parent = outline,
				Position = dim2(0, 1, 0, 1),
				BorderColor3 = rgb(0, 0, 0),
				Size = dim2(1, -2, 1, -2),
				BorderSizePixel = 0,
				BackgroundColor3 = themes.preset.inline
			})

			library:apply_theme(inline, "inline", "BackgroundColor3")

			local background = library:create("Frame", {
				Parent = inline,
				Position = dim2(0, 1, 0, 1),
				BorderColor3 = rgb(0, 0, 0),
				Size = dim2(1, -2, 1, -2),
				BorderSizePixel = 0,
				BackgroundColor3 = rgb(255, 255, 255)
			})

			library.section_holder = background

			library:create("UIPadding", {
				Parent = background,
				PaddingTop = dim(0, 4),
				PaddingBottom = dim(0, 4),
				PaddingRight = dim(0, 4),
				PaddingLeft = dim(0, 4)
			})

			local UIGradient = library:create("UIGradient", {
				Parent = background,
				Rotation = 90,
				Color = rgbseq{
					rgbkey(0, rgb(41, 41, 55)),
					rgbkey(1, rgb(35, 35, 47))
				}
			})

			library:apply_theme(UIGradient, "contrast", "Color")

			library.windows.style = library:panel({
				name = "Style",
				anchor_point = vec2(0, 0),
				size = dim2(0, 394, 0, 631),
				position = dim2(0, main_window.items.main_holder.AbsolutePosition.X + main_window.items.main_holder.AbsoluteSize.X + 2, 0, main_window.items.main_holder.AbsolutePosition.Y),
				image = library.images.Style
			})

			local style = library.windows.style

			local watermark = library:watermark({ default = "ShitHax.cc - uid: 0 - 01/01/0001 - 00:00:00" })
			library.watermark_object = watermark

			library:connection(run.RenderStepped, function()
				if not library.watermark_outline.Visible then
					return
				end
				library.user_stats.fps = library.user_stats.fps + 1
				library.user_stats.ping = stats.Network.ServerStatsItem["Data Ping"]:GetValue()
			end)

			task.spawn(function()
				while task.wait(1) do
					if library.watermark_outline.Visible then
						local wm = library.watermark_options
						local parts = {}
						insert(parts, wm.watermark_text)
						if library.user_info[1] == "dev" and wm.private then
							insert(parts, "developer")
						elseif library.user_info[1] == "private" and wm.private then
							insert(parts, "private")
						end
						if wm.version and library.script_version then
							insert(parts, "v" .. library.script_version)
						end
						if wm.fps and library.user_stats.fps then
							insert(parts, tostring(library.user_stats.fps) .. " fps")
							library.user_stats.fps = 0
						end
						if wm.ping and library.user_stats.ping then
							insert(parts, tostring(math.round(library.user_stats.ping)) .. "ms")
						end
						if wm.uid and library.user_info[2] then
							insert(parts, "uid" .. tostring(library.user_info[2]))
						end
						if wm.current_game then
							insert(parts, "project delta")
						end
						if wm.current_date then
							insert(parts, os.date("%b %d %Y"))
						end
						if wm.current_time then
							insert(parts, os.date("%H:%M:%S"))
						end
						watermark.change_text(table.concat(parts, " - "))
					end
				end
			end)

			local items = style.items

			local column = setmetatable(items, library):column()
			local section = column:section({name = "Theme"})
			section:label({name = "Menu Accent"})
			:colorpicker({name = "Menu Accent", color = themes.preset.accent, flag = "accent", callback = function(color, alpha)
				library:update_theme("accent", color)
			end})
			section:label({name = "Contrast"})
			:colorpicker({name = "Low", color = themes.preset.low_contrast, flag = "low_contrast", callback = function(color)
				if (flags["high_contrast"] and flags["low_contrast"]) then
					library:update_theme("contrast", rgbseq{
						rgbkey(0, flags["low_contrast"].Color),
						rgbkey(1, flags["high_contrast"].Color)
					})
				end

				library:update_theme("low_contrast", flags["low_contrast"].Color)
			end})
			:colorpicker({name = "High", color = themes.preset.high_contrast, flag = "high_contrast", callback = function(color)
				if (flags["high_contrast"] and flags["low_contrast"]) then
					library:update_theme("contrast", rgbseq{
						rgbkey(0, flags["low_contrast"].Color),
						rgbkey(1, flags["high_contrast"].Color)
					})
				end

				library:update_theme("high_contrast", flags["high_contrast"].Color)
			end})
			section:label({name = "Inline"})
			:colorpicker({name = "Inline", color = themes.preset.inline, flag = "inline", callback = function(color, alpha)
				library:update_theme("inline", color)
			end})
			section:label({name = "Outline"})
			:colorpicker({name = "Outline", color = themes.preset.outline, flag = "outline", callback = function(color, alpha)
				library:update_theme("outline", color)
			end})
			section:label({name = "Text Color"})
			:colorpicker({name = "Text Color", color = themes.preset.text, flag = "text_color", callback = function(color, alpha)
				library:update_theme("text", color)
			end})
			:colorpicker({name = "Text Outline Color", color = themes.preset.text_outline, flag = "text_outline", callback = function(color, alpha)
				library:update_theme("text_outline", color)
			end})
			section:label({name = "Glow"})
			:colorpicker({name = "Glow", color = themes.preset.glow, alpha = 0.2, flag = "glow", callback = function(color, alpha)
				library:update_theme("glow", color)
			end})
			section:dropdown({name = "Tweening Style", scrolling = true, flag = "tweening_style", items = library.easing_style_index, default = "Circular", callback = function(value)
				library.tweening_style = Enum.EasingStyle[value] or library.tweening_style
			end})
			section:dropdown({name = "Tweening Direction", flag = "tweening_direction", items = library.easing_direction_index, default = "InOut", callback = function(value)
				library.tweening_direction = Enum.EasingDirection[value] or library.tweening_direction
			end})
			section:slider({name = "Tweening Time", suffix = "s", flag = "tweening_time", min = 0.05, max = 1, default = 0.15, interval = 0.01, callback = function(value)
				library.tweening_speed = value
			end})
			section:toggle({name = "Pointer Design", default = true, flag = "pointer_design", callback = function(bool)
				library.pointer_design = bool

				if library.menu_opened then
					util:set_visible(library.pointer, bool)
				end
			end})

			local accessibility, other = column:multi_section({names = {"Accessibility", "Other"}})
			accessibility:label({name = "UI Bind"})
			:keybind({callback = window.set_menu_visibility, size = 28, key = Enum.KeyCode.End})
			accessibility:toggle({name = "Keybind List", flag = "keybind_list", callback = function(bool)
				library.keybind_list_frame.Visible = bool
			end})
			local watermark_elements = library.user_info[1] == "dev" and {"User", "Version", "FPS", "Ping", "UID", "Game", "Date", "Time"} or {"Version", "FPS", "Ping", "UID", "Game", "Date", "Time"}

			accessibility:toggle({name = "Watermark", enabled = true, default = true, flag = "watermark", callback = function(bool)
				watermark.set_visible(bool)
			end}):configuration({name = "Watermark Options"}, function(section)
				local elements = watermark_elements
				section:dropdown({name = "Watermark Elements", multi = true, flag = "watermark_elements", items = elements, default = elements, callback = function(selected)
					local keys = {
						User = "private",
						Version = "version",
						FPS = "fps",
						Ping = "ping",
						UID = "uid",
						Game = "current_game",
						Date = "current_date",
						Time = "current_time",
					}
					for _, key in keys do
						library.watermark_options[key] = false
					end
					for _, name in selected do
						local key = keys[name]
						if key then
							library.watermark_options[key] = true
						end
					end
				end})
				section:label({name = "Custom Watermark Text"})
				section:textbox({name = "Custom Watermark", flag = "custom_watermark", max = 20, placeholder = "ShitHax.cc", callback = function(text)
					local function reject(notice, output)
						library:notification({text = notice, flashing = true, time = 5})
						library.output.create_output({text = output, prefix = "WARN", color = library.colors.warning})
						library.watermark_options.watermark_text = "ShitHax.cc"
					end
					if text == "" then
						library.watermark_options.watermark_text = "ShitHax.cc"
					elseif text:match("^%s+$") then
						reject("The watermark cannot be empty. Please enter a valid string.", "The watermark cannot be empty. Please enter a valid string.")
					elseif text:lower():find("uid") then
						reject("The keyword 'uid' is not allowed in the watermark.", "The term 'uid' is not allowed in the watermark.")
					else
						library.watermark_options.watermark_text = text
					end
				end})
			end)
			accessibility:splitter()
			accessibility:toggle({name = "UI Management", default = true, tooltip = "Allows you to drag and resize UI elements", flag = "ui_mangement", callback = function(bool)
				library.drag_enabled = bool
			end})
			accessibility:toggle({name = "Aero Snap", default = true, flag = "aero_snap", callback = function(bool)
				library.aerosnap = bool
			end})
			accessibility:splitter()
			accessibility:dropdown({name = "Click Sound Style", flag = "click_style", items = {"Default", "Pride", "Halloween", "Wood", "Experience"}, default = "Default", callback = function(value)
				library.sound_settings.sound_type = value
			end})
			accessibility:slider({name = "Click Sound Volume", flag = "click_volume", min = 0, max = 10, default = 1, interval = 0.1, callback = function(value)
				library.sound_settings.sound_volume = value
			end})
			accessibility:slider({name = "Animation Frequency", tooltip = "Lowering this value will result in a boost of performance", suffix = "hz", flag = "animation_frequency", min = 15, max = 240, default = 240, interval = 1, callback = function(value)
				library.animation_frequency = value
			end})
			accessibility:slider({name = "Animation Speed", tooltip = "Changes the speed of Rainbow & Breathing animations", flag = "animation_speed", min = 0.5, max = 3, default = 1, interval = 0.1, callback = function(value)
				library.animation_speed = value
			end})
			accessibility:slider({name = "Blur Size", flag = "menu_blur_size", min = 0, max = 56, default = 20, interval = 1, callback = function(int)
				if window.opened then
					blur.Size = int
				end
			end})
			accessibility:slider({name = "FPS Cap", suffix = "hz", flag = "fps_cap", min = 30, max = 1000, default = 240, interval = 1, callback = function(value)
				if setfpscap then
					setfpscap(value)
				end
			end})

			other:button_holder({})
			other:button({name = "Copy JobId", callback = function()
				setclipboard(game.JobId)
			end})
			other:button({name = "Copy PlaceId", callback = function()
				setclipboard(tostring(game.PlaceId))
			end})
			other:button_holder({})
			other:button({name = "Copy Join Script", callback = function()
				setclipboard('cloneref(game:GetService("TeleportService")):TeleportToPlaceInstance(' .. game.PlaceId .. ', "' .. game.JobId .. '", game.Players.LocalPlayer)')
			end})
			other:button_holder({})
			other:button({name = "Test Notification", callback = function()
				library.output.create_output({text = "Triggered normal notification", prefix = "INFO", color = library.colors.information})
				library:notification({text = "The quick brown fox jumps over the lazy dog", time = 5})
			end})
			other:button({name = "Test Flashing Notification", callback = function()
				library.output.create_output({text = "Triggered flashing notification", prefix = "INFO", color = library.colors.information})
				library:notification({text = "The quick brown fox jumps over the lazy dog", flashing = true, time = 5})
			end})
			other:button_holder({})
			other:button({name = "Rejoin Server", confirm = true, callback = function()
				game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, game.JobId, lp)
			end})

			library.windows.output = library:panel({
				name = "Output",
				anchor_point = vec2(0, 0),
				size = dim2(0, 529, 0, 267),
				position = dim2(0, main_window.items.main_holder.AbsolutePosition.X - 531, 0, main_window.items.main_holder.AbsolutePosition.Y + 447),
				image = library.images.Output
			})

			local column = setmetatable(library.windows.output.items, library):column()
			local section = column:section({name = "Output"})
			library.output = section:output({})
			section:button_holder({})
			section:button({name = "Clear Output", confirm = true, callback = function()
				library.output.clear_output()
			end})

			library.windows.configurations_holder = library:panel({
				name = "Configurations",
				size = dim2(0, 324, 0, 438),
				position = dim2(0, style.items.main_holder.AbsolutePosition.X + style.items.main_holder.AbsoluteSize.X + 2, 0, style.items.main_holder.AbsolutePosition.Y),
				image = library.images.Configurations
			})

			local items = library.windows.configurations_holder.items

			getgenv().load_config = function(name)
				return library:load_config_file(name)
			end

			local column = setmetatable(items, library):column()
			local section = column:section({name = "Options"})
				config_holder = section:list({flag = "config_name_list"})
				library:config_list_update()
				section:textbox({flag = "config_name_text_box", max = 30, placeholder = "Type here..."})
				section:button_holder({})
			section:button({name = "Create", confirm = true, callback = function()
				local name = flags["config_name_text_box"]
				if type(name) ~= "string" or name:match("^%s*$") then
					library.output.create_output({text = "Create failed: type a configuration name first", prefix = "INFO", color = library.colors.warning})
					library:notification({text = "Type a configuration name first", time = 3})
					return
				end
				name = name:match("^%s*(.-)%s*$")
				local path = library.directory .. "/configs/" .. name .. ".cfg"
					library.output.create_output({text = "Creating configuration: " .. name, prefix = "INFO", color = library.colors.information})
					local ok, err = pcall(function()
						writefile(path, library:get_config())
					end)
					library:log_result(ok, "Created", "create", name, err)
					library:config_list_update()
				end})
			section:button({name = "Delete", confirm = true, callback = function()
				local name = flags["config_name_list"]
				if type(name) ~= "string" or name == "" then
					library.output.create_output({text = "Delete failed: select a configuration first", prefix = "INFO", color = library.colors.warning})
					library:notification({text = "Select a configuration first", time = 3})
					return
				end
				local path = library.directory .. "/configs/" .. name .. ".cfg"
					library.output.create_output({text = "Deleting configuration: " .. name, prefix = "INFO", color = library.colors.information})
					local ok, err = pcall(function()
						delfile(path)
					end)
					library:log_result(ok, "Deleted", "delete", name, err)
					library:config_list_update()
				end})
				section:button_holder({})
			section:button({name = "Load", confirm = true, callback = function()
				local name = flags["config_name_list"]
				if type(name) ~= "string" or name == "" then
					library.output.create_output({text = "Load failed: select a configuration first", prefix = "INFO", color = library.colors.warning})
					library:notification({text = "Select a configuration first", time = 3})
					return
				end
				library.output.create_output({text = "Loading configuration: " .. tostring(name or "<none>"), prefix = "INFO", color = library.colors.information})
					local ok, err = pcall(function()
						library:notification({text = "Loading Configuration: " .. tostring(name or "<none>"), flashing = true, time = 1.5})
						local loaded, load_err = library:load_config_file(name)
						if not loaded then
							error(load_err)
						end
					end)
					library:log_result(ok, "Loaded", "load", name, err)
				end})
			section:button({name = "Save", confirm = true, callback = function()
				local name = flags["config_name_list"]
				if type(name) ~= "string" or name == "" then
					library.output.create_output({text = "Save failed: select a configuration first", prefix = "INFO", color = library.colors.warning})
					library:notification({text = "Select a configuration first", time = 3})
					return
				end
				local path = library.directory .. "/configs/" .. name .. ".cfg"
					library.output.create_output({text = "Saving configuration: " .. name, prefix = "INFO", color = library.colors.information})
					local ok, err = pcall(function()
						writefile(path, library:get_config())
					end)
					library:log_result(ok, "Saved", "save", name, err)
					library:config_list_update()
				end})
				section:button_holder({})
				section:button({name = "Refresh Configurations", callback = function()
					library.output.create_output({text = "Refreshing configuration list", prefix = "INFO", color = library.colors.information})
					library:config_list_update()
					library:notification({text = "Refreshed Configurations", time = 3})
					library.output.create_output({text = "Configuration list refreshed", prefix = "SUCCESS", color = library.colors.success})
				end})
				section:button_holder({})
				section:button({name = "Unload Configuration", confirm = true, confirm_timer = 5, callback = function()
					library.output.create_output({text = "Unloading configuration: current", prefix = "INFO", color = library.colors.information})
					local ok, err = pcall(function()
						library:load_config(library.old_config)
					end)
					library:log_result(ok, "Unloaded", "unload", "current", err)
				end})
				section:button_holder({})
				section:button({name = "Unload Menu", confirm = true, confirm_timer = 5, callback = function()
					if library.unloading then
						return
					end

					library.unloading = true
					library:load_config(library.old_config)

					for _, gui in library.guis do
						gui:Destroy()
					end

					for _, connection in library.connections do
						connection:Disconnect()
					end

					run:UnbindFromRenderStep("update_esp")
					blur:Destroy()
				end})

			library.windows.playerlist_holder = library:panel({
				name = "Playerlist",
				anchor_point = vec2(0, 0),
				size = dim2(0, 529, 0, 445),
				position = dim2(0, main_window.items.main_holder.AbsolutePosition.X - 531, 0, main_window.items.main_holder.AbsolutePosition.Y),
				image = library.images.Playerlist
			})

			local items = library.windows.playerlist_holder.items

			local column = setmetatable(items, library):column()
			local section = column:section({name = "Playerlist"})
			local playerlist = section:playerlist({})
			library.priority_dropdown = section:dropdown({name = "Priority", items = {"Enemy", "Neutral", "Friendly"}, default = "Neutral", flag = "PLAYERLIST_DROPDOWN", callback = function(text)
				library.prioritize(text)
			end})

			return setmetatable(window, library)
		end

		function library:watermark(options)
			local cfg = {
				default = options.text or options.default or "n/a"
			}

			local watermark_outline = library:create("Frame", {
				BorderSizePixel = 0,
				Position = dim2(0, 31, 0, 0),
				Size = dim2(0, 50, 0, 29),
				BackgroundColor3 = themes.preset.outline,
				AutomaticSize = Enum.AutomaticSize.X,
				Parent = sgui
			})
			library.watermark_outline = watermark_outline
			library:apply_theme(watermark_outline, "outline", "BackgroundColor3")
			library:draggify(watermark_outline)

			local inline = library:create("Frame", {
				Position = dim2(0, 1, 0, 1),
				Size = dim2(1, -2, 1, -2),
				BorderSizePixel = 0,
				BackgroundColor3 = themes.preset.inline,
				Parent = watermark_outline
			})
			library:apply_theme(inline, "inline", "BackgroundColor3")

			local background_outer = library:create("Frame", {
				Position = dim2(0, 1, 0, 1),
				Size = dim2(1, -2, 1, -2),
				BorderSizePixel = 0,
				BackgroundColor3 = rgb(200, 200, 200),
				Parent = inline
			})

			local gradient_outer = library:create("UIGradient", {
				Rotation = 90,
				Color = rgbseq{rgbkey(0, rgb(41, 41, 55)), rgbkey(1, rgb(35, 35, 47))},
				Parent = background_outer
			})
			library:apply_theme(gradient_outer, "contrast", "Color")

			local inner_inline = library:create("Frame", {
				Position = dim2(0, 3, 0, 3),
				Size = dim2(1, -6, 1, -6),
				BorderSizePixel = 0,
				BackgroundColor3 = themes.preset.inline,
				Parent = background_outer
			})
			library:apply_theme(inner_inline, "inline", "BackgroundColor3")

			local background_inner = library:create("Frame", {
				Position = dim2(0, 1, 0, 1),
				Size = dim2(1, -2, 1, -2),
				BorderSizePixel = 0,
				BackgroundColor3 = rgb(255, 255, 255),
				Parent = inner_inline
			})

			local gradient_inner = library:create("UIGradient", {
				Rotation = 90,
				Color = rgbseq{rgbkey(0, rgb(41, 41, 55)), rgbkey(1, rgb(35, 35, 47))},
				Parent = background_inner
			})
			library:apply_theme(gradient_inner, "contrast", "Color")

			local accent_line = library:create("Frame", {
				Size = dim2(1, 0, 0, 2),
				BorderSizePixel = 0,
				BackgroundColor3 = themes.preset.accent,
				Parent = background_inner
			})
			library:apply_theme(accent_line, "accent", "BackgroundColor3")

			library:create("UIGradient", {
				Rotation = 90,
				Color = rgbseq{rgbkey(0, rgb(255, 255, 255)), rgbkey(1, rgb(167, 167, 167))},
				Parent = accent_line
			})

			library:create("UIPadding", {
				PaddingLeft = dim(0, 4),
				PaddingRight = dim(0, 9),
				Parent = accent_line
			})

			local text = library:create("TextLabel", {
				BackgroundTransparency = 1,
				FontFace = library.font,
				BorderSizePixel = 0,
				Text = "n/a",
				TextColor3 = themes.preset.text,
				TextSize = 12,
				Position = dim2(0, 0, 0, 9),
				AutomaticSize = Enum.AutomaticSize.X,
				Parent = accent_line
			})

			library:create("UIStroke", {
				LineJoinMode = Enum.LineJoinMode.Miter,
				Parent = text
			})

			function cfg.change_text(input)
				text.Text = input
			end

			function cfg.set_visible(bool)
				watermark_outline.Visible = bool
			end

			cfg.change_text(cfg.default)

			return cfg
		end

		function library:esp_preview(properties)
			local cfg = {items = {}, rotation = 0; objects = {};}

			lp.Character.Archivable = true
			local character = lp.Character:Clone()
			if character:FindFirstChild("Animate") then
				character.Animate:Destroy()
			end

			local items = cfg.items; do
				items.viewportframe = library:create( "ViewportFrame" , {
					Parent = self.holder;
					BackgroundTransparency = 1;
					Size = dim2(1, 0, 0, 220);
					BorderColor3 = rgb(0, 0, 0);
					ZIndex = 1;
					Position = dim2(0, 0, 0, 10);
					BorderSizePixel = 0;
					BackgroundColor3 = rgb(255, 255, 255)
				});

				items.camera = library:create( "Camera" , {
					FieldOfView = 70.00022888183594;
					CameraType = Enum.CameraType.Track;
					Focus = cfr(0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1);
					CFrame = cfr(0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1);
					Parent = ws;
					Name = "\0"
				});

				items.viewportframe.CurrentCamera = items.camera
				character.Parent = items.viewportframe

				items.camera.CameraSubject = character

				library:connection(run.RenderStepped, function()
					task.wait()
					cfg.rotation += 0.5
					character:SetPrimaryPartCFrame(cfr(Vector3.new(0, 1, -6)) * angle(0, math.rad(cfg.rotation), 0))
				end)
			end

			local objects = cfg.objects; do
				objects[ "holder" ] = library:create( "Frame" , {
					Parent = items.viewportframe;
					Name = "\0";
					BackgroundTransparency = 1;
					Position = dim2(0.5, 0, 0.5, 10);
					BorderColor3 = rgb(0, 0, 0);
					Size = dim2(0, 135, 0, 190);
					BorderSizePixel = 0;
					AnchorPoint = vec2(0.5, 0.5);
					BackgroundColor3 = rgb(255, 255, 255)
				});

				objects[ "box_outline" ] = library:create( "UIStroke" , {
					Parent = library.cache;
					LineJoinMode = Enum.LineJoinMode.Miter
				});

				objects[ "name" ] = library:create( "TextLabel" , {
					FontFace = library.font;
					Parent = library.cache;
					TextColor3 = flags["Name_Color"].Color;
					BorderColor3 = rgb(0, 0, 0);
					Text = string.format("%s (@%s)", lp.DisplayName, lp.Name);
					Name = "\0";
					TextStrokeTransparency = 0;
					AnchorPoint = vec2(0, 1);
					Size = dim2(1, 0, 0, 0);
					BackgroundTransparency = 1;
					Position = dim2(0, 0, 0, -5);
					BorderSizePixel = 0;
					AutomaticSize = Enum.AutomaticSize.Y;
					TextSize = 12;
				});

				objects[ "box_handler" ] = library:create( "Frame" , {
					Parent = library.cache;
					Name = "\0";
					BackgroundTransparency = 1;
					Position = dim2(0, 1, 0, 1);
					BorderColor3 = rgb(0, 0, 0);
					Size = dim2(1, -2, 1, -2);
					BorderSizePixel = 0;
					BackgroundColor3 = rgb(255, 255, 255)
				});

				objects[ "box_color" ] = library:create( "UIStroke" , {
					Color = rgb(255, 255, 255);
					LineJoinMode = Enum.LineJoinMode.Miter;
					Name = "\0";
					Parent = objects[ "box_handler" ]
				});

				objects[ "outline" ] = library:create( "Frame" , {
					Parent = objects[ "box_handler" ];
					Name = "\0";
					BackgroundTransparency = 1;
					Position = dim2(0, 1, 0, 1);
					BorderColor3 = rgb(0, 0, 0);
					Size = dim2(1, -2, 1, -2);
					BorderSizePixel = 0;
					BackgroundColor3 = rgb(255, 255, 255)
				});

				library:create( "UIStroke" , {
					Parent = objects[ "outline" ];
					LineJoinMode = Enum.LineJoinMode.Miter
				});

					objects[ "corners" ] = library:create( "Frame" , {
						Visible = true;
						BorderColor3 = rgb(0, 0, 0);
						Parent = library.cache;
						BackgroundTransparency = 1;
						Position = dim2(0, -1, 0, 2);
						Name = "\0";
						Size = dim2(1, 0, 1, 0);
						BorderSizePixel = 0;
						BackgroundColor3 = rgb(255, 255, 255)
					});

					objects[ "1" ] = library:create( "Frame" , {
						Parent = objects[ "corners" ];
						Name = "line";
						Position = dim2(0, 0, 0, -2);
						BorderColor3 = rgb(0, 0, 0);
						Size = dim2(0.4, 0, 0, 3);
						BorderSizePixel = 0;
						BackgroundColor3 = rgb(0, 0, 0)
					});

					library:create( "Frame" , {
						Parent = objects[ "1" ];
						Position = dim2(0, 1, 0, 1);
						BorderColor3 = rgb(0, 0, 0);
						Size = dim2(1, -2, 1, -2);
						BorderSizePixel = 0;
						BackgroundColor3 = flags["Box_Color"].Color
					});

					objects[ "2" ] = library:create( "Frame" , {
						Parent = objects[ "corners" ];
						Name = "line";
						Position = dim2(0, 0, 0, 1);
						BorderColor3 = rgb(0, 0, 0);
						Size = dim2(0, 3, 0.25, 0);
						BorderSizePixel = 0;
						BackgroundColor3 = rgb(0, 0, 0)
					});

					library:create( "Frame" , {
						Parent = objects[ "2" ];
						Position = dim2(0, 1, 0, -2);
						BorderColor3 = rgb(0, 0, 0);
						Size = dim2(1, -2, 1, 1);
						BorderSizePixel = 0;
						BackgroundColor3 = flags["Box_Color"].Color
					});

					objects[ "3" ] = library:create( "Frame" , {
						AnchorPoint = vec2(1, 0);
						Parent = objects[ "corners" ];
						Name = "line";
						Position = dim2(1, 0, 0, -2);
						BorderColor3 = rgb(0, 0, 0);
						Size = dim2(0.4, 0, 0, 3);
						BorderSizePixel = 0;
						BackgroundColor3 = rgb(0, 0, 0)
					});

					library:create( "Frame" , {
						Parent = objects[ "3" ];
						Position = dim2(0, 1, 0, 1);
						BorderColor3 = rgb(0, 0, 0);
						Size = dim2(1, -2, 1, -2);
						BorderSizePixel = 0;
						BackgroundColor3 = flags["Box_Color"].Color
					});

					objects[ "4" ] = library:create( "Frame" , {
						AnchorPoint = vec2(1, 0);
						Parent = objects[ "corners" ];
						Name = "line";
						Position = dim2(1, 0, 0, 1);
						BorderColor3 = rgb(0, 0, 0);
						Size = dim2(0, 3, 0.25, 0);
						BorderSizePixel = 0;
						BackgroundColor3 = rgb(0, 0, 0)
					});

					library:create( "Frame" , {
						Parent = objects[ "4" ];
						Position = dim2(0, 1, 0, -2);
						BorderColor3 = rgb(0, 0, 0);
						Size = dim2(1, -2, 1, 1);
						BorderSizePixel = 0;
						BackgroundColor3 = flags["Box_Color"].Color
					});

					objects[ "5" ] = library:create( "Frame" , {
						AnchorPoint = vec2(0, 1);
						Parent = objects[ "corners" ];
						Name = "line";
						Position = dim2(0, -1, 1, -2);
						BorderColor3 = rgb(0, 0, 0);
						Size = dim2(0.4, 0, 0, 3);
						BorderSizePixel = 0;
						BackgroundColor3 = rgb(0, 0, 0)
					});

					library:create( "Frame" , {
						Parent = objects[ "5" ];
						Position = dim2(0, 1, 0, 1);
						BorderColor3 = rgb(0, 0, 0);
						Size = dim2(1, -2, 1, -2);
						BorderSizePixel = 0;
						BackgroundColor3 = flags["Box_Color"].Color
					});

					objects[ "6" ] = library:create( "Frame" , {
						BorderColor3 = rgb(0, 0, 0);
						Rotation = 180;
						Parent = objects[ "corners" ];
						Name = "line";
						Position = dim2(0, 0, 1, -4);
						AnchorPoint = vec2(0, 1);
						Size = dim2(0, 3, 0.25, 1);
						BorderSizePixel = 0;
						BackgroundColor3 = rgb(0, 0, 0)
					});

					library:create( "Frame" , {
						Parent = objects[ "6" ];
						Position = dim2(0, 1, 0, -2);
						BorderColor3 = rgb(0, 0, 0);
						Size = dim2(1, -2, 1, 1);
						BorderSizePixel = 0;
						BackgroundColor3 = flags["Box_Color"].Color
					});

					objects[ "7" ] = library:create( "Frame" , {
						AnchorPoint = vec2(1, 1);
						Parent = objects[ "corners" ];
						Name = "line";
						Position = dim2(1, -1, 1, -2);
						BorderColor3 = rgb(0, 0, 0);
						Size = dim2(0.4, 0, 0, 3);
						BorderSizePixel = 0;
						BackgroundColor3 = rgb(0, 0, 0)
					});

					library:create( "Frame" , {
						Parent = objects[ "7" ];
						Position = dim2(0, 1, 0, 1);
						BorderColor3 = rgb(0, 0, 0);
						Size = dim2(1, -2, 1, -2);
						BorderSizePixel = 0;
						BackgroundColor3 = flags["Box_Color"].Color
					});

					objects[ "7" ] = library:create( "Frame" , {
						BorderColor3 = rgb(0, 0, 0);
						Rotation = 180;
						Parent = objects[ "corners" ];
						Name = "line";
						Position = dim2(1, 0, 1, -4);
						AnchorPoint = vec2(1, 1);
						Size = dim2(0, 3, 0.25, 1);
						BorderSizePixel = 0;
						BackgroundColor3 = rgb(0, 0, 0)
					});

					library:create( "Frame" , {
						Parent = objects[ "7" ];
						Position = dim2(0, 1, 0, -2);
						BorderColor3 = rgb(0, 0, 0);
						Size = dim2(1, -2, 1, 1);
						BorderSizePixel = 0;
						BackgroundColor3 = flags["Box_Color"].Color
					});

					objects[ "healthbar_holder" ] = library:create( "Frame" , {
						AnchorPoint = vec2(1, 0);
						Parent = library.cache;
						Name = "\0";
						Position = dim2(0, -5, 0, 0);
						BorderColor3 = rgb(0, 0, 0);
						Size = dim2(0, 4, 1, 0);
						BorderSizePixel = 0;
						BackgroundColor3 = rgb(0, 0, 0)
					});

					objects[ "healthbar" ] = library:create( "Frame" , {
						Parent = objects[ "healthbar_holder" ];
						Name = "\0";
						Position = dim2(0, 1, 0, 1);
						BorderColor3 = rgb(0, 0, 0);
						Size = dim2(1, -2, 1, -2);
						BorderSizePixel = 0;
						BackgroundColor3 = rgb(255, 255, 255)
					});

					objects[ "distance" ] = library:create( "TextLabel" , {
						FontFace = library.font;
						TextColor3 = flags["Distance_Color"].Color;
						BorderColor3 = rgb(0, 0, 0);
						Text = "127st";
						Parent = library.cache;
						TextStrokeTransparency = 0;
						Name = "\0";
						Size = dim2(1, 0, 0, 0);
						BackgroundTransparency = 1;
						Position = dim2(0, 0, 1, 5);
						BorderSizePixel = 0;
						AutomaticSize = Enum.AutomaticSize.Y;
						TextSize = 12;
					});

					objects[ "weapon" ] = library:create( "TextLabel" , {
						FontFace = library.font;
						TextColor3 = flags["Weapon_Color"].Color;
						BorderColor3 = rgb(0, 0, 0);
						Text = "[ Weapon ]";
						Parent = library.cache;
						TextStrokeTransparency = 0;
						Name = "\0";
						Size = dim2(1, 0, 0, 0);
						BackgroundTransparency = 1;
						Position = dim2(0, 0, 1, 19);
						BorderSizePixel = 0;
						AutomaticSize = Enum.AutomaticSize.Y;
						TextSize = 12;
					});

			end

			cfg.change_health = function()
				if flags[ "healthbar_holder" ] and flags[ "healthbar_holder" ].Parent ~= objects[ "holder" ] then
					return
				end

				local humanoid = character.Humanoid

				local multiplier = humanoid.MaxHealth * math.abs(math.sin(tick() * 2)) / humanoid.MaxHealth
				local color = flags[ "Health_Low" ].Color:Lerp( flags["Health_High"].Color, multiplier)

				objects[ "healthbar" ].Size = UDim2.new(1, -2, multiplier, -2)
				objects[ "healthbar" ].Position = UDim2.new(0, 1, 1 - multiplier, 1)
				objects[ "healthbar" ].BackgroundColor3 = color
			end

			function cfg.refresh_elements( )
				objects.holder.Parent = flags["Enabled"] and items.viewportframe or library.cache

				local temp = {
					["Names"] = objects["name"];
					["Name_Color"] = {objects["name"]};
					["Healthbar"] = objects[ "healthbar_holder" ];
					["Distance"] = objects[ "distance" ];
					["Weapon"] = objects[ "weapon" ];
					["Distance_Color"] = {objects[ "distance" ]};
					["Weapon_Color"] = {objects[ "weapon" ]};
				}

				for flag,object in temp do
					if type(object) == "table" then
						object[1].TextColor3 = flags[flag].Color
					else
						object.Parent = flags[flag] and objects[ "holder" ] or library.cache
					end
				end

				local is_corner = flags[ "Box_Type" ] == "Corner"

				if flags["Boxes"] then
					if is_corner then
						objects[ "corners" ].Parent = objects["holder"]
						objects[ "box_handler" ].Parent = library.cache
						objects[ "box_outline" ].Parent = library.cache
					else
						objects[ "box_handler" ].Parent = objects[ "holder" ]
						objects[ "box_outline" ].Parent = objects[ "holder" ]
						objects[ "corners" ].Parent = library.cache
					end
				else
					objects[ "corners" ].Parent =  library.cache
					objects[ "box_handler" ].Parent = library.cache
					objects[ "box_outline" ].Parent = library.cache
				end

				objects[ "box_color" ].Color = flags["Box_Color"].Color

				for _, corner in objects[ "corners" ]:GetChildren() do
					corner.Frame.BackgroundColor3 = flags["Box_Color"].Color
				end
			end

			task.spawn(function()
				while true do
					task.wait()
					cfg.change_health()
				end
			end)

			return setmetatable(cfg, library)
		end

		function library:refresh_notifications()
			for index, notification in pairs(library.notifications) do
				tween_service:Create(notification, TweenInfo.new(0.3, library.tweening_style, library.tweening_direction), { Position = dim2(0, 31, 0, (index - 1) * 27 + 89) }):Play()
			end
		end

		function library:notification(properties)
			local cfg = {
				time = properties.time or 5,
				text = properties.text or properties.name or "Notification",
				sound = properties.sound or false,
				sound_type = properties.sound_type or 1,
				volume = properties.volume or 0.5,
				flashing = properties.flashing or false,
				flashing_speed = properties.flashing_speed or 1,
				accent_elements = {}
			}

			local outline = library:create("Frame", {
				Parent = notif_holder,
				Size = dim2(0, 0, 0, 25),
				Position = dim2(0, 31, 0, #library.notifications * 28 + 72),
				BackgroundColor3 = themes.preset.outline,
				AnchorPoint = vec2(1, 0),
				AutomaticSize = Enum.AutomaticSize.X,
				BorderSizePixel = 0
			})

			library:apply_theme(outline, "outline", "BackgroundColor3")

			local inline = library:create("Frame", {
				Parent = outline,
				Size = dim2(1, -2, 1, -2),
				Position = dim2(0, 1, 0, 1),
				BackgroundColor3 = themes.preset.inline,
				BorderSizePixel = 0
			})

			library:apply_theme(inline, "inline", "BackgroundColor3")

			local background = library:create("Frame", {
				Parent = inline,
				Size = dim2(1, -2, 1, -2),
				Position = dim2(0, 1, 0, 1),
				BackgroundColor3 = rgb(255, 255, 255),
				BorderSizePixel = 0
			})

			library:create("UIGradient", {
				Parent = background,
				Color = rgbseq({
					rgbkey(0, themes.preset.high_contrast),
					rgbkey(1, themes.preset.low_contrast)
				})
			})

			library:create("TextLabel", {
				Parent = background,
				FontFace = library.font,
				TextColor3 = themes.preset.text,
				Text = "  " .. cfg.text .. "  ",
				Size = dim2(0, 0, 1, 0),
				AutomaticSize = Enum.AutomaticSize.X,
				TextSize = 12,
				BackgroundTransparency = 1,
				Position = dim2(0, 0, 0, -2),
				BorderSizePixel = 0
			})

			function cfg.create_accent(position, size, rotation)
				local accent = library:create("Frame", {
					Parent = outline,
					Position = position,
					Size = size,
					BackgroundColor3 = themes.preset.accent,
					BorderSizePixel = 0
				})

				library:apply_theme(accent, "accent", "BackgroundColor3")

				library:create("UIGradient", {
					Parent = accent,
					Rotation = rotation,
					Color = rgbseq({
						rgbkey(0, rgb(255, 255, 255)),
						rgbkey(1, rgb(187, 187, 187))
					})
				})

				insert(cfg.accent_elements, accent)

				return accent
			end

			cfg.create_accent(dim2(0, 2, 0, 2), dim2(0, 1, 1, -4), 90)
			local bar = cfg.create_accent(dim2(0, 2, 1, -3), dim2(0, -1, 0, 1), -180)

			insert(library.notifications, outline)
			library:refresh_notifications()

			if cfg.sound then
				library:sound(cfg.sound_type == 2 and "Warning" or "Notification", cfg.volume)
			end

			if cfg.flashing then
				library.flash_data[outline] = {
					objects = cfg.accent_elements,
					speed = cfg.flashing_speed,
					end_time = os.clock() + cfg.time,
					last = os.clock(),
					state = 0
				}
			end

			tween_service:Create(outline, TweenInfo.new(0.8, library.tweening_style, library.tweening_direction), { AnchorPoint = vec2(0, 0) }):Play()
			tween_service:Create(bar, TweenInfo.new(cfg.time, library.tweening_style, library.tweening_direction), { Size = dim2(1, -4, 0, 1) }):Play()

			task.delay(cfg.time, function()
				local index = find(library.notifications, outline)

				if index then
					remove(library.notifications, index)
				end

				library.flash_data[outline] = nil
				library:refresh_notifications()

				tween_service:Create(outline, TweenInfo.new(0.8, library.tweening_style, library.tweening_direction), { AnchorPoint = vec2(1, 0), BackgroundTransparency = 1 }):Play()

				local fades = {
					TextLabel = { TextTransparency = 1 },
					Frame = { BackgroundTransparency = 1 },
					ImageLabel = { ImageTransparency = 1 },
					UIStroke = { Transparency = 1 }
				}

				for _, descendant in pairs(outline:GetDescendants()) do
					local goal = fades[descendant.ClassName]

					if goal then
						tween_service:Create(descendant, TweenInfo.new(0.8, library.tweening_style, library.tweening_direction), goal):Play()
					end
				end

				task.wait(1)
				outline:Destroy()
			end)

			return cfg
		end

		function library:tab(options)
			local cfg = {
				name = options.name or "tab",
				enabled = false
			}

			local tab_holder = library:create("TextButton", {
				Parent = self.tab_holder,
				FontFace = library.font,
				TextColor3 = themes.preset.text,
				BorderColor3 = rgb(0, 0, 0),
				Text = "",
				BorderSizePixel = 0,
				Size = dim2(0, 0, 1, -2),
				ZIndex = 5,
				TextSize = 12,
				BackgroundColor3 = themes.preset.outline,
				AutoButtonColor = false
			}) library:apply_theme(tab_holder, "outline", "BackgroundColor3")

			local inline = library:create("Frame", {
				Parent = tab_holder,
				Size = dim2(1, 1, 1, 0),
				Position = dim2(0, 1, 0, 1),
				BorderColor3 = rgb(0, 0, 0),
				ZIndex = 5,
				BorderSizePixel = 0,
				BackgroundColor3 = themes.preset.inline
			}) library:apply_theme(inline, "inline", "BackgroundColor3")

			local background = library:create("Frame", {
				Parent = inline,
				Size = dim2(1, -2, 1, -1),
				Position = dim2(0, 1, 0, 1),
				BorderColor3 = rgb(0, 0, 0),
				ZIndex = 5,
				BorderSizePixel = 0,
				BackgroundColor3 = rgb(255, 255, 255)
			})

			library:apply_theme(library:create("UIGradient", {
				Parent = background,
				Rotation = 90,
				Color = rgbseq({rgbkey(0, rgb(41, 41, 55)), rgbkey(1, rgb(35, 35, 47))})
			}), "contrast", "Color")

			library:apply_theme(library:create("TextLabel", {
				Parent = background,
				FontFace = library.font,
				TextColor3 = themes.preset.text,
				BorderColor3 = rgb(0, 0, 0),
				Text = cfg.name,
				BackgroundTransparency = 1,
				Size = dim2(1, 0, 1, 0),
				BorderSizePixel = 0,
				AutomaticSize = Enum.AutomaticSize.X,
				TextSize = 12,
				ZIndex = 5,
				BackgroundColor3 = rgb(255, 255, 255)
			}), "accent", "TextColor3")

			local section_holder = library:create("Frame", {
				Parent = library.section_holder,
				BackgroundTransparency = 1,
				BorderColor3 = rgb(0, 0, 0),
				Size = dim2(1, 0, 1, 0),
				BorderSizePixel = 0,
				Visible = false,
				BackgroundColor3 = rgb(255, 255, 255)
			})
			cfg.holder = section_holder

			library:create("UIListLayout", {
				Parent = section_holder,
				FillDirection = Enum.FillDirection.Horizontal,
				HorizontalFlex = Enum.UIFlexAlignment.Fill,
				Padding = dim(0, 4),
				SortOrder = Enum.SortOrder.LayoutOrder
			})

			local function animate(button, gradient, text, size, rotation, color)
				local info = TweenInfo.new(0.15, library.tweening_style, library.tweening_direction)
				tween_service:Create(button, info, {Size = size}):Play()
				tween_service:Create(gradient, info, {Rotation = rotation}):Play()
				tween_service:Create(text, info, {TextColor3 = color}):Play()
			end

			function cfg.open_tab()
				library:sound(library.sound_settings.sound_type, library.sound_settings.sound_volume)

				if library.current_tab and library.current_tab[1] ~= background then
					local button = library.current_tab[1]
					animate(button, button:FindFirstChildOfClass("UIGradient"), button:FindFirstChildOfClass("TextLabel"), dim2(1, -2, 1, -1), 90, themes.preset.text)
					library.current_tab[2].Visible = false
					library.current_tab = nil
				end

				library.current_tab = {background, section_holder}
				animate(background, background:FindFirstChildOfClass("UIGradient"), background:FindFirstChildOfClass("TextLabel"), dim2(1, -2, 1, 0), -90, themes.preset.accent)
				section_holder.Visible = true

				if library.current_element_open and library.current_element_open ~= cfg then
					library.current_element_open.set_visible(false)
					library.current_element_open.open = false
					library.current_element_open = nil
				end
			end

			library:connection(tab_holder.MouseButton1Click, cfg.open_tab)

			return setmetatable(cfg, library)
		end

		function library:column(path)
			local cfg = {}

			local holder = path or self.holder

			local column = library:create("Frame", {
				Parent = holder,
				BackgroundTransparency = 1,
				BorderColor3 = rgb(0, 0, 0),
				Size = dim2(1, 0, 1, 0),
				BorderSizePixel = 0,
				BackgroundColor3 = themes.preset.inline
			}) library:apply_theme(column, "inline", "BackgroundColor3")

			library:create("UIListLayout", {
				Parent = column,
				Padding = dim(0, 4),
				SortOrder = Enum.SortOrder.LayoutOrder,
				VerticalFlex = Enum.UIFlexAlignment.Fill
			})

			cfg.holder = column

			return setmetatable(cfg, library)
		end

		function library:multi_section(options)
			local cfg = {
				names = options.names or {"a", "b", "c"},
				sections = {}
			}

			local outline = library:create("Frame", {
				Parent = self.holder,
				BorderColor3 = rgb(0, 0, 0),
				Size = dim2(1, 0, 1, 0),
				BorderSizePixel = 0,
				BackgroundColor3 = themes.preset.inline
			}) library:apply_theme(outline, "inline", "BackgroundColor3")

			local inline = library:create("Frame", {
				Parent = outline,
				Position = dim2(0, 1, 0, 1),
				BorderColor3 = rgb(0, 0, 0),
				Size = dim2(1, -2, 1, -2),
				BorderSizePixel = 0,
				BackgroundColor3 = themes.preset.outline
			}) library:apply_theme(inline, "outline", "BackgroundColor3")

			local background = library:create("Frame", {
				Parent = inline,
				ClipsDescendants = true,
				Position = dim2(0, 1, 0, 1),
				BorderColor3 = rgb(0, 0, 0),
				Size = dim2(1, -2, 1, -2),
				BorderSizePixel = 0,
				ZIndex = 1,
				BackgroundColor3 = rgb(255, 255, 255)
			})

			local accent = library:create("Frame", {
				Parent = background,
				Size = dim2(1, 0, 0, 2),
				BorderColor3 = rgb(0, 0, 0),
				ZIndex = 3,
				BorderSizePixel = 0,
				BackgroundColor3 = themes.preset.accent
			}) library:apply_theme(accent, "accent", "BackgroundColor3")

			library:create("UIGradient", {
				Parent = accent,
				Rotation = 90,
				Color = rgbseq({rgbkey(0, rgb(255, 255, 255)), rgbkey(1, rgb(167, 167, 167))})
			})

			library:apply_theme(library:create("UIGradient", {
				Parent = background,
				Rotation = 90,
				Color = rgbseq({rgbkey(0, rgb(41, 41, 55)), rgbkey(1, rgb(35, 35, 47))})
			}), "contrast", "Color")

			local tab_holder = library:create("Frame", {
				Parent = background,
				ClipsDescendants = true,
				BackgroundTransparency = 1,
				Position = dim2(0, -1, 0, 0),
				BorderColor3 = rgb(0, 0, 0),
				Size = dim2(1, 2, 0, 21),
				BorderSizePixel = 0,
				BackgroundColor3 = rgb(255, 255, 255)
			})

			library:create("UIListLayout", {
				Parent = tab_holder,
				FillDirection = Enum.FillDirection.Horizontal,
				HorizontalFlex = Enum.UIFlexAlignment.Fill,
				Padding = dim(0, -3),
				SortOrder = Enum.SortOrder.LayoutOrder
			})

			for _, name in cfg.names do
				local multi = {
					open = false
				}

				local button = library:create("TextButton", {
					Parent = tab_holder,
					AutoButtonColor = false,
					FontFace = library.font,
					TextColor3 = themes.preset.text,
					BorderColor3 = rgb(0, 0, 0),
					Text = "",
					BorderSizePixel = 0,
					Size = dim2(0, 0, 1, 0),
					ZIndex = 1,
					TextSize = 12,
					BackgroundColor3 = themes.preset.outline
				}) library:apply_theme(button, "outline", "BackgroundColor3")

				local button_background = library:create("Frame", {
					Parent = button,
					Size = dim2(1, 0, 1, -2),
					Position = dim2(0, 1, 0, 1),
					BorderColor3 = rgb(0, 0, 0),
					ZIndex = 1,
					BorderSizePixel = 0,
					BackgroundColor3 = rgb(255, 255, 255)
				})

				local gradient = library:create("UIGradient", {
					Parent = button_background,
					Rotation = 90,
					Color = rgbseq({rgbkey(0, rgb(41, 41, 55)), rgbkey(1, rgb(35, 35, 47))})
				}) library:apply_theme(gradient, "contrast", "Color")

				local text = library:create("TextLabel", {
					Parent = button_background,
					FontFace = library.font,
					TextColor3 = themes.preset.text,
					BorderColor3 = rgb(0, 0, 0),
					Text = name,
					BackgroundTransparency = 1,
					Size = dim2(0, 0, 1, 0),
					BorderSizePixel = 0,
					AutomaticSize = Enum.AutomaticSize.X,
					TextSize = 12,
					BackgroundColor3 = rgb(255, 255, 255)
				}) library:apply_theme(text, "accent", "TextColor3")

				library:create("UIStroke", {
					Parent = text,
					LineJoinMode = Enum.LineJoinMode.Miter
				})

				local scrolling_frame = library:create("ScrollingFrame", {
					Parent = background,
					ScrollBarImageColor3 = themes.preset.accent,
					Active = true,
					MidImage = library.images.Scroll,
					TopImage = library.images.Scroll,
					BottomImage = library.images.Scroll,
					AutomaticCanvasSize = Enum.AutomaticSize.Y,
					ScrollBarThickness = 2,
					Size = dim2(1, 0, 1, -20),
					Visible = false,
					BackgroundTransparency = 1,
					Position = dim2(0, 0, 0, 24),
					BackgroundColor3 = rgb(255, 255, 255),
					BorderColor3 = rgb(0, 0, 0),
					BorderSizePixel = 0,
					CanvasSize = dim2(0, 0, 0, 0)
				}) library:apply_theme(scrolling_frame, "accent", "ScrollBarImageColor3")

				library:apply_theme(library:create("UIGradient", {
					Parent = library:create("Frame", {
						Parent = background,
						BorderSizePixel = 0,
						BackgroundColor3 = rgb(255, 255, 255),
						BackgroundTransparency = 0,
						Size = dim2(1, 0, 0, 60),
						Position = dim2(0, 0, 1, -60),
						ZIndex = 10
					}),
					Rotation = 90,
					Color = rgbseq({rgbkey(0, rgb(10, 10, 10)), rgbkey(1, rgb(10, 10, 10))}),
					Transparency = numseq({numkey(0, 1), numkey(0.5, 1), numkey(1, 0)})
				}), "contrast", "Color")

				local elements = library:create("Frame", {
					Parent = scrolling_frame,
					BorderColor3 = rgb(0, 0, 0),
					Size = dim2(1, 0, 0, 0),
					BorderSizePixel = 0,
					BackgroundColor3 = rgb(255, 255, 255)
				})
				multi.holder = elements

				library:create("UIListLayout", {
					Parent = elements,
					SortOrder = Enum.SortOrder.LayoutOrder,
					HorizontalAlignment = Enum.HorizontalAlignment.Center,
					Padding = dim(0, 4)
				})

				library:create("UIPadding", {
					Parent = scrolling_frame,
					PaddingBottom = dim(0, 60)
				})

				function multi:open_tab(bool)
					local info = TweenInfo.new(0.15, library.tweening_style, library.tweening_direction)
					tween_service:Create(gradient, info, {Rotation = bool and -90 or 90}):Play()
					tween_service:Create(button, info, {Size = dim2(0, 0, 1, bool and 1 or 0)}):Play()
					tween_service:Create(text, info, {TextColor3 = bool and themes.preset.accent or themes.preset.text}):Play()
					scrolling_frame.Visible = bool
				end

				library:connection(button.MouseButton1Click, function()
					library:sound(library.sound_settings.sound_type, library.sound_settings.sound_volume)

					for _, section in cfg.sections do
						section:open_tab(false)
					end

					if library.current_element_open then
						library.current_element_open.set_visible(false)
						library.current_element_open.open = false
						library.current_element_open = nil
					end

					multi:open_tab(true)
				end)

				cfg.sections[#cfg.sections + 1] = setmetatable(multi, library)
			end

			cfg.sections[1]:open_tab(true)

			return unpack(cfg.sections)
		end

		function library:section(options)
			local cfg = {
				name = options.name or "Section"
			}

			local section = library:create("Frame", {
				Parent = self.holder,
				BorderColor3 = rgb(0, 0, 0),
				Size = dim2(1, 0, 1, 0),
				BorderSizePixel = 0,
				BackgroundColor3 = themes.preset.inline
			}) library:apply_theme(section, "inline", "BackgroundColor3")

			local inline = library:create("Frame", {
				Parent = section,
				Position = dim2(0, 1, 0, 1),
				BorderColor3 = rgb(0, 0, 0),
				Size = dim2(1, -2, 1, -2),
				BorderSizePixel = 0,
				BackgroundColor3 = themes.preset.outline
			}) library:apply_theme(inline, "outline", "BackgroundColor3")

			local background = library:create("Frame", {
				Parent = inline,
				Position = dim2(0, 1, 0, 1),
				BorderColor3 = rgb(0, 0, 0),
				Size = dim2(1, -2, 1, -2),
				BorderSizePixel = 0,
				BackgroundColor3 = rgb(255, 255, 255)
			})

			library:create("UIStroke", {
				Parent = library:create("TextLabel", {
					Parent = background,
					FontFace = library.font,
					TextColor3 = themes.preset.text,
					BorderColor3 = rgb(0, 0, 0),
					Text = cfg.name,
					BackgroundTransparency = 1,
					Position = dim2(0, 6, 0, 4),
					BorderSizePixel = 0,
					AutomaticSize = Enum.AutomaticSize.XY,
					TextSize = 12,
					BackgroundColor3 = rgb(255, 255, 255)
				}),
				LineJoinMode = Enum.LineJoinMode.Miter
			})

			local accent = library:create("Frame", {
				Parent = background,
				BorderColor3 = rgb(0, 0, 0),
				Size = dim2(1, 0, 0, 2),
				BorderSizePixel = 0,
				BackgroundColor3 = themes.preset.accent
			}) library:apply_theme(accent, "accent", "BackgroundColor3")

			library:create("UIGradient", {
				Parent = accent,
				Rotation = 90,
				Color = rgbseq({rgbkey(0, rgb(255, 255, 255)), rgbkey(1, rgb(167, 167, 167))})
			})

			library:apply_theme(library:create("UIGradient", {
				Parent = background,
				Rotation = 90,
				Color = rgbseq({rgbkey(0, rgb(41, 41, 55)), rgbkey(1, rgb(35, 35, 47))})
			}), "contrast", "Color")

			local scrolling_frame = library:create("ScrollingFrame", {
				Parent = background,
				ScrollBarImageColor3 = themes.preset.accent,
				Active = true,
				AutomaticCanvasSize = Enum.AutomaticSize.Y,
				ScrollBarThickness = 2,
				MidImage = library.images.Scroll,
				TopImage = library.images.Scroll,
				BottomImage = library.images.Scroll,
				Size = dim2(1, 0, 1, -20),
				BackgroundTransparency = 1,
				Position = dim2(0, 0, 0, 20),
				BackgroundColor3 = rgb(255, 255, 255),
				BorderColor3 = rgb(0, 0, 0),
				BorderSizePixel = 0,
				CanvasSize = dim2(0, 0, 0, 0)
			}) library:apply_theme(scrolling_frame, "accent", "ScrollBarImageColor3")

			library:connection(scrolling_frame:GetPropertyChangedSignal("CanvasPosition"), function()
				if library.current_element_open then
					library.current_element_open.set_visible(false)
					library.current_element_open.open = false
					library.current_element_open = nil
				end
			end)

			library:apply_theme(library:create("UIGradient", {
				Parent = library:create("Frame", {
					Parent = background,
					BorderSizePixel = 0,
					BackgroundColor3 = rgb(255, 255, 255),
					BackgroundTransparency = 0,
					Size = dim2(1, 0, 0, 60),
					Position = dim2(0, 0, 1, -60),
					ZIndex = 10
				}),
				Rotation = 90,
				Color = rgbseq({rgbkey(0, rgb(10, 10, 10)), rgbkey(1, rgb(10, 10, 10))}),
				Transparency = numseq({numkey(0, 1), numkey(0.5, 1), numkey(1, 0)})
			}), "contrast", "Color")

			local elements = library:create("Frame", {
				Parent = scrolling_frame,
				BorderColor3 = rgb(0, 0, 0),
				Size = dim2(1, 0, 0, 0),
				BorderSizePixel = 0,
				BackgroundColor3 = rgb(255, 255, 255)
			})
			cfg.holder = elements

			library:create("UIListLayout", {
				Parent = elements,
				Padding = dim(0, 4),
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				SortOrder = Enum.SortOrder.LayoutOrder
			})

			library:create("UIPadding", {
				Parent = scrolling_frame,
				PaddingBottom = dim(0, 10)
			})

			return setmetatable(cfg, library)
		end

		function library:slider(options)
			local cfg = {
				name = options.name,
				suffix = options.suffix or "",
				flag = options.flag or false,
				callback = options.callback or function() end,
				visible = options.visible or true,
				tooltip = options.tooltip,
				min = options.min or options.minimum or 0,
				max = options.max or options.maximum or 100,
				intervals = options.interval or options.decimal or 1,
				default = options.default or 10,
				dragging = false,
				value = options.default or 10,
				input_mode = false,
				items = {},
				slider_type = options.slider_type or "keybind"
			}

			local slider_holder = library:create("TextLabel", {
				Parent = self.holder,
				FontFace = library.font,
				TextColor3 = themes.preset.text,
				BorderColor3 = rgb(0, 0, 0),
				Text = "",
				ZIndex = 1,
				Size = dim2(1, -8, 0, 12),
				BorderSizePixel = 0,
				BackgroundTransparency = 1,
				TextXAlignment = Enum.TextXAlignment.Left,
				AutomaticSize = Enum.AutomaticSize.Y,
				TextYAlignment = Enum.TextYAlignment.Top,
				TextSize = 12,
				BackgroundColor3 = rgb(255, 255, 255)
			})

			local left_components = library:create("Frame", {
				Parent = slider_holder,
				BackgroundTransparency = 1,
				Position = dim2(0, 1, 0, -1),
				BorderColor3 = rgb(0, 0, 0),
				Size = dim2(0, 0, 0, 14),
				BorderSizePixel = 0,
				BackgroundColor3 = rgb(255, 255, 255)
			})

			local text_label
			if cfg.name then
				text_label = library:create("TextLabel", {
					Parent = left_components,
					FontFace = library.font,
					TextColor3 = themes.preset.text,
					BorderColor3 = rgb(0, 0, 0),
					Text = cfg.name,
					BackgroundTransparency = 1,
					Size = dim2(0, 0, 1, -1),
					BorderSizePixel = 0,
					AutomaticSize = Enum.AutomaticSize.X,
					TextSize = 12,
					BackgroundColor3 = rgb(255, 255, 255)
				}, "text")
			end

			library:create("UIListLayout", {
				Parent = left_components,
				Padding = dim(0, 5),
				FillDirection = Enum.FillDirection.Horizontal
			})

			local bottom_components = library:create("Frame", {
				Parent = slider_holder,
				Position = dim2(0, 0, 0, cfg.name and 15 or 0),
				BorderColor3 = rgb(0, 0, 0),
				Size = dim2(1, 0, 0, 0),
				BorderSizePixel = 0,
				BackgroundColor3 = rgb(255, 255, 255)
			})

			local slider = library:create("TextButton", {
				Parent = bottom_components,
				Position = dim2(0, 0, 0, 2),
				BorderColor3 = rgb(0, 0, 0),
				Size = dim2(1, -1, 1, 12),
				BorderSizePixel = 0,
				BackgroundColor3 = themes.preset.outline,
				Text = "",
				AutoButtonColor = false
			})

			library:apply_theme(slider, "outline", "BackgroundColor3")
			library:hoverify(slider_holder, slider)

			local inline = library:create("Frame", {
				Parent = slider,
				Position = dim2(0, 1, 0, 1),
				BorderColor3 = rgb(0, 0, 0),
				Size = dim2(1, -2, 1, -2),
				BorderSizePixel = 0,
				ZIndex = 1,
				BackgroundColor3 = themes.preset.inline
			})

			library:apply_theme(inline, "inline", "BackgroundColor3")

			local background = library:create("Frame", {
				Parent = inline,
				Position = dim2(0, 1, 0, 1),
				BorderColor3 = rgb(0, 0, 0),
				Size = dim2(1, -2, 1, -2),
				BorderSizePixel = 0
			})

			local contrast = library:create("Frame", {
				Parent = background,
				BorderColor3 = rgb(0, 0, 0),
				Size = dim2(1, 0, 1, 0),
				BorderSizePixel = 0,
				BackgroundColor3 = rgb(255, 255, 255)
			})

			local slider_text = library:create("TextLabel", {
				Parent = contrast,
				FontFace = library.font,
				TextColor3 = themes.preset.text,
				BorderColor3 = rgb(0, 0, 0),
				Text = "12.50/100.00",
				BackgroundTransparency = 1,
				Position = dim2(0, 0, 0, -1),
				Size = dim2(1, 0, 1, 0),
				BorderSizePixel = 0,
				TextSize = 12,
				ZIndex = 2,
				BackgroundColor3 = rgb(255, 255, 255)
			})

			local input_box = library:create("TextBox", {
				Parent = contrast,
				FontFace = library.font,
				TextColor3 = themes.preset.text,
				BorderColor3 = rgb(0, 0, 0),
				Text = "",
				BackgroundTransparency = 1,
				Position = dim2(0, 0, 0, -1),
				Size = dim2(1, 0, 1, 0),
				BorderSizePixel = 0,
				TextSize = 12,
				ZIndex = 3,
				Visible = false,
				ClearTextOnFocus = false,
				PlaceholderText = "Enter number...",
				BackgroundColor3 = rgb(255, 255, 255)
			})

			local fill = library:create("Frame", {
				Parent = contrast,
				BorderColor3 = rgb(0, 0, 0),
				Size = dim2(1, 0, 1, 0),
				BorderSizePixel = 0,
				BackgroundColor3 = themes.preset.accent
			})

			library:apply_theme(fill, "accent", "BackgroundColor3")

			library:create("UIGradient", {
				Parent = fill,
				Rotation = 90,
				Color = rgbseq({
					rgbkey(0, rgb(255, 255, 255)),
					rgbkey(1, rgb(117, 117, 117))
				})
			})

			library:create("UIGradient", {
				Parent = contrast,
				Rotation = 90,
				Color = rgbseq({
					rgbkey(0, rgb(41, 41, 55)),
					rgbkey(1, rgb(35, 35, 47))
				})
			})

			library:apply_theme(contrast:FindFirstChildOfClass("UIGradient"), "contrast", "Color")

			library:create("UIGradient", {
				Parent = background,
				Rotation = 90,
				Color = rgbseq({
					rgbkey(0, rgb(255, 255, 255)),
					rgbkey(1, rgb(167, 167, 167))
				})
			})

			library:create("UIListLayout", {
				Parent = bottom_components,
				Padding = dim(0, 10),
				SortOrder = Enum.SortOrder.LayoutOrder
			})

			local items = cfg.items

			if cfg.slider_type == "keybind" then
				items.outline = library:create("Frame", {
					Parent = sgui,
					Size = dim2(0, 182, 0, 82),
					Visible = false,
					Position = dim2(0.5804196000099182, 0, 0.24161073565483093, 0),
					BorderColor3 = rgb(0, 0, 0),
					BorderSizePixel = 0,
					AutomaticSize = Enum.AutomaticSize.None,
					BackgroundColor3 = themes.preset.outline
				})

				library:apply_theme(items.outline, "outline", "BackgroundColor3")

				items.glow = library:create("ImageLabel", {
					Parent = items.outline,
					ImageColor3 = themes.preset.glow,
					ScaleType = Enum.ScaleType.Slice,
					BorderColor3 = rgb(0, 0, 0),
					BackgroundColor3 = rgb(255, 255, 255),
					Visible = true,
					Image = library.images.Glow4,
					BackgroundTransparency = 1,
					ImageTransparency = 0.8,
					Position = dim2(0, -21, 0, -21),
					Size = dim2(1, 41, 1, 43),
					ZIndex = 0,
					BorderSizePixel = 0,
					SliceCenter = rect(vec2(21, 21), vec2(79, 79))
				})

				library:apply_theme(items.glow, "glow", "ImageColor3")

				items.accent = library:create("Frame", {
					Parent = items.outline,
					Size = dim2(1, -2, 1, -2),
					Position = dim2(0, 1, 0, 1),
					BorderColor3 = rgb(0, 0, 0),
					BorderSizePixel = 0,
					AutomaticSize = Enum.AutomaticSize.Y,
					BackgroundColor3 = themes.preset.accent
				})

				library:apply_theme(items.accent, "accent", "BackgroundColor3")

				items.background = library:create("Frame", {
					Parent = items.accent,
					Size = dim2(1, -2, 1, -2),
					Position = dim2(0, 1, 0, 1),
					BorderColor3 = rgb(0, 0, 0),
					BorderSizePixel = 0,
					AutomaticSize = Enum.AutomaticSize.Y,
					BackgroundColor3 = themes.preset.high_contrast
				})

				library:apply_theme(items.background, "high_contrast", "BackgroundColor3")

				items.holder = library:create("Frame", {
					Parent = items.background,
					Size = dim2(1, 1, 0, 0),
					Position = dim2(0, 0, 0, 20),
					BorderColor3 = rgb(0, 0, 0),
					BorderSizePixel = 0,
					BackgroundTransparency = 1,
					AutomaticSize = Enum.AutomaticSize.Y
				})

				library:create("UIListLayout", {
					Parent = items.holder,
					Padding = dim(0, 4),
					HorizontalAlignment = Enum.HorizontalAlignment.Center,
					SortOrder = Enum.SortOrder.LayoutOrder
				})

				library:create("UIPadding", {
					Parent = items.holder,
					PaddingBottom = dim(0, 10)
				})

				local section = setmetatable(items, library)
				local original = flags[cfg.flag]

				section:label({ name = "Override Keybind" }):keybind({
					name = cfg.name .. " Override",
					callback = function(active)
						if cfg.set and flags[cfg.flag .. "_override"] and flags[cfg.flag] then
							if active then
								cfg.set(flags[cfg.flag .. "_override"])
							else
								cfg.set(original)
							end
						end
					end,
					flag = cfg.flag .. "_override_keybind"
				})

				section:slider({
					name = "Override Value",
					slider_type = "normal",
					flag = cfg.flag .. "_override",
					suffix = cfg.suffix,
					min = cfg.min,
					max = cfg.max,
					interval = cfg.intervals,
					default = cfg.default
				})

				library:create("UIPadding", {
					PaddingBottom = dim(0, 2),
					Parent = items.accent
				})

				items.info_title = library:create("TextLabel", {
					FontFace = library.font,
					TextColor3 = rgb(136, 136, 136),
					BorderColor3 = rgb(0, 0, 0),
					Text = cfg.name .. " Value Override",
					Parent = items.outline,
					Size = dim2(1, 0, 0, 0),
					Position = dim2(0, 5, 0, 0),
					BackgroundTransparency = 1,
					TextXAlignment = Enum.TextXAlignment.Left,
					BorderSizePixel = 0,
					AutomaticSize = Enum.AutomaticSize.Y,
					TextSize = 12
				})

				library:create("UIStroke", {
					Parent = items.info_title
				})

				library:create("UIPadding", {
					PaddingBottom = dim(0, 2),
					Parent = items.outline
				})
			end

			function cfg.set(value)
				if not value or type(value) == "userdata" then
					return
				end

				cfg.value = clamp(library:round(value, cfg.intervals), cfg.min, cfg.max)

				fill.Size = dim2((cfg.value - cfg.min) / (cfg.max - cfg.min), 0, 1, 0)
				slider_text.Text = tostring(cfg.value) .. cfg.suffix .. "/" .. tostring(cfg.max) .. cfg.suffix
				flags[cfg.flag] = cfg.value

				cfg.callback(flags[cfg.flag])
			end

			function cfg.set_element_visible(bool)
				slider_holder.Visible = bool

				if text_label then
					text_label.Visible = bool
				end
			end

			function cfg.is_slider_active()
				local parent = slider_holder

				for _ = 1, 8 do
					if parent and parent.Parent then
						parent = parent.Parent
						if parent:IsA("GuiObject") and not parent.Visible then
							return false
						end
					else
						return false
					end
				end

				return true
			end

			function cfg.enter_input_mode()
				cfg.input_mode = true
				slider_text.Visible = false
				input_box.Visible = true
				input_box.Text = tostring(cfg.value)
				input_box:CaptureFocus()
			end

			function cfg.exit_input_mode(submit)
				cfg.input_mode = false
				input_box.Visible = false
				slider_text.Visible = true

				if submit then
					local number = tonumber(input_box.Text)
					if number and number == number and number ~= math.huge and number ~= -math.huge then
						cfg.set(number)
					end
				end

				input_box:ReleaseFocus()
			end

			library:connection(input_box.FocusLost, function(submit)
				if cfg.input_mode then
					cfg.exit_input_mode(submit)
				end
			end)

			library:connection(input_box:GetPropertyChangedSignal("Text"), function()
				local text = input_box.Text
				local filtered = text:gsub("[^0-9%.%-]", "")
				local dots = 0
				local minus = 0
				local result = ""

				for i = 1, #filtered do
					local char = filtered:sub(i, i)

					if char == "-" then
						if i == 1 and minus == 0 then
							result ..= char
							minus += 1
						end
					elseif char == "." then
						if dots == 0 then
							result ..= char
							dots += 1
						end
					else
						result ..= char
					end
				end

				if result ~= text then
					input_box.Text = result
				elseif #result > 0 and result ~= "-" and result ~= "." and result ~= "-." then
					local number = tonumber(result)

					if number and number == number and number ~= math.huge and number ~= -math.huge then
						library:sound(library.sound_settings.sound_type, library.sound_settings.sound_volume)
					end
				end
			end)

			library.active.slider_handlers[cfg.flag] = function(began)
				if not began then
					cfg.dragging = false
					return
				end

				if not cfg.is_slider_active() then
					return
				end

				if cfg.slider_type == "keybind" and items.outline.Visible and not library:hovering({ items.outline }) then
					items.outline.Visible = false
				end

				if not library:hovering({ slider }) then
					return
				end

				if library.menu_opened and (uis:IsKeyDown(Enum.KeyCode.LeftShift) or uis:IsKeyDown(Enum.KeyCode.RightShift)) then
					cfg.enter_input_mode()
				else
					cfg.dragging = true
					library.active.slider = { cfg = cfg, slider = slider }
				end
			end

			library:connection(slider.MouseButton1Down, function()
				if not library.menu_opened or not cfg.is_slider_active() or cfg.input_mode then
					return
				end

				if uis:IsKeyDown(Enum.KeyCode.LeftShift) or uis:IsKeyDown(Enum.KeyCode.RightShift) then
					cfg.enter_input_mode()
				else
					cfg.dragging = true
					library.active.slider = { cfg = cfg, slider = slider }
					library:sound(library.sound_settings.sound_type, library.sound_settings.sound_volume)
				end
			end)

			library:connection(slider.MouseButton1Up, function()
				cfg.dragging = false
				library.active.slider = nil
			end)

			if cfg.slider_type == "keybind" then
				library:connection(slider.MouseButton2Down, function()
					if not cfg.is_slider_active() then
						return
					end

					local mouse_location = uis:GetMouseLocation()
					library:sound(library.sound_settings.sound_type, library.sound_settings.sound_volume)
					items.outline.Visible = not items.outline.Visible
					items.outline.Position = dim2(0, mouse_location.X, 0, mouse_location.Y - 65)
				end)
			end

			if cfg.tooltip then
				library:tool_tip({ name = cfg.tooltip, path = slider_holder })
			end

			cfg.set(cfg.default)
			cfg.set_element_visible(cfg.visible)

			config_flags[cfg.flag] = cfg.set
			library.config_flags[cfg.flag] = cfg.set
			library.visible_flags[cfg.flag] = cfg.set_element_visible

			return setmetatable(cfg, library)
		end

		function library:toggle(options)
			local cfg = {
				enabled = options.enabled or nil,
				name = options.name or "Toggle",
				flag = options.flag or tostring(random(1, 9999999)),
				callback = options.callback or function() end,
				default = options.default or false,
				colorpicker = options.color or nil,
				visible = options.visible or true,
				tooltip = options.tooltip or nil
			}

			local toggle_holder = library:create("TextButton", {
				Parent = self.holder,
				FontFace = library.font,
				TextColor3 = rgb(151, 151, 151),
				BorderColor3 = rgb(0, 0, 0),
				Text = "",
				ZIndex = 1,
				Size = dim2(1, -8, 0, 12),
				BorderSizePixel = 0,
				BackgroundTransparency = 1,
				TextXAlignment = Enum.TextXAlignment.Left,
				AutomaticSize = Enum.AutomaticSize.Y,
				TextYAlignment = Enum.TextYAlignment.Top,
				TextSize = 12,
				BackgroundColor3 = rgb(255, 255, 255)
			})

			local right_components = library:create("Frame", {
				Parent = toggle_holder,
				Position = dim2(1, -1, 0, 1),
				BorderColor3 = rgb(0, 0, 0),
				Size = dim2(0, 0, 0, 12),
				BorderSizePixel = 0,
				BackgroundColor3 = rgb(255, 255, 255)
			})
			cfg.right_holder = right_components

			library:create("UIListLayout", {
				Parent = right_components,
				VerticalAlignment = Enum.VerticalAlignment.Center,
				FillDirection = Enum.FillDirection.Horizontal,
				HorizontalAlignment = Enum.HorizontalAlignment.Right,
				Padding = dim(0, 4),
				SortOrder = Enum.SortOrder.LayoutOrder
			})

			library:create("UIPadding", {
				Parent = toggle_holder
			})

			local left_components = library:create("Frame", {
				Parent = toggle_holder,
				BackgroundTransparency = 1,
				Position = dim2(0, 0, 0, 0),
				BorderColor3 = rgb(0, 0, 0),
				Size = dim2(0, 0, 0, 14),
				BorderSizePixel = 0,
				BackgroundColor3 = rgb(255, 255, 255)
			})

			local text = library:create("TextLabel", {
				Parent = left_components,
				FontFace = library.font,
				TextColor3 = themes.preset.text,
				BorderColor3 = rgb(0, 0, 0),
				Text = cfg.name,
				BackgroundTransparency = 1,
				Size = dim2(0, 0, 1, -1),
				BorderSizePixel = 0,
				AutomaticSize = Enum.AutomaticSize.X,
				TextSize = 12,
				BackgroundColor3 = rgb(255, 255, 255)
			})

			library:create("UIStroke", {
				Parent = text,
				LineJoinMode = Enum.LineJoinMode.Miter
			})

			library:create("UIListLayout", {
				Parent = left_components,
				Padding = dim(0, 5),
				FillDirection = Enum.FillDirection.Horizontal
			})

			local toggle = library:create("TextButton", {
				Parent = left_components,
				Text = "",
				AutoButtonColor = false,
				Position = dim2(0, 0, 0, 2),
				BorderColor3 = rgb(0, 0, 0),
				Size = dim2(0, 14, 0, 14),
				BorderSizePixel = 0,
				ZIndex = 1,
				BackgroundColor3 = themes.preset.outline
			}) library:apply_theme(toggle, "outline", "BackgroundColor3")
			library:apply_theme(toggle, "accent", "BackgroundColor3")

			local inline = library:create("Frame", {
				Parent = toggle,
				Position = dim2(0, 1, 0, 1),
				BorderColor3 = rgb(0, 0, 0),
				Size = dim2(1, -2, 1, -2),
				BorderSizePixel = 0,
				ZIndex = 2,
				BackgroundColor3 = themes.preset.inline
			}) library:apply_theme(inline, "inline", "BackgroundColor3")

			local accent = library:create("Frame", {
				Parent = inline,
				BackgroundTransparency = 1,
				ZIndex = 3,
				Position = dim2(0, 1, 0, 1),
				BorderColor3 = rgb(0, 0, 0),
				Size = dim2(1, -2, 1, -2),
				BorderSizePixel = 0,
				BackgroundColor3 = themes.preset.accent
			}) library:apply_theme(accent, "accent", "BackgroundColor3")

			library:create("UIGradient", {
				Parent = accent,
				Rotation = 90,
				Color = rgbseq({rgbkey(0, rgb(255, 255, 255)), rgbkey(1, rgb(117, 117, 117))})
			})

			library:apply_theme(library:create("UIGradient", {
				Parent = library:create("Frame", {
					Parent = inline,
					ZIndex = 2,
					Position = dim2(0, 1, 0, 1),
					BorderColor3 = rgb(0, 0, 0),
					Size = dim2(1, -2, 1, -2),
					BorderSizePixel = 0,
					BackgroundColor3 = rgb(255, 255, 255)
				}),
				Rotation = 90,
				Color = rgbseq({rgbkey(0, rgb(41, 41, 55)), rgbkey(1, rgb(35, 35, 47))})
			}), "contrast", "Color")

			library:hoverify(toggle_holder, toggle)

			function cfg.set_element_visible(bool)
				toggle_holder.Visible = bool
			end

			function cfg.set(bool)
				cfg.enabled = bool
				library:tween(accent, {BackgroundTransparency = bool and 0 or 1})
				flags[cfg.flag] = bool
				cfg.callback(bool)
			end

			function cfg.toggle_function()
				library:sound(library.sound_settings.sound_type, library.sound_settings.sound_volume)
				cfg.set(not cfg.enabled)
			end

			library:connection(toggle_holder.MouseButton1Click, cfg.toggle_function)
			library:connection(toggle.MouseButton1Click, cfg.toggle_function)

			if cfg.tooltip then
				library:tool_tip({name = cfg.tooltip, path = toggle_holder})
			end

			cfg.set(cfg.default)
			cfg.set_element_visible(cfg.visible)
			library.config_flags[cfg.flag] = cfg.set
			library.visible_flags[cfg.flag] = cfg.set_element_visible

			return setmetatable(cfg, library)
		end

		function library:configuration(options, builder)
			options = options or {}
			local cfg = {
				name = options.name or "Configuration",
				open = false,
			}

			local button = library:create("TextButton", {
				Parent = self.right_holder or self.holder,
				Name = "",
				Size = dim2(0, 14, 0, 14),
				BorderSizePixel = 0,
				BackgroundColor3 = themes.preset.outline,
				Text = "",
				AutoButtonColor = false,
				ZIndex = 1
			}) library:apply_theme(button, "outline", "BackgroundColor3")

			library:hoverify(button, button)

			local button_inline = library:create("Frame", {
				Parent = button,
				Name = "",
				Position = dim2(0, 1, 0, 1),
				Size = dim2(1, -2, 1, -2),
				BorderSizePixel = 0,
				BackgroundColor3 = themes.preset.inline,
				ZIndex = 2
			}) library:apply_theme(button_inline, "inline", "BackgroundColor3")

			local button_text = library:create("TextLabel", {
				Parent = button_inline,
				Name = "",
				Position = dim2(0, 0, 0, -1),
				Size = dim2(1, 0, 1, 0),
				BackgroundTransparency = 1,
				TextColor3 = themes.preset.text,
				FontFace = library.font,
				Text = "#",
				TextSize = 12,
				BorderSizePixel = 0,
				ZIndex = 3
			}) library:apply_theme(button_text, "text", "TextColor3")

			local button_background = library:create("Frame", {
				Parent = button_inline,
				Name = "",
				ZIndex = 2,
				Position = dim2(0, 1, 0, 1),
				BorderColor3 = rgb(0, 0, 0),
				Size = dim2(1, -2, 1, -2),
				BorderSizePixel = 0,
				BackgroundColor3 = rgb(255, 255, 255)
			})

			library:apply_theme(library:create("UIGradient", {
				Parent = button_background,
				Rotation = 90,
				Color = rgbseq({rgbkey(0, rgb(41, 41, 55)), rgbkey(1, rgb(35, 35, 47))})
			}), "contrast", "Color")

			local window = library:create("Frame", {
				Parent = sgui,
				Name = "",
				Size = dim2(0, 220, 0, 0),
				AutomaticSize = Enum.AutomaticSize.Y,
				BorderSizePixel = 0,
				BackgroundColor3 = themes.preset.outline,
				Visible = false,
				ZIndex = 1
			}) library:apply_theme(window, "outline", "BackgroundColor3")

			local accent = library:create("Frame", {
				Parent = window,
				Name = "",
				Position = dim2(0, 1, 0, 1),
				Size = dim2(1, -2, 1, -2),
				BorderSizePixel = 0,
				BackgroundColor3 = themes.preset.accent,
				ZIndex = 1
			}) library:apply_theme(accent, "accent", "BackgroundColor3")

			local background = library:create("Frame", {
				Parent = accent,
				Name = "",
				Position = dim2(0, 1, 0, 1),
				Size = dim2(1, -2, 1, -2),
				BorderSizePixel = 0,
				BackgroundColor3 = rgb(255, 255, 255),
				ZIndex = 1
			})

			local gradient = library:create("UIGradient", {
				Parent = background,
				Rotation = 90,
				Color = rgbseq({rgbkey(0, rgb(41, 41, 55)), rgbkey(1, rgb(35, 35, 47))})
			}) library:apply_theme(gradient, "contrast", "Color")

			library:create("UIPadding", {
				Parent = background,
				PaddingTop = dim(0, 5),
				PaddingBottom = dim(0, 6),
				PaddingLeft = dim(0, 4),
				PaddingRight = dim(0, -5)
			})

			local title = library:create("TextLabel", {
				Parent = background,
				Name = "",
				Position = dim2(0, 1, 0, -2),
				Size = dim2(1, 0, 0, 12),
				BackgroundTransparency = 1,
				TextColor3 = themes.preset.text,
				FontFace = library.font,
				Text = cfg.name,
				TextSize = 12,
				TextXAlignment = Enum.TextXAlignment.Left,
				BorderSizePixel = 0,
				ZIndex = 1
			}) library:apply_theme(title, "text", "TextColor3")

			library:create("UIStroke", {
				Parent = title,
				LineJoinMode = Enum.LineJoinMode.Miter
			})

			local holder = library:create("Frame", {
				Parent = background,
				Name = "",
				Position = dim2(0, 0, 0, 14),
				Size = dim2(1, 0, 0, 0),
				AutomaticSize = Enum.AutomaticSize.Y,
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				ZIndex = 1
			})

			library:create("UIListLayout", {
				Parent = holder,
				Padding = dim(0, 4),
				SortOrder = Enum.SortOrder.LayoutOrder
			})

			cfg.holder = holder
			cfg.window = window

			library.config_stack = library.config_stack or {}

			function cfg.set_visible(bool)
				local stack = library.config_stack
				local index = table.find(stack, cfg)

				if bool then
					for i = #stack, 1, -1 do
						if button:IsDescendantOf(stack[i].window) then
							break
						end
						stack[i].set_visible(false)
					end

					local position = button.AbsolutePosition
					window.Position = dim2(0, position.X - 220 + 14, 0, position.Y + 17)
					window.Visible = true
					cfg.open = true
					insert(stack, cfg)
				elseif index then
					for i = #stack, index, -1 do
						local open = table.remove(stack, i)
						open.window.Visible = false
						open.open = false
					end
				else
					window.Visible = false
					cfg.open = false
				end
			end

			library:connection(button.MouseButton1Click, function()
				library:sound(library.sound_settings.sound_type, library.sound_settings.sound_volume)
				cfg.set_visible(not cfg.open)
			end)

			library:connection(uis.InputBegan, function(input)
				if input.UserInputType ~= Enum.UserInputType.MouseButton1 or not cfg.open or library.current_element_open then
					return
				end

				local stack = library.config_stack
				local index = table.find(stack, cfg)
				if not index or library:hovering(button) then
					return
				end

				for i = index, #stack do
					if library:hovering(stack[i].window) then
						return
					end
				end

				cfg.set_visible(false)
			end)

			local section = setmetatable({holder = holder, right_holder = holder, configuration_of = cfg}, library)

			if type(builder) == "function" then
				builder(section)
			end

			return self, section
		end

		function library:colorpicker(options)
			local parent = self.right_holder

			local cfg = {
				name = options.name or "Color",
				flag = options.flag,
				color = options.color or color(1, 1, 1),
				alpha = options.alpha or 1,
				callback = options.callback or function() end,
				right_holder = self.right_holder
			}

			local h, s, v = cfg.color:ToHSV()
			local a = cfg.alpha
			local dragging

			local colorpicker_button = library:create("TextButton", {
				Parent = parent,
				BorderColor3 = rgb(0, 0, 0),
				Size = dim2(0, 24, 0, 14),
				BorderSizePixel = 0,
				BackgroundColor3 = themes.preset.outline,
				Text = "",
				AutoButtonColor = false
			})

			library:apply_theme(colorpicker_button, "outline", "BackgroundColor3")

			local button_inline = library:create("Frame", {
				Parent = colorpicker_button,
				ZIndex = 2,
				Position = dim2(0, 1, 0, 1),
				BorderColor3 = rgb(0, 0, 0),
				Size = dim2(1, -2, 1, -2),
				BorderSizePixel = 0,
				BackgroundColor3 = themes.preset.inline
			})

			library:apply_theme(button_inline, "inline", "BackgroundColor3")

			local handler = library:create("ImageLabel", {
				Parent = button_inline,
				Image = library.images.Transparency,
				ZIndex = 2,
				ResampleMode = Enum.ResamplerMode.Pixelated,
				ImageTransparency = 1,
				Position = dim2(0, 1, 0, 1),
				BorderColor3 = rgb(0, 0, 0),
				Size = dim2(1, -2, 1, -2),
				BorderSizePixel = 0,
				BackgroundColor3 = rgb(250, 165, 27),
				ScaleType = Enum.ScaleType.Tile,
				TileSize = dim2(0, 4, 0, 4)
			})

			library:hoverify(colorpicker_button, colorpicker_button)

			library:create("UIGradient", {
				Parent = handler,
				Rotation = 90,
				Color = rgbseq({
					rgbkey(0, rgb(255, 255, 255)),
					rgbkey(1, rgb(117, 117, 117))
				})
			})

			local colorpicker_holder = library:create("Frame", {
				Parent = sgui,
				Position = dim2(0, colorpicker_button.AbsolutePosition.X + 1, 0, colorpicker_button.AbsolutePosition.Y + 17),
				BorderColor3 = rgb(0, 0, 0),
				Size = dim2(0, 190, 0, 225),
				BorderSizePixel = 0,
				BackgroundColor3 = themes.preset.outline,
				Visible = false,
				ZIndex = 1
			})

			library:apply_theme(colorpicker_holder, "outline", "BackgroundColor3")
			library:make_resizable(colorpicker_holder)

			library:apply_theme(library:create("ImageLabel", {
				Parent = colorpicker_holder,
				ImageColor3 = themes.preset.glow,
				ScaleType = Enum.ScaleType.Slice,
				BorderColor3 = rgb(0, 0, 0),
				BackgroundColor3 = rgb(255, 255, 255),
				Visible = true,
				Image = library.images.Glow4,
				BackgroundTransparency = 1,
				ImageTransparency = 0.8,
				Position = dim2(0, -21, 0, -21),
				Size = dim2(1, 41, 1, 41),
				ZIndex = 0,
				BorderSizePixel = 0,
				SliceCenter = rect(vec2(21, 21), vec2(79, 79))
			}), "glow", "ImageColor3")

			local window_inline = library:create("Frame", {
				Parent = colorpicker_holder,
				Position = dim2(0, 1, 0, 1),
				BorderColor3 = rgb(0, 0, 0),
				Size = dim2(1, -2, 1, -2),
				BorderSizePixel = 0,
				BackgroundColor3 = themes.preset.accent
			})

			library:apply_theme(window_inline, "accent", "BackgroundColor3")

			local window_holder = library:create("Frame", {
				Parent = window_inline,
				Position = dim2(0, 1, 0, 1),
				BorderColor3 = themes.preset.outline,
				Size = dim2(1, -2, 1, -2),
				BorderSizePixel = 0,
				BackgroundColor3 = rgb(255, 255, 255)
			})

			library:apply_theme(library:create("UIGradient", {
				Parent = window_holder,
				Rotation = 90,
				Color = rgbseq({
					rgbkey(0, rgb(41, 41, 55)),
					rgbkey(1, rgb(35, 35, 47))
				})
			}), "contrast", "Color")

			local title = library:create("TextLabel", {
				Parent = window_holder,
				FontFace = library.font,
				TextColor3 = themes.preset.text,
				BorderColor3 = rgb(0, 0, 0),
				Text = cfg.name,
				BackgroundTransparency = 1,
				Position = dim2(0, 2, 0, 4),
				BorderSizePixel = 0,
				AutomaticSize = Enum.AutomaticSize.XY,
				TextSize = 12,
				BackgroundColor3 = rgb(255, 255, 255)
			})

			library:create("UIStroke", {
				Parent = title,
				LineJoinMode = Enum.LineJoinMode.Miter
			})

			library:create("UIPadding", {
				Parent = window_holder,
				PaddingBottom = dim(0, 4),
				PaddingRight = dim(0, 4),
				PaddingLeft = dim(0, 4)
			})

			local main_holder = library:create("Frame", {
				Parent = window_holder,
				Position = dim2(0, 0, 0, 20),
				BorderColor3 = rgb(0, 0, 0),
				Size = dim2(1, 0, 1, -67),
				BorderSizePixel = 0,
				BackgroundColor3 = themes.preset.inline
			})

			library:apply_theme(main_holder, "inline", "BackgroundColor3")

			cfg.holder = library:create("Frame", {
				Parent = colorpicker_holder,
				Position = dim2(0, 6, 1, -48),
				BorderColor3 = rgb(0, 0, 0),
				Size = dim2(1, -3, 0, 0),
				BorderSizePixel = 0
			})

			local effects = setmetatable(cfg, library):dropdown({
				flag = cfg.flag .. "_effects",
				items = { "Rainbow", "Breathing" },
				multi = true,
				ignore = cfg,
				default = {}
			})

			cfg.holder = library:create("Frame", {
				Parent = colorpicker_holder,
				Position = dim2(1, 2, 1, -25),
				BorderColor3 = rgb(0, 0, 0),
				AnchorPoint = vec2(1, 0),
				Size = dim2(1, -4, 0, 0),
				BorderSizePixel = 0
			})

			local section = setmetatable(cfg, library)

			section:button_holder({})

			section:button({
				name = "Copy",
				callback = function()
					setclipboard(library:to_hex(cfg.color))
					library.copied_flag = flags[cfg.flag]
					library.is_rainbow = flags[cfg.flag .. "_effects"]
				end
			})

			section:button({
				name = "Paste",
				callback = function()
					local selected = {}

					if find(library.is_rainbow, "Rainbow") then
						insert(selected, "Rainbow")
					end

					if find(library.is_rainbow, "Breathing") then
						insert(selected, "Breathing")
					end

					effects.set(selected)
					cfg.set(library.copied_flag.Color, library.copied_flag.Transparency)
				end
			})

			local main_holder_inline = library:create("Frame", {
				Parent = main_holder,
				Position = dim2(0, 1, 0, 1),
				BorderColor3 = rgb(0, 0, 0),
				Size = dim2(1, -2, 1, -2),
				BorderSizePixel = 0,
				BackgroundColor3 = themes.preset.outline
			})

			library:apply_theme(main_holder_inline, "outline", "BackgroundColor3")

			local main_holder_background = library:create("Frame", {
				Parent = main_holder_inline,
				Position = dim2(0, 1, 0, 1),
				BorderColor3 = rgb(0, 0, 0),
				Size = dim2(1, -2, 1, -2),
				BorderSizePixel = 0,
				BackgroundColor3 = rgb(255, 255, 255)
			})

			library:apply_theme(library:create("UIGradient", {
				Parent = main_holder_background,
				Rotation = 90,
				Color = rgbseq({
					rgbkey(0, rgb(41, 41, 55)),
					rgbkey(1, rgb(35, 35, 47))
				})
			}), "contrast", "Color")

			library:create("UIPadding", {
				Parent = main_holder_background,
				PaddingTop = dim(0, 4),
				PaddingBottom = dim(0, 4),
				PaddingRight = dim(0, 4),
				PaddingLeft = dim(0, 4)
			})

			local alpha = library:create("TextButton", {
				Parent = main_holder_background,
				AnchorPoint = vec2(0, 0.5),
				Position = dim2(0, 0, 1, -8),
				BorderColor3 = rgb(0, 0, 0),
				Size = dim2(1, -20, 0, 14),
				BorderSizePixel = 0,
				BackgroundColor3 = themes.preset.inline,
				Text = "",
				AutoButtonColor = false
			})

			library:apply_theme(alpha, "inline", "BackgroundColor3")

			local alpha_outline = library:create("Frame", {
				Parent = alpha,
				Position = dim2(0, 1, 0, 1),
				BorderColor3 = rgb(0, 0, 0),
				Size = dim2(1, -2, 1, -2),
				BorderSizePixel = 0,
				BackgroundColor3 = themes.preset.outline
			})

			library:apply_theme(alpha_outline, "outline", "BackgroundColor3")

			local alpha_drag = library:create("Frame", {
				Parent = alpha_outline,
				Position = dim2(0, 1, 0, 1),
				BorderColor3 = rgb(0, 0, 0),
				Size = dim2(1, -2, 1, -2),
				BorderSizePixel = 0,
				BackgroundColor3 = rgb(0, 221, 255)
			})

			local alpha_indicator = library:create("ImageLabel", {
				Parent = alpha_drag,
				ScaleType = Enum.ScaleType.Tile,
				BorderColor3 = rgb(0, 0, 0),
				Image = library.images.Transparency,
				BackgroundTransparency = 1,
				Size = dim2(1, 0, 1, 0),
				TileSize = dim2(0, 6, 0, 6),
				BorderSizePixel = 0,
				BackgroundColor3 = rgb(255, 255, 255)
			})

			library:create("UIGradient", {
				Parent = alpha_indicator,
				Transparency = numseq({
					numkey(0, 0),
					numkey(1, 1)
				})
			})

			local alpha_picker = library:create("Frame", {
				Parent = alpha_drag,
				BorderMode = Enum.BorderMode.Inset,
				BorderColor3 = rgb(0, 0, 0),
				Size = dim2(0, 3, 1, 0),
				BackgroundColor3 = rgb(255, 255, 255)
			})

			local hue = library:create("TextButton", {
				Parent = main_holder_background,
				AnchorPoint = vec2(1, 0),
				Position = dim2(1, -1, 0, 0),
				BorderColor3 = rgb(0, 0, 0),
				Size = dim2(0, 14, 1, -20),
				BorderSizePixel = 0,
				BackgroundColor3 = themes.preset.inline,
				Text = "",
				AutoButtonColor = false
			})

			local hue_outline = library:create("Frame", {
				Parent = hue,
				Position = dim2(0, 1, 0, 1),
				BorderColor3 = rgb(0, 0, 0),
				Size = dim2(1, -2, 1, -2),
				BorderSizePixel = 0,
				BackgroundColor3 = themes.preset.outline
			})

			local hue_drag = library:create("Frame", {
				Parent = hue_outline,
				Position = dim2(0, 1, 0, 1),
				BorderColor3 = rgb(0, 0, 0),
				Size = dim2(1, -2, 1, -2),
				BorderSizePixel = 0,
				BackgroundColor3 = rgb(255, 255, 255)
			})

			library:create("UIGradient", {
				Parent = hue_drag,
				Rotation = 270,
				Color = rgbseq({
					rgbkey(0, rgb(255, 0, 0)),
					rgbkey(0.17, rgb(255, 255, 0)),
					rgbkey(0.33, rgb(0, 255, 0)),
					rgbkey(0.5, rgb(0, 255, 255)),
					rgbkey(0.67, rgb(0, 0, 255)),
					rgbkey(0.83, rgb(255, 0, 255)),
					rgbkey(1, rgb(255, 0, 0))
				})
			})

			local hue_picker = library:create("Frame", {
				Parent = hue_drag,
				BorderMode = Enum.BorderMode.Inset,
				BorderColor3 = rgb(0, 0, 0),
				Size = dim2(1, 0, 0, 3),
				BackgroundColor3 = rgb(255, 255, 255)
			})

			local preview = library:create("Frame", {
				Parent = main_holder_background,
				AnchorPoint = vec2(1, 1),
				Position = dim2(1, -1, 1, -1),
				BorderColor3 = rgb(0, 0, 0),
				Size = dim2(0, 14, 0, 14),
				BorderSizePixel = 0,
				BackgroundColor3 = themes.preset.inline
			})

			library:apply_theme(preview, "inline", "BackgroundColor3")

			local preview_outline = library:create("Frame", {
				Parent = preview,
				Size = dim2(1, -2, 1, -2),
				Active = true,
				BorderColor3 = rgb(0, 0, 0),
				Position = dim2(0, 1, 0, 1),
				BorderSizePixel = 0,
				BackgroundColor3 = themes.preset.outline
			})

			library:apply_theme(preview_outline, "outline", "BackgroundColor3")

			local visualize = library:create("ImageLabel", {
				Parent = preview_outline,
				Size = dim2(1, -2, 1, -2),
				ScaleType = Enum.ScaleType.Tile,
				ResampleMode = Enum.ResamplerMode.Pixelated,
				TileSize = dim2(0, 4, 0, 4),
				ImageTransparency = 1,
				Image = library.images.Transparency,
				Active = true,
				BorderColor3 = rgb(0, 0, 0),
				Position = dim2(0, 1, 0, 1),
				BorderSizePixel = 0,
				BackgroundColor3 = rgb(0, 221, 255)
			})

			local satval_picker = library:create("Frame", {
				Parent = main_holder_background,
				BorderColor3 = rgb(0, 0, 0),
				Size = dim2(1, -20, 1, -20),
				BorderSizePixel = 0,
				BackgroundColor3 = themes.preset.inline
			})

			library:apply_theme(satval_picker, "inline", "BackgroundColor3")

			local satval_outline = library:create("Frame", {
				Parent = satval_picker,
				Position = dim2(0, 1, 0, 1),
				BorderColor3 = rgb(0, 0, 0),
				Size = dim2(1, -2, 1, -2),
				BorderSizePixel = 0,
				BackgroundColor3 = themes.preset.outline
			})

			library:apply_theme(satval_outline, "outline", "BackgroundColor3")

			local colorpicker = library:create("Frame", {
				Parent = satval_outline,
				Position = dim2(0, 1, 0, 1),
				BorderColor3 = rgb(0, 0, 0),
				Size = dim2(1, -2, 1, -2),
				BorderSizePixel = 0,
				BackgroundColor3 = rgb(0, 221, 255)
			})

			local sat = library:create("TextButton", {
				Parent = colorpicker,
				Size = dim2(1, 0, 1, 0),
				BorderColor3 = rgb(0, 0, 0),
				ZIndex = 2,
				BorderSizePixel = 0,
				BackgroundColor3 = rgb(255, 255, 255),
				Text = "",
				AutoButtonColor = false
			})

			library:create("UIGradient", {
				Parent = sat,
				Rotation = 270,
				Transparency = numseq({
					numkey(0, 0),
					numkey(1, 1)
				}),
				Color = rgbseq({
					rgbkey(0, rgb(0, 0, 0)),
					rgbkey(1, rgb(0, 0, 0))
				})
			})

			local val = library:create("TextButton", {
				Parent = colorpicker,
				BorderColor3 = rgb(0, 0, 0),
				Size = dim2(1, 0, 1, 0),
				BorderSizePixel = 0,
				BackgroundColor3 = rgb(255, 255, 255),
				Text = "",
				AutoButtonColor = false
			})

			library:create("UIGradient", {
				Parent = val,
				Transparency = numseq({
					numkey(0, 0),
					numkey(1, 1)
				})
			})

			local satval_indicator = library:create("Frame", {
				Parent = colorpicker,
				BorderColor3 = rgb(0, 0, 0),
				Size = dim2(0, 2, 0, 2),
				BorderSizePixel = 1,
				BackgroundColor3 = rgb(255, 255, 255),
				ZIndex = 3
			})

			function cfg.set_visible(bool)
				colorpicker_holder.Visible = bool

				if not bool then
					effects.set_visible(false)
					effects.open = false
					return
				end

				if library.current_element_open and library.current_element_open ~= cfg then
					library.current_element_open.set_visible(false)
					library.current_element_open.open = false
				end

				library.current_element_open = cfg
				colorpicker_holder.Position = dim2(0, colorpicker_button.AbsolutePosition.X + 1, 0, colorpicker_button.AbsolutePosition.Y + 17)
			end

			library:connection(colorpicker_button.MouseButton1Click, function()
				cfg.open = not cfg.open
				library:sound(library.sound_settings.sound_type, library.sound_settings.sound_volume)
				cfg.set_visible(cfg.open)
			end)

			function cfg.set(new_color, new_alpha)
				if new_color then
					h, s, v = new_color:ToHSV()
				end

				if new_alpha then
					a = new_alpha
				end

				local value = 1 - h
				util:set_property(hue_picker, "Position", dim2(0, 0, value, value < 1 and 0 or -3))
				util:set_property(alpha_picker, "Position", dim2(a, a < 1 and 0 or -3, 0, 0))
				util:set_property(satval_indicator, "Position", dim2(s, s < 1 and 0 or -3, 1 - v, 1 - v < 1 and 0 or -3))

				local current = hsv(h, s, v)

				util:set_property(alpha_drag, "BackgroundColor3", current)
				util:set_property(visualize, "BackgroundColor3", current)
				util:set_property(visualize, "ImageTransparency", a)
				util:set_property(handler, "BackgroundColor3", current)
				util:set_property(handler, "ImageTransparency", a)
				util:set_property(colorpicker, "BackgroundColor3", hsv(h, 1, 1))

				cfg.color = current
				cfg.alpha = a

				flags[cfg.flag] = {
					Color = current,
					Transparency = a
				}

				cfg.callback(current, a)
			end

			function cfg.update_color()
				local mouse = uis:GetMouseLocation()
				local offset = vec2(mouse.X, mouse.Y - gui_offset)

				if dragging == "sat" then
					s = clamp((offset - val.AbsolutePosition).X / val.AbsoluteSize.X, 0, 1)
					v = 1 - clamp((offset - sat.AbsolutePosition).Y / sat.AbsoluteSize.Y, 0, 1)
				elseif dragging == "hue" then
					h = clamp(1 - (offset - hue.AbsolutePosition).Y / hue.AbsoluteSize.Y, 0, 1)
				elseif dragging == "alpha" then
					a = clamp((offset - alpha.AbsolutePosition).X / alpha.AbsoluteSize.X, 0, 1)
				end

				cfg.set()
			end

			library:connection(alpha.MouseButton1Down, function()
				dragging = "alpha"
				library.active.color = cfg.update_color
			end)

			library:connection(hue.MouseButton1Down, function()
				dragging = "hue"
				library.active.color = cfg.update_color
			end)

			library:connection(sat.MouseButton1Down, function()
				dragging = "sat"
				library.active.color = cfg.update_color
			end)

			library:connection(uis.InputEnded, function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 then
					library.active.color = nil
				end
			end)

			library.color_animations[cfg.flag] = function(clock)
				local selected = flags[cfg.flag .. "_effects"]

				if type(selected) ~= "table" or #selected == 0 then
					return
				end

				local speed = library.animation_speed

				if find(selected, "Rainbow") then
					h = (clock * speed * 0.2) % 1
				end

				if find(selected, "Breathing") then
					a = (math.sin(clock * speed * 2) + 1) / 2
				end

				cfg.set()
			end

			cfg.set(cfg.color, cfg.alpha)

			library.config_flags[cfg.flag] = cfg.set

			return setmetatable(cfg, library)
		end

		function library:keybind(options)
			local parent = self.right_holder

			local cfg = {
				flag = options.flag or "n/a",
				callback = options.callback or function() end,
				open = false,
				binding = nil,
				name = options.name or nil,
				key = options.key or nil,
				mode = options.mode or "toggle",
				active = options.default or false
			}

			local function update_flag()
				flags[cfg.flag] = {
					mode = cfg.mode,
					key = cfg.key,
					active = cfg.active
				}
			end

			update_flag()

			local function get_key_name(key)
				return (tostring(key):gsub("Enum.", ""):gsub("UserInputType.", ""):gsub("KeyCode.", ""))
			end

			local items = {}

			local function update_list()
				if not cfg.name then
					return
				end

				local key_name = tostring(cfg.key) ~= "Enums" and get_key_name(cfg.key) or "None"

				items.name.Text = cfg.name
				items.bind.Text = key_name
				items.holder.Visible = cfg.active

				for _, label in pairs({ items.name, items.bind }) do
					library:tween(label, { TextTransparency = cfg.active and 0 or 1 })
					library:tween(label:FindFirstChildOfClass("UIStroke"), { Transparency = cfg.active and 0 or 1 })
				end
			end

			if cfg.name then
				items.holder = library:create("Frame", {
					Parent = library.keybind_list,
					BorderColor3 = rgb(0, 0, 0),
					Size = dim2(1, -5, 0, 18),
					Visible = false,
					Position = dim2(0, 5, 0, -1),
					BorderSizePixel = 0,
					BackgroundTransparency = 1,
					AutomaticSize = Enum.AutomaticSize.Y
				})

				items.name = library:create("TextLabel", {
					Parent = items.holder,
					FontFace = library.font,
					TextColor3 = themes.preset.text,
					BorderColor3 = rgb(0, 0, 0),
					Text = "",
					Size = dim2(0.8, 0, 1, 0),
					BorderSizePixel = 0,
					BackgroundTransparency = 1,
					TextXAlignment = Enum.TextXAlignment.Left,
					TextTruncate = Enum.TextTruncate.AtEnd,
					AutomaticSize = Enum.AutomaticSize.Y,
					TextSize = 12,
					BackgroundColor3 = themes.preset.text
				})

				items.bind = library:create("TextLabel", {
					Parent = items.holder,
					FontFace = library.font,
					TextColor3 = themes.preset.text,
					BorderColor3 = rgb(0, 0, 0),
					Text = "",
					Size = dim2(0.2, 0, 1, 0),
					Position = dim2(0.8, 0, 0, 0),
					BorderSizePixel = 0,
					BackgroundTransparency = 1,
					TextXAlignment = Enum.TextXAlignment.Right,
					TextTruncate = Enum.TextTruncate.AtEnd,
					AutomaticSize = Enum.AutomaticSize.Y,
					TextSize = 12,
					BackgroundColor3 = themes.preset.text
				})
			end

			local element = library:create("TextButton", {
				Parent = parent,
				BorderColor3 = rgb(0, 0, 0),
				Text = "",
				Size = dim2(0, 24, 0, 14),
				BorderSizePixel = 0,
				AutomaticSize = Enum.AutomaticSize.X,
				BackgroundColor3 = themes.preset.outline
			})

			library:apply_theme(element, "outline", "BackgroundColor3")

			library:create("UIPadding", {
				Parent = element,
				PaddingRight = dim(0, 2)
			})

			library:hoverify(element, element).Size = dim2(1, 2, 1, 0)

			local inline = library:create("Frame", {
				Parent = element,
				Position = dim2(0, 1, 0, 1),
				BorderColor3 = rgb(0, 0, 0),
				AutomaticSize = Enum.AutomaticSize.X,
				Size = dim2(1, -2, 1, -2),
				ZIndex = 2,
				BorderSizePixel = 0,
				BackgroundColor3 = themes.preset.inline
			})

			library:apply_theme(inline, "inline", "BackgroundColor3")

			library:create("UIPadding", {
				Parent = inline,
				PaddingRight = dim(0, 2)
			})

			local handler = library:create("Frame", {
				Parent = inline,
				ZIndex = 2,
				Position = dim2(0, 1, 0, 1),
				BorderColor3 = rgb(0, 0, 0),
				Size = dim2(1, -2, 1, -2),
				BorderSizePixel = 0,
				AutomaticSize = Enum.AutomaticSize.X,
				BackgroundColor3 = rgb(255, 255, 255)
			})

			library:apply_theme(library:create("UIGradient", {
				Parent = handler,
				Rotation = 90,
				Color = rgbseq({
					rgbkey(0, rgb(41, 41, 55)),
					rgbkey(1, rgb(35, 35, 47))
				})
			}), "contrast", "Color")

			local key_text = library:create("TextLabel", {
				Parent = handler,
				FontFace = library.font,
				TextColor3 = themes.preset.text,
				BorderColor3 = rgb(0, 0, 0),
				ZIndex = 2,
				Text = "",
				Size = dim2(1, 0, 1, 0),
				BackgroundTransparency = 1,
				Position = dim2(0, 0, 0, -2),
				BorderSizePixel = 0,
				AutomaticSize = Enum.AutomaticSize.XY,
				TextSize = 12,
				BackgroundColor3 = rgb(255, 255, 255)
			})

			library:create("UIPadding", {
				Parent = key_text,
				PaddingLeft = dim(0, 3),
				PaddingRight = dim(0, 2)
			})

			local selector = library:create("Frame", {
				Parent = sgui,
				Position = dim2(0, element.AbsolutePosition.X + 1, 0, element.AbsolutePosition.Y + 17),
				Visible = false,
				BorderColor3 = rgb(255, 255, 255),
				BorderSizePixel = 2,
				AutomaticSize = Enum.AutomaticSize.XY,
				BackgroundColor3 = rgb(255, 255, 255)
			})

			library:create("UIListLayout", {
				Parent = selector,
				SortOrder = Enum.SortOrder.LayoutOrder,
				HorizontalFlex = Enum.UIFlexAlignment.Fill,
				Padding = dim(0, 2)
			})

			local function create_button(text)
				local button = library:create("TextButton", {
					Parent = selector,
					FontFace = library.font,
					TextColor3 = themes.preset.text,
					BorderColor3 = rgb(0, 0, 0),
					Text = text,
					BackgroundTransparency = 1,
					AutomaticSize = Enum.AutomaticSize.XY,
					BorderSizePixel = 0,
					ZIndex = 2,
					TextSize = 12,
					BackgroundColor3 = rgb(255, 255, 255)
				})

				library:create("UIStroke", {
					Parent = button,
					LineJoinMode = Enum.LineJoinMode.Miter
				})

				return button
			end

			library:create("UIPadding", {
				Parent = selector,
				PaddingTop = dim(0, 3),
				PaddingBottom = dim(0, 5),
				PaddingRight = dim(0, 5),
				PaddingLeft = dim(0, 5)
			})

			local buttons = {
				hold = create_button("hold"),
				toggle = create_button("toggle"),
				always = create_button("always")
			}

			library:apply_theme(library:create("UIGradient", {
				Parent = selector,
				Rotation = 90,
				Color = rgbseq({
					rgbkey(0, rgb(41, 41, 55)),
					rgbkey(1, rgb(35, 35, 47))
				})
			}), "contrast", "Color")

			library:apply_theme(library:create("UIStroke", {
				Parent = selector,
				Color = themes.preset.inline,
				LineJoinMode = Enum.LineJoinMode.Miter,
				ApplyStrokeMode = Enum.ApplyStrokeMode.Border
			}), "inline", "Color")

			local function update_buttons()
				for mode, button in pairs(buttons) do
					button.TextColor3 = mode == cfg.mode and flags["accent"].Color or flags["text_color"].Color
				end
			end

			function cfg.set_visible(bool)
				selector.Visible = bool
				selector.Position = dim2(0, element.AbsolutePosition.X + 1, 0, element.AbsolutePosition.Y + 17)

				if bool then
					if library.current_element_open and library.current_element_open ~= cfg then
						library.current_element_open.set_visible(false)
						library.current_element_open.open = false
					end

					library.current_element_open = cfg
				end
			end

			local function set_active(bool)
				if cfg.mode == "always" then
					bool = true
				end

				cfg.active = bool
				cfg.callback(cfg.active)
				update_flag()
				update_list()
			end

			local function set_key(key)
				key = key.Name == "Escape" and "none" or key

				cfg.key = key
				cfg.key_name = get_key_name(key)
				key_text.Text = string.lower(cfg.key_name)
			end

			function cfg.set_mode(mode)
				cfg.mode = mode
				update_buttons()

				if mode == "always" then
					cfg.set(true)
				elseif mode == "hold" then
					cfg.set(false)
				end
			end

			function cfg.set(input)
				if type(input) == "boolean" then
					set_active(input)
					return
				elseif tostring(input):find("Enum") then
					set_key(input)
				elseif find({ "toggle", "hold", "always" }, input) then
					cfg.set_mode(input)
				elseif type(input) == "table" then
					input.key = type(input.key) == "string" and input.key ~= "none" and library:convert_enum(input.key) or input.key
					input.key = input.key == Enum.KeyCode.Escape and "none" or input.key

					cfg.key = input.key or "none"
					cfg.mode = input.mode or "toggle"

					if input.active then
						cfg.active = input.active
					end

					cfg.key_name = get_key_name(cfg.key)
					key_text.Text = string.lower(cfg.key_name)
					update_buttons()
				end

				update_flag()
				update_list()
			end

			for mode, button in pairs(buttons) do
				library:connection(button.MouseButton1Click, function()
					library:sound(library.sound_settings.sound_type, library.sound_settings.sound_volume)
					cfg.set_mode(mode)
					cfg.set_visible(false)
					cfg.open = false
				end)

				library:apply_theme(button, "text", "TextColor3")
			end

			library:connection(element.MouseButton2Click, function()
				cfg.open = not cfg.open
				library:sound(library.sound_settings.sound_type, library.sound_settings.sound_volume)
				cfg.set_visible(cfg.open)
			end)

			library:connection(element.MouseButton1Down, function()
				library:sound(library.sound_settings.sound_type, library.sound_settings.sound_volume)
				key_text.Text = "none"

				if not library.active.pending_bind then
					library.active.pending_bind = function(key)
						cfg.set(key)
					end
				end
			end)

			library.active.keybind_handlers[cfg.flag] = function(key)
				if key ~= cfg.key then
					return
				end

				if cfg.mode == "toggle" then
					cfg.active = not cfg.active
					cfg.set(cfg.active)
				elseif cfg.mode == "hold" then
					cfg.set(true)
				end
			end

			library.active.keybind_hold_handlers[cfg.flag] = function(key)
				if key == cfg.key and cfg.mode == "hold" then
					cfg.set(false)
				end
			end

			cfg.set({ mode = cfg.mode, active = cfg.active, key = cfg.key })

			library.config_flags[cfg.flag] = cfg.set

			return setmetatable(cfg, library)
		end

		function library:dropdown(options)
			local parent = self.holder

			local cfg = {
				name = options.name or nil,
				flag = options.flag,
				items = options.items or { "1", "2", "3" },
				callback = options.callback or function() end,
				multi = options.multi or false,
				visible = options.visible or true,
				open = false,
				option_instances = {},
				multi_items = {},
				scrolling = options.scrolling or false,
				ignore = options.ignore or nil
			}

			cfg.default = options.default or (cfg.multi and { cfg.items[1] } or cfg.items[1]) or nil

			local dropdown_holder = library:create("TextLabel", {
				Parent = parent,
				FontFace = library.font,
				TextColor3 = themes.preset.text,
				BorderColor3 = rgb(0, 0, 0),
				Text = "",
				ZIndex = 2,
				Size = dim2(1, -8, 0, 12),
				BorderSizePixel = 0,
				BackgroundTransparency = 1,
				TextXAlignment = Enum.TextXAlignment.Left,
				AutomaticSize = Enum.AutomaticSize.Y,
				TextYAlignment = Enum.TextYAlignment.Top,
				TextSize = 12,
				BackgroundColor3 = rgb(255, 255, 255)
			})

			local main_text

			if cfg.name then
				local left_components = library:create("Frame", {
					Parent = dropdown_holder,
					BackgroundTransparency = 1,
					Position = dim2(0, 2, 0, -1),
					BorderColor3 = rgb(0, 0, 0),
					Size = dim2(0, 0, 0, 14),
					BorderSizePixel = 0,
					BackgroundColor3 = rgb(255, 255, 255)
				})

				main_text = library:create("TextLabel", {
					Parent = left_components,
					FontFace = library.font,
					TextColor3 = themes.preset.text,
					BorderColor3 = rgb(0, 0, 0),
					Text = cfg.name,
					BackgroundTransparency = 1,
					Size = dim2(0, 0, 1, -1),
					BorderSizePixel = 0,
					AutomaticSize = Enum.AutomaticSize.X,
					TextSize = 12,
					BackgroundColor3 = rgb(255, 255, 255)
				})

				library:create("UIStroke", {
					Parent = main_text,
					LineJoinMode = Enum.LineJoinMode.Miter
				})

				library:create("UIListLayout", {
					Parent = left_components,
					Padding = dim(0, 5),
					FillDirection = Enum.FillDirection.Horizontal
				})

				cfg.right_holder = library:create("Frame", {
					Parent = dropdown_holder,
					Position = dim2(1, -1, 0, 1),
					BorderColor3 = rgb(0, 0, 0),
					Size = dim2(0, 0, 0, 12),
					BorderSizePixel = 0,
					BackgroundColor3 = rgb(255, 255, 255)
				})

				library:create("UIListLayout", {
					Parent = cfg.right_holder,
					VerticalAlignment = Enum.VerticalAlignment.Center,
					FillDirection = Enum.FillDirection.Horizontal,
					HorizontalAlignment = Enum.HorizontalAlignment.Right,
					Padding = dim(0, 4),
					SortOrder = Enum.SortOrder.LayoutOrder
				})
			end

			local bottom_components = library:create("Frame", {
				Parent = dropdown_holder,
				Position = dim2(0, 0, 0, cfg.name and 15 or 0),
				BorderColor3 = rgb(0, 0, 0),
				Size = dim2(1, 26, 0, 0),
				BorderSizePixel = 0,
				BackgroundColor3 = rgb(255, 255, 255)
			})

			local dropdown = library:create("TextButton", {
				Parent = bottom_components,
				Position = dim2(0, 0, 0, 2),
				BorderColor3 = rgb(0, 0, 0),
				Size = dim2(1, -27, 1, 18),
				BorderSizePixel = 0,
				BackgroundColor3 = themes.preset.outline,
				Text = "",
				AutoButtonColor = false
			})

			library:apply_theme(dropdown, "outline", "BackgroundColor3")
			library:hoverify(dropdown_holder, dropdown)

			local inline = library:create("Frame", {
				Parent = dropdown,
				ZIndex = 2,
				Position = dim2(0, 1, 0, 1),
				BorderColor3 = rgb(0, 0, 0),
				Size = dim2(1, -2, 1, -2),
				BorderSizePixel = 0,
				BackgroundColor3 = themes.preset.inline
			})

			library:apply_theme(inline, "inline", "BackgroundColor3")

			local background = library:create("Frame", {
				Parent = inline,
				Position = dim2(0, 1, 0, 1),
				BorderColor3 = rgb(0, 0, 0),
				Size = dim2(1, -2, 1, -2),
				ZIndex = 2,
				BorderSizePixel = 0,
				BackgroundColor3 = themes.preset.accent
			})

			library:apply_theme(background, "accent", "BackgroundColor3")

			local contrast = library:create("Frame", {
				Parent = background,
				ZIndex = 2,
				BorderColor3 = rgb(0, 0, 0),
				Size = dim2(1, 0, 1, 0),
				BorderSizePixel = 0,
				BackgroundColor3 = rgb(255, 255, 255)
			})

			local plus = library:create("TextLabel", {
				Parent = contrast,
				TextWrapped = true,
				TextColor3 = themes.preset.text,
				BorderColor3 = rgb(0, 0, 0),
				ZIndex = 2,
				Text = "+",
				Size = dim2(1, -4, 1, 0),
				Position = dim2(0, 0, 0, -1),
				BackgroundTransparency = 1,
				TextXAlignment = Enum.TextXAlignment.Right,
				FontFace = library.font,
				TextTruncate = Enum.TextTruncate.AtEnd,
				BorderSizePixel = 0,
				BackgroundColor3 = rgb(255, 255, 255)
			})

			library:create("UIStroke", {
				Parent = plus,
				LineJoinMode = Enum.LineJoinMode.Miter
			})

			local text = library:create("TextLabel", {
				Parent = contrast,
				FontFace = library.font,
				TextColor3 = themes.preset.text,
				ZIndex = 2,
				BorderColor3 = rgb(0, 0, 0),
				Text = "",
				Size = dim2(1, -4, 1, 0),
				Position = dim2(0, 4, 0, -1),
				BackgroundTransparency = 1,
				TextXAlignment = Enum.TextXAlignment.Left,
				BorderSizePixel = 0,
				TextTruncate = Enum.TextTruncate.AtEnd,
				TextSize = 12,
				BackgroundColor3 = rgb(255, 255, 255)
			})

			library:create("UIStroke", {
				Parent = text,
				LineJoinMode = Enum.LineJoinMode.Miter
			})

			library:apply_theme(library:create("UIGradient", {
				Parent = contrast,
				Rotation = 90,
				Color = rgbseq({
					rgbkey(0, rgb(41, 41, 55)),
					rgbkey(1, rgb(35, 35, 47))
				})
			}), "contrast", "Color")

			library:apply_theme(library:create("UIGradient", {
				Parent = background,
				Rotation = 90,
				Color = rgbseq({
					rgbkey(0, rgb(255, 255, 255)),
					rgbkey(1, rgb(167, 167, 167))
				})
			}), "contrast", "Color")

			library:create("UIListLayout", {
				Parent = bottom_components,
				Padding = dim(0, 10),
				SortOrder = Enum.SortOrder.LayoutOrder
			})

			local options_holder = library:create("Frame", {
				Parent = sgui,
				BorderColor3 = rgb(0, 0, 0),
				BackgroundTransparency = 1,
				Position = dim2(0, dropdown.AbsolutePosition.X + 1, 0, dropdown.AbsolutePosition.Y + 22),
				Size = dim2(0, dropdown.AbsoluteSize.X, 0, cfg.scrolling and 80 or 0),
				BorderSizePixel = 0,
				AutomaticSize = cfg.scrolling and Enum.AutomaticSize.None or Enum.AutomaticSize.Y,
				BackgroundColor3 = themes.preset.outline,
				Visible = false
			})

			library:apply_theme(library:create("ImageLabel", {
				Parent = options_holder,
				ImageColor3 = themes.preset.glow,
				ScaleType = Enum.ScaleType.Slice,
				BorderColor3 = rgb(0, 0, 0),
				BackgroundColor3 = rgb(255, 255, 255),
				Visible = true,
				Image = library.images.Glow4,
				BackgroundTransparency = 1,
				ImageTransparency = 0.8,
				Position = dim2(0, -22, 0, -21),
				Size = dim2(1, 41, 1, 45),
				ZIndex = 0,
				BorderSizePixel = 0,
				SliceCenter = rect(vec2(21, 21), vec2(79, 79))
			}), "glow", "ImageColor3")

			local options_inline = library:create("Frame", {
				Parent = options_holder,
				Size = dim2(1, -2, 1, 2),
				Position = dim2(0, 0, 0, 1),
				BorderColor3 = rgb(0, 0, 0),
				ZIndex = 3,
				BorderSizePixel = 0,
				BackgroundColor3 = themes.preset.inline
			})

			library:apply_theme(options_inline, "inline", "BackgroundColor3")

			local options_background

			if cfg.scrolling then
				options_background = library:create("ScrollingFrame", {
					Parent = options_inline,
					BorderColor3 = rgb(0, 0, 0),
					BackgroundTransparency = 1,
					MidImage = library.images.Scroll,
					TopImage = library.images.Scroll,
					BottomImage = library.images.Scroll,
					Position = dim2(0, 1, 0, 1),
					Size = dim2(1, -2, 1, 1),
					ZIndex = 3,
					BorderSizePixel = 0,
					BackgroundColor3 = themes.preset.accent,
					CanvasSize = dim2(0, 0, 0, 0),
					AutomaticCanvasSize = Enum.AutomaticSize.Y,
					ScrollBarThickness = 2,
					ScrollBarImageColor3 = themes.preset.accent
				})

				library:apply_theme(options_background, "accent", "BackgroundColor3")
				library:apply_theme(options_background, "accent", "ScrollBarImageColor3")
			else
				options_background = library:create("Frame", {
					Parent = options_inline,
					BorderColor3 = rgb(0, 0, 0),
					BackgroundTransparency = 1,
					Position = dim2(0, 1, 0, 1),
					Size = dim2(1, -2, 1, 1),
					ZIndex = 3,
					BorderSizePixel = 0,
					BackgroundColor3 = themes.preset.accent
				})

				library:apply_theme(options_background, "accent", "BackgroundColor3")
			end

			local options_contrast = library:create("Frame", {
				Parent = options_background,
				BorderColor3 = rgb(0, 0, 0),
				Size = dim2(1, 0, 1, -3),
				BorderSizePixel = 0,
				ZIndex = 3,
				BackgroundColor3 = rgb(255, 255, 255),
				AutomaticSize = cfg.scrolling and Enum.AutomaticSize.Y or Enum.AutomaticSize.None
			})

			library:create("UIPadding", {
				Parent = options_contrast,
				PaddingTop = dim(0, 2),
				PaddingBottom = dim(0, 2),
				PaddingRight = dim(0, 0),
				PaddingLeft = dim(0, 4)
			})

			local options_gradient = library:create("UIGradient", {
				Parent = options_contrast,
				Rotation = 90,
				Color = rgbseq({
					rgbkey(0, rgb(41, 41, 55)),
					rgbkey(1, rgb(35, 35, 47))
				})
			})

			library:apply_theme(options_gradient, "contrast", "Color")

			library:create("UIListLayout", {
				Parent = options_contrast,
				Padding = dim(0, 5),
				SortOrder = Enum.SortOrder.LayoutOrder
			})

			library:apply_theme(options_gradient, "contrast", "Color")

			library:apply_theme(library:create("UIGradient", {
				Parent = options_background,
				Rotation = 90,
				Color = rgbseq({
					rgbkey(0, rgb(255, 255, 255)),
					rgbkey(1, rgb(167, 167, 167))
				})
			}), "contrast", "Color")

			library:apply_theme(library:create("UIStroke", {
				Parent = options_inline,
				Color = themes.preset.outline,
				LineJoinMode = Enum.LineJoinMode.Miter
			}), "outline", "Color")

			function cfg.set_element_visible(bool)
				dropdown_holder.Visible = bool

				if main_text then
					main_text.Visible = bool
				end
			end

			function cfg.set_visible(bool)
				library.current_element_open = cfg.ignore or cfg

				options_holder.Visible = bool
				plus.Text = bool and "-" or "+"
				plus.TextSize = bool and 12 or 8

				if not bool then
					return
				end

				if library.current_element_open and library.current_element_open ~= cfg and not cfg.ignore then
					library.current_element_open.set_visible(false)
					library.current_element_open.open = false
				end

				options_holder.Size = dim2(0, dropdown.AbsoluteSize.X, 0, options_holder.Size.Y.Offset)
				options_holder.Position = dim2(0, dropdown.AbsolutePosition.X + 1, 0, dropdown.AbsolutePosition.Y + 22)
			end

			function cfg.set(value)
				local selected = {}
				local is_table = type(value) == "table"

				for _, option in next, cfg.option_instances do
					if option.Text == value or (is_table and find(value, option.Text)) then
						insert(selected, option.Text)
						cfg.multi_items = selected
						option.TextColor3 = themes.preset.accent
					else
						option.TextColor3 = themes.preset.text
					end
				end

				text.Text = is_table and concat(selected, ", ") or selected[1] or "nun"
				flags[cfg.flag] = is_table and selected or selected[1]

				cfg.callback(flags[cfg.flag])
			end

			function cfg:refresh_options(list)
				for _, option in next, cfg.option_instances do
					option:Destroy()
				end

				cfg.option_instances = {}

				for _, name in next, list do
					local option = library:create("TextButton", {
						Parent = options_contrast,
						FontFace = library.font,
						TextColor3 = themes.preset.text,
						BorderColor3 = rgb(0, 0, 0),
						Size = dim2(1, 0, 0, 0),
						BackgroundTransparency = 1,
						BorderSizePixel = 0,
						TextWrapped = true,
						AutomaticSize = Enum.AutomaticSize.Y,
						TextSize = 12,
						TextXAlignment = Enum.TextXAlignment.Left,
						ZIndex = 3,
						Text = name,
						BackgroundColor3 = rgb(255, 255, 255)
					})

					library:apply_theme(option, "accent", "TextColor3")

					library:create("UIStroke", {
						Parent = option,
						LineJoinMode = Enum.LineJoinMode.Miter
					})

					insert(cfg.option_instances, option)

					library:connection(option.MouseButton1Down, function()
						if cfg.multi then
							local index = find(cfg.multi_items, option.Text)

							if index then
								remove(cfg.multi_items, index)
							else
								insert(cfg.multi_items, option.Text)
							end

							library:sound(library.sound_settings.sound_type, library.sound_settings.sound_volume)
							cfg.set(cfg.multi_items)
						else
							cfg.set_visible(false)
							cfg.open = false
							library:sound(library.sound_settings.sound_type, library.sound_settings.sound_volume)
							cfg.set(option.Text)
						end
					end)
				end
			end

			library:connection(dropdown.MouseButton1Click, function()
				cfg.open = not cfg.open
				library:sound(library.sound_settings.sound_type, library.sound_settings.sound_volume)
				cfg.set_visible(cfg.open)
			end)

			cfg:refresh_options(cfg.items)
			cfg.set(cfg.default)

			library.config_flags[cfg.flag] = cfg.set
			library.visible_flags[cfg.flag] = cfg.set_element_visible

			cfg.set_element_visible(cfg.visible)

			return setmetatable(cfg, library)
		end

		function library:list(options)
			local cfg = {
				callback = options and options.callback or function() end,
				scale = options.size or 232,
				items = options.items or { "l1", "l2", "l3" },
				placeholdertext = options.placeholder or options.placeholdertext or "Search here...",
				visible = options.visible or true,
				option_instances = {},
				current_instance = nil,
				flag = options.flag or "n/a"
			}

			local list_holder = library:create("TextLabel", {
				Parent = self.holder,
				FontFace = library.font,
				TextColor3 = themes.preset.text,
				BorderColor3 = rgb(0, 0, 0),
				Text = "",
				ZIndex = 2,
				Size = dim2(1, -8, 0, 12),
				BorderSizePixel = 0,
				BackgroundTransparency = 1,
				TextXAlignment = Enum.TextXAlignment.Left,
				AutomaticSize = Enum.AutomaticSize.Y,
				TextYAlignment = Enum.TextYAlignment.Top,
				TextSize = 12,
				BackgroundColor3 = rgb(255, 255, 255)
			})

			library:create("UIPadding", {
				Parent = list_holder,
				PaddingLeft = dim(0, 1)
			})

			library:create("UIStroke", {
				Parent = list_holder
			})

			local bottom_components = library:create("Frame", {
				Parent = list_holder,
				BorderColor3 = rgb(0, 0, 0),
				Size = dim2(1, 26, 0, 0),
				BorderSizePixel = 0,
				BackgroundColor3 = rgb(255, 255, 255)
			})

			library:create("UIListLayout", {
				Parent = bottom_components,
				Padding = dim(0, 10),
				SortOrder = Enum.SortOrder.LayoutOrder
			})

			local list = library:create("Frame", {
				Parent = bottom_components,
				Position = dim2(0, 0, 0, 2),
				BorderColor3 = rgb(0, 0, 0),
				Size = dim2(1, -27, 1, cfg.scale),
				BorderSizePixel = 0,
				BackgroundColor3 = themes.preset.outline
			})

			local inline = library:create("Frame", {
				Parent = list,
				Position = dim2(0, 1, 0, 1),
				BorderColor3 = rgb(0, 0, 0),
				Size = dim2(1, -2, 1, -2),
				BorderSizePixel = 0,
				BackgroundColor3 = themes.preset.inline
			})

			library:apply_theme(inline, "inline", "BackgroundColor3")

			local background = library:create("Frame", {
				Parent = inline,
				Position = dim2(0, 1, 0, 1),
				BorderColor3 = rgb(0, 0, 0),
				Size = dim2(1, -2, 1, -2),
				BorderSizePixel = 0,
				BackgroundColor3 = themes.preset.accent
			})

			library:apply_theme(background, "accent", "BackgroundColor3")

			library:apply_theme(library:create("UIGradient", {
				Parent = background,
				Rotation = 90,
				Color = rgbseq({
					rgbkey(0, rgb(255, 255, 255)),
					rgbkey(1, rgb(167, 167, 167))
				})
			}), "contrast", "Color")

			local contrast = library:create("Frame", {
				Parent = background,
				BorderColor3 = rgb(0, 0, 0),
				Size = dim2(1, 0, 1, 0),
				BorderSizePixel = 0,
				BackgroundColor3 = rgb(255, 255, 255)
			})

			library:apply_theme(library:create("UIGradient", {
				Parent = contrast,
				Rotation = 90,
				Color = rgbseq({
					rgbkey(0, rgb(41, 41, 55)),
					rgbkey(1, rgb(35, 35, 47))
				})
			}), "contrast", "Color")

			local scrolling_frame = library:create("ScrollingFrame", {
				Parent = contrast,
				ScrollBarImageColor3 = themes.preset.accent,
				Active = true,
				MidImage = library.images.Scroll,
				TopImage = library.images.Scroll,
				BottomImage = library.images.Scroll,
				AutomaticCanvasSize = Enum.AutomaticSize.Y,
				ScrollBarThickness = 2,
				BackgroundTransparency = 1,
				Size = dim2(1, 0, 1, 0),
				BackgroundColor3 = rgb(255, 255, 255),
				BorderColor3 = rgb(0, 0, 0),
				BorderSizePixel = 0,
				CanvasSize = dim2(0, 0, 0, 0)
			})

			library:apply_theme(scrolling_frame, "accent", "ScrollBarImageColor3")

			local fade = library:create("Frame", {
				Parent = contrast,
				BorderSizePixel = 0,
				BackgroundColor3 = rgb(255, 255, 255),
				BackgroundTransparency = 0,
				Size = dim2(1, 0, 0, 60),
				Position = dim2(0, 0, 1, -60),
				ZIndex = 10
			})

			library:apply_theme(library:create("UIGradient", {
				Parent = fade,
				Rotation = 90,
				Color = rgbseq({
					rgbkey(0, rgb(10, 10, 10)),
					rgbkey(1, rgb(10, 10, 10))
				}),
				Transparency = numseq({
					numkey(0, 1),
					numkey(0.5, 1),
					numkey(1, 0)
				})
			}), "contrast", "Color")

			library:create("UIPadding", {
				Parent = scrolling_frame,
				PaddingBottom = dim(0, 4),
				PaddingTop = dim(0, 4)
			})

			library:create("UIListLayout", {
				Parent = scrolling_frame,
				Padding = dim(0, 4),
				SortOrder = Enum.SortOrder.LayoutOrder
			})

			function cfg.render_option(text)
				local button = library:create("TextButton", {
					Parent = scrolling_frame,
					Text = text,
					FontFace = library.font,
					TextColor3 = themes.preset.text,
					BorderColor3 = rgb(0, 0, 0),
					BackgroundTransparency = 1,
					Size = dim2(1, 0, 0, 0),
					BorderSizePixel = 0,
					AutomaticSize = Enum.AutomaticSize.Y,
					TextSize = 12,
					BackgroundColor3 = rgb(255, 255, 255)
				})

				library:apply_theme(button, "accent", "TextColor3")

				library:create("UIStroke", {
					Parent = button
				})

				return button
			end

			function cfg.set_element_visible(bool)
				list_holder.Visible = bool
			end

			function cfg.refresh_options(list_options)
				if type(list_options) == "function" then
					return
				end

				for _, option in next, cfg.option_instances do
					option:Destroy()
				end

				for _, option in next, list_options do
					local button = cfg.render_option(option)

					insert(cfg.option_instances, button)

					library:connection(button.MouseButton1Click, function()
						library:sound(library.sound_settings.sound_type, library.sound_settings.sound_volume)

						if cfg.current_instance and cfg.current_instance ~= button then
							cfg.current_instance.TextColor3 = themes.preset.text
						end

						cfg.current_instance = button
						button.TextColor3 = themes.preset.accent

						flags[cfg.flag] = button.Text
						cfg.callback(button.Text)
					end)
				end
			end

			function cfg.filter_options(text)
				for _, option in next, cfg.option_instances do
					if string.find(option.Text, text) then
						option.Visible = true
					else
						option.Visible = false
					end
				end
			end

			function cfg.set(value)
				for _, option in next, cfg.option_instances do
					if option.Text == value then
						option.TextColor3 = themes.preset.accent
					else
						option.TextColor3 = themes.preset.text
					end
				end

				flags[cfg.flag] = value
				cfg.callback(value)
			end

			cfg.refresh_options(cfg.items)
			cfg.set_element_visible(cfg.visible)

			library.visible_flags[cfg.flag] = cfg.set_element_visible
			library.config_flags[cfg.flag] = cfg.set

			return setmetatable(cfg, library)
		end

		function library:textbox(options)
			local cfg = {
				placeholder = options.placeholder or options.placeholdertext or options.holder or options.holdertext or "type here...",
				default = options.default,
				flag = options.flag or "",
				callback = options.callback or function() end,
				visible = options.visible or true,
				max = options.max or 9999,
				removing = false
			}

			local textbox_holder = library:create("TextLabel", {
				Parent = self.holder,
				FontFace = library.font,
				TextColor3 = themes.preset.text,
				BorderColor3 = rgb(0, 0, 0),
				Text = "",
				ZIndex = 2,
				Size = dim2(1, -8, 0, 12),
				BorderSizePixel = 0,
				BackgroundTransparency = 1,
				TextXAlignment = Enum.TextXAlignment.Left,
				AutomaticSize = Enum.AutomaticSize.Y,
				TextYAlignment = Enum.TextYAlignment.Top,
				TextSize = 12,
				BackgroundColor3 = rgb(255, 255, 255)
			})

			library:create("UIPadding", {
				Parent = textbox_holder,
				PaddingLeft = dim(0, 1)
			})

			library:create("UIStroke", {
				Parent = textbox_holder
			})

			local button = library:create("Frame", {
				Parent = textbox_holder,
				Position = dim2(0, 0, 0, 2),
				BorderColor3 = rgb(0, 0, 0),
				Size = dim2(1, -27, 0, 18),
				BorderSizePixel = 0,
				BackgroundColor3 = themes.preset.outline
			})

			library:hoverify(textbox_holder, button)
			library:apply_theme(button, "outline", "BackgroundColor3")

			local inline = library:create("Frame", {
				Parent = button,
				Position = dim2(0, 1, 0, 1),
				ZIndex = 2,
				BorderColor3 = rgb(0, 0, 0),
				Size = dim2(1, -2, 1, -2),
				BorderSizePixel = 0,
				BackgroundColor3 = themes.preset.inline
			})

			library:apply_theme(inline, "inline", "BackgroundColor3")

			local background = library:create("Frame", {
				Parent = inline,
				Position = dim2(0, 1, 0, 1),
				BorderColor3 = rgb(0, 0, 0),
				ZIndex = 2,
				Size = dim2(1, -2, 1, -2),
				BorderSizePixel = 0,
				BackgroundColor3 = themes.preset.accent
			})

			library:apply_theme(background, "accent", "BackgroundColor3")

			local TextBox = library:create("TextBox", {
				Parent = background,
				CursorPosition = -1,
				FontFace = library.font,
				TextColor3 = themes.preset.text,
				BorderColor3 = rgb(0, 0, 0),
				Text = "",
				Size = dim2(1, 0, 1, 0),
				BorderSizePixel = 0,
				TextWrapped = true,
				BackgroundTransparency = 1,
				TextTruncate = Enum.TextTruncate.SplitWord,
				PlaceholderText = cfg.placeholder,
				ClearTextOnFocus = false,
				ZIndex = 3,
				TextSize = 12,
				BackgroundColor3 = rgb(255, 255, 255)
			})

			library:create("UIStroke", {
				Parent = TextBox
			})

			local TextButton = library:create("TextButton", {
				Parent = background,
				FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal),
				TextColor3 = rgb(0, 0, 0),
				BorderColor3 = rgb(0, 0, 0),
				Text = "",
				AutoButtonColor = false,
				Size = dim2(1, 0, 1, 0),
				BorderSizePixel = 0,
				TextSize = 14,
				ZIndex = 2,
				BackgroundColor3 = rgb(255, 255, 255)
			})

			local UIGradient = library:create("UIGradient", {
				Parent = TextButton,
				Rotation = 90,
				Color = rgbseq({
					rgbkey(0, rgb(41, 41, 55)),
					rgbkey(1, rgb(35, 35, 47))
				})
			})

			library:apply_theme(UIGradient, "contrast", "Color")

			library:create("UIListLayout", {
				Parent = textbox_holder,
				FillDirection = Enum.FillDirection.Horizontal,
				HorizontalFlex = Enum.UIFlexAlignment.Fill,
				Padding = dim(0, 4),
				SortOrder = Enum.SortOrder.LayoutOrder
			})

			function cfg.set_element_visible(bool)
				textbox_holder.Visible = bool
			end

			library:connection(TextBox:GetPropertyChangedSignal("Text"), function()
				if cfg.removing then
					cfg.removing = false
					return
				end
				local text = TextBox.Text
				if cfg.max < #text then
					cfg.removing = true
					TextBox.Text = text:sub(1, cfg.max)
					return
				end
				flags[cfg.flag] = text
				cfg.callback(text)
				library:sound(library.sound_settings.sound_type, library.sound_settings.sound_volume)
			end)

			function cfg.set(text)
				if cfg.max < #text then
					text = text:sub(1, cfg.max)
				end
				flags[cfg.flag] = text
				TextBox.Text = text
				cfg.callback(text)
			end

			if cfg.default then
				cfg.set(cfg.default)
			end

			cfg.set_element_visible(cfg.visible)

			library.config_flags[cfg.flag] = cfg.set
			library.visible_flags[cfg.flag] = cfg.set_element_visible

			return setmetatable(cfg, library)
		end

		function library:button_holder(options)
			local cfg = {
				flag = options.flag or "n/a",
				visible = options.visible or true
			}

			local button_holder = library:create("TextLabel", {
				Parent = self.holder,
				FontFace = library.font,
				TextColor3 = themes.preset.text,
				BorderColor3 = rgb(0, 0, 0),
				Text = "",
				ZIndex = 2,
				Size = dim2(1, -8, 0, 12),
				BorderSizePixel = 0,
				BackgroundTransparency = 1,
				TextXAlignment = Enum.TextXAlignment.Left,
				AutomaticSize = Enum.AutomaticSize.Y,
				TextYAlignment = Enum.TextYAlignment.Top,
				TextSize = 12,
				BackgroundColor3 = rgb(255, 255, 255)
			})

			self.current_holder = button_holder

			library:create("UIStroke", {
				Parent = button_holder
			})

			library:create("UIListLayout", {
				Parent = button_holder,
				FillDirection = Enum.FillDirection.Horizontal,
				HorizontalFlex = Enum.UIFlexAlignment.Fill,
				Padding = dim(0, 5),
				SortOrder = Enum.SortOrder.LayoutOrder
			})

			function cfg.set_element_visible(bool)
				button_holder.Visible = bool
			end

			cfg.set_element_visible(cfg.visible)
			library.visible_flags[cfg.flag] = cfg.set_element_visible

			return setmetatable(cfg, library)
		end

		function library:button(options)
			local cfg = {
				callback = options.callback or function() end,
				name = options.text or options.name or "Button",
				confirm = options.confirm or false,
				confirm_timer = options.confirm_timer or 3,
				tooltip = options.tooltip or nil,
				confirm_active = false,
				confirm_countdown = 0,
				mouse_down = false,
				confirm_timer_id = nil
			}

			local button = library:create("TextButton", {
				Parent = self.current_holder,
				Position = dim2(0, 0, 0, 2),
				BorderColor3 = rgb(0, 0, 0),
				Size = dim2(1, -27, 0, 18),
				BorderSizePixel = 0,
				BackgroundColor3 = themes.preset.outline,
				Text = ""
			})

			library:hoverify(button, button)
			library:apply_theme(button, "outline", "BackgroundColor3")

			local inline = library:create("Frame", {
				Parent = button,
				ZIndex = 2,
				Position = dim2(0, 1, 0, 1),
				BorderColor3 = rgb(0, 0, 0),
				Size = dim2(1, -2, 1, -2),
				BorderSizePixel = 0,
				BackgroundColor3 = themes.preset.inline
			})

			library:apply_theme(inline, "inline", "BackgroundColor3")

			local background = library:create("Frame", {
				Parent = inline,
				ZIndex = 2,
				Position = dim2(0, 1, 0, 1),
				BorderColor3 = rgb(0, 0, 0),
				Size = dim2(1, -2, 1, -2),
				BorderSizePixel = 0,
				BackgroundColor3 = themes.preset.accent
			})

			library:apply_theme(background, "accent", "BackgroundColor3")

			library:apply_theme(library:create("UIGradient", {
				Parent = background,
				Rotation = 90,
				Color = rgbseq({
					rgbkey(0, rgb(255, 255, 255)),
					rgbkey(1, rgb(167, 167, 167))
				})
			}), "contrast", "Color")

			local contrast = library:create("Frame", {
				Parent = background,
				ZIndex = 2,
				BorderColor3 = rgb(0, 0, 0),
				Size = dim2(1, 0, 1, 0),
				BorderSizePixel = 0,
				BackgroundColor3 = rgb(255, 255, 255)
			})

			library:apply_theme(library:create("UIGradient", {
				Parent = contrast,
				Rotation = 90,
				Color = rgbseq({
					rgbkey(0, rgb(41, 41, 55)),
					rgbkey(1, rgb(35, 35, 47))
				})
			}), "contrast", "Color")

			local text = library:create("TextLabel", {
				Parent = contrast,
				TextWrapped = true,
				ZIndex = 3,
				TextColor3 = themes.preset.text,
				BorderColor3 = rgb(0, 0, 0),
				Text = cfg.name,
				Size = dim2(1, -4, 1, 0),
				Position = dim2(0, 4, 0, -1),
				BackgroundTransparency = 1,
				TextTruncate = Enum.TextTruncate.AtEnd,
				BorderSizePixel = 0,
				FontFace = library.font,
				TextSize = 12,
				BackgroundColor3 = rgb(255, 255, 255)
			})

			library:create("UIStroke", {
				Parent = text,
				LineJoinMode = Enum.LineJoinMode.Miter
			})

			local fill = library:create("Frame", {
				Parent = background,
				Name = "fill",
				ZIndex = 2,
				Size = dim2(1, 0, 1, 0),
				Position = dim2(0, 0, 0, 0),
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				BackgroundColor3 = themes.preset.accent
			})

			library:apply_theme(fill, "accent", "BackgroundColor3")

			library:create("UIGradient", {
				Parent = fill,
				Rotation = 90,
				Color = rgbseq({
					rgbkey(0, rgb(255, 255, 255)),
					rgbkey(1, rgb(117, 117, 117))
				})
			})

			local function reset_confirm()
				cfg.confirm_active = false
				cfg.confirm_countdown = 0
				text.Text = cfg.name
			end

			local function start_confirm()
				cfg.confirm_active = true
				cfg.confirm_countdown = cfg.confirm_timer
				text.Text = "Confirm " .. cfg.name .. "? (" .. cfg.confirm_countdown .. "s)"
				if cfg.confirm_timer_id then
					task.cancel(cfg.confirm_timer_id)
				end
				cfg.confirm_timer_id = task.delay(cfg.confirm_timer, reset_confirm)
			end

			library:connection(button.MouseButton1Down, function()
				cfg.mouse_down = true
				tween_service:Create(fill, TweenInfo.new(library.tweening_speed / 2, library.tweening_style, library.tweening_direction), { BackgroundTransparency = 0 }):Play()
			end)

			library:connection(button.MouseButton1Up, function()
				cfg.mouse_down = false
				tween_service:Create(fill, TweenInfo.new(library.tweening_speed / 2, library.tweening_style, library.tweening_direction), { BackgroundTransparency = 1 }):Play()
			end)

			library:connection(button.MouseLeave, function()
				if cfg.mouse_down then
					tween_service:Create(fill, TweenInfo.new(library.tweening_speed / 2, library.tweening_style, library.tweening_direction), { BackgroundTransparency = 1 }):Play()
				end
			end)

			library:connection(button.MouseButton1Click, function()
				library:sound(library.sound_settings.sound_type, library.sound_settings.sound_volume)
				if cfg.confirm then
					if cfg.confirm_active then
						reset_confirm()
						cfg.callback()
					else
						start_confirm()
					end
				else
					cfg.callback()
				end
			end)

			if cfg.tooltip then
				library:tool_tip({ name = cfg.tooltip, path = button })
			end

			return setmetatable(cfg, library)
		end

		function library:label(options)
			local cfg = {
				name = options.text or options.name or "Label"
			}

			local label = library:create("TextLabel", {
				Parent = self.holder,
				FontFace = library.font,
				TextColor3 = themes.preset.text,
				BorderColor3 = rgb(0, 0, 0),
				Text = "",
				ZIndex = 2,
				Size = dim2(1, -8, 0, 12),
				BorderSizePixel = 0,
				BackgroundTransparency = 1,
				TextXAlignment = Enum.TextXAlignment.Left,
				AutomaticSize = Enum.AutomaticSize.Y,
				TextYAlignment = Enum.TextYAlignment.Top,
				TextSize = 12,
				BackgroundColor3 = rgb(255, 255, 255)
			})

			library:create("UIStroke", {
				Parent = label
			})

			local left_components = library:create("Frame", {
				Parent = label,
				BackgroundTransparency = 1,
				Position = dim2(0, 1, 0, -1),
				BorderColor3 = rgb(0, 0, 0),
				Size = dim2(0, 0, 0, 14),
				BorderSizePixel = 0,
				BackgroundColor3 = rgb(255, 255, 255)
			})

			local text = library:create("TextLabel", {
				Parent = left_components,
				FontFace = library.font,
				TextColor3 = themes.preset.text,
				BorderColor3 = rgb(0, 0, 0),
				Text = cfg.name,
				BackgroundTransparency = 1,
				TextXAlignment = Enum.TextXAlignment.Left,
				BorderSizePixel = 0,
				AutomaticSize = Enum.AutomaticSize.Y,
				TextSize = 12,
				BackgroundColor3 = rgb(255, 255, 255)
			})

			local right_components = library:create("Frame", {
				Parent = label,
				Position = dim2(1, -1, 0, 1),
				BorderColor3 = rgb(0, 0, 0),
				Size = dim2(0, 0, 0, 12),
				BorderSizePixel = 0,
				BackgroundColor3 = rgb(255, 255, 255)
			})
			cfg.right_holder = right_components

			library:create("UIListLayout", {
				Parent = right_components,
				VerticalAlignment = Enum.VerticalAlignment.Center,
				FillDirection = Enum.FillDirection.Horizontal,
				HorizontalAlignment = Enum.HorizontalAlignment.Right,
				Padding = dim(0, 4),
				Name = "list",
				SortOrder = Enum.SortOrder.LayoutOrder
			})

			library:create("UIStroke", {
				Parent = text
			})

			function cfg.set(value)
				text.Text = value
			end

			return setmetatable(cfg, library)
		end

		function library:playerlist(options)
			local cfg = {
				callback = options.callback or function() end,
				labels = {}
			}

			local patterns = {
				Enemy = rgb(255, 72, 118),
				Neutral = themes.preset.text,
				Friendly = rgb(179, 255, 215)
			}

			local selected_button

			local playerlist_holder = library:create("TextLabel", {
				Parent = self.holder,
				FontFace = library.font,
				TextColor3 = themes.preset.text,
				BorderColor3 = rgb(0, 0, 0),
				Text = "",
				ZIndex = 2,
				Size = dim2(1, -8, 0, 12),
				BorderSizePixel = 0,
				BackgroundTransparency = 1,
				TextXAlignment = Enum.TextXAlignment.Left,
				AutomaticSize = Enum.AutomaticSize.Y,
				TextYAlignment = Enum.TextYAlignment.Top,
				TextSize = 12,
				BackgroundColor3 = rgb(255, 255, 255)
			})

			library:create("UIPadding", {
				Parent = playerlist_holder,
				PaddingBottom = dim(0, -2),
				PaddingLeft = dim(0, 1)
			})

			library:create("UIStroke", {
				Parent = playerlist_holder
			})

			local bottom_components = library:create("Frame", {
				Parent = playerlist_holder,
				BorderColor3 = rgb(0, 0, 0),
				Size = dim2(1, 26, 0, 0),
				BorderSizePixel = 0,
				BackgroundColor3 = rgb(255, 255, 255)
			})

			library:create("UIListLayout", {
				Parent = bottom_components,
				Padding = dim(0, 10),
				SortOrder = Enum.SortOrder.LayoutOrder
			})

			local list = library:create("Frame", {
				Parent = bottom_components,
				AutomaticSize = Enum.AutomaticSize.Y,
				Position = dim2(0, 0, 0, 2),
				BorderColor3 = rgb(0, 0, 0),
				Size = dim2(1, -27, 1, 280),
				BorderSizePixel = 0,
				BackgroundColor3 = themes.preset.outline
			})

			library:apply_theme(list, "outline", "BackgroundColor3")

			local inline = library:create("Frame", {
				Parent = list,
				Position = dim2(0, 1, 0, 1),
				BorderColor3 = rgb(0, 0, 0),
				Size = dim2(1, -2, 1, -2),
				BorderSizePixel = 0,
				BackgroundColor3 = themes.preset.inline
			})

			library:apply_theme(inline, "inline", "BackgroundColor3")

			local background = library:create("Frame", {
				Parent = inline,
				Position = dim2(0, 1, 0, 1),
				BorderColor3 = rgb(0, 0, 0),
				Size = dim2(1, -2, 1, -2),
				BorderSizePixel = 0,
				BackgroundColor3 = themes.preset.accent
			})

			library:apply_theme(library:create("UIGradient", {
				Parent = background,
				Rotation = 90,
				Color = rgbseq({
					rgbkey(0, rgb(255, 255, 255)),
					rgbkey(1, rgb(167, 167, 167))
				})
			}), "contrast", "Color")

			local contrast = library:create("Frame", {
				Parent = background,
				BorderColor3 = rgb(0, 0, 0),
				Size = dim2(1, 0, 1, 0),
				BorderSizePixel = 0,
				BackgroundColor3 = rgb(255, 255, 255)
			})

			library:apply_theme(library:create("UIGradient", {
				Parent = contrast,
				Rotation = 90,
				Color = rgbseq({
					rgbkey(0, rgb(41, 41, 55)),
					rgbkey(1, rgb(35, 35, 47))
				})
			}), "contrast", "Color")

			local scrolling_frame = library:create("ScrollingFrame", {
				Parent = contrast,
				ScrollBarImageColor3 = themes.preset.accent,
				Active = true,
				MidImage = library.images.Scroll,
				TopImage = library.images.Scroll,
				BottomImage = library.images.Scroll,
				AutomaticCanvasSize = Enum.AutomaticSize.Y,
				ScrollBarThickness = 2,
				BackgroundTransparency = 1,
				Size = dim2(1, 0, 1, 0),
				BackgroundColor3 = rgb(255, 255, 255),
				BorderColor3 = rgb(0, 0, 0),
				BorderSizePixel = 0,
				CanvasSize = dim2(0, 0, 0, 0)
			})

			library:apply_theme(scrolling_frame, "accent", "ScrollBarImageColor3")

			library:create("UIPadding", {
				Parent = scrolling_frame,
				PaddingTop = dim(0, 4),
				PaddingBottom = dim(0, 4),
				PaddingRight = dim(0, 4),
				PaddingLeft = dim(0, 4)
			})

			library:create("UIListLayout", {
				Parent = scrolling_frame,
				Padding = dim(0, 0),
				SortOrder = Enum.SortOrder.LayoutOrder
			})

			function cfg.create_player(player)
				local name = tostring(player)
				library.playerlist_data[name] = {}
				local data = library.playerlist_data[name]

				local button = library:create("TextButton", {
					Parent = scrolling_frame,
					FontFace = library.font,
					TextColor3 = themes.preset.text,
					BorderColor3 = rgb(0, 0, 0),
					Text = "",
					BackgroundTransparency = 1,
					Size = dim2(1, 0, 0, 0),
					BorderSizePixel = 0,
					AutomaticSize = Enum.AutomaticSize.Y,
					TextSize = 12,
					BackgroundColor3 = rgb(255, 255, 255)
				})

				local player_name = library:create("TextLabel", {
					Parent = button,
					FontFace = library.font,
					TextColor3 = themes.preset.text,
					BorderColor3 = rgb(0, 0, 0),
					Text = name,
					BorderSizePixel = 0,
					BackgroundTransparency = 1,
					TextXAlignment = Enum.TextXAlignment.Left,
					TextTruncate = Enum.TextTruncate.AtEnd,
					AutomaticSize = Enum.AutomaticSize.Y,
					TextSize = 12,
					LayoutOrder = -9,
					BackgroundColor3 = rgb(255, 255, 255)
				})

				library:apply_theme(player_name, "text", "TextColor3")
				library:apply_theme(player_name, "accent", "TextColor3")

				local priority_text = library:create("TextLabel", {
					Parent = button,
					FontFace = library.font,
					TextColor3 = name ~= lp.Name and themes.preset.text or rgb(0, 0, 255),
					BorderColor3 = rgb(0, 0, 0),
					Text = name ~= lp.Name and "Neutral" or "LocalPlayer",
					BackgroundTransparency = 1,
					TextXAlignment = Enum.TextXAlignment.Left,
					BorderSizePixel = 0,
					AutomaticSize = Enum.AutomaticSize.Y,
					TextSize = 12,
					BackgroundColor3 = rgb(255, 255, 255)
				})

				local divider = library:create("Frame", {
					Parent = priority_text,
					Position = dim2(0, -10, 0, 0),
					BorderColor3 = rgb(0, 0, 0),
					Size = dim2(0, 1, 0, 12),
					BorderSizePixel = 0,
					BackgroundColor3 = themes.preset.outline
				})

				library:apply_theme(divider, "outline", "BackgroundColor3")

				library:create("UIListLayout", {
					Parent = button,
					FillDirection = Enum.FillDirection.Horizontal,
					HorizontalFlex = Enum.UIFlexAlignment.Fill,
					SortOrder = Enum.SortOrder.LayoutOrder,
					VerticalFlex = Enum.UIFlexAlignment.Fill
				})

				library:create("UIPadding", {
					Parent = button,
					PaddingRight = dim(0, 2),
					PaddingLeft = dim(0, 2)
				})

				local line = library:create("Frame", {
					Parent = scrolling_frame,
					BorderColor3 = rgb(0, 0, 0),
					Size = dim2(1, 0, 0, 1),
					BorderSizePixel = 0,
					BackgroundColor3 = themes.preset.outline
				})

				library:apply_theme(line, "outline", "BackgroundColor3")

				data.main_instance = button
				data.main_line = line
				data.priority = "Neutral"
				data.priority_text = priority_text

				library:connection(button.MouseButton1Click, function()
					if selected_button then
						selected_button.TextColor3 = themes.preset.text
					end

					library:sound(library.sound_settings.sound_type, library.sound_settings.sound_volume)

					selected_button = player_name
					player_name.TextColor3 = themes.preset.accent

					library.selected_player = player_name.Text
					library.config_flags["PLAYERLIST_DROPDOWN"](data.priority_text.Text)

					local target = players:FindFirstChild(player_name.Text)

					if not target then
						return
					end

					local display = target.Name

					if target.DisplayName ~= target.Name then
						display = target.DisplayName .. " (@" .. target.Name .. ")"
					end

					cfg.labels.name.set("Player: " .. display)

					local function child(parent, name)
						return parent and parent:FindFirstChild(name)
					end

					local statistics = child(child(child(child(rs:FindFirstChild("Players"), target.Name), "Status"), "Journey"), "Statistics")
					local kills = statistics and statistics:GetAttribute("Kills") or 0
					local deaths = statistics and statistics:GetAttribute("Deaths") or 0
					local time_played = statistics and statistics:GetAttribute("TimePlayed") or 0
					local kd = deaths == 0 and kills or kills / deaths
					local hours = math.floor(time_played / 3600 * 100) / 100

					cfg.labels.display.set("User ID: " .. target.UserId .. " / KD: " .. string.format("%.2f", kd) .. " / Hours Played: " .. hours .. "h")

					library.priority_dropdown.set_element_visible(target ~= lp)
				end)

				return data
			end

			function cfg.search(text)
				for name, data in pairs(library.playerlist_data) do
					if type(data) == "table" and data.main_instance then
						local visible = string.lower(tostring(name)):match(string.lower(text)) and true or false
						data.main_instance.Visible = visible
						data.main_line.Visible = visible
					end
				end
			end

			function cfg.remove_player(player)
				local data = library.playerlist_data[tostring(player)]

				if data then
					data.main_instance:Destroy()
					data.main_line:Destroy()
				end
			end

			function library.prioritize(text)
				if not library.selected_player then
					return
				end

				local data = library.playerlist_data[library.selected_player]
				data.priority_text.Text = text
				data.priority_text.TextColor3 = patterns[text]
				data.priority = text
			end

			function library.get_priority(player)
				local data = library.playerlist_data[tostring(player)]

				if data then
					return data.priority
				end
			end

			library:connection(players.PlayerAdded, cfg.create_player)
			library:connection(players.PlayerRemoving, cfg.remove_player)

			for _, player in pairs(players:GetPlayers()) do
				insert(library.playerlist_data, cfg.create_player(player.Name))
			end

			self:textbox({
				name = "Search",
				max = 20,
				placeholder = "Type here...",
				callback = function(text)
					cfg.search(text)
				end
			})

			cfg.labels.name = self:label({ name = " " })
			cfg.labels.display = self:label({ name = " " })

			return setmetatable(cfg, library)
		end

		function library:make_panel(opts)
			opts = opts or {}
			local panel = {}

			panel.window = library:create("Frame", {
				Parent = opts.parent or sgui,
				Name = "",
				Position = opts.position or dim2(0, 400, 0, 300),
				BorderColor3 = rgb(0, 0, 0),
				Size = opts.size or dim2(0, 200, 0, 120),
				BorderSizePixel = 0,
				Visible = opts.visible == true,
				Active = true,
				AutomaticSize = opts.automatic_size or Enum.AutomaticSize.None,
				BackgroundColor3 = themes.preset.outline
			}) library:apply_theme(panel.window, "outline", "BackgroundColor3")
			library:draggify(panel.window)

			if opts.resizable then
				library:make_resizable(panel.window)
			end

			if opts.glow then
				panel.glow = library:create("ImageLabel", {
					Parent = panel.window,
					Name = "",
					ImageColor3 = themes.preset.glow,
					ScaleType = Enum.ScaleType.Slice,
					BorderColor3 = rgb(0, 0, 0),
					BackgroundColor3 = rgb(255, 255, 255),
					Visible = true,
					Image = library.images.Glow4,
					BackgroundTransparency = 1,
					ImageTransparency = 0.8,
					Position = dim2(0, -20, 0, -20),
					Size = dim2(1, 40, 1, 40),
					ZIndex = 0,
					BorderSizePixel = 0,
					SliceCenter = rect(vec2(21, 21), vec2(79, 79))
				}) library:apply_theme(panel.glow, "glow", "ImageColor3")
			end

			local inline = library:create("Frame", {
				Parent = panel.window,
				Name = "",
				Position = dim2(0, 1, 0, 1),
				BorderColor3 = rgb(0, 0, 0),
				Size = dim2(1, -2, 1, -2),
				BorderSizePixel = 0,
				BackgroundColor3 = themes.preset.inline
			}) library:apply_theme(inline, "inline", "BackgroundColor3")

			local background = library:create("Frame", {
				Parent = inline,
				Name = "",
				Position = dim2(0, 1, 0, 1),
				BorderColor3 = rgb(0, 0, 0),
				Size = dim2(1, -2, 1, -2),
				BorderSizePixel = 0,
				BackgroundColor3 = rgb(255, 255, 255)
			}) panel.background = background

			library:create("UIGradient", {
				Parent = background,
				Rotation = 90,
				Color = rgbseq{rgbkey(0, themes.preset.high_contrast), rgbkey(1, themes.preset.low_contrast)}
			})

			panel.accent = library:create("Frame", {
				Parent = background,
				Name = "",
				BorderColor3 = rgb(0, 0, 0),
				Size = dim2(1, 0, 0, 1),
				BorderSizePixel = 0,
				ZIndex = 4,
				BackgroundColor3 = themes.preset.accent
			}) library:apply_theme(panel.accent, "accent", "BackgroundColor3")

			if opts.title then
				panel.title = library:create("TextLabel", {
					Parent = background,
					Name = "",
					FontFace = library.font,
					TextColor3 = themes.preset.text,
					BorderColor3 = rgb(0, 0, 0),
					Text = opts.title,
					Size = dim2(1, -12, 0, 12),
					Position = dim2(0, 6, 0, 4),
					BackgroundTransparency = 1,
					TextXAlignment = Enum.TextXAlignment.Left,
					BorderSizePixel = 0,
					ZIndex = 5,
					TextSize = 12
				})
			end

			panel.holder = library:create("Frame", {
				Parent = background,
				Name = "",
				Position = dim2(0, 6, 0, opts.title and 20 or 6),
				BorderColor3 = rgb(0, 0, 0),
				Size = dim2(1, -12, 1, opts.title and -26 or -12),
				BorderSizePixel = 0,
				BackgroundTransparency = 1,
				BackgroundColor3 = rgb(255, 255, 255)
			})

			library:create("UIListLayout", {
				Parent = panel.holder,
				Padding = dim(0, opts.padding or 4),
				SortOrder = Enum.SortOrder.LayoutOrder
			})

			return panel
		end

		function library:splitter(options)
			options = options or {}
			local cfg = {
				offset = options.offset or 0
			}

			local holder = library:create("Frame", {
				Parent = self.holder,
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				Size = dim2(1, -9, 0, 8),
				ZIndex = 2
			})

			local outline = library:create("Frame", {
				Parent = holder,
				BorderSizePixel = 0,
				Size = dim2(1, 0, 0, 4),
				Position = dim2(0, -1 + cfg.offset, 0, 3),
				BackgroundColor3 = themes.preset.outline
			}) library:apply_theme(outline, "outline", "BackgroundColor3")

			local inline = library:create("Frame", {
				Parent = outline,
				BorderSizePixel = 0,
				Size = dim2(1, -2, 1, -2),
				Position = dim2(0, 1, 0, 1),
				BackgroundColor3 = themes.preset.inline
			}) library:apply_theme(inline, "inline", "BackgroundColor3")

			library:create("UIGradient", {
				Parent = inline,
				Rotation = 90,
				Color = rgbseq({rgbkey(0, rgb(255, 255, 255)), rgbkey(1, rgb(167, 167, 167))})
			})

			cfg.holder = holder

			return setmetatable(cfg, library)
		end

		function library:target_viewer()
			local settings = library.indicator_settings
			local cfg = {}

			local function text_label(props)
				local label = library:create("TextLabel", props)
				library:apply_theme(label, "text", "TextColor3")
				return label
			end

			cfg.outline = library:create("Frame", {
				Parent = sgui,
				Visible = false,
				Position = dim2(0, 50, 0, 90),
				Size = dim2(0, 250, 0, 100),
				BorderSizePixel = 0,
				BackgroundColor3 = themes.preset.outline
			}) library:apply_theme(cfg.outline, "outline", "BackgroundColor3")
			library:draggify(cfg.outline)
			library.player_indicator_frame = cfg.outline

			cfg.inline = library:create("Frame", {
				Position = dim2(0, 1, 0, 1),
				Size = dim2(1, -2, 1, -2),
				BorderSizePixel = 0,
				BackgroundColor3 = themes.preset.inline,
				Parent = cfg.outline
			}) library:apply_theme(cfg.inline, "inline", "BackgroundColor3")

			cfg.background = library:create("Frame", {
				Position = dim2(0, 1, 0, 1),
				Size = dim2(1, -2, 1, -2),
				BorderSizePixel = 0,
				BackgroundColor3 = rgb(200, 200, 200),
				Parent = cfg.inline
			})

			cfg.gradient = library:create("UIGradient", {
				Rotation = 90,
				Color = rgbseq({rgbkey(0, themes.preset.high_contrast), rgbkey(1, themes.preset.low_contrast)}),
				Parent = cfg.background
			}) library:apply_theme(cfg.gradient, "contrast", "Color")

			cfg.inner_inline = library:create("Frame", {
				Position = dim2(0, 3, 0, 3),
				Size = dim2(1, -6, 1, -6),
				BorderSizePixel = 0,
				BackgroundColor3 = themes.preset.inline,
				Parent = cfg.background
			}) library:apply_theme(cfg.inner_inline, "inline", "BackgroundColor3")

			cfg.inner_background = library:create("Frame", {
				Position = dim2(0, 1, 0, 1),
				Size = dim2(1, -2, 1, -2),
				BorderSizePixel = 0,
				BackgroundColor3 = rgb(255, 255, 255),
				Parent = cfg.inner_inline
			})

			cfg.inner_gradient = library:create("UIGradient", {
				Rotation = 90,
				Color = rgbseq({rgbkey(0, themes.preset.high_contrast), rgbkey(1, themes.preset.low_contrast)}),
				Parent = cfg.inner_background
			}) library:apply_theme(cfg.inner_gradient, "contrast", "Color")

			cfg.accent_line = library:create("Frame", {
				Size = dim2(1, 0, 0, 2),
				BorderSizePixel = 0,
				BackgroundColor3 = themes.preset.accent,
				Parent = cfg.inner_background
			}) library:apply_theme(cfg.accent_line, "accent", "BackgroundColor3")

			cfg.accent_gradient = library:create("UIGradient", {
				Rotation = 90,
				Color = rgbseq({rgbkey(0, rgb(255, 255, 255)), rgbkey(1, rgb(167, 167, 167))}),
				Parent = cfg.accent_line
			})

			cfg.healthbar_outline = library:create("Frame", {
				Position = dim2(0, 86, 0, 72),
				Size = dim2(0, 149, 0, 13),
				BorderSizePixel = 0,
				BackgroundColor3 = themes.preset.inline,
				Parent = cfg.inner_background
			}) library:apply_theme(cfg.healthbar_outline, "inline", "BackgroundColor3")

			cfg.healthbar_inline = library:create("Frame", {
				Position = dim2(0, 1, 0, 1),
				Size = dim2(1, -2, 1, -2),
				BorderSizePixel = 0,
				BackgroundColor3 = themes.preset.outline,
				Parent = cfg.healthbar_outline
			}) library:apply_theme(cfg.healthbar_inline, "outline", "BackgroundColor3")

			cfg.healthbar = library:create("Frame", {
				Position = dim2(0, 1, 0, 1),
				Size = dim2(1, -2, 1, -2),
				BorderSizePixel = 0,
				BackgroundColor3 = rgb(124, 255, 139),
				Parent = cfg.healthbar_inline
			})

			cfg.healthbar_gradient = library:create("UIGradient", {
				Rotation = 90,
				Color = rgbseq({rgbkey(0, rgb(255, 255, 255)), rgbkey(1, rgb(167, 167, 167))}),
				Parent = cfg.healthbar
			})

			cfg.health_flag = text_label({
				FontFace = library.fonts["Smallest Pixel"],
				Text = "100/100",
				TextXAlignment = Enum.TextXAlignment.Right,
				TextSize = 9,
				TextColor3 = themes.preset.text,
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				Size = dim2(0, 0, 0, 0),
				Position = dim2(1, -1, 0, 3),
				Parent = cfg.healthbar
			})

			cfg.image = library:create("ImageLabel", {
				ImageColor3 = rgb(224, 224, 224),
				ResampleMode = Enum.ResamplerMode.Pixelated,
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				Position = dim2(0, 4, 0, 6),
				Size = dim2(0, 78, 0, 78),
				Parent = cfg.inner_background
			})

			cfg.image_outline = library:create("UIStroke", {
				Parent = cfg.image,
				Color = themes.preset.inline,
				BorderStrokePosition = Enum.BorderStrokePosition.Outer,
				LineJoinMode = Enum.LineJoinMode.Miter
			}) library:apply_theme(cfg.image_outline, "inline", "Color")

			cfg.image_inline = library:create("UIStroke", {
				Parent = cfg.image,
				Color = themes.preset.outline,
				BorderStrokePosition = Enum.BorderStrokePosition.Inner,
				LineJoinMode = Enum.LineJoinMode.Miter
			}) library:apply_theme(cfg.image_inline, "outline", "Color")

			local function row(name, text, value, y, size)
				cfg[name .. "_text"] = text_label({
					FontFace = library.font,
					Text = text,
					TextXAlignment = Enum.TextXAlignment.Left,
					TextSize = 12,
					TextColor3 = themes.preset.text,
					BackgroundTransparency = 1,
					BorderSizePixel = 0,
					Size = size or dim2(0, 0, 0, 0),
					Position = dim2(0, 87, 0, y),
					Parent = cfg.inner_background
				})
				cfg[name .. "_value"] = text_label({
					FontFace = library.font,
					Text = value,
					TextXAlignment = Enum.TextXAlignment.Right,
					TextSize = 12,
					TextColor3 = themes.preset.text,
					BackgroundTransparency = 1,
					BorderSizePixel = 0,
					Size = dim2(0, 0, 0, 0),
					Position = dim2(0, 148, 0, 0),
					Parent = cfg[name .. "_text"]
				})
			end

			row("user", "user", "username", 10)
			row("kd", "kd", "0.00", 24, dim2(0, 148, 0, 0))
			row("time", "play time", "0.00h", 38)
			row("tool", "tool", "none", 52)
			row("status", "status", "visible", 52)
			cfg.status_text.Visible = false

			local default_image = "rbxassetid://100202384547792"
			local active_tween
			local viewer = {
				connections = {},
				current_model = nil,
				last_time = 0,
			}

			function viewer.set_visible(bool)
				cfg.outline.Visible = bool
			end

			local function health_color(ratio)
				local high, low = settings.high, settings.low
				return rgb(
					math.floor(low.R * 255 + (high.R - low.R) * 255 * ratio),
					math.floor(low.G * 255 + (high.G - low.G) * 255 * ratio),
					math.floor(low.B * 255 + (high.B - low.B) * 255 * ratio)
				)
			end

			local function set_health(health, max_health)
				local ratio = math.clamp(health / max_health, 0.01, 1)
				cfg.health_flag.Text = string.format("%d/%d", health, max_health)
				cfg.healthbar.Size = dim2(ratio, -2, 1, -2)
				cfg.healthbar.BackgroundColor3 = health_color(ratio)
			end

			local function tween_health(old_health, health, max_health)
				if active_tween then
					active_tween:Cancel()
					active_tween = nil
				end
				local from = math.clamp(old_health / max_health, 0.01, 1)
				local to = math.clamp(health / max_health, 0.01, 1)
				cfg.healthbar.Size = dim2(from, -2, 1, -2)
				cfg.healthbar.BackgroundColor3 = health_color(to)
				local tween = tween_service:Create(cfg.healthbar, TweenInfo.new(settings.time, settings.style, settings.direction), {Size = dim2(to, -2, 1, -2)})
				active_tween = tween
				tween:Play()
				cfg.health_flag.Text = string.format("%d/%d", health, max_health)
			end

			function viewer.refresh_healthbar()
				local model = viewer.current_model
				if not model then
					return
				end
				local target_humanoid = model:FindFirstChild("Humanoid")
				if target_humanoid then
					set_health(target_humanoid.Health, target_humanoid.MaxHealth)
				end
			end

			local function clear()
				if viewer.connections then
					for _, connection in viewer.connections do
						library:disconnect(connection)
					end
				end
				viewer.connections = {}
				viewer.current_model = nil
			end

			local function thumbnail(player)
				if player then
					local ok, image = pcall(players.GetUserThumbnailAsync, players, player.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size100x100)
					if ok then
						return image
					end
				end
				return default_image
			end

			function viewer.update_target(model)
				local now = tick()
				if now - viewer.last_time < settings.delay then
					return
				end
				viewer.last_time = now
				if viewer.current_model == model then
					return
				end
				local previous_health = 0
				if viewer.current_model then
					local previous_humanoid = viewer.current_model:FindFirstChild("Humanoid")
					previous_health = previous_humanoid and previous_humanoid.Health or 0
				end
				clear()
				if not model then
					viewer.set_visible(false)
					return
				end
				viewer.current_model = model
				local name = model.Name
				local target_humanoid = model:FindFirstChild("Humanoid")
				local player = players:FindFirstChild(name)
				local is_npc = player == nil
				cfg.user_value.Text = name
				viewer.set_visible(true)
				cfg.kd_text.Visible = not is_npc
				cfg.time_text.Visible = not is_npc
				if is_npc then
					cfg.tool_text.Position = dim2(0, 87, 0, 24)
					cfg.status_text.Position = dim2(0, 87, 0, 38)
				else
					cfg.tool_text.Position = dim2(0, 87, 0, 52)
					cfg.status_text.Position = dim2(0, 87, 0, 66)
				end
				task.spawn(function()
					cfg.image.Image = thumbnail(player)
				end)
				if not is_npc then
					local players_folder = replicated_storage:FindFirstChild("Players")
					local node = players_folder and players_folder:FindFirstChild(name)
					local journey = node and node:FindFirstChild("Status") and node.Status:FindFirstChild("Journey")
					local statistics = journey and journey:FindFirstChild("Statistics")
					if statistics then
						local function update_kd()
							local kills = statistics:GetAttribute("Kills") or 0
							local deaths = statistics:GetAttribute("Deaths") or 0
							cfg.kd_value.Text = string.format("%.2f (%d/%d)", util.calculate_kd(statistics), kills, deaths)
						end
						local function update_time()
							cfg.time_value.Text = string.format("%.2fh", (statistics:GetAttribute("TimePlayed") or 0) / 3600)
						end
						update_time()
						update_kd()
						insert(viewer.connections, library:connection(statistics:GetAttributeChangedSignal("Kills"), update_kd))
						insert(viewer.connections, library:connection(statistics:GetAttributeChangedSignal("Deaths"), update_kd))
					end
				end
				local last_health = previous_health
				local function update_health()
					if not target_humanoid then
						return
					end
					local health = target_humanoid.Health
					local max_health = target_humanoid.MaxHealth
					if settings.use_tween then
						tween_health(last_health, health, max_health)
					else
						set_health(health, max_health)
					end
					last_health = health
				end
				local function update_tool(tool_name)
					cfg.tool_value.Text = tool_name or "none"
				end
				local holding = model:FindFirstChild("Holding")
				if holding then
					update_tool(holding.Value and holding.Value.Name or nil)
					insert(viewer.connections, library:connection(holding:GetPropertyChangedSignal("Value"), function()
						local value = holding.Value
						update_tool(typeof(value) == "Instance" and value.Name or nil)
					end))
				end
				if target_humanoid then
					update_health()
					insert(viewer.connections, library:connection(target_humanoid:GetPropertyChangedSignal("Health"), update_health))
					insert(viewer.connections, library:connection(target_humanoid:GetPropertyChangedSignal("MaxHealth"), update_health))
				end
			end

			return viewer
		end

		function library:inventory_viewer()
			local settings = library.inv_configuration
			local structs = {}
			local lines = {}
			local last_view = 0

			local outline = library:create("Frame", {
				Parent = sgui,
				Visible = false,
				Active = true,
				Position = dim2(0, 50, 0, 469),
				Size = dim2(0, 200, 0, 25),
				BorderSizePixel = 0,
				BorderColor3 = rgb(0, 0, 0),
				BackgroundColor3 = themes.preset.outline
			}) library:apply_theme(outline, "outline", "BackgroundColor3")
			library:draggify(outline)
			library:make_resizable(outline)
			library.inventory_viewer_frame = outline

			library:apply_theme(library:create("ImageLabel", {
				Parent = outline,
				ImageColor3 = themes.preset.glow,
				ScaleType = Enum.ScaleType.Slice,
				BorderColor3 = rgb(0, 0, 0),
				Visible = true,
				Image = library.images.Glow4,
				BackgroundTransparency = 1,
				ImageTransparency = 0.8,
				Position = dim2(0, -20, 0, -20),
				Size = dim2(1, 40, 1, 40),
				ZIndex = 0,
				BorderSizePixel = 0,
				SliceCenter = Rect.new(Vector2.new(21, 21), Vector2.new(79, 79))
			}), "glow", "ImageColor3")

			local inline = library:create("Frame", {
				Parent = outline,
				Position = dim2(0, 1, 0, 1),
				Size = dim2(1, -2, 1, -2),
				BorderSizePixel = 0,
				BorderColor3 = rgb(0, 0, 0),
				BackgroundColor3 = themes.preset.inline
			}) library:apply_theme(inline, "inline", "BackgroundColor3")

			local background = library:create("Frame", {
				Parent = inline,
				Position = dim2(0, 1, 0, 1),
				Size = dim2(1, -2, 1, -2),
				BorderSizePixel = 0,
				BorderColor3 = rgb(0, 0, 0),
				BackgroundColor3 = rgb(255, 255, 255)
			})

			library:apply_theme(library:create("UIGradient", {
				Parent = background,
				Rotation = 90,
				Color = rgbseq({rgbkey(0, themes.preset.high_contrast), rgbkey(1, themes.preset.low_contrast)})
			}), "contrast", "Color")

			local accent = library:create("Frame", {
				Parent = background,
				Size = dim2(1, 0, 0, 2),
				BorderSizePixel = 0,
				BorderColor3 = rgb(0, 0, 0),
				BackgroundColor3 = themes.preset.accent
			}) library:apply_theme(accent, "accent", "BackgroundColor3")

			library:create("UIGradient", {
				Parent = accent,
				Enabled = true,
				Rotation = 90,
				Color = rgbseq({rgbkey(0, rgb(255, 255, 255)), rgbkey(1, rgb(167, 167, 167))})
			})

			local title = library:create("TextLabel", {
				Parent = background,
				FontFace = library.font,
				Text = "No one's Inventory",
				TextSize = 12,
				TextColor3 = themes.preset.text,
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				TextTruncate = Enum.TextTruncate.AtEnd,
				Size = dim2(1, 0, 1, 0)
			}) library:apply_theme(title, "text", "TextColor3")

			library:create("UIStroke", {
				Parent = title,
				LineJoinMode = Enum.LineJoinMode.Miter
			})

			local items_outline = library:create("Frame", {
				Parent = background,
				Position = dim2(0, -2, 1, 1),
				Size = dim2(1, 4, 0, 0),
				AutomaticSize = Enum.AutomaticSize.Y,
				BorderSizePixel = 0,
				BorderColor3 = rgb(0, 0, 0),
				Visible = false,
				BackgroundColor3 = themes.preset.outline
			}) library:apply_theme(items_outline, "outline", "BackgroundColor3")

			local items_inline = library:create("Frame", {
				Parent = items_outline,
				Position = dim2(0, 1, 0, 1),
				Size = dim2(1, -2, 1, -2),
				BorderSizePixel = 0,
				BorderColor3 = rgb(0, 0, 0),
				BackgroundColor3 = themes.preset.inline
			}) library:apply_theme(items_inline, "inline", "BackgroundColor3")

			local items_background = library:create("Frame", {
				Parent = items_inline,
				Position = dim2(0, 1, 0, 1),
				Size = dim2(1, -2, 1, -2),
				BorderSizePixel = 0,
				BackgroundColor3 = rgb(255, 255, 255)
			})

			library:apply_theme(library:create("UIGradient", {
				Parent = items_background,
				Rotation = 90,
				Color = rgbseq({rgbkey(0, themes.preset.high_contrast), rgbkey(1, themes.preset.low_contrast)})
			}), "contrast", "Color")

			library:create("UIListLayout", {
				Parent = items_background,
				Padding = dim(0, -1),
				SortOrder = Enum.SortOrder.LayoutOrder
			})

			library:create("UIPadding", {
				Parent = items_background,
				PaddingTop = dim(0, 4),
				PaddingBottom = dim(0, 5),
				PaddingLeft = dim(0, 4)
			})

			local items_text = library:create("TextLabel", {
				Parent = items_background,
				FontFace = library.font,
				Text = "",
				TextSize = 12,
				TextColor3 = themes.preset.text,
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				RichText = true,
				TextXAlignment = Enum.TextXAlignment.Left,
				TextYAlignment = Enum.TextYAlignment.Center,
				AutomaticSize = Enum.AutomaticSize.Y,
				Size = dim2(1, -10, 0, 0)
			}) library:apply_theme(items_text, "text", "TextColor3")

			local viewer = {}

			function viewer.set_visible(bool)
				outline.Visible = bool
				settings.enabled = bool
			end

			function viewer.clear_list()
				table.clear(structs)
				table.clear(lines)
				items_text.Text = ""
			end

			function viewer.add_line_struct(line_type, data, indent, section)
				structs[#structs + 1] = {line_type = line_type, data = data, indent = indent, section = section}
			end

			function viewer.build_stacks(source)
				local stacks = {}
				local children = typeof(source) == "Instance" and source:GetChildren() or source
				for _, item in children do
					local name = item.Name
					local amount = item:GetAttribute("Amount") or 1
					if not stacks[name] then
						stacks[name] = {stack_count = 0, total_amount = 0, name = name}
					end
					local stack = stacks[name]
					stack.stack_count = stack.stack_count + 1
					stack.total_amount = stack.total_amount + amount
				end
				return stacks
			end

			function viewer.render()
				table.clear(lines)
				local colors = settings.colors
				local sections = settings.sections or {"Hotbar", "Armor", "Miscellaneous", "Containers"}
				for _, struct in structs do
					if struct.line_type == "section" and not table.find(sections, struct.section or struct.data) then
						continue
					end
					if struct.line_type ~= "section" and struct.section and not table.find(sections, struct.section) then
						continue
					end
					local indent = string.rep("    ", struct.indent)
					if struct.line_type == "section" then
						lines[#lines + 1] = "<font color='" .. colors.section_title .. "'>" .. struct.data .. "</font>"
					elseif struct.line_type == "hotbar_item" then
						lines[#lines + 1] = indent .. "<font color='" .. colors.item_name .. "'>" .. struct.data .. "</font>"
					elseif struct.line_type == "stack" then
						local text = indent
						if struct.data.stack_count > 1 then
							text = text .. "<font color='" .. colors.stack .. "'>[" .. struct.data.stack_count .. "x]</font> "
						end
						text = text .. "<font color='" .. colors.item_name .. "'>" .. struct.data.name .. "</font>"
						if struct.data.total_amount > 1 then
							text = text .. " <font color='" .. colors.amount .. "'>(" .. struct.data.total_amount .. "x)</font>"
						end
						lines[#lines + 1] = text
					end
				end
				items_text.Text = table.concat(lines, "\n")
			end

			function viewer.view(name)
				local now = tick()
				if now - last_view < settings.delay then
					return
				end
				last_view = now
				viewer.clear_list()
				local players_folder = replicated_storage:FindFirstChild("Players")
				local node = players_folder and players_folder:FindFirstChild(name)
				if not node then
					title.Text = "No one's Inventory"
					items_outline.Visible = false
					return
				end
				title.Text = name .. "'s Inventory"
				local inventory = node:FindFirstChild("Inventory")
				if not inventory then
					items_outline.Visible = false
					return
				end
				local hotbar, armor, misc = {}, {}, {}
				for _, item in inventory:GetChildren() do
					local slot = item:GetAttribute("Slot")
					if slot == "ClothingHeadware" or slot == "ClothingChestRig" or slot == "ClothingGloves" or slot == "ClothingMask" or slot == "ClothingBackpack" or slot == "ClothingLegArmor" then
						armor[#armor + 1] = item
					elseif slot == "EquipmentGPS" or slot == "EquipmentCompass" or slot == "EquipmentLighter" or slot == "EquipmentMap" then
						misc[#misc + 1] = item
					elseif item.Name ~= "DV2" and item.Name ~= "Lighter" and item.Name ~= "Radio" and item.Name ~= "EstonianBorderMap" and not item:FindFirstChild("Inventory") then
						hotbar[#hotbar + 1] = item.Name
					end
				end
				local sections = settings.sections
				local function section_enabled(section)
					for _, enabled in sections do
						if enabled:lower() == section:lower() then
							return true
						end
					end
					return false
				end
				if #hotbar > 0 and section_enabled("Hotbar") then
					viewer.add_line_struct("section", "Hotbar", 0, "Hotbar")
					for _, item_name in hotbar do
						viewer.add_line_struct("hotbar_item", item_name, 1, "Hotbar")
					end
				end
				if #armor > 0 and section_enabled("Armor") then
					viewer.add_line_struct("section", "Armor", 0, "Armor")
					for _, stack in viewer.build_stacks(armor) do
						viewer.add_line_struct("stack", stack, 1, "Armor")
					end
				end
				if #misc > 0 and section_enabled("Miscellaneous") then
					viewer.add_line_struct("section", "Miscellaneous", 0, "Miscellaneous")
					for _, stack in viewer.build_stacks(misc) do
						viewer.add_line_struct("stack", stack, 1, "Miscellaneous")
					end
				end
				for _, item in inventory:GetChildren() do
					local contents = item:FindFirstChild("Inventory")
					if contents and section_enabled("Containers") then
						viewer.add_line_struct("section", item.Name, 0, "Containers")
						for _, stack in viewer.build_stacks(contents) do
							viewer.add_line_struct("stack", stack, 1, "Containers")
						end
					end
				end
				items_outline.Visible = true
				viewer.render()
			end

			return viewer
		end

		function library:session_data()
			local cfg = {}

			cfg.outline = library:create("Frame", {
				Parent = sgui,
				Visible = false,
				Position = dim2(0, 50, 0, 200),
				Size = dim2(0, 170, 0, 31),
				BorderSizePixel = 0,
				AutomaticSize = Enum.AutomaticSize.Y,
				BackgroundColor3 = themes.preset.outline
			}) library:apply_theme(cfg.outline, "outline", "BackgroundColor3")
			library:draggify(cfg.outline)
			library.session_data_frame = cfg.outline

			cfg.inline = library:create("Frame", {
				Position = dim2(0, 1, 0, 1),
				Size = dim2(1, -2, 1, -2),
				BorderSizePixel = 0,
				BackgroundColor3 = themes.preset.inline,
				Parent = cfg.outline
			}) library:apply_theme(cfg.inline, "inline", "BackgroundColor3")

			cfg.background = library:create("Frame", {
				Position = dim2(0, 1, 0, 1),
				Size = dim2(1, -2, 1, -2),
				BorderSizePixel = 0,
				BackgroundColor3 = rgb(200, 200, 200),
				Parent = cfg.inline
			})

			cfg.gradient = library:create("UIGradient", {
				Rotation = 90,
				Color = rgbseq({rgbkey(0, themes.preset.high_contrast), rgbkey(1, themes.preset.low_contrast)}),
				Parent = cfg.background
			}) library:apply_theme(cfg.gradient, "contrast", "Color")

			cfg.inner_inline = library:create("Frame", {
				Position = dim2(0, 3, 0, 3),
				Size = dim2(1, -6, 1, -6),
				BorderSizePixel = 0,
				BackgroundColor3 = themes.preset.inline,
				Parent = cfg.background
			}) library:apply_theme(cfg.inner_inline, "inline", "BackgroundColor3")

			cfg.accent_line = library:create("Frame", {
				Size = dim2(1, -2, 0, 2),
				Position = dim2(0, 1, 0, 1),
				BorderSizePixel = 0,
				BackgroundColor3 = themes.preset.accent,
				ZIndex = 2,
				Parent = cfg.inner_inline
			}) library:apply_theme(cfg.accent_line, "accent", "BackgroundColor3")

			cfg.accent_gradient = library:create("UIGradient", {
				Rotation = 90,
				Color = rgbseq({rgbkey(0, rgb(255, 255, 255)), rgbkey(1, rgb(167, 167, 167))}),
				Parent = cfg.accent_line
			})

			cfg.inner_background = library:create("Frame", {
				Position = dim2(0, 1, 0, 1),
				Size = dim2(1, -2, 1, -2),
				BorderSizePixel = 0,
				BackgroundColor3 = rgb(255, 255, 255),
				Parent = cfg.inner_inline
			})

			cfg.inner_gradient = library:create("UIGradient", {
				Rotation = 90,
				Color = rgbseq({rgbkey(0, themes.preset.high_contrast), rgbkey(1, themes.preset.low_contrast)}),
				Parent = cfg.inner_background
			}) library:apply_theme(cfg.inner_gradient, "contrast", "Color")

			library:create("UIListLayout", {
				Padding = dim(0, 5),
				SortOrder = Enum.SortOrder.LayoutOrder,
				Parent = cfg.inner_background
			})

			library:create("UIPadding", {
				PaddingTop = dim(0, 4),
				PaddingBottom = dim(0, 10),
				PaddingLeft = dim(0, 4),
				Parent = cfg.inner_background
			})

			local value_gradient = rgbseq({rgbkey(0, rgb(230, 230, 230)), rgbkey(1, rgb(230, 230, 230))})
			local text_props = {
				FontFace = library.font,
				TextSize = 12,
				TextColor3 = themes.preset.text,
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				Size = dim2(0, 0, 0, 11),
				Position = dim2(0, 0, 0, 0)
			}

			function cfg.update_visibility(key, bool)
				local element = cfg[key]
				if element then
					element.Visible = bool
				end
			end

			function cfg.update_flag(key, property, value)
				util:set_property(cfg[key], property, value)
			end

			function cfg.create_label(text_key, text, value_key, value, order)
				local label_props = table.clone(text_props)
				label_props.Text = text
				label_props.TextXAlignment = Enum.TextXAlignment.Left
				label_props.LayoutOrder = order
				label_props.Visible = false
				label_props.Parent = cfg.inner_background
				cfg[text_key] = library:create("TextLabel", label_props)
				library:apply_theme(cfg[text_key], "text", "TextColor3")

				local value_props = table.clone(text_props)
				value_props.Text = value
				value_props.TextXAlignment = Enum.TextXAlignment.Right
				value_props.Position = dim2(0, 151, 0, 0)
				value_props.Parent = cfg[text_key]
				cfg[value_key] = library:create("TextLabel", value_props)
				library:apply_theme(cfg[value_key], "text", "TextColor3")
				library:create("UIGradient", {Color = value_gradient, Parent = cfg[value_key]})
			end

			cfg.create_label("players_text", "players", "players_value", "0/30", 1)
			cfg.create_label("time_text", "time", "time_value", "00:00:00", 2)
			cfg.create_label("weather_text", "weather", "weather_value", "raining", 3)
			cfg.create_label("visor_text", "visor", "visor_value", "false", 4)
			cfg.create_label("kd_text", "kd", "kd_value", "0.00", 5)
			cfg.create_label("kills_text", "kills", "kills_value", "0", 6)
			cfg.create_label("deaths_text", "deaths", "deaths_value", "0", 7)

			function cfg.set_visible(bool)
				cfg.outline.Visible = bool
			end

			return cfg
		end

		function library:keybind_list(options)
			options = options or {}
			local cfg = {binds = {}}

			local panel = library:make_panel({
				parent = sgui,
				position = options.position or dim2(0, 10, 0, 300),
				size = options.size or dim2(0, 150, 0, 24),
				automatic_size = Enum.AutomaticSize.Y,
				title = options.title or "Keybinds",
				padding = 3
			})
			cfg.window = panel.window
			library.keybind_list = cfg

			function cfg.add_bind(name, key)
				local row = library:create("Frame", {
					Parent = panel.holder,
					Name = "",
					BorderColor3 = rgb(0, 0, 0),
					Size = dim2(1, 0, 0, 12),
					BorderSizePixel = 0,
					BackgroundTransparency = 1,
					BackgroundColor3 = rgb(255, 255, 255)
				})

				library:create("TextLabel", {
					Parent = row,
					Name = "",
					FontFace = library.font,
					TextColor3 = themes.preset.text,
					BorderColor3 = rgb(0, 0, 0),
					Text = tostring(name),
					BackgroundTransparency = 1,
					TextXAlignment = Enum.TextXAlignment.Left,
					Size = dim2(0.7, 0, 1, 0),
					BorderSizePixel = 0,
					TextSize = 12,
					BackgroundColor3 = rgb(255, 255, 255)
				})

				local key_label = library:create("TextLabel", {
					Parent = row,
					Name = "",
					FontFace = library.font,
					TextColor3 = themes.preset.accent,
					BorderColor3 = rgb(0, 0, 0),
					Text = "[" .. tostring(key) .. "]",
					BackgroundTransparency = 1,
					TextXAlignment = Enum.TextXAlignment.Right,
					Position = dim2(0.7, 0, 0, 0),
					Size = dim2(0.3, 0, 1, 0),
					BorderSizePixel = 0,
					TextSize = 12,
					BackgroundColor3 = rgb(255, 255, 255)
				}) library:apply_theme(key_label, "accent", "TextColor3")

				local bind = {
					instance = row,
					set_key = function(new_key) key_label.Text = "[" .. tostring(new_key) .. "]" end,
					set_visible = function(bool) row.Visible = bool end,
					destroy = function() row:Destroy() end
				}
				cfg.binds[name] = bind
				return bind
			end

			function cfg.remove_bind(name)
				if cfg.binds[name] then
					cfg.binds[name].destroy()
					cfg.binds[name] = nil
				end
			end

			function cfg.set_visible(bool)
				panel.window.Visible = bool
			end

			return setmetatable(cfg, library)
		end

return library, themes;
end

local function build_menu()
local ok
ok, library, themes = pcall(function()
    local path = config.ui_path
    if type(path) == "string" and isfile and isfile(path) then
        return loadstring(readfile(path))()
    end
    return embedded_ui()
end)
if not ok or type(library) ~= "table" then
    warn("[backtrack] failed to load ui: " .. tostring(library))
    return
end

local window = library:window({ name = os.date("ShitHax.cc - %b %d %Y"), size = dim2(0, 750, 0, 782) })

panels.target_viewer = library:target_viewer()
panels.inventory_viewer = library:inventory_viewer()
panels.session_data = library:session_data()
panels.target_viewer.set_visible(false)
panels.inventory_viewer.set_visible(false)
panels.session_data.set_visible(false)
panels.indicator = library.indicator_settings
panels.inv_configuration = library.inv_configuration

local combat_tab = window:tab({ name = "Combat" })
local players_tab = window:tab({ name = "Players" })
local misc_tab = window:tab({ name = "Misc" })
local visuals_tab = window:tab({ name = "Visuals" })

local combat_col1 = combat_tab:column()
local combat_col2 = combat_tab:column()
local combat_col3 = combat_col2:column()
local aiming_pane, combat_visuals_pane = combat_col1:multi_section({ names = { "Aiming", "Visualization" } })
local other_pane = combat_col2:section({ name = "Other" })
local weapon_mods = combat_col3:section({ name = "Weapon Modifications" })

local players_col1 = players_tab:column()
local players_col2 = players_tab:column()
local players_col3 = players_col2:column()
local esp_players, esp_npc, esp_other = players_col1:multi_section({ names = { "Players", "NPC", "Other" } })
local esp_preview = players_col2:section({ name = "ESP Preview" })
local esp_options = players_col3:section({ name = "Options" })

local misc_col1 = misc_tab:column()
local misc_col2 = misc_tab:column()
local misc_col3 = misc_col2:column()
local movement, exploits = misc_col1:multi_section({ names = { "Movement", "Exploits" } })
local local_pane, chat_pane = misc_col2:multi_section({ names = { "Local", "Chat" } })
local replication, visualization = misc_col3:multi_section({ names = { "Replication", "Visualization" } })

local visuals_col1 = visuals_tab:column()
local visuals_col2 = visuals_tab:column()
local visuals_col3 = visuals_col2:column()
local notifiers = visuals_col1:section({ name = "Notifiers", toggle = false })
local world_pane, lighting_pane = visuals_col2:multi_section({ names = { "World", "Lighting" } })
local viewmodel_pane, local_self_pane, crosshair_pane = visuals_col3:multi_section({ names = { "Viewmodel", "Local", "Crosshair" } })

visuals.create_fov()
visuals.create_sline()
visuals.create_crosshair()

local aim = config.combat.aiming
local cv = config.combat.visualization
local mods = config.combat.gun_mods
local rv = config.combat.resolvers

aiming_pane:toggle({
    name = "Silent Aim",
    flag = "silent_aim",
    callback = function(v)
        aim.silent_aim = v
        visuals.update_snapline()
    end,
}):configuration({ name = "Silent Aim Options" }, function(section)
    section:toggle({
        name = "Force Hit",
        flag = "force_hit",
        callback = function(v)
            mods.wallbang = v
        end,
    }):keybind({
        name = "Force Hit",
        flag = "force_hit_bind",
        callback = function(v)
            mods.wallbang = v
        end,
    })
    section:splitter({ offset = 1 })
    section:toggle({
        name = "Target Friendlies",
        flag = "target_friends",
        callback = function(v)
            aim.target_friendlies = v
            visuals.update_snapline()
        end,
    }):keybind({
        name = "Target Friendlies",
        flag = "target_friends_bind",
        callback = function(v)
            aim.target_friendlies = v
            visuals.update_snapline()
        end,
    })
    section:toggle({
        name = "Prioritize Enemies",
        default = true,
        flag = "prioritize_enemies",
        callback = function(v)
            aim.prioritize_enemies = v
            visuals.update_snapline()
        end,
    }):keybind({
        name = "Prioritize Enemies",
        flag = "prioritize_enemies_bind",
        callback = function(v)
            aim.prioritize_enemies = v
            visuals.update_snapline()
        end,
    })
    section:splitter({ offset = 1 })
    section:dropdown({
        name = "Target Sorting Type",
        flag = "target_sorting",
        items = { "Closest To Mouse", "Distance" },
        default = "Closest To Mouse",
        callback = function(v)
            aim.targeting_type = v:lower():gsub("%s+", "_")
        end,
    })
    section:splitter({ offset = 1 })
    section:toggle({
        name = "Target Players",
        flag = "target_players",
        default = true,
        callback = function(v)
            aim.target_players = v
            visuals.update_snapline()
        end,
    }):keybind({
        name = "Target Players",
        flag = "target_players_bind",
        callback = function(v)
            aim.target_players = v
            visuals.update_snapline()
        end,
    })
    section:toggle({
        name = "Target AI",
        default = true,
        flag = "target_ai",
        callback = function(v)
            aim.target_ai = v
            visuals.update_snapline()
        end,
    }):keybind({
        name = "Target AI",
        flag = "target_ai_bind",
        callback = function(v)
            aim.target_ai = v
            visuals.update_snapline()
        end,
    })
    section:toggle({
        name = "Target MI24V Helicopter",
        default = true,
        flag = "target_heli",
        callback = function(v)
            aim.target_heli = v
            visuals.update_snapline()
        end,
    }):keybind({
        name = "Target MI24V",
        flag = "target_heli_bind",
        callback = function(v)
            aim.target_heli = v
            visuals.update_snapline()
        end,
    })
end):keybind({
    name = "Silent Aim",
    flag = "silent_aim_bind",
    callback = function(v)
        aim.silent_aim = v
        visuals.update_snapline()
    end,
})

aiming_pane:toggle({
    name = "Aim Assist",
    flag = "aim_assist",
    callback = function(v)
        aim.aim_assist.enabled = v
        visuals.update_snapline()
    end,
}):configuration({ name = "Aim Assist Options" }, function(section)
    section:dropdown({
        name = "Method",
        flag = "aim_assist_method",
        items = { "Camera", "Mouse" },
        default = "Camera",
        callback = function(v)
            aim.aim_assist.type = v
        end,
    })
    section:slider({
        name = "Smoothing",
        min = 1,
        max = 100,
        default = 20,
        interval = 1,
        flag = "aim_assist_smoothing",
        callback = function(v)
            aim.aim_assist.smoothness = v / 100
            visuals.update_snapline()
        end,
    })
end):keybind({
    name = "Aim Assist",
    mode = "hold",
    flag = "aim_assist_bind",
    callback = function(v)
        aim.aim_assist.bind = v
        if aim.aim_assist.enabled then
            visuals.update_snapline()
        end
    end,
})

aiming_pane:splitter()

aiming_pane:toggle({
    name = "Auto Shoot",
    flag = "auto_shoot",
    callback = function(v)
        aim.auto_shoot.enabled = v
        visuals.update_snapline()
    end,
}):configuration({ name = "Auto Shoot Options" }, function(section)
    section:slider({
        name = "Delay",
        min = 0,
        max = 1,
        default = 0.01,
        suffix = "s",
        interval = 0.01,
        flag = "auto_shoot_delay",
        callback = function(v)
            aim.auto_shoot.delay = v
        end,
    })
    section:slider({
        name = "Scan Rate",
        min = 0.01,
        max = 1,
        default = 0.2,
        suffix = "s",
        interval = 0.01,
        flag = "auto_shoot_rate",
        callback = function(v)
            aim.auto_shoot.interval = v
        end,
    })
end):keybind({
    name = "Auto Shoot",
    flag = "auto_shoot_bind",
    callback = function(v)
        aim.auto_shoot.enabled = v
        visuals.update_snapline()
    end,
})

aiming_pane:splitter()

aiming_pane:toggle({
    name = "Wall Check",
    flag = "wall_check",
    callback = function(v)
        aim.wall_check = v
        visuals.update_snapline()
    end,
}):keybind({
    name = "Wall Check",
    flag = "wall_check_bind",
    callback = function(v)
        aim.wall_check = v
        visuals.update_snapline()
    end,
})

aiming_pane:toggle({
    name = "Dead Check",
    flag = "dead_check",
    callback = function(v)
        aim.dead_check = v
        visuals.update_snapline()
    end,
}):keybind({
    name = "Dead Check",
    flag = "dead_check_bind",
    callback = function(v)
        aim.dead_check = v
        visuals.update_snapline()
    end,
})

aiming_pane:toggle({
    name = "Distance Check",
    flag = "distance_check",
    callback = function(v)
        aim.max_distance.enabled = v
        visuals.update_snapline()
    end,
}):configuration({ name = "Distance Check Options" }, function(section)
    section:slider({
        name = "Maximum Distance",
        min = 1,
        max = 3000,
        default = 1300,
        suffix = "m",
        interval = 1,
        flag = "distance_check_value",
        callback = function(v)
            aim.max_distance.value = v
            visuals.update_snapline()
        end,
    })
end)

aiming_pane:splitter()

aiming_pane:toggle({
    name = "Use FOV",
    default = true,
    flag = "use_fov",
    callback = function(v)
        aim.ignore_fov = not v
    end,
}):keybind({
    name = "Use FOV",
    flag = "use_fov_bind",
    callback = function(v)
        aim.ignore_fov = not v
    end,
})

aiming_pane:slider({
    name = "FOV Radius",
    min = 1,
    max = 1250,
    default = 150,
    interval = 1,
    flag = "fov_radius",
    callback = function(v)
        aim.fov_radius = v
        visuals.update_fov()
    end,
})

aiming_pane:slider({
    name = "Hitchance",
    min = 1,
    max = 100,
    default = 100,
    suffix = "%",
    interval = 1,
    flag = "hit_chance",
    callback = function(v)
        aim.hitchance = v
    end,
})

aiming_pane:dropdown({
    name = "Hitboxes",
    scrolling = true,
    multi = true,
    flag = "hitboxes",
    items = aim.existing_hitboxes,
    default = "Head",
    callback = function(v)
        aim.hitboxes = type(v) == "table" and v or { v }
    end,
})

combat_visuals_pane:toggle({
    name = "Target Indicator",
    flag = "target_indicator",
    callback = function(v)
        panels.indicator.enabled = v
        panels.target_viewer.set_visible(v)
    end,
}):configuration({ name = "Indicator Options" }, function(section)
    section:slider({
        name = "Delay",
        min = 0.1,
        max = 5,
        default = 0.2,
        interval = 0.01,
        flag = "indicator_delay",
        callback = function(v)
            panels.indicator.delay = v
        end,
    })
    section:toggle({
        name = "Animate",
        flag = "animate_indicator",
        callback = function(v)
            panels.indicator.use_tween = v
        end,
    })
    section:slider({
        slider_type = "normal",
        suffix = "s",
        flag = "indicator_time",
        min = 0.05,
        max = 1,
        default = 0.15,
        interval = 0.01,
        callback = function(v)
            panels.indicator.time = v
        end,
    })
    section:dropdown({
        name = "Easing Style",
        scrolling = true,
        flag = "indicator_style",
        items = library.easing_style_index,
        default = "Circular",
        callback = function(v)
            panels.indicator.style = Enum.EasingStyle[v]
        end,
    })
    section:dropdown({
        name = "Direction",
        flag = "indicator_direction",
        items = library.easing_direction_index,
        default = "InOut",
        callback = function(v)
            panels.indicator.direction = Enum.EasingDirection[v]
        end,
    })
end):colorpicker({
    name = "High",
    flag = "indicator_high",
    color = rgb(124, 255, 139),
    alpha = 1,
    callback = function(v)
        panels.indicator.high = v
        panels.target_viewer.refresh_healthbar()
    end,
}):colorpicker({
    name = "Low",
    flag = "indicator_low",
    color = rgb(255, 72, 118),
    alpha = 1,
    callback = function(v)
        panels.indicator.low = v
        panels.target_viewer.refresh_healthbar()
    end,
})

combat_visuals_pane:toggle({
    name = "Inventory Viewer",
    flag = "inventory_viewer",
    callback = function(v)
        panels.inventory_viewer.set_visible(v)
    end,
}):configuration({ name = "Inventory Viewer Options" }, function(section)
    section:label({ name = "Colors" }):colorpicker({
        name = "Section Title Color",
        flag = "section_title_color",
        color = rgb(45, 209, 235),
        alpha = 1,
        callback = function(v)
            panels.inv_configuration.colors.section_title = library:to_hex(v)
            panels.inventory_viewer.render()
        end,
    }):colorpicker({
        name = "Stack Color",
        flag = "stack_color",
        color = rgb(224, 224, 224),
        alpha = 1,
        callback = function(v)
            panels.inv_configuration.colors.stack = library:to_hex(v)
            panels.inventory_viewer.render()
        end,
    }):colorpicker({
        name = "Item Name Color",
        flag = "item_name_color",
        color = rgb(224, 224, 224),
        alpha = 1,
        callback = function(v)
            panels.inv_configuration.colors.item_name = library:to_hex(v)
            panels.inventory_viewer.render()
        end,
    }):colorpicker({
        name = "Amount Color",
        flag = "amount_color",
        color = rgb(224, 224, 224),
        alpha = 1,
        callback = function(v)
            panels.inv_configuration.colors.amount = library:to_hex(v)
            panels.inventory_viewer.render()
        end,
    })
    section:dropdown({
        name = "Inventory Sections",
        multi = true,
        items = { "Hotbar", "Armor", "Miscellaneous", "Containers" },
        default = { "Hotbar", "Armor", "Miscellaneous", "Containers" },
        flag = "inventory_viewer_sections",
        callback = function(v)
            panels.inv_configuration.sections = v
            panels.inventory_viewer.render()
        end,
    })
    section:slider({
        name = "Delay",
        min = 0.25,
        max = 5,
        default = 1,
        interval = 0.01,
        flag = "inventory_viewer_delay",
        callback = function(v)
            panels.inv_configuration.delay = v
        end,
    })
end):keybind({
    name = "Inventory Viewer",
    flag = "inventory_viewer_bind",
    callback = function(v)
        panels.inventory_viewer.set_visible(v)
    end,
})

combat_visuals_pane:splitter()

combat_visuals_pane:toggle({
    name = "Enable FOV",
    flag = "fov_enabled",
    callback = function(v)
        cv.fov_enabled = v
        visuals.update_fov()
    end,
}):configuration({ name = "FOV Options" }, function(section)
    section:slider({
        name = "Thickness",
        min = 1,
        max = 5,
        default = 1,
        interval = 1,
        flag = "fov_thickness",
        callback = function(v)
            cv.thickness = v
            visuals.update_fov()
        end,
    })
    section:toggle({
        name = "Outline",
        flag = "fov_outline",
        callback = function(v)
            cv.fov_outline = v
            visuals.update_fov()
        end,
    }):colorpicker({
        name = "Outline Color",
        flag = "fov_outline_color",
        color = rgb(0, 0, 0),
        alpha = 1,
        callback = function(color, alpha)
            cv.fov_outline_color = color
            cv.fov_outline_transparency = 1 - alpha
            visuals.update_fov()
        end,
    })
    section:toggle({
        name = "FOV Fill",
        flag = "fov_fill",
        callback = function(v)
            cv.fov_fill = v
            visuals.update_fov()
        end,
    }):colorpicker({
        name = "Gradient Color Left",
        flag = "fov_fill_gradient_left",
        color = rgb(45, 209, 235),
        alpha = 0.5,
        callback = function(color, alpha)
            cv.fov_fill_color_1 = color
            cv.fov_fill_transparency_1 = 1 - alpha
            visuals.update_fov()
        end,
    }):colorpicker({
        name = "Gradient Color Right",
        flag = "fov_fill_gradient_right",
        color = rgb(203, 79, 104),
        alpha = 0.5,
        callback = function(color, alpha)
            cv.fov_fill_color_2 = color
            cv.fov_fill_transparency_2 = 1 - alpha
            visuals.update_fov()
        end,
    })
    section:toggle({
        name = "Glow",
        flag = "fov_glow",
        callback = function(v)
            cv.fov_fill_glow = v
            visuals.update_fov()
        end,
    }):colorpicker({
        name = "Gradient Color Left",
        flag = "fov_fill_glow_gradient_left",
        color = rgb(45, 209, 235),
        alpha = 0.5,
        callback = function(color, alpha)
            cv.fill_glow_color_1 = color
            cv.fill_glow_transparency_1 = 1 - alpha
            visuals.update_fov()
        end,
    }):colorpicker({
        name = "Gradient Color Right",
        flag = "fov_fill_glow_gradient_right",
        color = rgb(203, 79, 104),
        alpha = 0.5,
        callback = function(color, alpha)
            cv.fill_glow_color_2 = color
            cv.fill_glow_transparency_2 = 1 - alpha
            visuals.update_fov()
        end,
    })
    section:toggle({
        name = "Spin",
        flag = "fov_spin",
        callback = function(v)
            cv.spin_gradients = v
            visuals.update_fov()
        end,
    })
    section:slider({
        slider_type = "normal",
        min = -5,
        max = 5,
        default = 1,
        interval = 0.1,
        flag = "fov_spin_speed",
        callback = function(v)
            cv.spin_speed = v
        end,
    })
end):colorpicker({
    name = "Gradient Color Left",
    flag = "fov_gradient_left",
    color = rgb(45, 209, 235),
    alpha = 1,
    callback = function(color, alpha)
        cv.fov_color_1 = color
        cv.fov_transparency_1 = 1 - alpha
        visuals.update_fov()
    end,
}):colorpicker({
    name = "Gradient Color Right",
    flag = "fov_gradient_right",
    color = rgb(203, 79, 104),
    alpha = 1,
    callback = function(color, alpha)
        cv.fov_color_2 = color
        cv.fov_transparency_2 = 1 - alpha
        visuals.update_fov()
    end,
})

combat_visuals_pane:toggle({
    name = "Enable Snapline",
    flag = "snapline_enabled",
    callback = function(v)
        cv.snapline_enabled = v
        visuals.update_snapline()
    end,
}):configuration({ name = "Snapline Options" }, function(section)
    section:toggle({
        name = "Outline",
        flag = "snapline_outline",
        callback = function(v)
            cv.snapline_outline = v
            visuals.update_snapline()
        end,
    }):colorpicker({
        name = "Outline Color",
        flag = "snapline_outline_color",
        color = rgb(0, 0, 0),
        alpha = 1,
        callback = function(color, alpha)
            cv.snapline_outline_color = color
            cv.snapline_outline_transparency = 1 - alpha
            visuals.update_snapline()
        end,
    })
    section:slider({
        name = "Thickness",
        suffix = "px",
        min = 1,
        max = 3,
        default = 1,
        interval = 1,
        flag = "snapline_thickness",
        callback = function(v)
            cv.snapline_thickness = v
        end,
    })
end):colorpicker({
    name = "Gradient Color Mouse",
    flag = "snapline_gradient_mouse",
    color = rgb(45, 209, 235),
    alpha = 1,
    callback = function(color, alpha)
        cv.snapline_color_1 = color
        cv.snapline_transparency_1 = 1 - alpha
        visuals.update_snapline()
    end,
}):colorpicker({
    name = "Gradient Color Target",
    flag = "snapline_gradient_target",
    color = rgb(203, 79, 104),
    alpha = 1,
    callback = function(color, alpha)
        cv.snapline_color_2 = color
        cv.snapline_transparency_2 = 1 - alpha
        visuals.update_snapline()
    end,
})

combat_visuals_pane:splitter()

local hs = cv.hitsounds

combat_visuals_pane:toggle({
    name = "Override Headshot Hitsound",
    flag = "enable_head_hitsound",
    callback = function(v)
        hs.head.enabled = v
    end,
}):configuration({ name = "Hitsound Options" }, function(section)
    section:dropdown({
        name = "Sound",
        scrolling = true,
        flag = "head_hitsound_type",
        items = hs.hitsound_index,
        default = "Neverlose",
        callback = function(v)
            hs.head.sound = v
            if not library.loading and not library.unloading then
                visuals.preview_sound(library.hitsounds[hs.head.sound], hs.head.volume, hs.head.pitch)
            end
        end,
    })
    section:slider({
        name = "Volume",
        min = 0.1,
        max = 5,
        default = 1,
        interval = 0.1,
        flag = "head_hitsound_volume",
        callback = function(v)
            hs.head.volume = v
        end,
    })
    section:slider({
        name = "Pitch",
        min = 0.1,
        max = 5,
        default = 1,
        interval = 0.1,
        flag = "head_hitsound_pitch",
        callback = function(v)
            hs.head.pitch = v
        end,
    })
end)

combat_visuals_pane:toggle({
    name = "Override Body Hitsound",
    flag = "enable_body_hitsound",
    callback = function(v)
        hs.body.enabled = v
    end,
}):configuration({ name = "Hitsound Options" }, function(section)
    section:dropdown({
        name = "Sound",
        scrolling = true,
        flag = "body_hitsound_type",
        items = hs.hitsound_index,
        default = "Cod",
        callback = function(v)
            hs.body.sound = v
            if not library.loading and not library.unloading then
                visuals.preview_sound(library.hitsounds[hs.body.sound], hs.body.volume, hs.body.pitch)
            end
        end,
    })
    section:slider({
        name = "Volume",
        min = 0.1,
        max = 5,
        default = 1,
        interval = 0.1,
        flag = "body_hitsound_volume",
        callback = function(v)
            hs.body.volume = v
        end,
    })
    section:slider({
        name = "Pitch",
        min = 0.1,
        max = 5,
        default = 1,
        interval = 0.1,
        flag = "body_hitsound_pitch",
        callback = function(v)
            hs.body.pitch = v
        end,
    })
end)

combat_visuals_pane:toggle({
    name = "Override Killsound",
    flag = "enable_kill_sound",
    callback = function(v)
        hs.kill.enabled = v
    end,
}):configuration({ name = "Killsound Options" }, function(section)
    section:dropdown({
        name = "Sound",
        scrolling = true,
        flag = "killsound_type",
        items = hs.hitsound_index,
        default = "Landing",
        callback = function(v)
            hs.kill.sound = v
            if not library.loading and not library.unloading then
                visuals.preview_sound(library.hitsounds[hs.kill.sound], hs.kill.volume, hs.kill.pitch)
            end
        end,
    })
    section:slider({
        name = "Volume",
        min = 0.1,
        max = 5,
        default = 1,
        interval = 0.1,
        flag = "killsound_volume",
        callback = function(v)
            hs.kill.volume = v
        end,
    })
    section:slider({
        name = "Pitch",
        min = 0.1,
        max = 5,
        default = 1,
        interval = 0.1,
        flag = "killsound_pitch",
        callback = function(v)
            hs.kill.pitch = v
        end,
    })
end)

combat_visuals_pane:splitter()

local shoot = cv.custom_shoot_sound

combat_visuals_pane:toggle({
    name = "Override Shoot Sound",
    flag = "enable_custom_shoot_sound",
    callback = function(v)
        shoot.enabled = v
    end,
}):configuration({ name = "Shoot Sound Options" }, function(section)
    section:dropdown({
        name = "Type",
        scrolling = true,
        flag = "shoot_sound_type",
        items = shoot.sound_index,
        default = shoot.sound,
        callback = function(v)
            shoot.sound = v
            if not library.loading and not library.unloading then
                visuals.preview_sound("rbxassetid://" .. shoot.sounds[shoot.sound], shoot.volume, shoot.pitch)
            end
        end,
    })
    section:slider({
        name = "Volume",
        min = 0.1,
        max = 5,
        default = 1,
        interval = 0.1,
        flag = "shoot_sound_volume",
        callback = function(v)
            shoot.volume = v
        end,
    })
    section:slider({
        name = "Pitch",
        min = 0.1,
        max = 5,
        default = 1,
        interval = 0.1,
        flag = "shoot_sound_pitch",
        callback = function(v)
            shoot.pitch = v
        end,
    })
end)

combat_visuals_pane:splitter()

local bt = cv.bullet_tracers

combat_visuals_pane:toggle({
    name = "Bullet Tracers",
    flag = "enable_bullet_tracers",
    callback = function(v)
        bt.enabled = v
    end,
}):configuration({ name = "Bullet Tracer Options" }, function(section)
    section:dropdown({
        name = "Texture",
        scrolling = true,
        items = { "DNA", "Energy", "Laser", "Lightning", "Neon", "Pulsing" },
        default = "Neon",
        flag = "bullet_tracer_texture",
        callback = function(v)
            bt.texture = v
        end,
    })
    section:slider({
        name = "Texture Speed",
        min = 0.1,
        max = 5,
        default = 1,
        interval = 0.1,
        flag = "bullet_tracer_texture_speed",
        callback = function(v)
            bt.texture_speed = v
        end,
    })
    section:toggle({
        name = "Randomize Curve",
        flag = "randomize_curve",
        callback = function(v)
            bt.randomize_curve = v
        end,
    })
    section:slider({
        name = "Curve Close",
        min = -20,
        max = 20,
        default = 0,
        interval = 0.1,
        flag = "curve_1",
        callback = function(v)
            bt.curve_1 = v
        end,
    })
    section:slider({
        name = "Curve Far",
        min = -20,
        max = 20,
        default = 0,
        interval = 0.1,
        flag = "curve_2",
        callback = function(v)
            bt.curve_2 = v
        end,
    })
    section:slider({
        name = "Curve Segments",
        min = 1,
        max = 75,
        default = 10,
        interval = 0.01,
        flag = "curve_segments",
        callback = function(v)
            bt.segments = v
        end,
    })
    section:slider({
        name = "Width",
        min = 0.01,
        max = 5,
        default = 0.1,
        interval = 0.01,
        flag = "bullet_tracer_width",
        callback = function(v)
            bt.width = v
        end,
    })
    section:slider({
        name = "Lifetime",
        min = 0.1,
        max = 10,
        suffix = "s",
        default = 1.5,
        interval = 0.1,
        flag = "bullet_tracer_lifetime",
        callback = function(v)
            bt.lifetime = v
        end,
    })
end):colorpicker({
    name = "Color 1",
    flag = "bullet_tracer_color_1",
    color = rgb(45, 209, 235),
    alpha = 1,
    callback = function(color, alpha)
        bt.color_1 = color
        bt.transparency_1 = 1 - alpha
    end,
}):colorpicker({
    name = "Color 2",
    flag = "bullet_tracer_color_2",
    color = rgb(203, 79, 104),
    alpha = 1,
    callback = function(color, alpha)
        bt.color_2 = color
        bt.transparency_2 = 1 - alpha
    end,
})

local hm = cv.hitmarkers

combat_visuals_pane:toggle({
    name = "Hitmarkers",
    flag = "enable_hitmarkers",
    callback = function(v)
        hm.enabled = v
    end,
}):configuration({ name = "Hitmarker Options" }, function(section)
    section:toggle({
        name = "Outline",
        flag = "hitmarker_outline",
        callback = function(v)
            hm.outline = v
        end,
    }):colorpicker({
        name = "Outline Color",
        flag = "hitmarker_outline_color",
        color = rgb(0, 0, 0),
        alpha = 1,
        callback = function(color, alpha)
            hm.outline_color = color
            hm.outline_transparency = 1 - alpha
        end,
    })
    section:dropdown({
        name = "Image",
        flag = "hitmarker_image",
        items = { "Arrow", "Box", "Cross", "Diamond", "Heart", "Plus" },
        default = "Arrow",
        callback = function(v)
            hm.image = v
        end,
    })
    section:slider({
        name = "Lifetime",
        min = 0.1,
        max = 10,
        suffix = "s",
        default = 1.5,
        interval = 0.1,
        flag = "hitmarker_lifetime",
        callback = function(v)
            hm.lifetime = v
        end,
    })
end):colorpicker({
    name = "Instance Color",
    flag = "hitmarker_color",
    color = rgb(45, 209, 235),
    alpha = 1,
    callback = function(color, alpha)
        hm.color = color
        hm.transparency = 1 - alpha
    end,
})

local bi = cv.bullet_impacts

combat_visuals_pane:toggle({
    name = "Bullet Impacts",
    flag = "enable_bullet_impacts",
    callback = function(v)
        bi.enabled = v
    end,
}):configuration({ name = "Bullet Impact Options" }, function(section)
    section:dropdown({
        name = "Material",
        flag = "bullet_impact_material",
        items = { "ForceField", "Glass", "Neon", "SmoothPlastic" },
        default = "ForceField",
        callback = function(v)
            bi.material = v
        end,
    })
    section:slider({
        name = "Lifetime",
        min = 0.1,
        max = 10,
        suffix = "s",
        default = 1.5,
        interval = 0.1,
        flag = "bullet_impact_lifetime",
        callback = function(v)
            bi.lifetime = v
        end,
    })
end):colorpicker({
    name = "Instance Color",
    flag = "bullet_impact_color",
    color = rgb(45, 209, 235),
    alpha = 1,
    callback = function(color, alpha)
        bi.color = color
        bi.transparency = 1 - alpha
    end,
})

local vfx = cv.hit_vfx

combat_visuals_pane:toggle({
    name = "Hit VFX",
    flag = "enable_hit_vfx",
    callback = function(v)
        vfx.enabled = v
    end,
}):configuration({ name = "Hit VFX Options" }, function(section)
    section:dropdown({
        name = "Particles",
        multi = true,
        flag = "hit_vfx_texture",
        items = { "Glow", "Shards", "Shine", "Star" },
        default = { "Shards" },
        callback = function(v)
            vfx.particles = v
        end,
    })
    section:slider({
        name = "Rate",
        min = 10,
        max = 100,
        default = 40,
        interval = 1,
        flag = "hit_vfx_rate",
        callback = function(v)
            vfx.rate = v
        end,
    })
    section:slider({
        name = "Lifetime",
        min = 0.1,
        max = 1,
        suffix = "s",
        default = 0.3,
        interval = 0.1,
        flag = "hit_vfx_lifetime",
        callback = function(v)
            vfx.lifetime = v
        end,
    })
end):colorpicker({
    name = "VFX Color",
    flag = "hit_vfx_color",
    color = rgb(45, 209, 235),
    alpha = 1,
    callback = function(color)
        vfx.color = color
    end,
})

for _, entry in {
    { "Instant Aim", "instant_aim" },
    { "Instant Lean", "instant_lean" },
    { "Instant Bullet", "instant_bullet" },
    { "Instant Equip", "instant_equip" },
    { "No Bobbing", "no_bobbing" },
    { "No Recoil", "no_recoil" },
    { "No Sway", "no_sway" },
    { "Remove Spread", "remove_spread" },
    { "Remove Obstructions", "remove_obstructions" },
    { "Remove Sprinting Animation", "remove_sprinting_animation", "remove_sprint_animation" },
    { "Remove Muzzle Effects", "remove_muzzle_effects" },
    { "Unlock Firemodes", "unlock_firemodes" },
} do
    weapon_mods:toggle({
        name = entry[1],
        flag = entry[2],
        callback = function(v)
            mods[entry[3] or entry[2]] = v
        end,
    })
end

weapon_mods:toggle({
    name = "Double Tap",
    flag = "double_tap",
    callback = function(v)
        mods.double_tap = v
    end,
}):keybind({
    name = "Double Tap",
    flag = "double_tap_bind",
    callback = function(v)
        mods.double_tap = v
    end,
})

weapon_mods:toggle({
    name = "Rapid Fire",
    flag = "rapid_fire",
    callback = function(v)
        mods.rapid_fire.enabled = v
    end,
}):configuration({ name = "Rapid Fire Options" }, function(section)
    section:slider({
        name = "Fire Rate",
        min = 1,
        max = 100,
        default = 1,
        interval = 1,
        flag = "fire_rate",
        callback = function(v)
            mods.rapid_fire.value = v
        end,
    })
end)

weapon_mods:toggle({
    name = "Rapid Knife",
    flag = "rapid_knife",
    callback = function(v)
        mods.rapid_knife.enabled = v
    end,
}):configuration({ name = "Rapid Knife Options" }, function(section)
    section:slider({
        name = "Swing Rate",
        min = 1,
        max = 100,
        default = 1,
        interval = 1,
        flag = "swing_rate",
        callback = function(v)
            mods.rapid_knife.rate = v
        end,
    })
end)

other_pane:toggle({
    name = "Server Desync Resolver",
    flag = "server_desync_resolver",
    callback = function(v)
        rv.server_desync_resolver.enabled = v
        combat.position_verify()
    end,
}):keybind({
    name = "Server Desync Resolver",
    flag = "server_desync_resolver_bind",
    callback = function(v)
        rv.server_desync_resolver.enabled = v
        combat.position_verify()
    end,
})

other_pane:toggle({
    name = "Stream Sync",
    tooltip = "Loads all player positions in the game",
    flag = "stream_sync",
    callback = function(v)
        config.stream_sync.enabled = v
    end,
}):keybind({
    name = "Stream Async",
    flag = "stream_sync_bind",
    callback = function(v)
        config.stream_sync.enabled = v
    end,
})

other_pane:splitter()

other_pane:toggle({
    name = "Sit on Resolve",
    flag = "sit",
    callback = function(v)
        rv.use_sit = v
    end,
}):keybind({
    name = "Sit on Resolve",
    flag = "sit_bind",
    callback = function(v)
        rv.use_sit = v
    end,
})

other_pane:splitter()

local function resolver_options(key, prefix, first)
    return function(section)
        section:slider(first)
        section:slider({
            name = "Timeout",
            min = 0.1,
            max = 3,
            default = 1,
            suffix = "s",
            interval = 0.1,
            flag = prefix .. "_timeout",
            callback = function(v)
                rv[key].timeout = v
            end,
        })
        section:dropdown({
            name = "Method",
            flag = prefix .. "_method",
            items = { "Classic", "CFrame" },
            default = "Classic",
            callback = function(v)
                rv[key].method = v
            end,
        })
    end
end

other_pane:toggle({
    name = "Underground Resolver",
    flag = "underground_resolver",
    callback = function(v)
        rv.underground_resolver.enabled = v
    end,
}):configuration({ name = "Underground Resolver Options" }, resolver_options("underground_resolver", "underground_resolver", {
    name = "Depth",
    min = 5,
    max = 50,
    default = 15,
    suffix = "m",
    interval = 1,
    flag = "underground_resolver_depth",
    callback = function(v)
        rv.underground_resolver.depth = v
    end,
})):keybind({
    name = "Underground Resolver",
    mode = "hold",
    flag = "underground_resolver_bind",
    callback = function(v)
        rv.underground_resolver.bind = v
        combat.underground_resolve()
    end,
})

other_pane:toggle({
    name = "Sky Peek",
    flag = "sky_peek",
    callback = function(v)
        rv.peek.enabled = v
    end,
}):configuration({ name = "Sky Peek Options" }, resolver_options("peek", "sky_peek", {
    name = "Height",
    min = 10,
    max = 300,
    default = 30,
    suffix = "m",
    interval = 1,
    flag = "sky_peek_depth",
    callback = function(v)
        rv.peek.height = v
    end,
})):keybind({
    name = "Sky Peek",
    mode = "hold",
    flag = "sky_peek_bind",
    callback = function(v)
        rv.peek.bind = v
        combat.peek_resolve()
    end,
})

other_pane:toggle({
    name = "TP Peek",
    flag = "tp_peek",
    callback = function(v)
        rv.tp_peek.enabled = v
    end,
}):configuration({ name = "TP Peek Options" }, resolver_options("tp_peek", "tp_peek", {
    name = "Height",
    min = 1,
    max = 300,
    default = 50,
    suffix = "m",
    interval = 1,
    flag = "tp_peek_height",
    callback = function(v)
        rv.tp_peek.height = v
    end,
})):keybind({
    name = "TP Peek",
    mode = "hold",
    flag = "tp_peek_bind",
    callback = function(v)
        rv.tp_peek.bind = v
        combat.tp_peek_resolve()
    end,
})

esp.tab(esp_players, "esp", false)
esp.tab(esp_npc, "esp.bots", true)

esp_other:toggle({
    name = "ESP Enabled",
    flag = "other_esp_enabled",
    callback = function(v)
        config.esp.other.enabled = v
    end,
}):configuration({ name = "ESP Options" }, function(section)
    section:slider({
        name = "Render Distance",
        min = 1,
        max = 1300,
        default = 1300,
        suffix = "m",
        interval = 1,
        flag = "other_render_distance",
        callback = function(v)
            config.esp.other.render_distance = v
        end,
    })
end):keybind({
    name = "Other ESP",
    flag = "other_esp_enabled_bind",
    callback = function(v)
        config.esp.other.enabled = v
    end,
})

esp_other:splitter()

local function other_esp(label, key, prefix, extra, options_name)
    local o = config.esp.other[key]
    esp_other:toggle({
        name = label,
        flag = prefix .. "_enabled",
        callback = function(v)
            o.enabled = v
            esp.refresh_custom()
        end,
    }):configuration({ name = options_name }, function(section)
        section:toggle({
            name = "Render Outline",
            flag = prefix .. "_outline",
            default = true,
            callback = function(v)
                o.outline = v
                esp.refresh_custom()
            end,
        }):colorpicker({
            name = "Outline Color",
            flag = prefix .. "_outline_color",
            color = rgb(0, 0, 0),
            callback = function(color, alpha)
                o.outline_color = color
                o.outline_transparency = 1 - alpha
                esp.refresh_custom()
            end,
        })
        section:splitter({ offset = 1 })
        section:toggle({
            name = "Icon",
            flag = extra.icon_prefix .. "_icon",
            callback = function(v)
                o.icon = v
                esp.refresh_custom()
            end,
        }):colorpicker({
            name = "Image Color",
            flag = extra.icon_prefix .. "_icon_color",
            color = rgb(255, 255, 255),
            callback = function(color, alpha)
                o.icon_color = color
                o.icon_transparency = 1 - alpha
                esp.refresh_custom()
            end,
        })
        section:toggle({
            name = "Distance",
            flag = extra.icon_prefix .. "_distance",
            callback = function(v)
                o.distance = v
                esp.refresh_custom()
            end,
        })
        if extra.local_corpse then
            section:splitter({ offset = 1 })
            section:toggle({
                name = "Local Corpse",
                flag = "highlight_local_corpse",
                callback = function(v)
                    o.highlight_self_body = v
                    esp.refresh_custom()
                end,
            }):colorpicker({
                name = "Text Color",
                flag = "self_corpse_color",
                color = rgb(255, 255, 255),
                callback = function(color, alpha)
                    o.self_color = color
                    o.self_transparency = 1 - alpha
                    esp.refresh_custom()
                end,
            }):colorpicker({
                name = "Image Color",
                flag = "self_corpse_icon_color",
                color = rgb(255, 255, 255),
                callback = function(_, alpha)
                    o.self_transparency_image = 1 - alpha
                    esp.refresh_custom()
                end,
            })
        end
        section:splitter({ offset = 1 })
        section:dropdown({
            name = "Font",
            scrolling = true,
            flag = prefix .. "_font",
            items = font_names,
            default = "Tahoma",
            callback = function(v)
                o.font = v
                esp.refresh_custom()
            end,
        })
    end):colorpicker({
        name = "Text Color",
        flag = extra.color_flag,
        color = rgb(255, 255, 255),
        callback = function(color, alpha)
            o.color = color
            o.transparency = 1 - alpha
            esp.refresh_custom()
        end,
    })
end

other_esp("Exits", "exit", "exit", { icon_prefix = "exit", color_flag = "exit_color" }, "Exit Options")
other_esp("Vehicles", "uaz", "vehicle", { icon_prefix = "vehicle", color_flag = "vehicle_color" }, "Vehicle Options")
other_esp("Corpses", "body", "corpse", { icon_prefix = "body", color_flag = "body_color", local_corpse = true }, "Corpse Options")
other_esp("Dropped Items", "item", "item", { icon_prefix = "item", color_flag = "item_color" }, "Dropped Item Options")
other_esp("MI24V Helicopter", "heli", "heli", { icon_prefix = "heli", color_flag = "heli_color" }, "Heli Options")

esp_options:dropdown({
    name = "Bounding Type",
    flag = "esp_sizing_type",
    items = { "Static", "Dynamic" },
    default = "Static",
    callback = function(v)
        config.esp.box_type = v
    end,
})

esp_options:slider({
    name = "Dynamic Padding",
    min = 0.7,
    max = 2,
    default = 1,
    interval = 0.01,
    flag = "dynamic_padding",
    callback = function(v)
        config.esp.dynamic_padding = v
    end,
})

esp_options:slider({
    name = "Static Width",
    min = 2,
    max = 4,
    default = 3.6,
    interval = 0.1,
    flag = "size_static_x",
    callback = function(v)
        config.esp.box_size = Vector2.new(v, config.esp.box_size.Y)
    end,
})

esp_options:slider({
    name = "Static Height",
    min = 5,
    max = 5.5,
    default = 5,
    interval = 0.1,
    flag = "size_static_y",
    callback = function(v)
        config.esp.box_size = Vector2.new(config.esp.box_size.X, v)
    end,
})

esp_options:splitter()

esp_options:toggle({
    name = "Display Measurement Unit",
    flag = "esp_measurement_unit_enabled",
    default = true,
    callback = function(v)
        config.esp.show_distance_format = v
    end,
})

local function refresh_distance_format()
    local unit = config.esp.distance_unit
    local suffix = unit == "studs" and "st" or unit == "meters" and "m" or ""
    config.esp.distance_format = esp.format_text(suffix, config.esp.text_case)
end

esp_options:dropdown({
    name = "Measurement Unit",
    flag = "esp_measurement_unit",
    items = { "Studs", "Meters" },
    default = "Meters",
    callback = function(v)
        config.esp.distance_unit = v:lower()
        refresh_distance_format()
    end,
})

esp_options:splitter()

esp_options:dropdown({
    name = "Font Case",
    flag = "esp_text_case",
    items = { "Uppercase", "Lowercase", "Titlecase" },
    default = "Lowercase",
    tooltip = "Updates the case for ESP labels",
    callback = function(v)
        config.esp.text_case = v
        refresh_distance_format()
        esp.refresh(false)
        esp.refresh(true)
        esp.refresh_custom()
    end,
})

esp_options:slider({
    name = "Update Rate",
    suffix = "hz",
    min = 30,
    max = 240,
    default = 240,
    interval = 1,
    flag = "esp_update_rate",
    tooltip = "Lowering this value will result in a boost of performance",
    callback = function(v)
        config.esp.update_rate = v
    end,
})

esp_options:splitter()
esp_options:button_holder({})
esp_options:button({
    name = "Test Healthbar Animation",
    tooltip = "Animates every healthbar from 0 to their current health value",
    callback = function()
        esp.test_animation()
    end,
})

local mv = config.misc.movement

movement:toggle({
    name = "Flyhack",
    flag = "flyhack",
    callback = function(v)
        mv.flyhack.enabled = v
    end,
}):configuration({ name = "Flyhack Options" }, function(section)
    section:slider({
        name = "Horizontal Speed",
        min = 0.1,
        max = 100,
        interval = 0.1,
        default = 20,
        flag = "flyhack_horizontal_speed",
        callback = function(v)
            mv.flyhack.speed_horizontal = v
        end,
    })
    section:slider({
        name = "Vertical Speed",
        min = 0.1,
        max = 100,
        interval = 0.1,
        default = 20,
        flag = "flyhack_vertical_speed",
        callback = function(v)
            mv.flyhack.speed_vertical = v
        end,
    })
    section:slider({
        name = "Speed Multiplier",
        min = 0.1,
        max = 10,
        interval = 0.1,
        default = 1,
        flag = "flyhack_multiplier",
        callback = function(v)
            mv.flyhack.multiplier = v
        end,
    })
end):keybind({
    name = "Flyhack",
    flag = "flyhack_bind",
    callback = function(v)
        combat.toggle_fly(v)
    end,
})

movement:toggle({
    name = "Long Jump",
    flag = "long_jump",
    callback = function(v)
        mv.long_jump.enabled = v
    end,
}):configuration({ name = "Long Jump Options" }, function(section)
    section:slider({
        name = "Forward Force",
        min = 1,
        max = 15,
        interval = 0.1,
        default = 8,
        flag = "forward_force_value",
        callback = function(v)
            mv.long_jump.forward_force = v
        end,
    })
    section:slider({
        name = "Upward Force",
        min = 0,
        max = 10,
        interval = 0.1,
        default = 1.5,
        flag = "upward_force_value",
        callback = function(v)
            mv.long_jump.upward_force = v
        end,
    })
    section:slider({
        name = "Cooldown",
        min = 0.1,
        max = 3,
        interval = 0.1,
        default = 1,
        flag = "long_jump_cooldown",
        callback = function(v)
            mv.long_jump.cooldown = v
        end,
    })
end):keybind({
    name = "Long Jump",
    mode = "hold",
    flag = "long_jump_bind",
    callback = function()
        if mv.long_jump.enabled then
            combat.long_jump()
        end
    end,
})

movement:splitter()

local function humanoid_toggle(label, key, flag, slider, options_name, bind)
    local toggle = movement:toggle({
        name = label,
        flag = flag,
        callback = function(v)
            mv[key].enabled = v
            combat.update_humanoid(humanoid)
        end,
    }):configuration({ name = options_name }, function(section)
        slider.callback = function(v)
            mv[key].value = v
            combat.update_humanoid(humanoid)
        end
        section:slider(slider)
    end)
    if bind then
        toggle:keybind({
            name = label,
            flag = flag .. "_bind",
            callback = function(v)
                mv[key].enabled = v
                combat.update_humanoid(humanoid)
            end,
        })
    end
end

humanoid_toggle("Speedhack", "speedhack", "speed_hack", { name = "Speed", min = 0.1, max = 30, interval = 0.1, default = 20, flag = "speed_hack_value" }, "Speedhack Options", true)
humanoid_toggle("Jumphack", "jumphack", "jump_hack", { name = "Height", min = 0.1, max = 20, interval = 0.1, default = 3, flag = "jump_hack_value" }, "Jumphack Options", true)
humanoid_toggle("Gravity", "gravity", "gravity", { name = "Gravity", min = 1, max = 300, interval = 1, default = workspace.Gravity, flag = "gravity_value" }, "Gravity Options", true)
humanoid_toggle("Max Slope Angle", "max_slope_angle", "max_slope_angle", { name = "Slope Angle", min = 1, max = 89, interval = 1, default = workspace.Gravity, flag = "max_slope_angle_value" }, "Gravity Options", false)

movement:splitter()

movement:toggle({
    name = "Remove Jump Cooldown",
    flag = "remove_jump_cooldown",
    callback = function(v)
        mv.remove_jump_cooldown = v
    end,
}):keybind({
    name = "Remove Jump Cooldown",
    flag = "remove_jump_cooldown_bind",
    callback = function(v)
        mv.remove_jump_cooldown = v
    end,
})

movement:toggle({
    name = "Remove Fall Damage",
    flag = "remove_fall_damage",
    callback = function(v)
        config.misc.nofall.enabled = v
    end,
}):keybind({
    name = "Remove Fall Damage",
    flag = "remove_fall_damage_bind",
    callback = function(v)
        config.misc.nofall.enabled = v
    end,
})

local_pane:toggle({
    name = "Jesus",
    flag = "jesus",
    callback = function(v)
        mv.jesus = v
    end,
}):keybind({
    name = "Jesus",
    flag = "jesus_bind",
    callback = function(v)
        mv.jesus = v
    end,
})

local_pane:toggle({
    name = "Remove Drowning Damage",
    flag = "remove_drowning",
    callback = function(v)
        mv.no_drown = v
        visuals.update_water_blur()
    end,
}):keybind({
    name = "Remove Drowning Damage",
    flag = "remove_drowning_bind",
    callback = function(v)
        mv.no_drown = v
        visuals.update_water_blur()
    end,
})

local_pane:toggle({
    name = "Remove Water Physics",
    flag = "remove_water_physics",
    callback = function(v)
        mv.remove_water_physics = v
        combat.update_humanoid_state()
    end,
}):keybind({
    name = "Remove Water Physics",
    flag = "remove_water_physics_bind",
    callback = function(v)
        mv.remove_water_physics = v
        combat.update_humanoid_state()
    end,
})

local_pane:splitter()

local_pane:toggle({
    name = "Multi Use",
    flag = "multi_use",
    callback = function(v)
        config.misc.multi_use.enabled = v
    end,
}):configuration({ name = "Multi Use Options" }, function(section)
    section:slider({
        name = "Times",
        suffix = "x",
        min = 2,
        max = 4,
        default = 3,
        interval = 1,
        flag = "multi_use_times",
        callback = function(v)
            config.misc.multi_use.times = v - 1
        end,
    })
end):keybind({
    name = "Multi Use",
    flag = "multi_use_bind",
    callback = function(v)
        config.misc.multi_use.enabled = v
    end,
})

local tt = config.misc.trash_talk

chat_pane:toggle({
    name = "Trash Talk",
    flag = "trash_talk",
    callback = function(v)
        tt.enabled = v
    end,
}):keybind({
    name = "Trash Talk",
    flag = "trash_talk_bind",
    callback = function(v)
        if not tt.enabled then
            return
        end
        if v and not tt.trash_talking then
            tt.trash_talking = true
            local phrases = tt.phrases[tt.tt_type:lower()]
            if phrases and #phrases > 0 then
                local phrase
                repeat
                    phrase = phrases[math.random(1, #phrases)]
                until phrase ~= tt.last_phrase or #phrases == 1
                tt.last_phrase = phrase
                TextChatService.TextChannels.RBXGeneral:SendAsync(phrase)
            end
        elseif not v then
            tt.trash_talking = false
        end
    end,
})

chat_pane:dropdown({
    name = "Trash Talk Type",
    flag = "trash_talk_type",
    items = { "Backtrack", "Casual", "Exploit", "Passive" },
    default = "Backtrack",
    callback = function(v)
        tt.tt_type = v
    end,
})

local ds = config.misc.desync

replication:toggle({
    name = "Desynchronization",
    flag = "desynchronization",
    callback = function(v)
        ds.desync_toggle = v
    end,
}):configuration({ name = "Desynchronization Options" }, function(section)
    section:slider({
        name = "Delay",
        min = 0.1,
        max = 10,
        default = 2.5,
        interval = 0.1,
        flag = "desynchronization_delay",
        callback = function(v)
            ds.freeze_delay = v
        end,
    })
    section:toggle({
        name = "Smooth",
        flag = "desynchronization_smooth",
        callback = function(v)
            ds.smooth = v
        end,
    })
end):keybind({
    name = "Desynchronization",
    flag = "desynchronization_bind",
    callback = function()
        desync.toggle()
    end,
})

replication:splitter()

replication:toggle({
    name = "Position Spoofer",
    flag = "position_spoofer",
    callback = function(v)
        ds.position_spoofer.enabled = v
    end,
}):keybind({
    name = "Position Spoofer",
    flag = "position_spoofer_bind",
    callback = function(v)
        ds.position_spoofer.enabled = v
    end,
})

for _, axis in { { "X", "x", -10, 10 }, { "Y", "y", -4, 6 }, { "Z", "z", -10, 10 } } do
    replication:slider({
        name = axis[1] .. " Offset",
        min = axis[3],
        max = axis[4],
        default = 0,
        interval = 0.1,
        flag = "offset_" .. axis[2],
        callback = function(v)
            ds.position_spoofer[axis[2]] = v
        end,
    })
end

replication:splitter()

local rs = ds.rotation_spoofer

replication:toggle({
    name = "Rotation Spoofer",
    flag = "rotation_spoofer",
    callback = function(v)
        rs.enabled = v
    end,
}):configuration({ name = "Rotation Spoofer Options" }, function(section)
    for _, axis in { "Roll", "Pitch", "Yaw" } do
        local key = axis:lower()
        section:toggle({
            name = "Spin " .. axis,
            flag = "spin_" .. key,
            callback = function(v)
                rs.spin[key].enabled = v
            end,
        }):keybind({
            name = "Spin " .. axis,
            flag = "spin_" .. key .. "_bind",
            callback = function(v)
                rs.spin[key].enabled = v
            end,
        })
        section:slider({
            slider_type = "normal",
            suffix = "",
            min = 0.1,
            max = 25,
            default = 1,
            interval = 0.1,
            flag = "spin_" .. key .. "_speed",
            callback = function(v)
                rs.spin[key].speed = v
            end,
        })
    end
end):keybind({
    name = "Rotation Spoofer",
    flag = "rotation_spoofer_bind",
    callback = function(v)
        rs.enabled = v
    end,
})

for _, axis in { "Roll", "Pitch", "Yaw" } do
    replication:slider({
        name = axis,
        min = -180,
        max = 180,
        default = 0,
        interval = 1,
        flag = "rotation_" .. axis:lower(),
        callback = function(v)
            rs[axis:lower()] = v
        end,
    })
end

replication:splitter()

local anim = ds.animations

replication:toggle({
    name = "Play Animation",
    flag = "play_animation",
    callback = function(v)
        anim.enabled = v
        desync.update_animation()
    end,
}):configuration({ name = "Animation Options" }, function(section)
    section:textbox({
        flag = "animation_id",
        tooltip = "Using abnormal animations may result in detection",
        max = 30,
        placeholder = "Enter Animation ID",
        callback = function(v)
            anim.animation = v:match("^%d+$") and "rbxassetid://" .. v or v
            if anim.enabled then
                desync.update_animation()
            end
        end,
    })
    section:slider({
        name = "Time Position",
        min = 0,
        max = 15,
        default = 0,
        interval = 0.0001,
        flag = "animation_time_position",
        callback = function(v)
            anim.time_position = v
            if anim.enabled then
                desync.update_time_position()
            end
        end,
    })
    section:slider({
        name = "Speed",
        min = 0,
        max = 10,
        default = 0,
        interval = 0.1,
        flag = "spoofer_animation_speed",
        callback = function(v)
            anim.speed = v
            if anim.enabled then
                desync.update_animation_speed()
            end
        end,
    })
end):keybind({
    name = "Animation",
    flag = "play_animation_bind",
    callback = function(v)
        anim.enabled = v
        desync.update_animation()
    end,
})

replication:splitter()

replication:toggle({
    name = "Custom Pitch",
    flag = "pitch",
    callback = function(v)
        config.misc.pitch.enabled = v
        combat.update_pitch()
    end,
}):keybind({
    name = "Custom Pitch",
    flag = "pitch_bind",
    callback = function(v)
        config.misc.pitch.enabled = v
        combat.update_pitch()
    end,
})

replication:slider({
    slider_type = "normal",
    min = -0.7,
    max = 0.7,
    default = 0,
    interval = 0.1,
    flag = "pitch_value",
    callback = function(v)
        config.misc.pitch.value = v
        combat.update_pitch()
    end,
})

local server_vis = ds.visualization.server

visualization:toggle({
    name = "Visualize Server Position",
    flag = "server_position_visualizer",
    callback = function(v)
        server_vis.enabled = v
        visuals.update_visualizer()
    end,
}):configuration({ name = "Cham Options" }, function(section)
    section:slider({
        name = "Glow Intensity",
        min = 1,
        max = 5,
        default = 1.5,
        interval = 0.01,
        flag = "server_position_glow_intensity",
        callback = function(v)
            server_vis.color.f = v
            visuals.update_visualizer()
        end,
    })
    section:dropdown({
        name = "Type",
        flag = "server_position_visualizer_material",
        items = { "Default", "Flat", "Shaded" },
        default = "Default",
        callback = function(v)
            server_vis.cham_type = v
            visuals.update_visualizer()
        end,
    })
end):colorpicker({
    name = "Instance Color",
    flag = "server_position_visualizer_color",
    color = rgb(45, 209, 235),
    callback = function(color, alpha)
        server_vis.color.c = color
        server_vis.color.t = 1 - alpha
        visuals.update_visualizer()
    end,
})

visualization:toggle({
    name = "Third Person Only",
    flag = "server_position_third_person_only",
    callback = function(v)
        server_vis.third_person_only = v
        visuals.update_visualizer()
    end,
})

visualization:toggle({
    name = "Tween Position",
    tooltip = "Smooths visualizer movement for appearance, may slightly reduce positional accuracy",
    flag = "server_position_tween",
    callback = function(v)
        server_vis.use_tween = v
    end,
})

visualization:toggle({
    name = "Animate",
    tooltip = "Animates the visualizer using your local character's current animations",
    default = true,
    flag = "server_position_animation",
    callback = function(v)
        server_vis.visualize_animations = v
    end,
})

exploits:button_holder({})
exploits:button({
    name = "Reset Character",
    confirm = true,
    tooltip = "Instantly resets your character (counts as a death)",
    callback = function()
        local health = find(lp.Character, "Health")
        local drowning = find(health, "Drowning")
        if drowning then
            drowning:FireServer()
        end
    end,
})

exploits:splitter()

exploits:dropdown({
    name = "Detonation Mode",
    flag = "detonation_mode",
    items = { "All", "One" },
    default = "All",
    callback = function(v)
        config.misc.detonation_mode = v
    end,
})

exploits:button_holder({})
exploits:button({
    name = "Explode Landmines",
    confirm = true,
    tooltip = "Detonates every Outpost landmine currently placed on the map",
    callback = function()
        combat.explode_landmines()
    end,
})

exploits:dropdown({
    name = "UAZ Spawn Type",
    flag = "uaz_spawn_type",
    items = { "Farthest", "Nearest", "Random" },
    default = "Nearest",
    callback = function(v)
        config.misc.uaz_spawn_type = v
    end,
})

exploits:button_holder({})
exploits:button({
    name = "Spawn UAZ",
    confirm = true,
    tooltip = "Teleports the nearest available UAZ vehicle directly to your position",
    callback = function()
        combat.spawn_uaz()
    end,
})

exploits:splitter()

exploits:dropdown({
    name = "Traders",
    flag = "selected_traders",
    multi = true,
    items = { "Anna", "Blaze", "Boss", "Designer", "Mihkel", "Nurse", "Seryozha" },
    default = { "Blaze", "Mihkel", "Nurse", "Seryozha" },
    callback = function(v)
        config.misc.selected_npcs = v
    end,
})

exploits:button_holder({})
exploits:button({
    name = "Teleport Traders",
    confirm = true,
    tooltip = "Summons all trader NPCs and positions them in a circle around you",
    callback = function()
        combat.teleport_traders()
    end,
})

exploits:splitter()

exploits:button_holder({})
exploits:button({
    name = "Sort Inventory",
    confirm = true,
    tooltip = "Sorts all items in your inventory by category and value",
    callback = function()
        task.spawn(sorter.sort_inventory)
    end,
})
exploits:button({
    name = "Sort Vault",
    confirm = true,
    tooltip = "Sorts all items in your vault by category and value",
    callback = function()
        task.spawn(sorter.sort_vault)
    end,
})

world_pane:toggle({
    name = "Remove Grass",
    flag = "remove_grass",
    callback = function(v)
        sethiddenproperty(terrain, "Decoration", not v)
    end,
})

world_pane:toggle({
    name = "Remove Foliage",
    flag = "remove_foliage",
    callback = function(v)
        config.visuals.world.remove_foliage = v
        visuals.update_foliage()
    end,
})

world_pane:toggle({
    name = "Remove Trees",
    flag = "remove_trees",
    callback = function(v)
        config.visuals.world.remove_trees = v
        visuals.update_foliage()
    end,
})

world_pane:splitter()

for _, material in { "Grass", "Ground", "LeafyGrass", "Rock", "Sand" } do
    terrain_defaults[material] = terrain:GetMaterialColor(Enum.Material[material])
    local colors = config.visuals.world.terrain_colors
    colors[material] = colors[material] or { enabled = false, color = terrain_defaults[material] }
    world_pane:toggle({
        name = material .. " Color",
        flag = material:lower() .. "_toggle",
        callback = function(v)
            colors[material].enabled = v
            visuals.update_terrain()
        end,
    }):colorpicker({
        name = material .. " Color",
        flag = material:lower() .. "_color",
        color = colors[material].color,
        callback = function(color)
            colors[material].color = color
            visuals.update_terrain()
        end,
    })
end

local lt = config.visuals.lighting

lighting_pane:toggle({
    name = "Override Ambient",
    flag = "override_ambient",
    callback = function(v)
        lt.override_ambient = v
        visuals.update_lighting()
    end,
}):colorpicker({
    name = "Ambient Color",
    flag = "ambient_color",
    color = Color3.fromHex("#FFFFFF"),
    alpha = 1,
    callback = function(color)
        lt.ambient = color
        visuals.update_lighting()
    end,
}):colorpicker({
    name = "Outdoor Ambient Color",
    flag = "outdoor_ambient_color",
    color = Color3.fromHex("#FFFFFF"),
    alpha = 1,
    callback = function(color)
        lt.outdoor_ambient = color
        visuals.update_lighting()
    end,
})

lighting_pane:splitter()

lighting_pane:toggle({
    name = "Override Brightness",
    flag = "override_brightness",
    callback = function(v)
        lt.override_brightness = v
        visuals.update_lighting()
    end,
})

lighting_pane:slider({
    name = "Brightness",
    min = 0,
    max = 75,
    default = 2,
    interval = 1,
    flag = "brightness_value",
    callback = function(v)
        lt.brightness = v
        visuals.update_lighting()
    end,
})

lighting_pane:toggle({
    name = "Override Clock Time",
    flag = "override_clock_time",
    callback = function(v)
        lt.override_clocktime = v
        visuals.update_lighting()
    end,
})

lighting_pane:slider({
    name = "Clock Time",
    min = 0,
    max = 24,
    default = 22.9,
    interval = 0.1,
    flag = "clock_time",
    callback = function(v)
        lt.clock_time = v
        visuals.update_lighting()
    end,
})

lighting_pane:splitter()

local at = lt.atmosphere

local function atmosphere_slider(section, name, key, max, default, flag)
    section:slider({
        name = name,
        min = 0,
        max = max,
        default = default,
        interval = max > 1 and 0.1 or 0.01,
        flag = flag,
        callback = function(v)
            at[key] = v
            visuals.update_atmosphere()
        end,
    })
end

lighting_pane:toggle({
    name = "Override Fog",
    flag = "override_fog",
    callback = function(v)
        at.override_fog = v
        visuals.update_atmosphere()
    end,
}):configuration({ name = "Fog Options" }, function(section)
    atmosphere_slider(section, "Density", "density", 1, 0, "atmosphere_density")
    atmosphere_slider(section, "Offset", "offset", 1, 0, "atmosphere_offset")
end)

lighting_pane:toggle({
    name = "Override Fog Colors",
    flag = "override_fog_colors",
    callback = function(v)
        at.override_fog_colors = v
        visuals.update_atmosphere()
    end,
}):colorpicker({
    name = "Color",
    flag = "atmosphere_color",
    color = rgb(255, 255, 255),
    callback = function(color)
        at.color = color
        visuals.update_atmosphere()
    end,
}):colorpicker({
    name = "Decay",
    flag = "atmosphere_decay",
    color = rgb(255, 255, 255),
    callback = function(color)
        at.decay = color
        visuals.update_atmosphere()
    end,
})

lighting_pane:splitter()

lighting_pane:toggle({
    name = "Override Glare",
    flag = "override_glare",
    callback = function(v)
        at.override_glare = v
        visuals.update_atmosphere()
    end,
}):configuration({ name = "Glare Options" }, function(section)
    atmosphere_slider(section, "Glare", "glare", 10, 0, "glare")
end)

lighting_pane:toggle({
    name = "Override Haze",
    flag = "override_haze",
    callback = function(v)
        at.override_haze = v
        visuals.update_atmosphere()
    end,
}):configuration({ name = "Haze Options" }, function(section)
    atmosphere_slider(section, "Haze", "haze", 10, 0, "haze")
end)

local bl = lt.bloom

lighting_pane:toggle({
    name = "Override Bloom",
    flag = "override_bloom",
    callback = function(v)
        bl.override_bloom = v
        visuals.update_bloom()
    end,
}):configuration({ name = "Bloom Options" }, function(section)
    for _, s in {
        { "Intensity", "intensity", 0, 10, 0.5, "bloom_intensity" },
        { "Size", "size", 0, 100, 56, "bloom_size" },
        { "Threshold", "threshold", -1, 1, 0.8, "bloom_threshold" },
    } do
        section:slider({
            name = s[1],
            min = s[3],
            max = s[4],
            default = s[5],
            interval = 0.1,
            flag = s[6],
            callback = function(v)
                bl[s[2]] = v
                visuals.update_bloom()
            end,
        })
    end
end)

local pn = config.misc.notifications
local wn = config.visuals.world.notifications

notifiers:toggle({
    name = "Report Notifications",
    flag = "report_notify",
    callback = function(v)
        pn.report.enabled = v
    end,
}):configuration({ name = "Report Notification Options" }, function(section)
    section:toggle({
        name = "Sound",
        flag = "report_sound",
        callback = function(v)
            pn.report.sound = v
        end,
    })
    section:slider({
        name = "Volume",
        min = 1,
        max = 2,
        default = 1,
        interval = 0.1,
        flag = "report_volume",
        callback = function(v)
            pn.report.volume = v
        end,
    })
    section:toggle({
        name = "Flashing",
        flag = "report_flashing",
        callback = function(v)
            pn.report.flashing = v
        end,
    })
    section:slider({
        name = "Duration",
        min = 1,
        max = 10,
        default = 3,
        interval = 0.1,
        flag = "report_notification_duration",
        callback = function(v)
            pn.report.duration = v
        end,
    })
end)

notifiers:button_holder({})
notifiers:button({
    name = "Show Current Reports",
    tooltip = "Displays how many times you have been reported with a notification",
    callback = function()
        visuals.update_report_count()
    end,
})

notifiers:splitter()

notifiers:toggle({
    name = "Enable Join Notifications",
    flag = "join_notify",
    callback = function(v)
        pn.join.enabled = v
    end,
}):configuration({ name = "Join Notification Options" }, function(section)
    section:toggle({
        name = "Display KD",
        flag = "join_kd",
        callback = function(v)
            pn.join.kd = v
        end,
    })
    section:toggle({
        name = "Display Hours Played",
        flag = "join_time",
        callback = function(v)
            pn.join.hours_played = v
        end,
    })
    section:slider({
        name = "Duration",
        min = 1,
        max = 10,
        default = 3,
        interval = 0.1,
        flag = "join_notification_duration",
        callback = function(v)
            pn.join.duration = v
        end,
    })
end)

notifiers:toggle({
    name = "Enable Leave Notifications",
    flag = "leave_notify",
    callback = function(v)
        pn.leave.enabled = v
    end,
}):configuration({ name = "Leave Notification Options" }, function(section)
    section:slider({
        name = "Duration",
        min = 1,
        max = 10,
        default = 3,
        interval = 0.1,
        flag = "leave_notification_duration",
        callback = function(v)
            pn.leave.duration = v
        end,
    })
end)

notifiers:toggle({
    name = "Flashing Notifications",
    flag = "player_notification_flashing",
    callback = function(v)
        pn.flashing = v
    end,
})

notifiers:splitter()

notifiers:toggle({
    name = "Flare Calls",
    flag = "flare_calls",
    callback = function(v)
        wn.flare_fired = v
    end,
})

notifiers:toggle({
    name = "Supply Drops",
    flag = "supply_drops",
    callback = function(v)
        wn.airdrop_dropped = v
    end,
})

notifiers:toggle({
    name = "Notification Sound",
    flag = "supply_sound",
    callback = function(v)
        wn.sound = v
    end,
})

notifiers:slider({
    name = "Notification Volume",
    min = 0.1,
    max = 2,
    default = 1,
    interval = 0.1,
    flag = "supply_volume",
    callback = function(v)
        wn.volume = v
    end,
})

notifiers:toggle({
    name = "Flashing Notifications",
    flag = "notification_flashing",
    callback = function(v)
        wn.flashing = v
    end,
})

notifiers:slider({
    name = "Notification Duration",
    min = 0.5,
    max = 3,
    default = 3,
    interval = 0.1,
    flag = "notification_duration",
    callback = function(v)
        wn.duration = v
    end,
})

local vm = config.visuals.viewmodel

viewmodel_pane:toggle({
    name = "Override Viewmodel",
    flag = "viewmodel_override",
    callback = function(v)
        vm.enabled = v
    end,
}):configuration({ name = "Viewmodel Options" }, function(section)
    section:toggle({
        name = "Remove Clothing",
        flag = "viewmodel_remove_clothes",
        callback = function(v)
            vm.remove_clothing = v
            visuals.update_viewmodel()
        end,
    })
    section:toggle({
        name = "Apply Highlight",
        flag = "viewmodel_highlight",
        callback = function(v)
            vm.highlight.enabled = v
            visuals.update_viewmodel()
        end,
    }):colorpicker({
        name = "Instance Fill Color",
        flag = "viewmodel_highlight_fill",
        color = rgb(45, 209, 235),
        alpha = 0.5,
        callback = function(color, alpha)
            vm.highlight.fill.color = color
            vm.highlight.fill.transparency = 1 - alpha
            visuals.update_viewmodel()
        end,
    }):colorpicker({
        name = "Instance Outline Color",
        flag = "viewmodel_highlight_outline",
        color = rgb(45, 209, 235),
        alpha = 0.5,
        callback = function(color, alpha)
            vm.highlight.outline.color = color
            vm.highlight.outline.transparency = 1 - alpha
            visuals.update_viewmodel()
        end,
    })
    section:slider({
        name = "Fill Transparency Multiplier",
        min = -20,
        max = 20,
        default = 1,
        interval = 0.1,
        flag = "viewmodel_fill_mult",
        callback = function(v)
            vm.highlight.fill.multiplier = v
            visuals.update_viewmodel()
        end,
    })
    section:slider({
        name = "Outline Transparency Multiplier",
        min = -20,
        max = 20,
        default = 1,
        interval = 0.1,
        flag = "viewmodel_outline_mult",
        callback = function(v)
            vm.highlight.outline.multiplier = v
            visuals.update_viewmodel()
        end,
    })
end)

viewmodel_pane:toggle({
    name = "Override Weapon",
    flag = "viewmodel_weapon",
    callback = function(v)
        vm.weapon_enabled = v
        visuals.update_viewmodel()
    end,
}):configuration({ name = "Weapon Options" }, function(section)
    section:dropdown({
        name = "Weapon Material",
        flag = "viewmodel_weapon_material",
        items = { "ForceField", "Glass", "Neon", "SmoothPlastic" },
        default = "ForceField",
        callback = function(v)
            vm.weapon_material = v
            visuals.update_viewmodel()
        end,
    })
end):colorpicker({
    name = "Instance Color",
    flag = "viewmodel_weapon_color",
    color = rgb(45, 209, 235),
    callback = function(color, alpha)
        vm.weapon_color = color
        vm.weapon_transparency = math.min(0.99, 1 - alpha)
        visuals.update_viewmodel()
    end,
})

viewmodel_pane:toggle({
    name = "Override Arms",
    flag = "viewmodel_arms",
    callback = function(v)
        vm.arms_enabled = v
        visuals.update_viewmodel()
    end,
}):configuration({ name = "Arm Options" }, function(section)
    section:dropdown({
        name = "Arms Material",
        flag = "viewmodel_arms_material",
        items = { "ForceField", "Glass", "Neon", "SmoothPlastic" },
        default = "ForceField",
        callback = function(v)
            vm.arms_material = v
            visuals.update_viewmodel()
        end,
    })
end):colorpicker({
    name = "Instance Color",
    flag = "viewmodel_arms_color",
    color = rgb(45, 209, 235),
    callback = function(color, alpha)
        vm.arms_color = color
        vm.arms_transparency = math.min(0.99, 1 - alpha)
        visuals.update_viewmodel()
    end,
})

viewmodel_pane:toggle({
    name = "Override Viewmodel Offset",
    flag = "viewmodel_offset",
    callback = function(v)
        vm.offset.enabled = v
        visuals.update_viewmodel()
    end,
}):configuration({ name = "Offset Options" }, function(section)
    for _, axis in { "X", "Y", "Z" } do
        section:slider({
            name = axis .. " Offset",
            min = -5,
            max = 5,
            default = 0,
            interval = 0.01,
            flag = "viewmodel_" .. axis:lower(),
            callback = function(v)
                vm.offset[axis:lower()] = v
                visuals.update_viewmodel()
            end,
        })
    end
end)

local ls = config.visuals.local_self

local_self_pane:toggle({
    name = "Third Person",
    flag = "third_person",
    callback = function(v)
        ls.third_person = v
        visuals.update_visualizer()
        combat.update_pitch()
    end,
}):configuration({ name = "Third Person Options" }, function(section)
    section:slider({
        name = "Distance",
        min = 1,
        max = 20,
        default = 2,
        suffix = "m",
        interval = 0.1,
        flag = "third_person_distance",
        callback = function(v)
            ls.third_person_value = v
        end,
    })
    section:toggle({
        name = "Visualize Pitch",
        flag = "visualize_pitch",
        callback = function(v)
            ls.visualize_pitch = v
            combat.update_pitch()
        end,
    })
end):keybind({
    name = "Third Person",
    flag = "third_person_bind",
    callback = function(v)
        ls.third_person = v
        visuals.update_visualizer()
        combat.update_pitch()
    end,
})

local_self_pane:splitter()

local_self_pane:toggle({
    name = "Self Chams",
    flag = "self_chams",
    callback = function(v)
        ls.player_chams = v
        visuals.update_character()
    end,
}):configuration({ name = "Self Cham Options" }, function(section)
    section:dropdown({
        name = "Material",
        flag = "self_chams_material",
        items = { "ForceField", "Glass", "Neon", "SmoothPlastic" },
        default = "ForceField",
        callback = function(v)
            ls.player_material = v
            visuals.update_character()
        end,
    })
    section:toggle({
        name = "Remove Clothing",
        flag = "self_remove_clothing",
        callback = function(v)
            ls.remove_clothing = v
            visuals.update_character()
        end,
    })
end):colorpicker({
    name = "Instance Color",
    flag = "self_chams_color",
    color = rgb(45, 209, 235),
    callback = function(color, alpha)
        ls.player_color = color
        ls.player_transparency = math.min(0.99, 1 - alpha)
        visuals.update_character()
    end,
})

local_self_pane:splitter()

local_self_pane:toggle({
    name = "Aspect Ratio",
    flag = "aspect_ratio",
    callback = function(v)
        ls.aspect_ratio.enabled = v
        visuals.update_camera()
    end,
}):configuration({ name = "Aspect Ratio Options" }, function(section)
    for _, dir in { "Vertical", "Horizontal" } do
        section:slider({
            name = dir,
            min = 1,
            max = 100,
            default = 100,
            interval = 0.1,
            suffix = "%",
            flag = "ratio_" .. dir:lower(),
            callback = function(v)
                ls.aspect_ratio[dir:lower()] = v
                visuals.update_camera()
            end,
        })
    end
end)

local function gameplay_fov(value)
    local gameplay = gameplay_settings()
    if gameplay then
        gameplay:SetAttribute("DefaultFOV", value)
    end
end

local_self_pane:toggle({
    name = "Override FOV",
    flag = "override_fov",
    callback = function(v)
        ls.override_fov = v
        local gameplay = gameplay_settings()
        if v then
            ls.default_fov = gameplay and gameplay:GetAttribute("DefaultFOV")
            gameplay_fov(ls.fov_value)
        else
            gameplay_fov(ls.default_fov)
        end
    end,
})

local_self_pane:slider({
    name = "FOV Value",
    min = 1,
    max = 120,
    default = 90,
    interval = 1,
    flag = "fov_value",
    callback = function(v)
        ls.fov_value = v
        if ls.override_fov then
            gameplay_fov(v)
        end
    end,
})

local_self_pane:splitter()

local removals = config.visuals.ui_removals

local_self_pane:toggle({
    name = "Enable Removals",
    flag = "screen_removals",
    callback = function(v)
        removals.enabled = v
        visuals.update_ui()
    end,
})

local_self_pane:dropdown({
    name = "Removals",
    scrolling = true,
    multi = true,
    flag = "remove_elements",
    items = { "Flashbang", "Gas Mask", "Parallax", "Visor", "Inventory Background", "Inventory Blur", "Inventory Decoration" },
    default = { "Visor" },
    callback = function(v)
        removals.elements = v
        visuals.update_ui()
    end,
})

local_self_pane:toggle({
    name = "Override Whiz Volume",
    flag = "override_whiz",
    callback = function(v)
        ls.override_whiz = v
        visuals.update_whiz()
    end,
})

local_self_pane:slider({
    slider_type = "normal",
    min = 0,
    max = 2,
    default = 0.5,
    interval = 0.01,
    flag = "whiz_volume",
    callback = function(v)
        ls.whiz_volume = v
        visuals.update_whiz()
    end,
})

local_self_pane:splitter()

local_self_pane:toggle({
    name = "Session Data",
    flag = "session_data",
    callback = function(v)
        panels.session_data.update_visibility("outline", v)
    end,
}):keybind({
    name = "Session Data",
    flag = "session_data_bind",
    callback = function(v)
        panels.session_data.update_visibility("outline", v)
    end,
})

local data_elements = { "Player Count", "Server Time", "Weather", "KD", "Kills", "Deaths" }

local_self_pane:dropdown({
    name = "Data Elements",
    multi = true,
    flag = "data_elements",
    items = data_elements,
    default = { "KD", "Kills", "Deaths" },
    callback = function(selected)
        for _, name in data_elements do
            panels.session_data.update_visibility(config.session_data_map[name], false)
        end
        for _, name in selected do
            local key = config.session_data_map[name]
            if key then
                panels.session_data.update_visibility(key, true)
            end
        end
    end,
})

local hide = config.visuals.ui_hide

local_self_pane:toggle({
    name = "Hide UI",
    flag = "hide_ui",
    callback = function(v)
        hide.enabled = v
        visuals.update_ui()
    end,
}):keybind({
    name = "Hide UI",
    flag = "hide_ui_bind",
    callback = function(v)
        hide.hide = v
        visuals.update_ui()
    end,
})

local_self_pane:dropdown({
    name = "Hide Elements",
    multi = true,
    flag = "hide_elements",
    items = { "Main Gui", "Server Info" },
    default = { "Main Gui", "Server Info" },
    callback = function(selected)
        local names = { ["Main Gui"] = "MainGui", ["Server Info"] = "ServerInfo" }
        local elements = {}
        for _, name in selected do
            if names[name] then
                table.insert(elements, names[name])
            end
        end
        hide.elements = elements
        visuals.update_ui()
    end,
})

local ch = config.visuals.crosshair

crosshair_pane:toggle({
    name = "Enable Crosshair",
    flag = "crosshair",
    callback = function(v)
        ch.enabled = v
        visuals.update_crosshair()
    end,
}):colorpicker({
    name = "Outer Gradient Color",
    flag = "crosshair_color_outer",
    color = rgb(45, 209, 235),
    callback = function(color, alpha)
        ch.color_1 = color
        ch.color_transparency_1 = 1 - alpha
        visuals.update_crosshair()
    end,
}):colorpicker({
    name = "Inner Gradient Color",
    flag = "crosshair_color_inner",
    color = rgb(45, 209, 235),
    callback = function(color, alpha)
        ch.color_2 = color
        ch.color_transparency_2 = 1 - alpha
        visuals.update_crosshair()
    end,
})

crosshair_pane:toggle({
    name = "Outline",
    flag = "crosshair_outline",
    callback = function(v)
        ch.outline = v
        visuals.update_crosshair()
    end,
}):colorpicker({
    name = "Outline Color",
    flag = "crosshair_outline_color",
    color = rgb(0, 0, 0),
    callback = function(color, alpha)
        ch.outline_color = color
        ch.outline_transparency = 1 - alpha
    end,
})

crosshair_pane:dropdown({
    name = "Position",
    flag = "crosshair_position",
    items = { "Center", "Mouse", "Target" },
    default = "Center",
    callback = function(v)
        ch.position = v
        visuals.update_crosshair()
    end,
})

for _, s in {
    { "Gap", "gap", 3, 100, 18, "crosshair_gap" },
    { "Length", "length", 1, 75, 37, "crosshair_length" },
    { "Width", "width", 1, 4, 1, "crosshair_width" },
    { "Rotation", "rotation", -180, 180, 0, "crosshair_rotation" },
} do
    crosshair_pane:slider({
        name = s[1],
        min = s[3],
        max = s[4],
        default = s[5],
        interval = 1,
        flag = s[6],
        callback = function(v)
            ch[s[2]] = v
            visuals.update_crosshair()
        end,
    })
end

crosshair_pane:toggle({
    name = "Spin",
    flag = "crosshair_spin",
    callback = function(v)
        ch.spin = v
        visuals.update_crosshair()
    end,
})

crosshair_pane:slider({
    name = "Spin Speed",
    min = -5,
    max = 5,
    default = 1,
    interval = 0.1,
    flag = "crosshair_spin_speed",
    callback = function(v)
        ch.spin_speed = v
        visuals.update_crosshair()
    end,
})

crosshair_pane:toggle({
    name = "Resize",
    flag = "crosshair_resize",
    callback = function(v)
        ch.animation.resize = v
    end,
}):configuration({ name = "Animation Options" }, function(section)
    section:toggle({
        name = "Animate Length",
        flag = "crosshair_animate_length",
        callback = function(v)
            ch.animation.length.resize = v
        end,
    })
    section:slider({
        name = "Value",
        min = 1,
        max = 75,
        default = 19,
        interval = 1,
        flag = "crosshair_length_value",
        callback = function(v)
            ch.animation.length.value = v
        end,
    })
    section:splitter({ offset = 1 })
    section:toggle({
        name = "Animate Gap",
        flag = "crosshair_animate_gap",
        callback = function(v)
            ch.animation.gap.resize = v
        end,
    })
    section:slider({
        name = "Value",
        min = 3,
        max = 100,
        default = 36,
        interval = 1,
        flag = "crosshair_gap_value",
        callback = function(v)
            ch.animation.gap.value = v
        end,
    })
    section:splitter({ offset = 1 })
    section:slider({
        name = "Speed",
        min = 0.01,
        max = 5,
        default = 1,
        interval = 0.01,
        flag = "crosshair_animation_speed",
        callback = function(v)
            ch.animation.speed = v
        end,
    })
end)

library:refresh_contrast()

local function log_and_notify(text, prefix, color, time)
    library:notification({ text = text, flashing = true, time = time })
    library.output.create_output({ text = text, prefix = prefix, color = color })
end

for _, text in library.pending_logs do
    library:notification({ text = text, flashing = true, time = 4.5 })
    library.output.create_output({ text = text, prefix = "WARN", color = library.colors.warning })
end
table.clear(library.pending_logs)

library.old_config = library:get_config()
window.set_menu_visibility(true)

if library.checks.first_time then
    log_and_notify("Initializing ShitHax.cc for the first time...", "WARN", library.colors.warning, 5)
else
    log_and_notify("Initializing ShitHax.cc...", "INFO", library.colors.information, 5)
end

start_runtime()

library.output.create_output({ text = "Initializing client bypass...", prefix = "WARN", color = library.colors.warning })
library.output.create_output({ text = "Initialized client bypass successfully!", prefix = "SUCCESS", color = library.colors.success })

task.delay(1.5, function()
    if library.checks.first_time then
        log_and_notify("Successfully initialized ShitHax.cc for the first time!", "SUCCESS", library.colors.success, 7.5)
    else
        log_and_notify("Loaded ShitHax.cc successfully!", "SUCCESS", library.colors.success, 5.5)
    end
    library.loading = false
end)

combat_tab.open_tab()

end

build_menu()
