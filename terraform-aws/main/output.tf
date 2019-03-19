# output - in a separate terraform file

#output "rds_endpoint" {
#  value = "${aws_db_instance.vhaDatabase.endpoint}"
#}

output "rds_endpoit" {
  value = "${module.vha-dev-rds.rds_endpoint}"
}
