local dap = require("dap")
local dap_languages = {
  "rust", 
}

local packages = {

  ["rust"] = "vscode-extensions.vadimcn.vscode-lldb.lldb",

}

local debuggers = {

  ["rust-path"] = "/bin/lldb-vscode",
  ["rust-name"] = "lldb",
  
}



local function print_default()

  for i = 1, #dap_languages do

    local install_adapter = '! nix-shell -p '.. packages[dap_languages[i]]
    vim.cmd(install_adapter)
    
    -- Get the binary path for the DAP
    local binary_path = vim.system({'nix', 'eval', 'nixpkgs#'..packages[dap_languages[i]]..'.outPath'}):wait().stdout
    binary_path = string.sub(binary_path,2,#binary_path-2) .. debuggers[dap_languages[i]..'-path']

    -- Add the adapter to nvim-dap   
    local add_adapter = 

    'lua require(\'dap\').adapters.'..debuggers[dap_languages[i]..'-name']..' = { '.. 
      'type = \'executable\'; '.. 
      'command = \''..binary_path..'\'; '.. 
      'name = \''..debuggers[dap_languages[i]..'-name']..'\'; '.. 
    '} '
    
----------------- 
    print(add_adapter)
    
    -- Add basic configuration for the DAP 
    local add_config = 

    'lua require(\"dap\").configurations.'..dap_languages[i]..' = { '..
      '{ '..
        'name = \'Debug\'; '..
        'type = \''..debuggers[dap_languages[i]..'-name']..'\'; '.. 
        'request = \'launch\'; '..
        'program = function() '..
          'return vim.fn.input(\'Path to executable: \', vim.fn.getcwd() .. \'/\', \'file\') '..
        'end; '..
        'cwd = \'${workspaceFolder}\'; '..
        'stopOnEntry = false; '..
        'args = {}; '..
      '}, '..
    '}'
-----------------
    
    print(add_config) 
  
    vim.cmd(add_adapter)
    vim.cmd(add_config)
    print(dap_languages[i])
  end
    
end

return {

  print_default = print_default

}
