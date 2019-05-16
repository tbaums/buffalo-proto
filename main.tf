provider "aws" {
 region = "us-east-1"
}
module "dcos" {
  source = "dcos-terraform/dcos/aws"
#  dcos_instance_os    = "coreos_1855.5.0"
  dcos_instance_os    = "centos_7.5"
  cluster_name        = "buffalo-proto"
  ssh_public_key_file = "~/.ssh/ccm-default.pub"
  admin_ips           = ["0.0.0.0/0"]
  num_masters        = "1"
  num_private_agents = "9"
  num_public_agents  = "2"
  bootstrap_instance_type = "t2.medium"
  public_agents_instance_type = "c5.xlarge"
  private_agents_instance_type = "c5.4xlarge"
  masters_instance_type = "m4.xlarge"
  availability_zones = ["us-east-1a","us-east-1b","us-east-1c"]
  dcos_version = "1.13.0"
  #dcos_variant = "open"
  subnet_range        = "172.16.0.0/16"
  dcos_variant = "ee"
  dcos_license_key_contents = "${file("~/scripts/license.txt")}"
  #dcos_install_mode = "${var.dcos_install_mode}"
  #dcos_resolvers = ["169.254.169.253"]
  tags = {owner = "mtanenbaum", expiration = "8h"}
  dcos_overlay_network = <<EOF
  # YAML
      vtep_subnet: 44.128.0.0/20
      vtep_mac_oui: 70:B3:D5:00:00:00
      overlays:
        - name: dcos
          subnet: 12.0.0.0/8
          prefix: 26
        - name: dev
          subnet: 9.1.0.0/16
          prefix: 24
        - name: qa
          subnet: 9.2.0.0/16
          prefix: 24
        - name: prod
          subnet: 9.3.0.0/16
          prefix: 24
  EOF
#  dcos_resolvers = <<EOF
#  # YAML
#    - "169.254.169.253"
#  EOF

  public_agents_additional_ports = ["10102","50000","10101","6000", "6001", "6002", "6003", "6445", "6444", "6443", "7443", "8080", "8085", "10080", "11080", "12080", "13080", "14080", "3000", "9090", "9093", "9091", "6090", "30443", "30080"]
}
output "masters-ips" {
  value = "${module.dcos.masters-ips}"
}
output "cluster-address" {
  value = "${module.dcos.masters-loadbalancer}"
}
output "public-agents-loadbalancer" {
  value = "${module.dcos.public-agents-loadbalancer}"
}
