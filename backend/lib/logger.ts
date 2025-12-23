import fs from 'fs';
import path from 'path';

// Log levels
export enum LogLevel {
  INFO = 'INFO',
  SUCCESS = 'SUCCESS',
  WARNING = 'WARNING',
  ERROR = 'ERROR',
  DEBUG = 'DEBUG',
}

// Log colors for console output
const LogColors = {
  [LogLevel.INFO]: '\x1b[36m',     // Cyan
  [LogLevel.SUCCESS]: '\x1b[32m',  // Green
  [LogLevel.WARNING]: '\x1b[33m',  // Yellow
  [LogLevel.ERROR]: '\x1b[31m',    // Red
  [LogLevel.DEBUG]: '\x1b[35m',    // Magenta
  RESET: '\x1b[0m',
};

// Log icons for better visibility
const LogIcons = {
  [LogLevel.INFO]: 'ℹ️',
  [LogLevel.SUCCESS]: '✅',
  [LogLevel.WARNING]: '⚠️',
  [LogLevel.ERROR]: '❌',
  [LogLevel.DEBUG]: '🔍',
};

interface LogEntry {
  timestamp: string;
  level: LogLevel;
  message: string;
  context?: string;
  data?: any;
  stack?: string;
}

class Logger {
  private logsDir: string;
  private isDevelopment: boolean;

  constructor() {
    this.logsDir = path.join(process.cwd(), 'logs');
    this.isDevelopment = process.env.NODE_ENV !== 'production';
    this.ensureLogsDirectory();
  }

  private ensureLogsDirectory(): void {
    const dirs = [
      this.logsDir,
      path.join(this.logsDir, 'info'),
      path.join(this.logsDir, 'success'),
      path.join(this.logsDir, 'warning'),
      path.join(this.logsDir, 'error'),
      path.join(this.logsDir, 'combined'),
    ];

    dirs.forEach(dir => {
      if (!fs.existsSync(dir)) {
        fs.mkdirSync(dir, { recursive: true });
      }
    });
  }

  private getTimestamp(): string {
    return new Date().toISOString();
  }

  private getDateString(): string {
    return new Date().toISOString().split('T')[0];
  }

  private formatLogEntry(entry: LogEntry): string {
    let log = `[${entry.timestamp}] [${entry.level}]`;
    if (entry.context) log += ` [${entry.context}]`;
    log += ` ${entry.message}`;
    if (entry.data) log += `\n  Data: ${JSON.stringify(entry.data, null, 2)}`;
    if (entry.stack) log += `\n  Stack: ${entry.stack}`;
    return log;
  }

  private writeToFile(level: LogLevel, entry: LogEntry): void {
    const dateString = this.getDateString();
    const formattedEntry = this.formatLogEntry(entry) + '\n';

    // Write to level-specific file
    const levelDir = level.toLowerCase();
    const levelFilePath = path.join(this.logsDir, levelDir, `${dateString}.log`);
    fs.appendFileSync(levelFilePath, formattedEntry);

    // Write to combined log
    const combinedFilePath = path.join(this.logsDir, 'combined', `${dateString}.log`);
    fs.appendFileSync(combinedFilePath, formattedEntry);
  }

  private consoleLog(level: LogLevel, entry: LogEntry): void {
    const color = LogColors[level];
    const icon = LogIcons[level];
    const reset = LogColors.RESET;

    let consoleMsg = `${color}${icon} [${entry.level}]${reset}`;
    if (entry.context) consoleMsg += ` ${color}[${entry.context}]${reset}`;
    consoleMsg += ` ${entry.message}`;

    switch (level) {
      case LogLevel.ERROR:
        console.error(consoleMsg);
        if (entry.data) console.error('  Data:', entry.data);
        if (entry.stack) console.error('  Stack:', entry.stack);
        break;
      case LogLevel.WARNING:
        console.warn(consoleMsg);
        if (entry.data) console.warn('  Data:', entry.data);
        break;
      case LogLevel.DEBUG:
        if (this.isDevelopment) {
          console.debug(consoleMsg);
          if (entry.data) console.debug('  Data:', entry.data);
        }
        break;
      default:
        console.log(consoleMsg);
        if (this.isDevelopment && entry.data) console.log('  Data:', entry.data);
    }
  }

