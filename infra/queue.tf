# Contract for the dispatch-jobs address. The Kubernetes Service of the same
# name is what intake and dispatcher are configured to call. This resource is
# the queue the architecture binds. Nothing here is applied.
resource "aws_sqs_queue" "dispatch_jobs" {
  name                       = "harbor-relay-dispatch-jobs"
  message_retention_seconds  = 86400
  visibility_timeout_seconds = 30
  sqs_managed_sse_enabled    = true

  tags = {
    system = "harbor-relay"
    role   = "dispatch-jobs"
  }
}

output "dispatch_jobs_name" {
  value       = aws_sqs_queue.dispatch_jobs.name
  description = "Queue name published at the dispatch-jobs Service."
}
