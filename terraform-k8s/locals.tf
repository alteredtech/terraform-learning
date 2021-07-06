# --- root/locals.tf ---

locals {
  deployment = {
    nodered = {
      image = "nodered/node-red:latest"
      int   = 1880
      ext   = 1880
      volumepath = "/data"
    #   volumes = [
    #     { container_path_each = "/data" }
    #   ]
    }
    influxdb = {
      image = "influxdb"
      int   = 8086
      ext   = 8086
      volumepath = "/var/lib/influxdb"
    #   volumes = [
    #     { container_path_each = "/var/lib/influxdb" }
    #   ]
    }
    grafana = {
      image = "grafana/grafana"
      int   = 3000
      ext   = 3000
      volumepath = "/var/lib/grafana"
    #   volumes = [
    #     { container_path_each = "/var/lib/grafana" }
    #   ]
    }
  }
}