// Tunnel 1

resource "google_compute_vpn_tunnel" "leftright_a" {
    name = "${var.prefix}-vpn-${var.left.name}${var.right.name}-a"
    shared_secret = var.secret
    region = var.left.router.region
    vpn_gateway = var.left.gw.id
    peer_gcp_gateway = var.right.gw.id
    router = var.left.router.id
    vpn_gateway_interface = 0
}

resource "google_compute_vpn_tunnel" "rightleft_a" {
    name = "${var.prefix}-vpn-${var.right.name}${var.left.name}-a"
    shared_secret = var.secret
    region = var.left.router.region
    vpn_gateway = var.right.gw.id
    peer_gcp_gateway = var.left.gw.id
    router = var.right.router.id
    vpn_gateway_interface = 0
}

resource "google_compute_router_interface" "left_a" {
    name = "${var.left.name}${var.right.name}-a"
    region = var.left.router.region
    router = var.left.router.name
    vpn_tunnel = google_compute_vpn_tunnel.leftright_a.name
    ip_range = "${cidrhost(var.tunnel_cidrs[0], 1)}/${split("/", var.tunnel_cidrs[0])[1]}"
}

resource "google_compute_router_interface" "right_a" {
    name = "${var.right.name}${var.left.name}-a"
    region = var.right.router.region
    router = var.right.router.name
    vpn_tunnel = google_compute_vpn_tunnel.rightleft_a.name
    ip_range = "${cidrhost(var.tunnel_cidrs[0], 2)}/${split("/", var.tunnel_cidrs[0])[1]}"
}

resource "google_compute_router_peer" "leftright_a" {
    name = "${var.prefix}-bgp-${var.left.name}${var.right.name}-a"
    region = var.left.router.region
    router = var.left.router.name
    interface = google_compute_router_interface.left_a.name
    peer_asn = var.right.router.bgp[0].asn
    peer_ip_address = split( "/", google_compute_router_interface.right_a.ip_range)[0]
}

resource "google_compute_router_peer" "rightleft_a" {
    name = "${var.prefix}-bgp-${var.right.name}${var.left.name}-a"
    region = var.right.router.region
    router = var.right.router.name
    interface = google_compute_router_interface.right_a.name
    peer_asn = var.left.router.bgp[0].asn
    peer_ip_address = split( "/", google_compute_router_interface.left_a.ip_range)[0]
}

//Tunnel 2

resource "google_compute_vpn_tunnel" "leftright_b" {
    name = "${var.prefix}-vpn-${var.left.name}${var.right.name}-b"
    shared_secret = var.secret
    region = var.left.router.region
    vpn_gateway = var.left.gw.id
    peer_gcp_gateway = var.right.gw.id
    router = var.left.router.id
    vpn_gateway_interface = 1
}

resource "google_compute_vpn_tunnel" "rightleft_b" {
    name = "${var.prefix}-vpn-${var.right.name}${var.left.name}-b"
    shared_secret = var.secret
    region = var.left.router.region
    vpn_gateway = var.right.gw.id
    peer_gcp_gateway = var.left.gw.id
    router = var.right.router.id
    vpn_gateway_interface = 1
}

resource "google_compute_router_interface" "left_b" {
    name = "${var.left.name}${var.right.name}-b"
    region = var.left.router.region
    router = var.left.router.name
    vpn_tunnel = google_compute_vpn_tunnel.leftright_b.name
    ip_range = "${cidrhost(var.tunnel_cidrs[1], 1)}/${split("/", var.tunnel_cidrs[1])[1]}"
}

resource "google_compute_router_interface" "right_b" {
    name = "${var.right.name}${var.left.name}-b"
    region = var.right.router.region
    router = var.right.router.name
    vpn_tunnel = google_compute_vpn_tunnel.rightleft_b.name
    ip_range = "${cidrhost(var.tunnel_cidrs[1], 2)}/${split("/", var.tunnel_cidrs[1])[1]}"
}

resource "google_compute_router_peer" "leftright_b" {
    name = "${var.prefix}-bgp-${var.left.name}${var.right.name}-b"
    region = var.left.router.region
    router = var.left.router.name
    interface = google_compute_router_interface.left_b.name
    peer_asn = var.right.router.bgp[0].asn
    peer_ip_address = split( "/", google_compute_router_interface.right_b.ip_range)[0]
}

resource "google_compute_router_peer" "rightleft_b" {
    name = "${var.prefix}-bgp-${var.right.name}${var.left.name}-b"
    region = var.right.router.region
    router = var.right.router.name
    interface = google_compute_router_interface.right_b.name
    peer_asn = var.left.router.bgp[0].asn
    peer_ip_address = split( "/", google_compute_router_interface.left_b.ip_range)[0]
}