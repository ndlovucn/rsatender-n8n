# n8n Setup Guide for RSA Tender

This guide will help you set up n8n for tender scraping workflows in your RSA Tender project.

## Prerequisites

- Docker and Docker Compose installed
- Your existing n8n workflow exported from n8n.cloud

## Quick Setup

### 1. Start n8n

```bash
# Start all services including n8n
docker compose up -d

# Or start just n8n
docker compose up -d n8n
```

### 2. Access n8n

- **URL**: http://localhost:5678
- **Username**: admin
- **Password**: tendermatch2024

### 3. Import Your Existing Workflow

#### Method 1: Manual Import (Recommended)

1. **Export from n8n.cloud**:
   - Go to your workflow in n8n.cloud
   - Click the three dots menu
   - Select "Export"
   - Choose "JSON" format
   - Download the file

2. **Import to Local n8n**:
   - Open http://localhost:5678
   - Click "Import from file"
   - Select your exported JSON file
   - Review and import

#### Method 2: Automated Import

1. **Save your workflow JSON**:
   ```bash
   # Save your exported workflow to the workflows directory
   cp your-workflow.json n8n-workflows/
   ```

2. **Run the import script**:
   ```bash
   ./scripts/import-n8n-workflows.sh
   ```

## Configuring Your Workflow for Local Environment

### 1. Update API Endpoints

Your workflow likely uses n8n.cloud webhook URLs. Update them to use local endpoints:

**Before (n8n.cloud)**:
```
https://hook.eu1.n8n.cloud/abc123/your-webhook
```

**After (local)**:
```
http://localhost:5678/webhook/your-webhook-id
```

### 2. Update Database Connections

If your workflow connects to databases, update the connection settings:

**PostgreSQL Connection**:
- Host: `postgres` (Docker service name)
- Port: `5432`
- Database: `tendermatch_dev`
- Username: `dev`
- Password: `dev`

### 3. Update HTTP Request Nodes

For nodes that make HTTP requests to your backend:

**Base URL**: `http://localhost:8080`

**Available Endpoints**:
- `POST /tenders/scrape/all` - Scrape all sources
- `POST /tenders/scrape/source/{id}` - Scrape specific source
- `GET /tenders` - Get tenders
- `POST /documents/upload` - Upload documents
- `GET /chat/sessions` - Get chat sessions

### 4. Environment Variables

Your workflow can use these environment variables:

```javascript
// In n8n expressions
$env.TENDERMATCH_API_URL
$env.TENDERMATCH_DB_HOST
$env.TENDERMATCH_DB_NAME
$env.TENDERMATCH_DB_USER
$env.TENDERMATCH_DB_PASSWORD
```

## Database Integration

### Direct Database Access

n8n can write directly to your `tenders` table using the PostgreSQL node:

```javascript
// PostgreSQL node configuration
{
  "operation": "Insert",
  "table": "tenders",
  "columns": {
    "id": "{{ $json.id }}",
    "source_id": "{{ $json.source_id }}",
    "reference_number": "{{ $json.reference_number }}",
    "title": "{{ $json.title }}",
    "description": "{{ $json.description }}",
    "original_url": "{{ $json.original_url }}",
    "status": "OPEN",
    "created_at": "{{ $now }}",
    "updated_at": "{{ $now }}"
  }
}
```

### Database Connection Settings

In n8n, configure the PostgreSQL connection with these settings:

```javascript
// PostgreSQL connection settings
{
  "host": "postgres",
  "port": 5432,
  "database": "tendermatch_dev",
  "user": "dev", 
  "password": "dev",
  "schema": "public"
}
```

## Sample Workflow

A sample workflow has been created at `n8n-workflows/tender-scraping-workflow.json` that demonstrates:

1. **Cron Trigger**: Runs every 2 hours
2. **Get Active Sources**: Queries your database for active tender sources
3. **Scrape Each Source**: Calls your API to scrape each source
4. **Error Handling**: Updates source status and sends alerts
5. **Success Notifications**: Sends success/failure notifications

## Testing Your Workflow

### 1. Manual Testing

1. **Enable the workflow** in n8n
2. **Trigger manually** using the "Execute Workflow" button
3. **Monitor execution** in the execution log
4. **Check results** in your database

