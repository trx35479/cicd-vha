# Expose rds attributes 

output "rds_endpoint" {
  value = "${aws_db_instance.vhaDatabase.*.endpoint}"
}
