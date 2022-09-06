include "root" {
  path   = find_in_parent_folders()
  expose = true

}

inputs = {
  env    = include.root.locals.env
  region = include.root.locals.aws_region
}
