vim.api.nvim_create_user_command("AutocmdStats", function()
  local autocmds = vim.api.nvim_get_autocmds({})
  local groups = {}

  for _, autocmd in ipairs(autocmds) do
    local group = autocmd.group_name or "<unnamed>"
    groups[group] = (groups[group] or 0) + 1
  end

  print("=== Autocmd Statistics ===")
  print(string.format("Total autocmds: %d", #autocmds))
  print("\nGroups with >1 autocmd:")
  for name, count in pairs(groups) do
    if count > 1 then
      print(string.format("  %s: %d", name, count))
    end
  end
end, { desc = "Show autocmd statistics" })

vim.api.nvim_create_user_command("MemoryStats", function()
  local autocmds = vim.api.nvim_get_autocmds({})
  local namespaces = vim.api.nvim_get_namespaces()

  print("=== Memory Statistics ===")
  print(string.format("Autocmds: %d", #autocmds))
  print(string.format("Namespaces: %d", vim.tbl_count(namespaces)))
  print(string.format("Buffers: %d", vim.fn.bufnr("$")))
end, { desc = "Show memory statistics" })

vim.api.nvim_create_user_command("MemoryDetailed", function()
  -- Force garbage collection before measuring for accurate results
  collectgarbage("collect")

  local mem_mb = collectgarbage("count") / 1024
  print("=== Detailed Memory Statistics ===")
  print(string.format("Lua memory: %.2f MB", mem_mb))

  -- Count autocmds per group
  local autocmds = vim.api.nvim_get_autocmds({})
  local groups = {}
  for _, ac in ipairs(autocmds) do
    local g = ac.group_name or "<unnamed>"
    groups[g] = (groups[g] or 0) + 1
  end

  -- Sort groups by count
  local sorted_groups = {}
  for name, count in pairs(groups) do
    table.insert(sorted_groups, { name = name, count = count })
  end
  table.sort(sorted_groups, function(a, b)
    return a.count > b.count
  end)

  print("\nTop autocmd groups (with >3 autocmds):")
  for _, item in ipairs(sorted_groups) do
    if item.count > 3 then
      print(string.format("  %s: %d", item.name, item.count))
    end
  end

  print(string.format("\nTotal autocmds: %d", #autocmds))
  print(string.format("Total namespaces: %d", vim.tbl_count(vim.api.nvim_get_namespaces())))
  print(string.format("Total buffers: %d", vim.fn.bufnr("$")))
end, { desc = "Show detailed memory statistics with Lua memory usage" })
