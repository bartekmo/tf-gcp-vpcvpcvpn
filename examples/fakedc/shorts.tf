locals {
    regions_short = [
        replace( replace( replace( replace(replace(replace(replace(replace(replace(var.regions[0], "south", "s"), "east", "e"), "central", "c"), "north", "n"), "west", "w"), "europe-", "eu"), "australia", "au" ), "northamerica", "na"), "southamerica", "sa"),
        replace( replace( replace( replace(replace(replace(replace(replace(replace(var.regions[1], "south", "s"), "east", "e"), "central", "c"), "north", "n"), "west", "w"), "europe-", "eu"), "australia", "au" ), "northamerica", "na"), "southamerica", "sa")    
    ]
}