# AgroVision Logs Directory

This directory contains application logs organized by category and date.

## Structure

```
logs/
├── info/           # Informational logs (general operations)
├── success/        # Success logs (completed operations)
├── warning/        # Warning logs (potential issues)
├── error/          # Error logs (failures and exceptions)
├── combined/       # All logs combined
└── README.md       # This file
```

## Log File Naming

Log files are named by date: `YYYY-MM-DD.log`

## Log Entry Format

```
[TIMESTAMP] [LEVEL] [CONTEXT] Message
  Data: { ... }
  Stack: ...
```

## Log Levels

- **INFO** ℹ️ - General information about system operations
- **SUCCESS** ✅ - Successful operations (auth, API calls, etc.)
- **WARNING** ⚠️ - Potential issues that don't stop execution
- **ERROR** ❌ - Failures and exceptions
- **DEBUG** 🔍 - Detailed debugging info (dev only)

## Cleanup

Old logs are automatically cleaned after 30 days by default.

## Usage in Code

```typescript
import { logger } from '@/lib/logger';

// Basic logging
logger.info('User logged in', 'AUTH');
logger.success('Order completed', 'ORDERS', { orderId: '123' });
logger.warning('Rate limit approaching', 'API');
logger.error('Database connection failed', 'DB', error);
logger.debug('Processing request', 'API', { payload });

// Specialized logging
logger.auth('login', userId, true);
logger.api('/api/users', 'GET', 200, userId);
logger.request('GET', '/api/farms', 200, 45, userId);
```
