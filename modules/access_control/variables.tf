variable "project_id" { type = string }
variable "principals" {
  description = "Role -> list of principals"
  type        = map(list(string))
}