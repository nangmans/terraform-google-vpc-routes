resource "random_id" "random_id" {
  for_each = local.routes
  keepers = {
    network                = var.network_name
    dest_range             = each.value.dest_range
    priority               = try(each.value.priority, 1000)
    tag                    = try(join(",", each.value.tags), null)
    next_hop_gateway       = try(each.value.next_hop_gateway, null)
    next_hop_instance      = try(each.value.next_hop_instance, null)
    next_hop_instance_zone = try(each.value.next_hop_instance_zone, null)
    next_hop_ip            = try(each.value.next_hop_ip, null)
    next_hop_vpn_tunnel    = try(each.value.next_hop_vpn_tunnel, null)
    next_hop_ilb           = try(each.value.next_hop_ilb, null)
  }
  byte_length = 5
}

resource "time_static" "timestamp" {
  for_each = local.routes
  triggers = {
    name = md5(jsonencode(each.value))
  }
}

resource "google_compute_route" "route" {
  for_each = local.routes
  project  = var.project_id
  name = format(
    "%s-%s",
    each.key,
    random_id.random_id[each.key].hex
  )
   
  description = format(
    "%s route in %s network to %s created at %s",
    each.key,
    var.network_name,
    try(each.value.next_hop_gateway, null) != null ? each.value.next_hop_gateway :
    try(each.value.next_hop_instance, null) != null ? each.value.next_hop_instance :
    try(each.value.next_hop_ip, null) != null ? each.value.next_hop_ip :
    try(each.value.next_hop_vpn_tunnel) != null ? each.value.next_hop_vpn_tunnel :
    try(each.value.next_hop_ilb) != null ? each.value.next_hop_ilb : "At least one of value is required",
    time_static.timestamp[each.key].rfc3339
  )

  network                = random_id.random_id[each.key].keepers.network
  dest_range             = random_id.random_id[each.key].keepers.dest_range
  priority               = random_id.random_id[each.key].keepers.priority
  tags                   = try(split(",", random_id.random_id[each.key].keepers.tag),null)
  next_hop_gateway       = try(each.value.next_hop_gateway, null)
  next_hop_instance      = try(random_id.random_id[each.key].keepers.next_hop_instance,null)
  next_hop_instance_zone = try(random_id.random_id[each.key].keepers.next_hop_instance_zone,null)
  next_hop_ip            = try(random_id.random_id[each.key].keepers.next_hop_ip,null)
  next_hop_vpn_tunnel    = try(random_id.random_id[each.key].keepers.next_hop_vpn_tunnel,null)
  next_hop_ilb           = try(random_id.random_id[each.key].keepers.next_hop_ilb,null)

  lifecycle {
    create_before_destroy = true
  }
}