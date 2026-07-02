local home = os.getenv 'HOME'

return {
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
