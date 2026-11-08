# Harbor Relay platform

The Kubernetes manifests and the OpenTofu queue module of Harbor Relay, a fictional parcel desk.
The application code and the architecture model live in
[archboard-relay-example](https://github.com/miklschmidt/archboard-relay-example).
Read that README first. This repository is the platform side of the same example.

Nothing here is real. There is no cluster and no cloud account. CI validates the files and applies nothing.

## What is here

| Path | What it is |
| --- | --- |
| `deploy/kubernetes/` | A Deployment and a Service for each of Intake, Catalog, Dispatcher and Billing, the `dispatch-jobs` Service, and the `peer-endpoints` ConfigMap |
| `infra/` | OpenTofu: the SQS queue behind `dispatch-jobs`, with its provider lock file |
| `scripts/validate.sh` | `kubeconform` on the manifests, then `tofu fmt`, `init -backend=false` and `validate` |

`peer-endpoints` holds the address of every peer: `CATALOG_URL`, `DISPATCH_JOBS_URL` and `BILLING_URL`.
Intake and Dispatcher load it with `envFrom`, as a platform team would do for every workload that calls out.
Whether a workload reads an address is the application's choice. The platform does not decide it.

The manifests use `envFrom` and not a literal `env` entry on purpose. Archboard counts a literal entry as
evidence for the Deployment, whether or not any code reads it. It counts a ConfigMap entry only when code reads that name.

## How Archboard uses this repository

The architecture model in the application repository binds its Kubernetes and OpenTofu modules to files here,
by the repository identity `github.com/miklschmidt/archboard-relay-example-infra`.
When the application reads `process.env.BILLING_URL`, `archboard check` follows that name through
`envFrom` to `peer-endpoints.yaml` and finds the Billing Service. A pull request that changes only the
application repository can therefore add a hop that the model does not draw, and the check fails it.

## Validate

```bash
scripts/validate.sh
```

It needs [kubeconform](https://github.com/yannh/kubeconform) v0.6.7 and [OpenTofu](https://opentofu.org) 1.10.6.
The provider block sets placeholder credentials and skips every credential lookup, so no plan reads ambient AWS credentials.
