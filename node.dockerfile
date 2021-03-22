FROM ghost:4-alpine as builder

FROM uselagoon/node-14:latest

ENV GHOST_INSTALL="/var/lib/ghost" \
  GHOST_CONTENT="/var/lib/ghost/content" \
  GHOST_THEMES="/var/lib/ghost/content/themes" \
  GHOST_APPS="/var/lib/ghost/content/apps" \
  GHOST_DATA="/var/lib/ghost/content/data" \
  GHOST_IMAGES="/var/lib/ghost/content/images" \
  GHOST_SETTINGS="/var/lib/ghost/content/settings" \
  NODE_ENV="production"

COPY --from=builder --chown=node:node "${GHOST_INSTALL}" "${GHOST_INSTALL}"

RUN set -eux; \
  mkdir -p "$GHOST_THEMES" && chown node:node "$GHOST_THEMES"; \
  mkdir -p "$GHOST_APPS" && chown node:node "$GHOST_APPS"; \
  mkdir -p "$GHOST_DATA" && chown node:node "$GHOST_DATA"; \
  mkdir -p "$GHOST_IMAGES" && chown node:node "$GHOST_IMAGES"; \
  mkdir -p "$GHOST_SETTINGS" && chown node:node "$GHOST_SETTINGS"; \
  cd $GHOST_INSTALL; \
  find $GHOST_INSTALL -type d -exec chmod 00775 {} \; ; \
  cp -R ${GHOST_CONTENT}.orig/themes/* $GHOST_THEMES && chown node:node "$GHOST_THEMES";

WORKDIR $GHOST_INSTALL
COPY config.production.json .
RUN ep config.production.json
EXPOSE 3000
VOLUME $GHOST_DATA

# Run as the node user (as ghost does not like running as root).
USER 1000

# @TODO wait for the database to start.
CMD ["node", "current/index.js"]
