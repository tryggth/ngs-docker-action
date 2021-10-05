#!/bin/sh -l

sed -i "s/USER_JWT/$INPUT_USER/g" /actions.creds
sed -i "s/USER_NKEY_SEED/$INPUT_SEED/g" /actions.creds

export ACTION_EVENT=$(jq -n --arg value $GITHUB_JOB '. + {GITHUB_JOB: $value}' | \
  jq --arg value $GITHUB_REF '. + {GITHUB_REF: $value}' | \
  jq --arg value $GITHUB_SHA '. + {GITHUB_SHA: $value}' | \
  jq --arg value $GITHUB_REPOSITORY '. + {GITHUB_REPOSITORY: $value}' | \
  jq --arg value $GITHUB_REPOSITORY_OWNER '. + {GITHUB_REPOSITORY_OWNER: $value}' | \
  jq --arg value $GITHUB_ACTOR '. + {GITHUB_ACTOR: $value}' | \
  jq --arg value $GITHUB_RUN_ID '. + {GITHUB_RUN_ID: $value}' | \
  jq --arg value $GITHUB_RUN_NUMBER '. + {GITHUB_RUN_NUMBER: $value}' | \
  jq --arg value $GITHUB_RETENTION_DAYS '. + {GITHUB_RETENTION_DAYS: $value}' | \
  jq --arg value $GITHUB_RUN_ATTEMPT '. + {GITHUB_RUN_ATTEMPT: $value}' | \
  jq --arg value $GITHUB_WORKFLOW '. + {GITHUB_WORKFLOW: $value}' | \
  jq --arg value $GITHUB_HEAD_REF '. + {GITHUB_HEAD_REF: $value}' | \
  jq --arg value $GITHUB_BASE_REF '. + {GITHUB_BASE_REF: $value}' | \
  jq --arg value $GITHUB_EVENT_NAME '. + {GITHUB_EVENT_NAME: $value}' | \
  jq --arg value $GITHUB_ACTION '. + {GITHUB_ACTION: $value}' | \
  jq --arg value $GITHUB_EVENT_PATH '. + {GITHUB_EVENT_PATH: $value}' | \
  jq --arg value $GITHUB_ACTION_REPOSITORY '. + {GITHUB_ACTION_REPOSITORY: $value}' | \
  jq --arg value $GITHUB_ACTION_REF '. + {GITHUB_ACTION_REF: $value}')

# Debugging information - message payload
echo $ACTION_EVENT

# Add any additional debugging information between the BEGIN and END markers
echo "---------BEGIN EVENT INFO---------"
cat $GITHUB_EVENT_PATH
echo "----------END EVENT INFO----------"

/go/bin/nats-pub -s "$INPUT_NATS" -creds /actions.creds "$INPUT_SUBJECT" "$ACTION_EVENT"
exit $?
