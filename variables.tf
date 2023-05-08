variable "config_directories" {
  description = "List of paths to folders where routes configs are stored in yaml format. Folder may include subfolders with configuration files. Files suffix must be `.yaml`."
  type        = list(string)
}

variable "network_name" {
  description = "Name of the network this set of routes rules applies to."
  type        = string
}

variable "project_id" {
  description = "Project Id."
  type        = string
}

variable "impersonate_sa" {
  description = "Email of the service account to use for Terraform"
  type        = string
}

variable "validate_labels" {
  description = "validate labels"
  type        = map(string)
}

