require "helpers/test_helper"
require "helpers/test_collection"

# Use :test credentials in ~/.fog for live integration testing
# XXX not sure if this will work on Travis CI or not
Fog.credential = :test

# Enable test debugging, providing additional information in some methods
DEBUG = ENV['FOG_TEST_DEBUG'] || false

# Helpers

TEST_PROJECT = Fog.credentials[:google_project]

TEST_ZONE = "us-central1-f".freeze
TEST_REGION = "us-central1".freeze
TEST_SIZE_GB = 10
TEST_MACHINE_TYPE = "n1-standard-1".freeze
TEST_IMAGE = "debian-9-stretch-v20180611".freeze
TEST_IMAGE_PROJECT = "debian-cloud".freeze
TEST_IMAGE_FAMILY = "debian-9".freeze

# XXX This depends on a public image in gs://fog-test-bucket; there may be a better way to do this
# The image was created like so: https://cloud.google.com/compute/docs/images#export_an_image_to_google_cloud_storage
TEST_RAW_DISK_SOURCE = "http://storage.googleapis.com/fog-test-bucket/fog-test-raw-disk-source.image.tar.gz".freeze

TEST_SQL_TIER_FIRST = "D1".freeze
TEST_SQL_REGION_FIRST = "us-central".freeze

TEST_SQL_TIER_SECOND = "db-n1-standard-1".freeze
TEST_SQL_REGION_SECOND = TEST_REGION

# Test certificate/key for SSL Proxy tests, generated via:
# $ openssl genrsa -out example.key 2048
# $ openssl req -new -key example.key -out example.csr
# ...
# Common Name (eg, fully qualified host name) []:example.com
# Email Address []:admin@example.com
# ...
# $ openssl x509 -req -in example.csr -signkey example.key -out example.crt

TEST_PEM_CERTIFICATE = <<CERT
-----BEGIN CERTIFICATE-----
MIIC7DCCAdQCCQCDSZQ3PYJW6zANBgkqhkiG9w0BAQUFADA4MRQwEgYDVQQDDAtl
eGFtcGxlLmNvbTEgMB4GCSqGSIb3DQEJARYRYWRtaW5AZXhhbXBsZS5jb20wHhcN
MTgwNjI4MDEzMzA5WhcNMTgwNzI4MDEzMzA5WjA4MRQwEgYDVQQDDAtleGFtcGxl
LmNvbTEgMB4GCSqGSIb3DQEJARYRYWRtaW5AZXhhbXBsZS5jb20wggEiMA0GCSqG
SIb3DQEBAQUAA4IBDwAwggEKAoIBAQC2DQkr6HBIoVsi7I+uHtmmge1KvbWP4nwg
tmKe8FtprjyaBcY729Sc0LTgkOh0krVem9nsxd/Lea47jHTV/vM03xsOuEKRKy3S
Horlr0TBRvB7tSmZCH0jn4x+V/k2qdLKhiDAtbLZ1UC3SWu3OjbE9ozf3fNPmssT
bK2sNesa2XlydzL8wyZMajGLs8CEHVqpZwLSPTeGB3LAhdRjfzJLijqe124otVIb
3+tbxYZVY5GLVQIIR/DlwRzZLxptPALvHq3t3eOfC3eZImXqUzGmoug6nDrdKuEs
C8yaoCNC3sSecoaV5Kyy70Hae+wFV7ocZGejm9AtuHXF1pgM4outAgMBAAEwDQYJ
KoZIhvcNAQEFBQADggEBAFRYuOe7nwR8Sn7TDyzPcqau3yF2qYATtrDIzo7xmh3o
T18FYCeX9gu/M9ytziM2lb/+WRqvcu55FrQiBz434E4wYH/IGUZK849V03dCro10
Po5Hhayt5+tv5Ti0JqmJoC/HN0hNF+WQA8kikiteTTohIDj9rVX2uULA61rnHXSZ
h6ZZRce3PdRKIUjOcQ4pIoI8QXSIToBsdY+Cieg9PHCt8mZhevU7COE1lfPFtdlY
HJhg5xhHVUt40qsahpvUjnPBU8rJPPE06ougf5qjr0D8ZoYeuUQT0VJYwwacfpeb
hs6AFOH5IAj6gjdIRhOWzYSxBYeyzJGfiPSbK4rowFM=
-----END CERTIFICATE-----
CERT

