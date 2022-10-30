execute 'source' fnamemodify(expand('<sfile>'), ':h').'/rc/vimrc'

" defer
lua <<EOF
local function get_git_pwd()
  local git_pwd = vim.fn.systemlist('git rev-parse --show-toplevel')[1]
  if string.match(git_pwd, 'fatal: not a git repository') then
    git_pwd = nil
  end
  return git_pwd
end

vim.defer_fn(function()
  vim.cmd [[
    color nvcode
    " for drop command
    let $NVIM_LISTEN_ADDRESS=1
  ]]

  if get_git_pwd() ~= nil then
    vim.cmd [[ set signcolumn=yes ]]
  end
end, 0)
EOF
