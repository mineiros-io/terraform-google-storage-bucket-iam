# ---------------------------------------------------------------------------------------------------------------------
# REQUIRED VARIABLES
# These variables must be set when using this module.
# ---------------------------------------------------------------------------------------------------------------------

variable "bucket" {
  description = "(Required) Used to find the parent resource to bind the IAM policy to."
  type        = string
}

# ---------------------------------------------------------------------------------------------------------------------
# OPTIONAL VARIABLES
# These variables have defaults, but may be overridden.
# ---------------------------------------------------------------------------------------------------------------------

variable "members" {
  type        = set(string)
  description = "(Optional) Identities that will be granted the privilege in role. Each entry can have one of the following values: 'allUsers', 'allAuthenticatedUsers', 'serviceAccount:{emailid}', 'group:{emailid}', 'domain:{domain}'."
  default     = []
}

variable "role" {
  description = "(Optional) The role that should be applied. Only one 'iam_binding' can be used per role. Note that custom roles must be of the format '[projects|organizations]/{parent-name}/roles/{role-name}'."
  type        = string
  default     = null
}

variable "authoritative" {
  description = "(Optional) Whether to use iam_binding (authoritative mode) or iam_member (non-authoritative/additive mode)."
  type        = bool
  default     = true
}

variable "policy_bindings" {
  description = "(optional) A list of IAM policy bindings."
  type        = any
  default     = null
}

# ------------------------------------------------------------------------------
# MODULE CONFIGURATION PARAMETERS
# These variables are used to configure the module.
# ------------------------------------------------------------------------------

variable "module_enabled" {
  type        = bool
  description = "(Optional) Whether to create resources within the module or not. Default is 'true'."
  default     = true
}

variable "module_depends_on" {
  type        = any
  description = "(Optional) A list of external resources the module depends_on. Default is '[]'."
  default     = []
}
