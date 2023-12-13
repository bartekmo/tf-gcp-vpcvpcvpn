variable "prefix" {
    type = string
    default = "example-"
}

variable "regions" {
    type = list(string)
    default = ["europe-central2", "europe-west1"]
}