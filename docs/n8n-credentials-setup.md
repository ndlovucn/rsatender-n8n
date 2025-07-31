# n8n Credentials Setup Guide

## PostgreSQL Credentials Configuration

When importing the Eskom n8n scraper workflows, you'll need to configure PostgreSQL credentials to connect to the database.

### Step 1: Access n8n Credentials

1. Open your n8n instance at `http://localhost:5678`
2. Go to **Settings** → **Credentials** (or click the user icon → **Credentials**)
3. Click **+ Add Credential**

### Step 2: Create PostgreSQL Credential

1. Search for and select **Postgres**
2. Fill in the connection details:

```
Name: PostgreSQL Local Dev
Host: postgres (or tendermatch-postgres if running from host)
Database: tendermatch_dev
User: dev
Password: dev
Port: 5432
SSL Mode: disable
```

**Important Notes:**
- If n8n is running in Docker and connecting to PostgreSQL in Docker, use hostname: `postgres`
- If n8n is running on host and connecting to PostgreSQL in Docker, use hostname: `localhost` or `tendermatch-postgres`
- The database credentials match those defined in `docker-compose.yml`

### Step 3: Test Connection

1. Click **Test** to verify the connection works
2. You should see: ✅ **Connection successful**
3. Click **Save** to store the credentials

### Step 4: Update Workflow

1. Import the workflow JSON file
2. The workflow should automatically use the credential named "PostgreSQL Local Dev"
3. If you see credential errors, manually assign the credential:
   - Click on the PostgreSQL node (e.g., "Upsert Tender")
   - In the **Credentials** section, select "PostgreSQL Local Dev"
   - Save the workflow

### Alternative: Environment-Based Configuration

For production deployments, you can set up credentials using environment variables:

```bash
# In your n8n environment
N8N_DEFAULT_BINARY_DATA_MODE=filesystem
DB_TYPE=postgresdb
DB_POSTGRESDB_HOST=postgres
DB_POSTGRESDB_PORT=5432
DB_POSTGRESDB_DATABASE=tendermatch_dev
DB_POSTGRESDB_USER=dev
DB_POSTGRESDB_PASSWORD=dev
```

### Troubleshooting

**Error: "Node does not have any credentials set"**
- Solution: Follow steps above to create and assign PostgreSQL credentials

**Error: "Connection failed"**
- Check that PostgreSQL container is running: `docker ps | grep postgres`
- Verify connection details match `docker-compose.yml`
- For host connections, use `localhost:5432`
- For container-to-container, use `postgres:5432`

**Error: "relation does not exist"**
- Ensure the backend application has run and applied all Flyway migrations
- Check that the `tenders` table exists in the database

### Docker Network Considerations

If n8n is running in Docker alongside PostgreSQL:
```yaml
# Add to your docker-compose.yml
n8n:
  image: n8nio/n8n
  networks:
    - tendermatch-network  # Same network as PostgreSQL
```

If n8n is running on the host:
- Use `localhost:5432` for PostgreSQL connection
- Ensure PostgreSQL port is exposed in docker-compose.yml (which it is: `5432:5432`)

### Workflow Files

- **`eskom-n8n-scraper.json`**: Original workflow with UPSERT functionality
- **`eskom_n8n-scraper-enhanced.json`**: Enhanced version with additional error handling

Both workflows expect a PostgreSQL credential named "PostgreSQL Local Dev". 