### 2. Automated Testing

1. **Set up triggers** (cron, webhook, etc.)
2. **Test with sample data**
3. **Verify error handling**
4. **Check notifications**

## Monitoring and Debugging

### 1. n8n Logs

```bash
# View n8n logs
docker compose logs -f n8n

# View specific log levels
docker compose logs -f n8n | grep ERROR
```

### 2. Execution History

- Access execution history in n8n UI
- View detailed logs for each execution
- Debug failed executions

### 3. Health Checks

```bash
# Check n8n health
curl http://localhost:5678/healthz

# Check all services
docker compose ps
```

## Database Schema

Your `tenders` table structure:

```sql
CREATE TABLE tenders (
    id UUID PRIMARY KEY,
    source_id UUID REFERENCES tender_sources(id),
    reference_number VARCHAR(255),
    title VARCHAR(255),
    description TEXT,
    issuing_department VARCHAR(255),
    original_url VARCHAR(255),
    document_url VARCHAR(255),
    estimated_value DOUBLE PRECISION,
    currency VARCHAR(255),
    publication_date TIMESTAMP WITH TIME ZONE,
    closing_date TIMESTAMP WITH TIME ZONE,
    briefing_date TIMESTAMP WITH TIME ZONE,
    briefing_location VARCHAR(255),
    is_briefing_compulsory BOOLEAN,
    contact_person VARCHAR(255),
    contact_email VARCHAR(255),
    contact_phone VARCHAR(255),
    status VARCHAR(255),
    categories JSONB,
    categories_text VARCHAR(255),
    locations JSONB,
    locations_text VARCHAR(255),
    keywords JSONB,
    keywords_text VARCHAR(255),
    additional_details JSONB,
    additional_details_text VARCHAR(255),
    last_scraped_at TIMESTAMP WITH TIME ZONE,
    migrated_to_mongodb BOOLEAN,
    created_at TIMESTAMP WITH TIME ZONE,
    updated_at TIMESTAMP WITH TIME ZONE,
    embedding vector(1024),
    vectorized BOOLEAN,
    fts_vector tsvector
);
```

## API Endpoints

Your workflow can use these endpoints:

### Tender Scraping
```http
POST /tenders/scrape/all
POST /tenders/scrape/source/{id}
GET /tenders/scrape/test/{id}
```

### Tender Management
```http
GET /tenders
GET /tenders/search
GET /tenders/{id}
POST /tenders/feedback
```

### Document Processing
```http
POST /documents/upload
GET /documents/{id}/status
DELETE /documents/{id}
```

### User Management
```http
GET /profile
POST /profile
GET /users/me
```

### Chat & AI
```http
POST /chat/sessions
POST /chat/sessions/{id}/messages
GET /chat/sessions/{id}/messages
```

## Troubleshooting

### Common Issues

1. **n8n won't start**:
   ```bash
   # Check if PostgreSQL is ready
   docker compose logs postgres
   
   # Check n8n logs
   docker compose logs n8n
   ```

2. **Database connection issues**:
   - Verify PostgreSQL is running
   - Check database credentials
   - Ensure database exists

3. **Workflow import fails**:
   - Check JSON format
   - Verify all required nodes are available
   - Check for custom node dependencies

### Getting Help

- Check n8n documentation: https://docs.n8n.io/
- Review execution logs in n8n UI
- Check Docker logs for service issues

## Production Considerations

### 1. Security

- Change default passwords
- Use environment variables for sensitive data
- Enable HTTPS in production
- Restrict network access

### 2. Performance

- Monitor resource usage
- Optimize workflow execution
- Use appropriate timeouts
- Implement retry logic

### 3. Backup

- Backup n8n data volume
- Export workflows regularly
- Backup PostgreSQL database

## Next Steps

1. **Import your workflow** from n8n.cloud
2. **Configure endpoints** for your local environment
3. **Test the workflow** with sample data
4. **Set up scheduling** for automated execution
5. **Monitor and optimize** performance

## Support

For issues with:
- **n8n**: Check the n8n documentation and community forums
- **Database**: Check PostgreSQL logs and connection settings
- **API**: Verify your backend service is running and accessible
- **Docker**: Check Docker logs and container status 