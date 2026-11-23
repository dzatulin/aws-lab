resource "pritunl_user" "lab" {
  name            = "lab-user"
  email           = "d.zatulin@gmail.com"
  organization_id = pritunl_organization.lab.id
}