TEST_PEM_CERTIFICATE_PRIVATE_KEY = <<KEY
-----BEGIN RSA PRIVATE KEY-----
MIIEpAIBAAKCAQEAtg0JK+hwSKFbIuyPrh7ZpoHtSr21j+J8ILZinvBbaa48mgXG
O9vUnNC04JDodJK1XpvZ7MXfy3muO4x01f7zNN8bDrhCkSst0h6K5a9EwUbwe7Up
mQh9I5+Mflf5NqnSyoYgwLWy2dVAt0lrtzo2xPaM393zT5rLE2ytrDXrGtl5cncy
/MMmTGoxi7PAhB1aqWcC0j03hgdywIXUY38yS4o6ntduKLVSG9/rW8WGVWORi1UC
CEfw5cEc2S8abTwC7x6t7d3jnwt3mSJl6lMxpqLoOpw63SrhLAvMmqAjQt7EnnKG
leSssu9B2nvsBVe6HGRno5vQLbh1xdaYDOKLrQIDAQABAoIBAD5GA0cjwZT2rQgr
R5LWNrmAZD1W246WeMNv4BhiO8LQuSYup3q+XeIuelD/AKUvsh7kzQzzOvSNcQ4p
o6W4ClWho83LNeoWjRv9GqIq7Cf5LjYC6HHSt4vB/fsR+Mu8F8DzVKzW+pENI5AO
62vH3AhQFixV7e7jEmhYmqf34a5S9U3+0OkzRRbFVA5rBxKK4xLqrX/app4/TKs6
msn+qCJUAVxggcKIACF0slzbGuKfCSOyfPM4dmKV1n857wDu2YB9QwaaI+aHtR9S
rassm1TCcqirUIOsTcAaZ5szjkhAhH+pg/xVjl/2ppz1W/m9cfNQ4zwle1YuUmpS
OxyqUcECgYEA8jQ0zZG4J7MOX29o2F+D4VI5I1kp6uLsfhb8KztEgpgdMy+nGNsK
wlOd2fJU3hK51dg82HKSSEzHHPud7O39pWEo3iSmgdZ+pXhjXe95x+bVPfP01eSp
CSyMP8t6c9RxVtpVU1IbrjMXROuwEIxaIzMhT4YYDGOoSj2xLn43N9kCgYEAwGuv
MJeCDMI2Zr+OA1N3FUk6Py8q1zxJN3Wt3CwSjp57K3g2LaqN6gwgIbN3d1fEV9cM
ATtjjsFC+toFrP8BZ1wj3DY8Q4OsOmXng1V4bw4Y5xsT6SxXh7E0gU2L8MCjUdri
WUUu++yRRcUpWUGRRMYx6cN529HPNbAPm5Y8QfUCgYAGpCHShS1cgU9ilIZ2cGAI
XJ3Od1Jr6176shyl/tEJF6ytS6A0UUVBQNOyNy/WiwLndy9r6/BQ5TIMfGW/KmNr
FnftZ2ndY4lDdkKbP8bCEXVFZpwPBV8RLlSGJ0krReb5r7DpQPYbV7FKpX/FZGPQ
VUWTjaS5Kj5iEsD5+mH/OQKBgQCKhftc8/V/0eDwHz7RTikQfeMc0Yv530CmWGWN
d3z0h0sMhEIcpgf8UjZfjJ+YnuqOghX2XRbTEnZxuLsVS49rJX37bl/8CrLWZ74/
YiyNZoyu82NmHbH10bCG1ZjE/SmWKAmDUrb8TdZXcBTQWM+Hv1b3fu4fPe/6KoFR
9Nn0cQKBgQC8BViTyfPTSuTEb8z7uzLEQk13MH+LTHFngFevWoq3OStEsmsIYK1K
GcF1N9ZzPH024uwdcLjjwpul/avUHqzfp5ZILuI83Z/OqYYLiCQ0BbAQno7Cp5Be
wLjafhPTSAIS0jijglJ7uzaSbFUW11fw1/EIqIFNe0R0Xf9lsyPxFA==
-----END RSA PRIVATE KEY-----
KEY

class FogIntegrationTest < MiniTest::Test
  def namespaced_name
    "#{self.class}_#{name}"
  end
end
