import type { APIContext } from 'astro';
import type { CreateProfileRequestDto, ProfileResponseDto } from '../../types';
import { createProfileSchema } from '../../lib/schemas/profile.schema';
import { ProfileService } from '../../lib/services/profile.service';
import { DEFAULT_USER_ID } from '../../db/supabase.client';
import { logApiError } from '../../middleware/error-logger';

export const prerender = false;

/**
 * POST /profile endpoint
 * Creates a new user profile with travel preferences.
 * 
 * @param {APIContext} context - The Astro API context containing request and Supabase client
 * @returns {Promise<Response>} HTTP response
 * 
 * @throws {400} - When input validation fails
 * @throws {409} - When profile already exists for the user
 * @throws {500} - When server error occurs
 * 
 * @example
 * POST /profile
 * {
 *   "activityLevel": "moderate",
 *   "favoriteSports": ["hiking", "swimming"],
 *   "travelerType": "adventurer",
 *   "homeLocation": "Warsaw",
 *   "autoGenerate": true
 * }
 */
export async function POST(context: APIContext): Promise<Response> {
  try {
    const { request, locals } = context;
    
    // Parse and validate input data
    const requestData = await request.json();
    const validationResult = createProfileSchema.safeParse(requestData);
    
    if (!validationResult.success) {
      return new Response(
        JSON.stringify({ 
          error: 'Invalid input', 
          details: validationResult.error.format() 
        }), 
        { status: 400, headers: { 'Content-Type': 'application/json' } }
      );
    }
    
    const profileData = validationResult.data as CreateProfileRequestDto;
    
    // Check for existing profile
    const { data: existingProfile } = await locals.supabase
      .from('profiles')
      .select('user_id')
      .eq('user_id', DEFAULT_USER_ID)
      .maybeSingle();
    
    if (existingProfile) {
      return new Response(
        JSON.stringify({ error: 'Profile already exists' }), 
        { status: 409, headers: { 'Content-Type': 'application/json' } }
      );
    }
    
    // Create profile
    const profileService = new ProfileService(locals.supabase);
    const profile = await profileService.createProfile({
      userId: DEFAULT_USER_ID,
      ...profileData
    });
    
    // Return response
    const response: ProfileResponseDto = {
      ...profile,
      autoGenerate: profileData.autoGenerate
    };
    
    return new Response(
      JSON.stringify(response), 
      { status: 201, headers: { 'Content-Type': 'application/json' } }
    );
  } catch (error) {
    logApiError(error, context);
    return new Response(
      JSON.stringify({ 
        error: 'Internal server error', 
        message: 'Failed to create profile' 
      }), 
      { status: 500, headers: { 'Content-Type': 'application/json' } }
    );
  }
} 