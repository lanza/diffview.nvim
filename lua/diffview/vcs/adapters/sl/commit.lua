local oop = require('diffview.oop')
local Commit = require('diffview.vcs.commit').Commit

local M = {}

---@class SlCommit : Commit
local SlCommit = oop.create_class('SlCommit', Commit)

function SlCommit:init(opt)
  self:super(opt)

  if opt.time_offset then
    self.time_offset = SlCommit.parse_time_offset(opt.time_offset)
    self.time = self.time - self.time_offset
  else
    self.time_offset = 0
  end

  self.iso_date = Commit.time_to_iso(self.time, self.time_offset)
end

---@param iso_date string?
function SlCommit.parse_time_offset(iso_date)
  if not iso_date or iso_date == "" then
    return 0
  end

  local sign, offset = vim.trim(iso_date):match("([+-])(%d+)")

  offset = tonumber(offset)

  if sign == "-" then
    offset = -offset
  end

  return offset
end

M.SlCommit = SlCommit
return M
