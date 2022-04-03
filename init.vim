let g:neovimconfig = "~/AppData/Local/nvim/"

let g:config_files = ["config.vim"]

if exists('g:vscode')
    " VSCode extension
else
    for config_file in g:config_files
        execute 'source ' .. g:neovimconfig .. '/' .. config_file
    endfor
endif
