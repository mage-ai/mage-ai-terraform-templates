# fs.tf | File System Configuration

resource "google_filestore_instance" "instance" {
  name = "${var.app_name}"
  location = var.zone
  tier = "BASIC_HDD"

  file_shares {
    capacity_gb = 1024
    name        = "share1"
  }

  networks {
    network = "default"
    modes   = ["MODE_IPV4"]
  }
}

resource "google_vpc_access_connector" "connector" {
  name          = "${var.app_name}-connector"
  ip_cidr_range = "10.8.0.0/28"
  region        = var.region
  network       = "default"
}

# ---------------------------------------------------
# Uncomment the resource below to use a cheaper NFS provisioned on GCP Compute Engine.
# Then update the value of "FILESTORE_IP_ADDRESS" to module.nfs.internal_ip
# and update the value of "FILE_SHARE_NAME" to "share/mage"
# ---------------------------------------------------
#
# module "nfs" {
#   source  = "DeimosCloud/nfs/google"
#   version = "1.0.1"
#   # insert the 5 required variables here
#   name_prefix = "${var.app_name}-nfs"
#   # labels      = local.common_labels
#   # subnetwork  = module.vpc.public_subnetwork
#   attach_public_ip = true
#   project     = var.project_id
#   network     = "default"
#   machine_type = "e2-medium"
#   export_paths = [
#     "/share/mage",
#   ]
#   capacity_gb = "100"
# }
