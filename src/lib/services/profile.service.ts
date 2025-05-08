import type { CreateProfileCommand, ProfileEntity } from "../../types";
import type { SupabaseClient } from "../../db/supabase.client";

/**
 * Service responsible for managing user profiles in the database.
 * Handles profile creation, retrieval, and updates through Supabase.
 */
export class ProfileService {
  constructor(private readonly supabase: SupabaseClient) {}

  /**
   * Creates a new user profile in the database.
   * 
   * @param command - The command containing profile data and user ID
   * @throws Will throw an error if the database operation fails
   * @returns A promise that resolves to the created profile entity
   */
  async createProfile(command: CreateProfileCommand): Promise<ProfileEntity> {
    const { userId, activityLevel, favoriteSports, travelerType, homeLocation } = command;
    
    const { data, error } = await this.supabase
      .from('profiles')
      .insert({
        user_id: userId,
        activity_level: activityLevel,
        favorite_sports: favoriteSports,
        traveler_type: travelerType,
        home_location: homeLocation
      })
      .select('*')
      .single();
    
    if (error) throw error;
    
    return {
      userId: data.user_id,
      activityLevel: data.activity_level,
      favoriteSports: data.favorite_sports,
      travelerType: data.traveler_type,
      homeLocation: data.home_location,
      createdAt: data.created_at,
      updatedAt: data.updated_at
    };
  }
} 