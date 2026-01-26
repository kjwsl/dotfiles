augroup AutoSourceVim
    " Automatically source vim files after being written.
    autocmd BufWritePost *.vim source %
augroup END

