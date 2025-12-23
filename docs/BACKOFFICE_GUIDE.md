# 🔐 AgroVision Admin Backoffice Guide

## Overview

The AgroVision Admin Backoffice is a comprehensive web-based administrative interface that allows administrators to manage the entire platform, monitor activities, moderate content, generate reports, and manage users.

---

## 🌐 Access Information

**URL**: `http://localhost:3001/admin`  
**Default Admin Credentials**:
- Email: `admin@agrovision.rw`
- Password: `Admin@123`

> ⚠️ **Important**: Change these credentials immediately after first login in production!

---

## 🚀 Getting Started

### 1. Starting the Backoffice

```bash
cd backend
npm run dev
```

The backoffice will be available at: `http://localhost:3001/admin`

### 2. First Login

1. Navigate to `http://localhost:3001/admin`
2. Enter your admin credentials
3. Click "Login"
4. You'll be redirected to the dashboard

### 3. Creating the First Admin User

Run this SQL in your database or use Prisma Studio:

```sql
INSERT INTO "User" (id, name, email, phone, password, role, status, "subscriptionTier")
VALUES (
  gen_random_uuid(),
  'Admin User',
  'admin@agrovision.rw',
  '+250788000000',
  -- Password: Admin@123 (hashed with bcrypt)
  '$2a$10$YourHashedPasswordHere',
  'ADMIN',
  'ACTIVE',
  'ENTERPRISE'
);
```

Or use the registration endpoint with role set to ADMIN.

---

## 📊 Dashboard Features

### Main Dashboard

The dashboard provides an at-a-glance view of:

- **Total Users**: Number of registered users
- **Total Farms**: Registered farms in the system
- **Total Crops**: Crops being tracked
- **AI Diagnoses**: Number of disease scans completed
- **Orders**: Total marketplace orders
- **Monthly Revenue**: Current month's revenue
- **Active Listings**: Products currently for sale
- **System Status**: Platform health check

### Quick Actions

- Manage Users
- Moderate Listings
- View Reports
- Add Content

---

## 👥 User Management

**Access**: `/admin/users`

### Features

1. **View All Users**
   - Search by name, email, or phone
   - Filter by role (Farmer, Buyer, Expert, Admin)
   - Filter by status (Active, Suspended, Banned)
   - View user statistics (farms, crops, diagnoses)

2. **User Details**
   - Complete user profile
   - Activity history
   - Farms and crops
   - Order history
   - Payment records

3. **User Actions**
   - Update user status (Active/Suspended/Banned)
   - Change subscription tier
   - Modify user role
   - Delete user account

### API Endpoints

```typescript
GET  /api/admin/users          // List all users
GET  /api/admin/users/:id      // Get user details
PUT  /api/admin/users/:id      // Update user
DELETE /api/admin/users/:id    // Delete user
```

---

## 🛒 Marketplace Moderation

**Access**: `/admin/marketplace`

### Features

1. **Listing Moderation**
   - Review pending listings
   - Approve/reject listings
   - Suspend inappropriate content
   - Add moderation notes

2. **Moderation Actions**
   - **APPROVE**: Make listing active and visible
   - **REJECT**: Deny listing with reason
   - **SUSPEND**: Temporarily hide listing

3. **Filters**
   - View by status (Pending, Active, Rejected, Suspended)
   - Search by product name
   - Filter by seller

### API Endpoints

```typescript
GET /api/admin/marketplace         // List listings
PUT /api/admin/marketplace/:id     // Moderate listing
```

---

## 📈 Reports & Analytics

**Access**: `/admin/reports`

### Available Reports

#### 1. Overview Report
Complete system overview with all key metrics.

#### 2. Users Report
- Total users by date range
- Users by role distribution
- Users by subscription tier
- User growth trends

#### 3. Revenue Report
- Total revenue
- Average transaction value
- Revenue by payment type
- Daily revenue trends
- Transaction counts

#### 4. Diagnoses Report
- Total AI scans
- Disease distribution
- Average confidence scores
- Most common diseases

#### 5. Marketplace Report
- Total listings
- Total orders
- Orders by status
- Top products by views
- Revenue by product

