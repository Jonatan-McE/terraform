output "depended_on" {
  value = length(null_resource.dependency_setter) > 0 ? null_resource.dependency_setter[0].id : ""
}
