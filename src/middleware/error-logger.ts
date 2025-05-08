import type { APIContext } from 'astro';

/**
 * Error logger middleware for API endpoints.
 * Logs errors with additional context information.
 * 
 * @param error - The error that occurred
 * @param context - The API context when the error occurred
 */
export function logApiError(error: unknown, context: APIContext): void {
  const errorObject = {
    timestamp: new Date().toISOString(),
    path: new URL(context.request.url).pathname,
    method: context.request.method,
    error: error instanceof Error ? {
      name: error.name,
      message: error.message,
      stack: error.stack
    } : String(error)
  };

  // In development, log to console
  if (import.meta.env.DEV) {
    console.error('API Error:', errorObject);
    return;
  }

  // In production, you might want to send this to a logging service
  // This is a placeholder for actual production logging implementation
  console.error('API Error:', JSON.stringify(errorObject));
} 