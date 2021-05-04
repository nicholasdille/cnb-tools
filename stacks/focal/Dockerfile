FROM ubuntu:focal AS base
ENV CNB_USER_ID=1000
ENV CNB_GROUP_ID=1000
ENV CNB_STACK_ID="io.dille.stacks.focal"
LABEL io.buildpacks.stack.id="io.dille.stacks.focal"
RUN groupadd cnb --gid ${CNB_GROUP_ID} \
 && useradd --uid ${CNB_USER_ID} --gid ${CNB_GROUP_ID} -m -s /bin/bash cnb

FROM base AS run
USER ${CNB_USER_ID}:${CNB_GROUP_ID}

FROM base AS build
RUN apt-get update \
 && apt-get -y install --no-install-recommends \
        curl \
        jq \
        ca-certificates \
 && rm -rf /var/lib/apt/lists/*
USER ${CNB_USER_ID}:${CNB_GROUP_ID}
