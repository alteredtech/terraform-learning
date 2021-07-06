terraform {
  backend "remote" {
    organization = "alteredtech"

    workspaces {
      name = "alt-k8s"
    }
  }
}