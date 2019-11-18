#!/bin/bash

# Send a webhook back to bits-jenkins to start the deploy
curl "https://hooks-proxy.broadinstitute.org/generic-webhook/jenkins/devops/?token=${CIRCLE_BRANCH}-${JENKINS_TOKEN}&cause=CircleCI+Push"
