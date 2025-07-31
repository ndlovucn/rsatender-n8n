# Database Connection Details for n8n Workflows

## Overview

Your RSA Tender backend uses multiple database connections. Here are the connection details you can use in your n8n workflows to connect to the same databases.

## 1. Railway PostgreSQL Database (Primary)

This is the main database that your backend service uses for production data.

### Connection Details for n8n
```
Database Type: PostgreSQL
Host: metro.proxy.rlwy.net
Port: 16871
Database: railway
Username: postgres
Password: 6~.aYrOcS~7SU10H9~wl..T.qHgWzUmk
SSL Mode: require
```

### Full Connection URL
```
postgresql://postgres:6~.aYrOcS~7SU10H9~wl..T.qHgWzUmk@metro.proxy.rlwy.net:16871/railway
```

### n8n PostgreSQL Node Configuration
When setting up a PostgreSQL node in n8n:
1. **Host**: `metro.proxy.rlwy.net`
2. **Port**: `16871`
3. **Database**: `railway`
4. **User**: `postgres`
5. **Password**: `6~.aYrOcS~7SU10H9~wl..T.qHgWzUmk`
6. **SSL**: Enable SSL/TLS
7. **Connection Timeout**: 30000ms (optional)

## 2. Supabase Database (Alternative)

Your backend also has Supabase database configuration available.

### Connection Details for n8n
```
Database Type: PostgreSQL
Host: aws-0-af-south-1.pooler.supabase.com
Port: 5432
Database: postgres
Username: postgres.zzedeyvokwqhrjqovggc
Password: your-supabase-db-password
SSL Mode: require
```

### Supabase URL
```
Base URL: https://zzedeyvokwqhrjqovggc.supabase.co
```

## 3. Redis Connection (For Caching/Queue)

Your backend also uses Redis for caching and queue management.

### Redis Connection Details
```
Host: redis.railway.internal (internal network)
Port: 6379
Username: default
Password: zblrOCXgHgkJjRyoEnhjiSMbsYmjZOxT
```

### Redis URL
```
redis://default:zblrOCXgHgkJjRyoEnhjiSMbsYmjZOxT@redis.railway.internal:6379
```

## Important Notes

### Security Considerations
- These are **production credentials** - handle with care
- Use Railway's secure environment variable management
- Consider creating read-only database users for n8n workflows if you only need to read data

### Database Schema
Your backend uses these main database tables (based on the configuration):
- User profiles and authentication data
- Tender information and documents
- Workflow execution logs
- File storage metadata
- AI processing results

### Connection from n8n to Backend Services

If your n8n workflows need to call your backend APIs instead of direct database access:

```
Backend API URL: https://backend-production-a515.up.railway.app
```

### Recommended Approach for n8n

1. **For Read Operations**: Use the PostgreSQL connection directly
2. **For Write Operations**: Consider using your backend API endpoints for data integrity
3. **For Complex Operations**: Use the backend API to leverage business logic

## Example n8n Workflow Configurations

### PostgreSQL Query Node
```json
{
  "node": "PostgreSQL",
  "credentials": {
    "host": "metro.proxy.rlwy.net",
    "port": 16871,
    "database": "railway",
    "user": "postgres",
    "password": "6~.aYrOcS~7SU10H9~wl..T.qHgWzUmk",
    "ssl": true
  },
  "operation": "executeQuery",
  "query": "SELECT * FROM tender_documents WHERE status = 'active'"
}
```

### HTTP Request to Backend API
```json
{
  "node": "HTTP Request",
  "method": "GET",
  "url": "https://backend-production-a515.up.railway.app/api/tenders",
  "headers": {
    "Authorization": "Bearer YOUR_JWT_TOKEN"
  }
}
```

## Testing Connection

You can test these connections using:
1. n8n's built-in credential testing
2. Direct SQL queries in n8n workflows
3. External tools like pgAdmin or DBeaver

## Support

If you need help with specific n8n workflows or database queries, refer to:
- Your backend API documentation
- Database schema documentation
- n8n PostgreSQL node documentation 