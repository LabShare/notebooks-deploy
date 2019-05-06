resource "aws_key_pair" "mykeypair" {
  key_name = "jupyter"
  public_key = "${file("${var.public-key}")}"
  lifecycle {
    ignore_changes = ["public_key"]
  }
}
