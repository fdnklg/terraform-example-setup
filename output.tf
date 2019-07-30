output "public-dns" {
  value = "${aws_instance.web.public_dns}"
}