### Generating Reports

1. Select report type
2. Choose date range
3. Click "Generate Report"
4. View results
5. Download as JSON

### API Endpoint

```typescript
GET /api/admin/reports?type={type}&startDate={date}&endDate={date}
```

**Parameters**:
- `type`: overview | users | revenue | diagnoses | marketplace
- `startDate`: ISO date string
- `endDate`: ISO date string

---

## 🚜 Farm Management

**Access**: `/admin/farms`

### Features

- View all farms in the system
- See farm details (location, size, crops)
- Monitor farm activities
- View farm statistics

---

## 📚 Content Management

**Access**: `/admin/content`

### Features

1. **Learning Content**
   - Add educational articles
   - Upload videos
   - Create tutorials
   - Manage categories

2. **Forum Moderation**
   - Review reported posts
   - Delete inappropriate content
   - Ban spam users
   - Pin important discussions

---

## ⚙️ Settings

**Access**: `/admin/settings`

### Configuration Options

1. **Platform Settings**
   - Site name and branding
   - Contact information
   - Social media links

2. **Email Settings**
   - SMTP configuration
   - Email templates

3. **Payment Settings**
   - Payment gateway credentials
   - Commission rates
   - Currency settings

4. **API Settings**
   - Weather API keys
   - SMS provider settings
   - Cloud storage credentials

---

## 🔐 Security Features

### Authentication

- JWT-based authentication
- Secure HTTP-only cookies
- 24-hour session expiry
- Automatic logout on inactivity

### Authorization

- Role-based access control (RBAC)
- Admin-only routes protected
- Middleware validation on all endpoints

### Data Protection

- Password hashing with bcrypt
- SQL injection prevention
- XSS protection
- CSRF tokens

---

## 📱 Mobile vs Backoffice

| Feature | Mobile App | Backoffice |
|---------|-----------|-----------|
| **Purpose** | User-facing farming tools | Admin management |
| **Users** | Farmers, Buyers, Experts | Administrators only |
| **Access** | iOS/Android apps | Web browser |
| **Port** | API via backend | localhost:3001 |
| **Auth** | User JWT tokens | Admin JWT tokens |
| **Features** | Farming, marketplace, learning | Management, reports, moderation |

---

## 🛠️ Technical Architecture

### Tech Stack

- **Framework**: Next.js 14 (App Router)
- **UI**: React Server Components + Client Components
- **Styling**: CSS Modules
- **Database**: PostgreSQL via Prisma
- **Authentication**: JWT + HTTP-only cookies
- **API**: REST API routes

### File Structure

```
backend/
├── app/
│   ├── api/admin/              # Admin API routes
│   │   ├── auth/
│   │   │   ├── login/route.ts
│   │   │   └── logout/route.ts
│   │   ├── dashboard/route.ts
│   │   ├── users/
│   │   │   ├── route.ts
│   │   │   └── [id]/route.ts
│   │   ├── reports/route.ts
│   │   └── marketplace/
│   │       └── [id]/route.ts
│   │
│   └── admin/                  # Admin UI pages
│       ├── layout.tsx
│       ├── page.tsx           # Login page
│       ├── dashboard/
│       │   └── page.tsx
│       ├── users/
│       │   └── page.tsx
│       └── reports/
│           └── page.tsx
│
└── middleware/
    └── adminAuth.ts           # Admin auth middleware
```

---

## 🔧 Development Guide

### Running in Development

```bash
# Terminal 1 - Backend with Backoffice
cd backend
npm install
npm run dev
# Access at http://localhost:3001/admin

# Terminal 2 - Mobile API (same backend, different routes)
# Mobile app connects to http://localhost:3001/api
```

### Building for Production

```bash
cd backend
npm run build
npm start
```

### Environment Variables

```env
# Database
DATABASE_URL="postgresql://postgres:123@localhost:5432/agri-db"

# Authentication
JWT_SECRET="your-super-secret-jwt-key"
NEXTAUTH_SECRET="your-nextauth-secret"

# Admin Credentials
ADMIN_EMAIL="admin@agrovision.rw"
ADMIN_PASSWORD="Admin@123"

# Port
BACKOFFICE_PORT=3001
```

