data "terraform_remote_state" "kubeconfig" {
    backend = "remote"
    config = {
        organization = "alteredtech"
        workspaces = {
            name = "alt-dev"
        }
    }
}