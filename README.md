<!--
Copyright 2021 Bugopolis LLC

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
-->
# `ngs-docker-action` GitHub Action

Publishes Github Action event data to [Synadia][NGS]. Subscribers can use
the data for CI systems or general event processing.

## Table of Contents

* [Prerequisites](#prerequisites)
* [Usage](#usage)
* [Inputs](#inputs)
  * [Metadata customizations](#metadata-customizations)
  * [Allow unauthenticated requests](#Allow-unauthenticated-requests)
* [Outputs](#outputs)
* [Credentials](#credentials)
  * [Used with `setup-gcloud`](#Used-with-setup-gcloud)
  * [Via Credentials](#Via-Credentials)
  * [Via Application Default Credentials](#Via-Application-Default-Credentials)
* [Example Workflows](#example-workflows)
* [Migrating from `setup-gcloud`](#migrating-from-setup-gcloud)
* [Contributing](#contributing)
* [License](#License)

## Prerequisites

This action requires:

* Synadia NGS account. A [Developer account](https://synadia.com/ngs/pricing) will suffice to use the action.

* The credentials for a NGS account user. They are the inputs to the action. See [Credentials](#credentials) below for more information about
creating a user and getting the credentials.


## Usage

```yaml
steps:
  - name: Send event
    uses: tryggth/ngs-docker-action@v0.2
    with:
      subject: GA
      user: ${{ secrets.NGS_USER }}
      seed: ${{ secrets.NGS_USER_SEED }}```

## Inputs

| Name          | Requirement | Default | Description |
| ------------- | ----------- | ------- | ----------- |
| `subject`| _optional_ | `GA` | NATS subject |
| `user`| required`|  _none_ |  USER NKEY SEED See [Credentials](#credentials) |

### Metadata customizations

You can store your service specification in a YAML file. This will allow for
further service configuration, such as [memory limits](https://cloud.google.com/run/docs/configuring/memory-limits),
[CPU allocation](https://cloud.google.com/run/docs/configuring/cpu),
[max instances](https://cloud.google.com/run/docs/configuring/max-instances),
and [more](https://cloud.google.com/sdk/gcloud/reference/run/deploy#OPTIONAL-FLAGS).
**Other inputs will be overridden when using `metadata`**

- See [Deploying a new service](https://cloud.google.com/run/docs/deploying#yaml)
to create a new YAML service definition, for example:

```YAML
apiVersion: serving.knative.dev/v1
kind: Service
metadata:
  name: SERVICE
spec:
  template:
    spec:
      containers:
      - image: IMAGE
```

- See [Deploy a new revision of an existing service](https://cloud.google.com/run/docs/deploying#yaml_1)
to generated a YAML service specification from an existing service:

```
gcloud run services describe SERVICE --format yaml > service.yaml
```

## Outputs

- `none`

## Credentials

There are a few ways to authenticate this action. A service account will be needed with the following roles:

- Cloud Run Admin (`roles/run.admin`):
  - Can create, update, and delete services.
  - Can get and set IAM policies.

## Example Workflows

* [Deploy a prebuilt container](#deploy-a-prebuilt-container)

* [Build and deploy a container](#build-and-deploy-a-container)

### Setup

1.  Create a new Google Cloud Project (or select an existing project).

1. [Enable the Cloud Run API](https://console.cloud.google.com/flows/enableapi?apiid=run.googleapis.com).

1.  [Create a Google Cloud service account][sa] or select an existing one.

1.  Add the the following [Cloud IAM roles][roles] to your service account:

    - `Cloud Run Admin` - allows for the creation of new Cloud Run services

    - `Service Account User` -  required to deploy to Cloud Run as service account

    - `Storage Admin` - allow push to Google Container Registry (this grants project level access, but recommend reducing this scope to [bucket level permissions](https://cloud.google.com/container-registry/docs/access-control#grant).)

1.  [Download a JSON service account key][create-key] for the service account.

1.  Add the following [secrets to your repository's secrets][gh-secret]:

    - `GCP_PROJECT`: Google Cloud project ID

    - `GCP_SA_KEY`: the downloaded service account key

### Deploy a prebuilt container

To run this [workflow](.github/workflows/example-workflow-quickstart.yaml), push to the branch named `example-deploy`:

```sh
git push YOUR-FORK main:example-deploy
```

### Build and deploy a container

To run this [workflow](.github/workflows/example-workflow.yaml), push to the branch named `example-build-deploy`:

```sh
git push YOUR-FORK main:example-build-deploy
```

**Reminder: If this is your first deployment of a service, it will reject all unauthenticated requests. Learn more at [allowing unauthenticated requests](#Allow-unauthenticated-requests)**


## Contributing

See [CONTRIBUTING](CONTRIBUTING.md).

## License

See [LICENSE](LICENSE).


## Code of Conduct

:wave: Be nice.  See [our code of conduct](CONDUCT)
