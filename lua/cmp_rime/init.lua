local cmp = require('cmp')

local source = {}

local rime_initialized = false

source._callback = function(id, candidates)
    local callback = source._callback_table[id]
    if callback == nil then
        return
    end

    print('candidates', candidates)
    if candidates == nil or candidates == vim.NIL then
        callback()
    else
        callback({
            items = candidates,
            isIncomplete = true
        })
    end
    table.remove(source._callback_table, id)
end

source._callback_table = {}

local defaults = {
    shared_data_dir = '/usr/share/rime-data',
    user_data_dir = vim.fn.getenv('HOME') .. '/.local/share/cmp-rime',
    max_candidates = 10
}

source._validate = function(_, option)
    local opts = vim.tbl_deep_extend('keep', option, defaults)
    vim.validate({
        shared_data_dir = { opts.shared_data_dir, 'string' },
        user_data_dir = { opts.user_data_dir, 'string' },
        max_candidates = { opts.max_candidates, 'number' }
    })
    return opts
end

source.new = function()
  return setmetatable({}, { __index = source })
end

source.get_keyword_pattern = function()
  return '\\%([a-zA-Z]\\)*'
end

source.complete = function(self, request, callback)
    local opts = self:_validate(request.option)
    if(not rime_initialized) then
        vim.fn.RimeInit(opts)
        rime_initialized = true
    end

    local input = string.sub(request.context.cursor_before_line, request.offset)
    self._callback_table[request.context.id] = callback
    vim.fn.RimeGetCandidatesFromKeys(input, opts.max_candidates, request.context.cursor, request.context.id)
end

return source
