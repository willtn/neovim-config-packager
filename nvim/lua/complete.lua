local util = require 'vim.lsp.util'
local api = vim.api
local M = {}

local function ins_complete()
  local mode_keys = api.nvim_replace_termcodes("<C-g><C-g><C-n>", true, false, true)
  return api.nvim_feedkeys(mode_keys, 'n', true)
end

function M.trigger_custom_complete()
  local bufnr = api.nvim_get_current_buf()
  local pos = api.nvim_win_get_cursor(0)
  local line = api.nvim_get_current_line()
  local line_to_cursor = line:sub(1, pos[2])
  local textMatch = vim.fn.match(line_to_cursor, '\\k*$')
  local prefix = line_to_cursor:sub(textMatch+1)
  local params = util.make_position_params()

  vim.lsp.buf_request(bufnr, 'textDocument/completion', params, function(err, _, result)
    if err or not result then
      return ins_complete()
    end

    local matches = util.text_document_completion_list_to_complete_items(result, prefix)

    if vim.tbl_isempty(matches) then
      return ins_complete()
    end

    return vim.fn.complete(textMatch+1, matches)
  end)

  return -2
end

return M
