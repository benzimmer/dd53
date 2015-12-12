# DD53

![Codeship Status for benzimmer/dd53](https://img.shields.io/codeship/4a874db0-de0e-0132-6a07-2204af7cc628.svg?style=flat)
[![Dependency Status](https://gemnasium.com/benzimmer/dd53.svg)](https://gemnasium.com/benzimmer/dd53)

## General

DD53 is a [dynamic DNS](https://en.wikipedia.org/wiki/Dynamic_DNS) updater for [AWS Route 53](https://aws.amazon.com/route53/).

It currently only implements the following parameters from <https://help.dyn.com/remote-access-api/>:

- hostname
- myip

Not currently supported are:

- wildcard (deprecated by dyn.com)
- mx (deprecated by dyn.com)
- backmx (deprecated by dyn.com)
- offline (not implemented)

## Requirements

- Ruby 2.2.x
- an AWS account
- A Route53 hosted zone (see [documentation](https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/getting-started.html))

## Route 53 setup

Create a new hosted zone and point your domains nameserver records at it as described in the documentation

## App configuration parameters

Required env variables

<table>
  <tr>
    <th>Variable name</th>
    <th>Use</th>
  </tr>
  <tr>
    <td>AUTH_USERNAME</td>
    <td>basic auth username</td>
  </tr>
  <tr>
    <td>AUTH_PASSWORD</td>
    <td>basic auth password</td>
  </tr>
  <tr>
    <td>AWS_REGION</td>
    <td>Amazon Web Services Region to use</td>
  </tr>
  <tr>
    <td>AWS_ACCESS_KEY_ID</td>
    <td>Amazon Web Services access key ID</td>
  </tr>
  <tr>
    <td>AWS_SECRET_ACCESS_KEY</td>
    <td>Amazon Web Services secret access key</td>
  </tr>
  <tr>
    <td>AWS_HOSTED_ZONE_ID</td>
    <td>Amazon Web Services Route 53 Zond ID</td>
  </tr>
</table>

## Usage

```bash
AUTH_USERNAME=ddns_updater AUTH_PASSWORD=mysecret AWS_ACCESS_KEY_ID=yourawsaccesskeyid AWS_SECRET_ACCESS_KEY=yourawssecretaccesskey AWS_HOSTED_ZONE_ID=thehostedzoneid AWS_REGION=eu-central-1 bundle exec rackup
```
