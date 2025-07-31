# Use the official n8n image
FROM n8nio/n8n:latest

# Set user to root to install additional packages
USER root

# Install curl for health checks and other utilities
RUN apk add --no-cache curl

# Create directories for workflows and custom nodes
RUN mkdir -p /home/node/.n8n/workflows
RUN mkdir -p /home/node/.n8n/custom

# Copy workflows and custom configurations
COPY workflows/ /home/node/.n8n/workflows/
COPY custom-nodes/ /home/node/.n8n/custom/
COPY config/n8n.env /tmp/n8n.env

# Set ownership of n8n directories
RUN chown -R node:node /home/node/.n8n

# Switch back to node user
USER node

# Set working directory
WORKDIR /home/node/.n8n

# Expose n8n port
EXPOSE 5678

# Health check - n8n responds on root path
HEALTHCHECK --interval=30s --timeout=10s --start-period=60s --retries=3 \
  CMD curl -f http://localhost:5678/ || exit 1

# Use default CMD from base image - don't override with custom CMD
