local oop = require("diffview.oop")
local Rev = require('diffview.vcs.rev').Rev
local RevType = require('diffview.vcs.rev').RevType

local M = {}

---@class SlRev : Rev
local SlRev = oop.create_class("SlRev", Rev)

SlRev.NULL_TREE_SHA = "0000000000000000000000000000000000000000"

function SlRev:init(rev_type, revision, track_head)
  local t = type(revision)

  assert(
    revision == nil or t == "string" or t == "number",
    "'revision' must be one of: nil, string, number!"
  )
  if t == "string" then
    assert(revision ~= "", "'revision' cannot be an empty string!")
  end

  t = type(track_head)
  assert(t == "boolean" or t == "nil", "'track_head' must be of type boolean!")

  self.type = rev_type
  self.track_head = track_head or false

  self.commit = revision
end

function SlRev.new_null_tree()
  return SlRev(RevType.COMMIT, SlRev.NULL_TREE_SHA)
end

function SlRev:object_name(abbrev_len)
  if self.commit then
    if abbrev_len then
      return self.commit:sub(1, abbrev_len)
    end

    return self.commit
  end

  return "UNKNOWN"
end

---@param rev_from SlRev|string
---@param rev_to SlRev|string
---@return string?
function SlRev.to_range(rev_from, rev_to)
  local name_from = type(rev_from) == "string" and rev_from or rev_from:object_name()
  local name_to

  if rev_to then
    if type(rev_to) == "string" then
      name_to = rev_to
    elseif rev_to.type == RevType.COMMIT then
      name_to = rev_to:object_name()
    end
  end

  if name_from and name_to then
    return name_from .. "::" .. name_to
  else
    return name_from .. "::" .. name_from
  end
end

M.SlRev = SlRev
return M
