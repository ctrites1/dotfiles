-- Live browser preview for HTML / Markdown / AsciiDoc (`:LivePreview start`).
--
-- Deferred: the plugin's `plugin/livepreview.lua` pulls in `livepreview.health`
-- and `livepreview.utils` as it is sourced, which cost ~180ms of startup for a
-- command that is used occasionally. `lazy_load` stands in until it is.
local util = require 'user.util'

util.lazy_load {
  specs = { util.gh 'brianhuster/live-preview.nvim' },
  cmds = { 'LivePreview' },
  complete = { 'start', 'close', 'pick', '-h', '--help' },
}
