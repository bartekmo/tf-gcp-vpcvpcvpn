variable "prefix" {
    type = string
}
variable "secret" {
    type = string
}

variable "left" {
    type = object({
      name = string
      gw = object({
        id = string
      })
      router = object({
        id = string
        name = string
        region = string
        bgp = list(object({
            asn = string
        }))
      })
    })
}

variable "right" {
    type = object({
      name = string
      gw = object({
        id = string
      })
      router = object({
        id = string
        name = string
        region = string
        bgp = list(object({
            asn = string
        }))
      })
    })
}

variable "tunnel_cidrs" {
    type = list(string)
    default = ["169.254.3.0/30", "169.254.4.0/30"]
}