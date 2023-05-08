# terraform-google-route

이 모듈은 [terraform-google-module-template](https://stash.wemakeprice.com/users/lswoo/repos/terraoform-google-module-template/browse)에 의해서 생성되었습니다. 

The resources that this module will create are:

- Create Routes with the provided name

## Usage

모듈의 기본적인 사용법은 다음과 같습니다:

```hcl
module "route" {
  source = "git::https://stash.wemakeprice.com/scm/tgm/terraform-google-vpc-routes.git"

  project_id         = "my-prod-project"
  network            = "my-prod-network"
  config_directories = [
    "./prod",
    "./common"
  ]
}
```

모듈 사용의 예시는 [examples](./examples/) 디렉토리에 있습니다.

## Rule definition format and structure
Routes configuration은 폴더 내에 yaml 파일의 형태로 위치해야 합니다. Routes 구조는 다음과 같습니다.

```
route-name: # route 이름. module에 의해 naming convention이 조정됩니다.
  dest_range: 0.0.0.0/0 #route가 적용되는 패킷의 목적지 IP 범위. IPv4만 지원합니다.
  priority: 1000 # route의 우선순위. 두 route가 같은 prefix length값을 가지게 될때, 낮은 priority 값을 가진 route가 적용됩니다. 기본값은 1000이며 0부터 65545까지의 값을 가질 수 있습니다.
  tags: ['some-tag'] # route가 적용될 인스턴스 태그의 리스트
  
  next_hop_gateway: # 일치하는 패킷을 담당할 게이트웨이 URL. 현재는 전체 혹은 일부로 이루어진 Internet gateway URL만을 지원합니다. 
  # https://www.googleapis.com/compute/v1/projects/project/global/gateways/default-internet-gateway
  # projects/project/global/gateways/default-internet-gateway
  # global/gateways/default-internet-gateway
  # default-internet-gateway
  
  next_hop_instance: # 일치하는 패킷을 담당할 인스턴스 URL. 전체 혹은 일부 URL을 사용할 수 있습니다.
  # https://www.googleapis.com/compute/v1/projects/project/zones/zone/instances/instance
  # projects/project/zones/zone/instances/instance
  # zones/zone/instances/instance
  # 인스턴스 명 (next_hop_instance_zone 필요)
  next_hop_instance_zone: # next_hop_instance값이 지정된 경우 필요합니다. next_hop_instance에서 지정된 인스턴스의 존. next_hop_instance 값이 URL로 지정된 경우 생략합니다.
  
  next_hop_ip: # 일치하는 패킷을 담당할 인스턴스의 네트워크 IP 주소.
  
  next_hop_vpn_tunnel: # 일치하는 패킷을 담당할 VPN터널의 URL
  
  next_hop_ilb: # 일치하는 패킷을 담당할 포워딩 룰 타입이  loadBalancingScheme=INTERNAL인 IP 혹은 URL 주소. GA Provider를 사용할 경우 포워딩 룰은 일부 혹은 전체 URL로만 지정할 수 있습니다.
  # https://www.googleapis.com/compute/v1/projects/project/regions/region/forwardingRules/forwardingRule
  # 10.128.0.56
```
<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| config\_directories | yaml 포맷의 firewall config 파일이 위치한 폴더 경로의 List. 파일의 접미사는 반드시 `.yaml`여야 함. | `list(string)` | n/a | yes |
| network | route를 생성할 네트워크명 | `string` | n/a | yes |
| project\_id | 프로젝트 Id. | `string` | n/a | yes |

## Outputs

No output.

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## Requirements

이 모듈을 사용하기 위해 필요한 사항을 표기합니다.

### Software

아래 dependencies들이 필요합니다:

- [Terraform][terraform] v1.3
- [Terraform Provider for GCP][terraform-provider-gcp] plugin v3.53

### Service Account

이 모듈의 리소스를 배포하기 위해서는 아래 역할이 필요합니다:

- Compute Network Admin: `roles/compute.networkAdmin`

[Project Factory module][project-factory-module] 과
[IAM module][iam-module]로 필요한 역할이 부여된 서비스 어카운트를 배포할 수 있습니다.

### APIs

이 모듈의 리소스가 배포되는 프로젝트는 아래 API가 활성화되어야 합니다:

- None

[Project Factory module][project-factory-module]을 이용해 필요한 API를 활성화할 수 있습니다..

## Contributing

Refer to the [contribution guidelines](./CONTRIBUTING.md) for
information on contributing to this module.

[iam-module]: https://registry.terraform.io/modules/terraform-google-modules/iam/google
[project-factory-module]: https://registry.terraform.io/modules/terraform-google-modules/project-factory/google
[terraform-provider-gcp]: https://www.terraform.io/docs/providers/google/index.html
[terraform]: https://www.terraform.io/downloads.html

## Security Disclosures

Please see our [security disclosure process](./SECURITY.md).

## TO DO

- [ ] Example README 번역
