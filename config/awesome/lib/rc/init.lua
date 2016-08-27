
--[[

     rc
     Awesome WM configuration module
--]]

local naughty = require ("naughty")

package.loaded.rc = nil

local function notify_require (name)
    local function naughty_handler (err)
        naughty.notify({ preset = naughty.config.presets.critical,
            title = "Error while loading an RC file",
            text = "When loading `" .. name .. "`, got the following error:\n" .. err
        })
    end

    local _, result = xpcall(function () return require(name) end, naughty_handler)
    return result
end

notify_require("errors")

local rc =
{
    layout  = require("lain.layout"),
    util    = require("lain.util"),
    widgets = require("lain.widgets")
}

return rc
