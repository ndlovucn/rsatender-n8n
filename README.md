# RSA Tender n8n Workflow Service

## Overview

This repository contains the n8n workflow automation service for the RSA Tender system. n8n provides visual workflow automation for tender scraping, document processing, notifications, and data enrichment.

## Quick Start

### Railway Deployment

1. **Connect to Railway**:
   ```bash
   railway login
   railway init
   ```

2. **Set Environment Variables**:
   ```bash
   railway variables set N8N_BASIC_AUTH_USER=admin
   railway variables set N8N_BASIC_AUTH_PASSWORD=your-secure-password
   railway variables set TENDERMATCH_API_URL=https://your-backend-url
   ```

3. **Deploy**:
   ```bash
   railway up
   ```

## Features

- **Visual Workflow Designer**: Create and manage automation workflows
- **Tender Scraping Workflows**: Automated data collection from multiple sources
- **Document Processing**: OCR, text extraction, and AI-powered analysis
- **Notifications**: Email, Slack, Discord, and SMS notifications
- **Data Enrichment**: Company information and geographic data enhancement
- **Database Integration**: Direct PostgreSQL integration with the main database

## Environment Variables

### Required Variables

- `N8N_BASIC_AUTH_USER`: Admin username for n8n interface
- `N8N_BASIC_AUTH_PASSWORD`: Admin password for n8n interface
- `DATABASE_HOST`: PostgreSQL host
- `DATABASE_PORT`: PostgreSQL port (default: 5432)
- `DATABASE_NAME`: Database name
- `DATABASE_USER`: Database username
- `DATABASE_PASSWORD`: Database password

### Optional Variables

- `TENDERMATCH_API_URL`: Backend API URL for integration
- `N8N_WEBHOOK_URL`: Public webhook URL for n8n
- `GENERIC_TIMEZONE`: Timezone (default: Africa/Johannesburg)
- `N8N_LOG_LEVEL`: Log level (default: info)

## Available Workflows

### 1. Tender Scraping Workflow
- **File**: `tender-scraping-workflow.json`
- **Purpose**: Multi-source tender data collection

### 2. Eskom n8n Scraper
- **File**: `eskom-n8n-scraper.json`
- **Purpose**: Specialized Eskom tender scraping

## Documentation

See the `docs/` directory for detailed documentation:
- n8n setup guide
- credentials setup
- workflow development
- implementation details

## Contributing

1. Fork the repository
2. Create feature branch: `git checkout -b feature/new-workflow`
3. Make changes and test
4. Submit pull request
