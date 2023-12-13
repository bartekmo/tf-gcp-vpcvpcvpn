// "Datacemter" networks

resource "google_compute_network" "dc" {
    count = 2

    name = "${var.prefix}-vpc-dc${count.index+1}"
    auto_create_subnetworks = false
    routing_mode = "GLOBAL"
} 

resource "google_compute_subnetwork" "dc" {
    count = 2

    name = "${var.prefix}-sb-dc${count.index+1}"
    region = var.regions[count.index]
    ip_cidr_range = "192.168.${count.index+1}00.0/24"
    network = google_compute_network.dc[count.index].id
    secondary_ip_range {
        range_name = "test1"
        ip_cidr_range = "192.168.${count.index+1}01.0/24"
    }
    secondary_ip_range {
        range_name = "test2"
        ip_cidr_range = "192.168.${count.index+1}02.0/24"
    }
}

// "Interconnect" networks
resource "google_compute_network" "ic" {
    name = "${var.prefix}-vpc-ic"
    auto_create_subnetworks = false
    routing_mode = "GLOBAL"
}

resource "google_compute_subnetwork" "ic" {
    for_each = toset(var.regions)

    name = "${var.prefix}-sb-ic"
    region = each.key
    ip_cidr_range = "10.2.0.${index(var.regions, each.key)*128}/25"
    network = google_compute_network.ic.id
}

// "Datacenter" routers and VPN gateways

resource "google_compute_router" "dc" {
  count = 2

  name   = "${var.prefix}-rtr-dc${count.index+1}"
  region = var.regions[count.index]
  network = google_compute_network.dc[count.index].id
  bgp {
    asn = 64512
  }
}

resource "google_compute_ha_vpn_gateway" "dc" {
  count = 2

  region   = var.regions[count.index]
  name     = "${var.prefix}-gw-dc${count.index+1}"
  network  = google_compute_network.dc[count.index].id
}

// "Interconnect" routers and VPN gateways

resource "google_compute_router" "ic" {
  count = 2

  name   = "${var.prefix}-rtr-ic-${local.regions_short[count.index]}"
  region = var.regions[count.index]
  network = google_compute_network.ic.id
  bgp {
    asn = 64513
  }
}

resource "google_compute_ha_vpn_gateway" "ic" {
  count = 2

  region   = var.regions[count.index]
  name     = "${var.prefix}-gw-ic${count.index+1}"
  network  = google_compute_network.ic.id
}

// VPN tunnels

module "vpn" {
    source = "./vpnha"
    count = 2

    prefix = var.prefix
    left = {
        name = "dc${count.index+1}"
        gw = google_compute_ha_vpn_gateway.dc[count.index]
        router = google_compute_router.dc[count.index]
    }
    right = {
        name = "ic${count.index+1}"
        gw = google_compute_ha_vpn_gateway.ic[count.index]
        router = google_compute_router.ic[count.index]
    }

    tunnel_cidrs = [
        "169.254.${count.index}.0/30",
        "169.254.${count.index}.16/30"
    ]
}