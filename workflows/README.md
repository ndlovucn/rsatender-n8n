# n8n Workflows for RSA Tender

This directory contains n8n workflows for tender scraping and automation.

## Workflow Types

1. **Tender Scraping Workflows**
   - Multi-source scraping with fallbacks
   - Data validation and cleaning
   - Error handling and retry logic

2. **Document Processing Workflows**
   - OCR and text extraction
   - Metadata extraction
   - AI-powered analysis

3. **Notification Workflows**
   - Email notifications
   - Slack/Discord alerts
   - SMS notifications

4. **Data Enrichment Workflows**
   - Company information enrichment
   - Geographic data enhancement
   - Category classification

## Importing Workflows

1. Export your workflow from n8n.cloud
2. Save the JSON file in this directory
3. Import via n8n UI or use the CLI

## Environment Variables

The following environment variables are available in workflows:
- TENDERMATCH_API_URL: http://localhost:8080
- TENDERMATCH_DB_HOST: postgres
- TENDERMATCH_DB_PORT: 5432
- TENDERMATCH_DB_NAME: tendermatch_dev
- TENDERMATCH_DB_USER: dev
- TENDERMATCH_DB_PASSWORD: dev

## Database Schema

### Tenders Table Structure
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

### Available Endpoints for n8n Integration
- `POST /tenders/scrape/all` - Scrape all sources
- `POST /tenders/scrape/source/{id}` - Scrape specific source
- `GET /tenders` - Get tenders
- `POST /documents/upload` - Upload documents
- `GET /chat/sessions` - Get chat sessions
- `POST /profile` - Update user profile

## Usage Examples

### Direct Database Insert
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
    "status": "OPEN",
    "created_at": "{{ $now }}",
    "updated_at": "{{ $now }}"
  }
}
```

### API Call
```javascript
// HTTP Request node
{
  "method": "POST",
  "url": "http://localhost:8080/tenders/scrape/source/{{ $json.source_id }}",
  "body": {
    "fromDate": "{{ $now.minus({days: 1}).toISOString() }}",
    "maxResults": 50
  }
}
``` 