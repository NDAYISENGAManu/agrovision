# 🚀 Quick Start Guide

## Complete Setup in 30 Minutes

### Step 1: Prerequisites (5 minutes)

Install required software:

```bash
# Check Node.js (should be 18+)
node --version

# Check PostgreSQL
psql --version

# Check Flutter
flutter --version

# If not installed, download from:
# Node.js: https://nodejs.org/
# PostgreSQL: https://www.postgresql.org/download/
# Flutter: https://flutter.dev/docs/get-started/install
```

### Step 2: Clone & Setup Backend (10 minutes)

```bash
# Clone repository
git clone https://github.com/yourusername/AgroVision.git
cd AgroVision

# Setup backend
cd backend
npm install

# Copy environment file
cp .env.example .env

# Edit .env with your database credentials
nano .env  # or use any text editor

# Create database
createdb agri-db

# Run migrations
npm run db:generate
npm run db:push

# Start backend
npm run dev
```

Backend should now be running at `http://localhost:3001` ✅

### Step 3: Setup Mobile App (10 minutes)

```bash
# Open new terminal
cd ../mobile

# Install dependencies
flutter pub get

# Update API URL in lib/core/constants/api_constants.dart
# Change baseUrl to your computer's IP address
# Example: 'http://192.168.1.100:3001/api'

# Run on Android
flutter run

# Or run on iOS (macOS only)
flutter run -d ios
```

Mobile app should launch on your device/emulator ✅

### Step 4: Test the App (5 minutes)

1. **Register a new account**
   - Use format: +250788123456
   - Password: test123

2. **Test API connection**
   - Check if registration works
   - Login should return JWT token

3. **Explore features**
   - Dashboard loads
   - Can create a farm
   - Can add crops

## Common Issues & Solutions

### Backend Issues

**Issue**: Database connection error
```bash
# Solution: Check PostgreSQL is running
sudo service postgresql start

# Verify connection
psql -U postgres -d agri-db
```

**Issue**: Port 3001 already in use
```bash
# Solution: Change port in backend
# Edit package.json: "dev": "next dev -p 3002"
# Update mobile API URL accordingly
```

### Mobile Issues

**Issue**: Can't connect to API
```bash
# Solution 1: Use your computer's IP, not localhost
# Find your IP:
ipconfig  # Windows
ifconfig  # Mac/Linux

# Solution 2: Check firewall allows port 3001
```

**Issue**: Flutter build errors
```bash
# Solution: Clean and rebuild
flutter clean
flutter pub get
flutter run
```

## Next Steps

### Implement Core Features

1. **Complete Authentication Flow**
   - Implement login UI
   - Add form validation
   - Handle token storage
   - Implement logout

2. **Build Farm Management**
   - Farm list with cards
   - Add farm form
   - Farm detail view
   - Edit/delete farms

3. **Add Crop Tracking**
   - Crop creation form
   - Crop lifecycle tracking
   - Cost recording
   - Harvest tracking

4. **Integrate AI Diagnosis**
   - Camera integration
   - Image upload to API
   - Display diagnosis results
   - Treatment recommendations

### Development Tips

**Hot Reload**: 
- Backend: Automatically reloads on file changes
- Flutter: Press 'r' for hot reload, 'R' for hot restart

**Debugging**:
- Backend: Check terminal logs
- Flutter: Use `print()` or `debugPrint()`
- Database: Use Prisma Studio (`npm run db:studio`)

**Testing**:
- Test APIs with Postman/Thunder Client
- Use Flutter DevTools for mobile debugging

## Deployment Checklist

### Backend Deployment

- [ ] Set up production database
- [ ] Configure environment variables
- [ ] Set up Cloudinary for images
- [ ] Configure payment gateway
- [ ] Set up email/SMS service
- [ ] Deploy to Vercel/AWS
- [ ] Set up SSL certificate
- [ ] Configure custom domain

### Mobile Deployment

- [ ] Update API URLs to production
- [ ] Configure app signing keys
- [ ] Test on multiple devices
- [ ] Prepare app store assets
- [ ] Submit to Google Play
- [ ] Submit to App Store (if iOS)

## Getting Help

- **Documentation**: Check `/docs` folder
- **Issues**: Create GitHub issue
- **Email**: dev@agrovision.rw
- **Community**: Join our Discord/Slack

## Performance Optimization

### Backend
- Enable caching with Redis
- Optimize database queries
- Use CDN for static assets
- Implement rate limiting

### Mobile
- Lazy load images
- Implement pagination
- Cache API responses
- Optimize image sizes

## Security Checklist

- [ ] Use HTTPS in production
- [ ] Implement rate limiting
- [ ] Validate all inputs
- [ ] Sanitize user data
- [ ] Use prepared statements
- [ ] Enable CORS properly
- [ ] Store secrets securely
- [ ] Implement 2FA

## Monitoring

Set up monitoring for production:
- Error tracking (Sentry)
- Performance monitoring (New Relic)
- Analytics (Google Analytics, Mixpanel)
- Uptime monitoring (UptimeRobot)

---

**Need help?** Check documentation or create an issue on GitHub.

**Ready to launch?** Follow the deployment checklist above.

Good luck building! 🚀
