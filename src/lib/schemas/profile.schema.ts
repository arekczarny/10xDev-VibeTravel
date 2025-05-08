import { z } from "zod";

export const createProfileSchema = z.object({
  activityLevel: z.string().min(1, "Activity level is required"),
  favoriteSports: z.array(z.string()).min(1, "At least one favorite sport is required"),
  travelerType: z.string().min(1, "Traveler type is required"),
  homeLocation: z.string().min(1, "Home location is required"),
  autoGenerate: z.boolean()
}); 