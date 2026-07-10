local home = os.getenv 'HOME'

return {
  {
    name = 'trt_llm',
    local_prefix = home .. '/work',
    root_name_pattern = '^trt%-llm',
    remote_prefix = '/workspace',
    ssh_alias = 'baseten-dev-pod',
    clangd = 'clangd-18',
    compiler = 'clang++-18',
    cuda_arch = 'sm_100a',
    cuda_path = '/usr/local/cuda',
    compile_commands_dir = 'cpp/build',
    container = 'trt-llm-tooling',
    filetypes = { 'c', 'cpp', 'cuda' },
    preflight = true,
  },
  {
    name = 'b200',
    local_prefix = home .. '/work',
    remote_prefix = '/workspace',
    ssh_alias = 'baseten-dev-pod',
    clangd = 'clangd-21',
    compiler = 'clang++-21',
    cuda_arch = 'sm_100a',
    cuda_path = '/usr/local/cuda',
    filetypes = { 'cuda' },
    preflight = true,
  },
}
