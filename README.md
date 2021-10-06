<!--
Copyright 2021 Bugopolis LLC

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
-->
# `ngs-docker-action` GitHub Action

Publishes Github Action event data to [Synadia NGS](https://synadia.com/ngs). Subscribers can use
the data for CI systems or general event processing.

## Table of Contents

* [Prerequisites](#prerequisites)
* [Usage](#usage)
* [Inputs](#inputs)
* [Outputs](#outputs)
* [Setup](#setup)
  * [Setup NGS](#setup-ngs-account)
  * [Setup NGS]()
  * [Setup NGS]()
* [Credentials](#credentials)
* [Example Workflows](#example-workflows)
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
    uses: tryggth/ngs-docker-action@v0.24
    with:
      subject: GA
      user: ${{ secrets.NGS_USER }}
      seed: ${{ secrets.NGS_USER_SEED }}
```

## Inputs

| Name          | Requirement | Default | Description |
| ------------- | ----------- | ------- | ----------- |
| `subject`| _optional_ | `GA` | NATS subject |
| `user`| _required_ | |  USER JWT. See [Credentials](#credentials) |
| `seed`| _required_ | |  USER NKEY SEED. See [Credentials](#credentials) |
| `nats`| _optional_ | `connect.ngs.global` | NATS server URL |

## Outputs

- `none`

There are no step outputs. The effective output is the payload of the sent NGS
message.  Here is an example from the action in this action's repository:

```json
'{
  "GITHUB_JOB": "send_actions_event",
  "GITHUB_REF": "refs/heads/main",
  "GITHUB_SHA": "ac8eb00ed476abebdd46ad7b25f1e7a49ae9bae5",
  "GITHUB_REPOSITORY": "tryggth/ngs-docker-action",
  "GITHUB_REPOSITORY_OWNER": "tryggth",
  "GITHUB_ACTOR": "tryggth",
  "GITHUB_RUN_ID": "1309190176",
  "GITHUB_RUN_NUMBER": "16",
  "GITHUB_RETENTION_DAYS": "90",
  "GITHUB_RUN_ATTEMPT": "1",
  "GITHUB_WORKFLOW": ".github/workflows/main.yml",
  "GITHUB_EVENT_NAME": "push",
  "GITHUB_ACTION": "__tryggth_ngs-docker-action",
  "GITHUB_EVENT_PATH": "/github/workflow/event.json",
  "GITHUB_ACTION_REPOSITORY": "tryggth/ngs-docker-action",
  "GITHUB_ACTION_REF": "v0.2"
}'
```
The content of the NATS payload tries to strike a balance of providing enough data
from the action's triggering event to be useful for most (Continuous Integration) use cases while also providing the Github coordinates necessary to retrieve the action run's log.

The action run's log contains additional triggering event - including the entire event's payload between the sentinel `---------BEGIN EVENT INFO---------` and `----------END EVENT INFO----------`. Here is an example of such a payload:

```
---------BEGIN EVENT INFO---------
{
  "after": "ac8eb00ed476abebdd46ad7b25f1e7a49ae9bae5",
  "base_ref": null,
  "before": "11b60c517a36dbe70071ec4a028c382a9ad9e9ac",
  "commits": [
    {
      "author": {
        "email": "tryggth@tryggth.com",
        "name": "Tryggth",
        "username": "tryggth"
      },
      "committer": {
        "email": "tryggth@tryggth.com",
        "name": "Tryggth",
        "username": "tryggth"
      },
      "distinct": true,
      "id": "ac8eb00ed476abebdd46ad7b25f1e7a49ae9bae5",
      "message": "Documentation formating experimentation",
      "timestamp": "2021-10-05T13:11:16-07:00",
      "tree_id": "79fedf768c29575857c94ee41078c74695768111",
      "url": "https://github.com/tryggth/ngs-docker-action/commit/ac8eb00ed476abebdd46ad7b25f1e7a49ae9bae5"
    }
  ],
  "compare": "https://github.com/tryggth/ngs-docker-action/compare/11b60c517a36...ac8eb00ed476",
  "created": false,
  "deleted": false,
  "forced": false,
  "head_commit": {
    "author": {
      "email": "tryggth@tryggth.com",
      "name": "Tryggth",
      "username": "tryggth"
    },
    "committer": {
      "email": "tryggth@tryggth.com",
      "name": "Tryggth",
      "username": "tryggth"
    },
    "distinct": true,
    "id": "ac8eb00ed476abebdd46ad7b25f1e7a49ae9bae5",
    "message": "Documentation formating experimentation",
    "timestamp": "2021-10-05T13:11:16-07:00",
    "tree_id": "79fedf768c29575857c94ee41078c74695768111",
    "url": "https://github.com/tryggth/ngs-docker-action/commit/ac8eb00ed476abebdd46ad7b25f1e7a49ae9bae5"
  },
  "pusher": {
    "email": "tryggth@tryggth.com",
    "name": "tryggth"
  },
  "ref": "refs/heads/main",
  "repository": {
    "allow_forking": true,
    "archive_url": "https://api.github.com/repos/tryggth/ngs-docker-action/{archive_format}{/ref}",
    "archived": false,
    "assignees_url": "https://api.github.com/repos/tryggth/ngs-docker-action/assignees{/user}",
    "blobs_url": "https://api.github.com/repos/tryggth/ngs-docker-action/git/blobs{/sha}",
    "branches_url": "https://api.github.com/repos/tryggth/ngs-docker-action/branches{/branch}",
    "clone_url": "https://github.com/tryggth/ngs-docker-action.git",
    "collaborators_url": "https://api.github.com/repos/tryggth/ngs-docker-action/collaborators{/collaborator}",
    "comments_url": "https://api.github.com/repos/tryggth/ngs-docker-action/comments{/number}",
    "commits_url": "https://api.github.com/repos/tryggth/ngs-docker-action/commits{/sha}",
    "compare_url": "https://api.github.com/repos/tryggth/ngs-docker-action/compare/{base}...{head}",
    "contents_url": "https://api.github.com/repos/tryggth/ngs-docker-action/contents/{+path}",
    "contributors_url": "https://api.github.com/repos/tryggth/ngs-docker-action/contributors",
    "created_at": 1633372921,
    "default_branch": "main",
    "deployments_url": "https://api.github.com/repos/tryggth/ngs-docker-action/deployments",
    "description": "Action for publishing Action event data to Synadia Account channel",
    "disabled": false,
    "downloads_url": "https://api.github.com/repos/tryggth/ngs-docker-action/downloads",
    "events_url": "https://api.github.com/repos/tryggth/ngs-docker-action/events",
    "fork": false,
    "forks": 0,
    "forks_count": 0,
    "forks_url": "https://api.github.com/repos/tryggth/ngs-docker-action/forks",
    "full_name": "tryggth/ngs-docker-action",
    "git_commits_url": "https://api.github.com/repos/tryggth/ngs-docker-action/git/commits{/sha}",
    "git_refs_url": "https://api.github.com/repos/tryggth/ngs-docker-action/git/refs{/sha}",
    "git_tags_url": "https://api.github.com/repos/tryggth/ngs-docker-action/git/tags{/sha}",
    "git_url": "git://github.com/tryggth/ngs-docker-action.git",
    "has_downloads": true,
    "has_issues": true,
    "has_pages": false,
    "has_projects": true,
    "has_wiki": true,
    "homepage": null,
    "hooks_url": "https://api.github.com/repos/tryggth/ngs-docker-action/hooks",
    "html_url": "https://github.com/tryggth/ngs-docker-action",
    "id": 413543681,
    "issue_comment_url": "https://api.github.com/repos/tryggth/ngs-docker-action/issues/comments{/number}",
    "issue_events_url": "https://api.github.com/repos/tryggth/ngs-docker-action/issues/events{/number}",
    "issues_url": "https://api.github.com/repos/tryggth/ngs-docker-action/issues{/number}",
    "keys_url": "https://api.github.com/repos/tryggth/ngs-docker-action/keys{/key_id}",
    "labels_url": "https://api.github.com/repos/tryggth/ngs-docker-action/labels{/name}",
    "language": "Shell",
    "languages_url": "https://api.github.com/repos/tryggth/ngs-docker-action/languages",
    "license": {
      "key": "mit",
      "name": "MIT License",
      "node_id": "MDc6TGljZW5zZTEz",
      "spdx_id": "MIT",
      "url": "https://api.github.com/licenses/mit"
    },
    "master_branch": "main",
    "merges_url": "https://api.github.com/repos/tryggth/ngs-docker-action/merges",
    "milestones_url": "https://api.github.com/repos/tryggth/ngs-docker-action/milestones{/number}",
    "mirror_url": null,
    "name": "ngs-docker-action",
    "node_id": "R_kgDOGKYtAQ",
    "notifications_url": "https://api.github.com/repos/tryggth/ngs-docker-action/notifications{?since,all,participating}",
    "open_issues": 0,
    "open_issues_count": 0,
    "owner": {
      "avatar_url": "https://avatars.githubusercontent.com/u/656385?v=4",
      "email": "jimw@bugopolis.com",
      "events_url": "https://api.github.com/users/tryggth/events{/privacy}",
      "followers_url": "https://api.github.com/users/tryggth/followers",
      "following_url": "https://api.github.com/users/tryggth/following{/other_user}",
      "gists_url": "https://api.github.com/users/tryggth/gists{/gist_id}",
      "gravatar_id": "",
      "html_url": "https://github.com/tryggth",
      "id": 656385,
      "login": "tryggth",
      "name": "tryggth",
      "node_id": "MDQ6VXNlcjY1NjM4NQ==",
      "organizations_url": "https://api.github.com/users/tryggth/orgs",
      "received_events_url": "https://api.github.com/users/tryggth/received_events",
      "repos_url": "https://api.github.com/users/tryggth/repos",
      "site_admin": false,
      "starred_url": "https://api.github.com/users/tryggth/starred{/owner}{/repo}",
      "subscriptions_url": "https://api.github.com/users/tryggth/subscriptions",
      "type": "User",
      "url": "https://api.github.com/users/tryggth"
    },
    "private": false,
    "pulls_url": "https://api.github.com/repos/tryggth/ngs-docker-action/pulls{/number}",
    "pushed_at": 1633464780,
    "releases_url": "https://api.github.com/repos/tryggth/ngs-docker-action/releases{/id}",
    "size": 15,
    "ssh_url": "git@github.com:tryggth/ngs-docker-action.git",
    "stargazers": 0,
    "stargazers_count": 0,
    "stargazers_url": "https://api.github.com/repos/tryggth/ngs-docker-action/stargazers",
    "statuses_url": "https://api.github.com/repos/tryggth/ngs-docker-action/statuses/{sha}",
    "subscribers_url": "https://api.github.com/repos/tryggth/ngs-docker-action/subscribers",
    "subscription_url": "https://api.github.com/repos/tryggth/ngs-docker-action/subscription",
    "svn_url": "https://github.com/tryggth/ngs-docker-action",
    "tags_url": "https://api.github.com/repos/tryggth/ngs-docker-action/tags",
    "teams_url": "https://api.github.com/repos/tryggth/ngs-docker-action/teams",
    "trees_url": "https://api.github.com/repos/tryggth/ngs-docker-action/git/trees{/sha}",
    "updated_at": "2021-10-05T20:02:57Z",
    "url": "https://github.com/tryggth/ngs-docker-action",
    "visibility": "public",
    "watchers": 0,
    "watchers_count": 0
  },
  "sender": {
    "avatar_url": "https://avatars.githubusercontent.com/u/19417021?v=4",
    "events_url": "https://api.github.com/users/tryggth/events{/privacy}",
    "followers_url": "https://api.github.com/users/tryggth/followers",
    "following_url": "https://api.github.com/users/tryggth/following{/other_user}",
    "gists_url": "https://api.github.com/users/tryggth/gists{/gist_id}",
    "gravatar_id": "",
    "html_url": "https://github.com/tryggth",
    "id": 19417021,
    "login": "tryggth",
    "node_id": "MDQ6VXNlcjE5NDE3MDIx",
    "organizations_url": "https://api.github.com/users/tryggth/orgs",
    "received_events_url": "https://api.github.com/users/tryggth/received_events",
    "repos_url": "https://api.github.com/users/tryggth/repos",
    "site_admin": false,
    "starred_url": "https://api.github.com/users/tryggth/starred{/owner}{/repo}",
    "subscriptions_url": "https://api.github.com/users/tryggth/subscriptions",
    "type": "User",
    "url": "https://api.github.com/users/tryggth"
  }
}----------END EVENT INFO----------
```
The subscriber receiving the NATS message can use the `GITHUB_REPOSITORY` and `GITHUB_RUN_ID` to download the full log and extract the full event information as described [here](https://docs.github.com/en/rest/reference/actions#download-job-logs-for-a-workflow-run). [*NOTE*: _The API call returns a 302 with a `Location:`header for the actual URL. The actual URL will only be valid for 1 minute. However, the log itself will persist for the duration stated in `GITHUB_RETENTION_DAYS` original message field._]

## Setup

### Setup NGS account

### Deploy message receiver

### Add the following `YAML` file to your to the `.github/workflows` directory in your repository

```yaml
on:
  push:
  pull_request:
  page_build:
  release:
  repository_dispatch:
  workflow_call:
  workflow_dispatch:
  check_run:
  check_suite:
  create:
  delete:
  deployment:
  deployment_status:
  discussion:
  discussion_comment:
  fork:
  gollum:
  issue_comment:
  issues:
  label:
  milestone:
  project:
  project_card:
  project_column:
  public:
  pull_request_review:
  pull_request_review_comment:
  pull_request_target:
  registry_package:
  status:
  watch:
  # workflow_run: - Normally this would specify a trigger workflow.
  # Without a workflow name scoping the run it would infinitiely loop

jobs:
  send_actions_event:
    runs-on: ubuntu-latest
    name: Marshal Event
    steps:
      - name: Send event
        uses: tryggth/ngs-docker-action@v0.24
        with:
          subject: GA
          user: ${{ secrets.NGS_USER }}
          seed: ${{ secrets.NGS_USER_SEED }}
```

## Credentials

## Example Workflows

* add sample

## Contributing

See [CONTRIBUTING](CONTRIBUTING.md).

## License

See [LICENSE](LICENSE).


## Code of Conduct

:wave: Be nice.  See [our code of conduct](CONDUCT)
