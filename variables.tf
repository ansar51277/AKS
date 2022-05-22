variable "rgname" {
    description = "This is the resource group name"
    type = map(any)
    default = {
        name = "rgaks"
        location = "East Us"
           }
  }