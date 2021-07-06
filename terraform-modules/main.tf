
module "image" {
  source   = "./image"
  for_each = local.deployment
  image_in = each.value.image
}


module "container" {
  source       = "./container"
  for_each     = local.deployment
  count_in     = each.value.container_count
  name_in      = each.key
  image_in     = each.value.image
  int_port_in  = each.value.int
  ext_port_in  = each.value.ext
  sudo_pass_in = var.sudo_pass
  volumes_in   = each.value.volumes
}