---

## 📊 Common Admin Tasks

### 1. Moderate a New Listing

```bash
1. Go to /admin/marketplace
2. Filter by "PENDING"
3. Click on listing to review
4. Choose APPROVE/REJECT/SUSPEND
5. Add moderation notes
6. Submit
```

### 2. Suspend a User

```bash
1. Go to /admin/users
2. Search for user
3. Click "View"
4. Change status to "SUSPENDED"
5. Save changes
```

### 3. Generate Monthly Report

```bash
1. Go to /admin/reports
2. Select "Revenue Report"
3. Set date range (first to last day of month)
4. Click "Generate Report"
5. Download JSON
```

### 4. View Platform Statistics

```bash
1. Go to /admin/dashboard
2. View real-time stats
3. Check quick actions
4. Navigate to detailed sections
```

---

## 🐛 Troubleshooting

### Can't Login

1. Verify admin user exists in database
2. Check password is correctly hashed
3. Verify `role` is set to `ADMIN`
4. Clear browser cookies
5. Check console for errors

### Dashboard Not Loading

1. Check database connection
2. Verify API routes are accessible
3. Check browser console for errors
4. Ensure JWT secret is configured

### Reports Not Generating

1. Verify date range is valid
2. Check database has data for that period
3. Look for errors in server logs
4. Test API endpoint directly

---

## 🚀 Deployment

### Vercel Deployment

```bash
# Deploy backend with admin panel
vercel --prod

# Set environment variables in Vercel dashboard
# Enable authentication protection
```

### AWS/DigitalOcean Deployment

```bash
# Build the application
npm run build

# Start with PM2
pm2 start npm --name "agrovision-admin" -- start

# Or with Docker
docker build -t agrovision-backend .
docker run -p 3001:3001 agrovision-backend
```

### Security Checklist

- [ ] Change default admin credentials
- [ ] Use strong JWT secret
- [ ] Enable HTTPS in production
- [ ] Set secure cookie flags
- [ ] Implement rate limiting
- [ ] Enable CORS properly
- [ ] Set up database backups
- [ ] Enable logging and monitoring
- [ ] Use environment variables
- [ ] Restrict admin IP addresses (optional)

---

## 📞 Support

### Getting Help

- **Documentation**: Check this guide first
- **API Docs**: See `/docs/API_DOCUMENTATION.md`
- **Issues**: Open GitHub issue
- **Email**: support@agrovision.rw

### Resources

- [Next.js Documentation](https://nextjs.org/docs)
- [Prisma Documentation](https://www.prisma.io/docs)
- [React Documentation](https://react.dev)

---

## 🔄 Updates & Maintenance

### Updating the Backoffice

```bash
# Pull latest changes
git pull origin main

# Install dependencies
npm install

# Run migrations
npm run db:migrate

# Restart server
npm run dev
```

### Database Backups

```bash
# Backup database
pg_dump -U postgres agri-db > backup-$(date +%Y%m%d).sql

# Restore database
psql -U postgres agri-db < backup-20241212.sql
```

---

## 📝 Future Enhancements

### Planned Features

- [ ] Real-time notifications
- [ ] Advanced analytics dashboard
- [ ] Bulk user operations
- [ ] Email campaign management
- [ ] System logs viewer
- [ ] Performance monitoring
- [ ] A/B testing tools
- [ ] Customer support chat
- [ ] Mobile app version
- [ ] Multi-language support

---

## 🎓 Best Practices

### Admin User Management

1. Create separate admin accounts for each administrator
2. Use strong passwords (min 12 characters)
3. Enable 2FA when available
4. Regularly audit admin actions
5. Remove inactive admin accounts

### Data Management

1. Regularly backup database
2. Monitor storage usage
3. Archive old data
4. Clean up test data
5. Validate data integrity

### Security

1. Keep dependencies updated
2. Monitor for security vulnerabilities
3. Review access logs
4. Test security regularly
5. Follow OWASP guidelines

---

**Last Updated**: December 12, 2025  
**Version**: 1.0  
**Maintainer**: AgroVision Development Team