  private log(level: LogLevel, message: string, context?: string, data?: any, error?: Error): void {
    const entry: LogEntry = {
      timestamp: this.getTimestamp(),
      level,
      message,
      context,
      data,
      stack: error?.stack,
    };

    // Always write to file
    this.writeToFile(level, entry);

    // Console output (controlled by level and environment)
    if (level === LogLevel.ERROR || level === LogLevel.WARNING) {
      this.consoleLog(level, entry);
    } else if (this.isDevelopment || level === LogLevel.SUCCESS) {
      this.consoleLog(level, entry);
    }
  }

  // Public logging methods
  info(message: string, context?: string, data?: any): void {
    this.log(LogLevel.INFO, message, context, data);
  }

  success(message: string, context?: string, data?: any): void {
    this.log(LogLevel.SUCCESS, message, context, data);
  }

  warning(message: string, context?: string, data?: any): void {
    this.log(LogLevel.WARNING, message, context, data);
  }

  error(message: string, context?: string, error?: Error | any, data?: any): void {
    const errorObj = error instanceof Error ? error : new Error(JSON.stringify(error));
    this.log(LogLevel.ERROR, message, context, data, errorObj);
  }

  debug(message: string, context?: string, data?: any): void {
    if (this.isDevelopment) {
      this.log(LogLevel.DEBUG, message, context, data);
    }
  }

  // HTTP request logging
  request(method: string, path: string, status: number, duration: number, userId?: string): void {
    const level = status >= 500 ? LogLevel.ERROR : status >= 400 ? LogLevel.WARNING : LogLevel.INFO;
    const message = `${method} ${path} ${status} ${duration}ms`;
    this.log(level, message, 'HTTP', { userId, status, duration });
  }

  // Database operation logging
  db(operation: string, table: string, duration?: number, data?: any): void {
    const message = duration 
      ? `${operation} on ${table} (${duration}ms)`
      : `${operation} on ${table}`;
    this.debug(message, 'DATABASE', data);
  }

  // Authentication logging
  auth(action: string, userId?: string, success: boolean = true, data?: any): void {
    const level = success ? LogLevel.SUCCESS : LogLevel.WARNING;
    const message = `Auth: ${action}${userId ? ` for user ${userId}` : ''}`;
    this.log(level, message, 'AUTH', data);
  }

  // API endpoint logging
  api(endpoint: string, method: string, status: number, userId?: string): void {
    const level = status >= 500 ? LogLevel.ERROR : status >= 400 ? LogLevel.WARNING : LogLevel.SUCCESS;
    const message = `${method} ${endpoint} → ${status}`;
    this.log(level, message, 'API', { userId });
  }

  // Clean old logs (keep last N days)
  async cleanOldLogs(daysToKeep: number = 30): Promise<void> {
    const cutoffDate = new Date();
    cutoffDate.setDate(cutoffDate.getDate() - daysToKeep);

    const subDirs = ['info', 'success', 'warning', 'error', 'combined'];

    for (const subDir of subDirs) {
      const dirPath = path.join(this.logsDir, subDir);
      if (fs.existsSync(dirPath)) {
        const files = fs.readdirSync(dirPath);
        for (const file of files) {
          const filePath = path.join(dirPath, file);
          const stats = fs.statSync(filePath);
          if (stats.mtime < cutoffDate) {
            fs.unlinkSync(filePath);
            this.info(`Cleaned old log file: ${file}`, 'LOGGER');
          }
        }
      }
    }
  }
}

// Export singleton instance
export const logger = new Logger();

// Export default for convenience
export default logger;
