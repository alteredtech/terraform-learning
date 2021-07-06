resource "docker_volume" "container_volume" {
  count = var.volume_count
  name  = "${var.volume_name}-${count.index}"
  #   sudo_use = var.sudo_pass_in
  provisioner "local-exec" {
    when       = destroy
    command    = "mkdir ${path.cwd}/../backup/"
    on_failure = continue
  }
  #   provisioner "local-exec" {
  #     when       = destroy
  #     command    = "tar -czvf ${path.cwd}/../backup/${self.name}.tar.gz ${self.mountpoint}/"
  #     on_failure = fail
  #   }

}