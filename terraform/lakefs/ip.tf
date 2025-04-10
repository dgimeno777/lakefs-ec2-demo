
data "http" "ip" {
  url = "https://ipv4.icanhazip.com/"
}

locals {
  public_ip = chomp(data.http.ip.response_body)
}
