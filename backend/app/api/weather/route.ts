// Weather API route
import { NextRequest } from 'next/server';
import { prisma } from '@/lib/prisma';
import { apiResponse, apiError } from '@/utils/apiResponse';
import { requireAuth } from '@/middleware/auth';

const OPENWEATHER_API_KEY = process.env.OPENWEATHER_API_KEY;
const OPENWEATHER_URL = 'https://api.openweathermap.org/data/2.5';

// GET - Get weather data
export async function GET(request: NextRequest) {
  const userOrError = await requireAuth(request);
  if (userOrError instanceof Response) return userOrError;

  try {
    const { searchParams } = new URL(request.url);
    const lat = searchParams.get('lat') || '-1.9403';
    const lon = searchParams.get('lon') || '29.8739';
    const farmId = searchParams.get('farmId');

    // If farmId provided, get farm location
    let location = { lat: parseFloat(lat), lon: parseFloat(lon) };
    
    if (farmId) {
      const farm = await prisma.farm.findFirst({
        where: { id: farmId, userId: userOrError.id },
      });
      if (farm && farm.latitude && farm.longitude) {
        location = { lat: farm.latitude, lon: farm.longitude };
      }
    }

    // Fetch current weather from OpenWeatherMap
    let currentWeather = null;
    let forecast = null;

    if (OPENWEATHER_API_KEY) {
      try {
        const currentRes = await fetch(
          `${OPENWEATHER_URL}/weather?lat=${location.lat}&lon=${location.lon}&appid=${OPENWEATHER_API_KEY}&units=metric`
        );
        currentWeather = await currentRes.json();

        const forecastRes = await fetch(
          `${OPENWEATHER_URL}/forecast?lat=${location.lat}&lon=${location.lon}&appid=${OPENWEATHER_API_KEY}&units=metric`
        );
        forecast = await forecastRes.json();
      } catch (err) {
        console.error('OpenWeatherMap API error:', err);
      }
    }

    // Fallback mock data if API fails or no key
    if (!currentWeather || currentWeather.cod !== 200) {
      currentWeather = {
        main: {
          temp: 22,
          feels_like: 23,
          humidity: 65,
          pressure: 1015,
        },
        weather: [{ main: 'Clouds', description: 'partly cloudy', icon: '02d' }],
        wind: { speed: 3.5 },
        clouds: { all: 40 },
        name: 'Kigali',
      };
    }

    if (!forecast || forecast.cod !== '200') {
      forecast = {
        list: Array.from({ length: 5 }, (_, i) => ({
          dt: Date.now() / 1000 + i * 86400,
          main: { temp: 20 + Math.random() * 5, humidity: 60 + Math.random() * 20 },
          weather: [{ main: 'Clouds', description: 'partly cloudy' }],
        })),
      };
    }

    // Store weather data
    await prisma.weatherData.create({
      data: {
        farmId: farmId || null,
        location: currentWeather.name || 'Unknown',
        latitude: location.lat,
        longitude: location.lon,
        temperature: currentWeather.main.temp,
        feelsLike: currentWeather.main.feels_like || currentWeather.main.temp,
        humidity: currentWeather.main.humidity,
        pressure: currentWeather.main.pressure || 1015,
        windSpeed: currentWeather.wind?.speed || 0,
        windDirection: currentWeather.wind?.deg || 0,
        cloudCover: currentWeather.clouds?.all || 0,
        rainfall: 0,
        condition: currentWeather.weather[0]?.main || 'Unknown',
        description: currentWeather.weather[0]?.description || 'Unknown',
        icon: currentWeather.weather[0]?.icon || '01d',
        date: new Date(),
      },
    });

    // Check for weather alerts
    const alerts = [];
    if (currentWeather.main.temp > 35) {
      alerts.push({ type: 'HEAT', message: 'High temperature alert! Ensure crops are well-watered.' });
    }
    if (currentWeather.main.humidity > 85) {
      alerts.push({ type: 'HUMIDITY', message: 'High humidity may increase disease risk.' });
    }
    if (currentWeather.weather[0]?.main === 'Rain') {
      alerts.push({ type: 'RAIN', message: 'Rain expected. Delay any pesticide application.' });
    }

    return apiResponse({
      current: currentWeather,
      forecast: forecast.list?.slice(0, 7),
      alerts,
      location: {
        lat: location.lat,
        lon: location.lon,
        name: currentWeather.name,
      },
    });
  } catch (error) {
    console.error('Weather API error:', error);
    return apiError('Failed to fetch weather data', 500);
  }
}
