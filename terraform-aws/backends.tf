terraform {
  backend "remote" {
    organization = "alteredtech"

    workspaces {
      name = "alt-dev"
    }
  }
}