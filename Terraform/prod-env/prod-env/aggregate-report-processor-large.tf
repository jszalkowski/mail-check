module "aggregate-report-processor-large" {
  source	      	= "./lambdaProcessor-module"
  env-name            	= "${var.env-name}"
  aws-region          	= "${var.aws-region}"
  aws-account-id	= "${var.aws-account-id}"
  lambda-filename     	= "AggregateReportParser.zip"
  source-code-hash	= "${base64sha256(file("AggregateReportParser.zip"))}"
  lambda-function-name	= "TF-${var.env-name}-aggregate-report-parser-large"
  handler		= "Dmarc.AggregateReport.Parser.Lambda::Dmarc.AggregateReport.Parser.Lambda.AggregateReportProcessor::HandleScheduledEvent"
  lambda-role		= "${aws_iam_role.lambda-report-processor.arn}"
  connection-string	= "Server = ${aws_rds_cluster.rds-cluster.endpoint}; Port = 3306; Database = dmarc; Uid = ${var.db-processor-uname}; Pwd = ${var.db-processor-pwd};Connection Timeout=5;"
  subnet-ids		= "${join(",", aws_subnet.dmarc-env-subnet.*.id)}"
  security-group-ids	= "${aws_security_group.lambda-parser.id}"
  lambda-memory	        = "1528"
  lambda-timeout        = "180"
  scheduler-interval	= "5"
  RemainingTimeThresholdSeconds = "90"
  QueueUrl		= "${aws_sqs_queue.aggregate-report-queue2.id}"
}  
