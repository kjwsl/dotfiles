local M = {}

function M.get_os()
    local slash = package.config:sub(1,1)
    local os = ""
    if slash == "\\" then
        os = 'w'
    elseif slash == "/" then
        os = 'u'
    end
    return os
end

function M.is_tool_installed(toolname)
    local cmd = "which " .. toolname
    local handle = io.popen(cmd, "r")
    local result = handle:read("*a")
    handle:close()

    if result == "" then
        return false
    else
        return true
    end
end


return M
