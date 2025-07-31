# Use the official n8n image as-is
FROM n8nio/n8n:latest

# Just copy the workflows - keep everything else as default
COPY workflows/ /home/node/.n8n/workflows/
