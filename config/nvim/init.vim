execute 'source' fnamemodify(expand('<sfile>'), ':h').'/rc/vimrc'

" defer settings
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
    set cursorline
    set mouse=ni
    set nu
    set rnu
    let g:nvcode_termcolors=256
    " color nvcode
    " color palenight
    color base16-tokyo-night-dark
    hi Cursor cterm=reverse gui=reverse
  ]]

  if get_git_pwd() ~= nil then
    vim.cmd [[ set signcolumn=yes ]]
  end
end, 0)
EOF
