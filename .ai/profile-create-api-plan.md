
# API Endpoint Implementation Plan: Create Profile

## 1. Przegląd endpointa

Endpoint POST /profile służy do utworzenia profilu użytkownika po rejestracji. Zapisuje preferencje podróżnicze użytkownika, w tym poziom aktywności, ulubione sporty, typ podróżnika, lokalizację domową oraz preferencję automatycznego generowania planów.

## 2. Szczegóły żądania

- Metoda HTTP: POST
- Struktura URL: `/profile`
- Parametry:
  - Wymagane: brak (wszystkie dane przesyłane w ciele żądania)
  - Opcjonalne: brak
- Request Body:
  ```json
  {
    "activityLevel": "string",
    "favoriteSports": ["string"],
    "travelerType": "string",
    "homeLocation": "string",
    "autoGenerate": boolean
  }
  ```

## 3. Wykorzystywane typy

```typescript
// DTO do obsługi żądania
import { CreateProfileRequestDto } from "../types";

// Command Model do komunikacji z serwisem
import { CreateProfileCommand } from "../types";

// Entity do mapowania na strukturę bazy danych
import { ProfileEntity } from "../types";

// DTO do obsługi odpowiedzi
import { ProfileResponseDto } from "../types";
```

## 4. Szczegóły odpowiedzi

- Kod statusu: 201 Created
- Body odpowiedzi: Obiekt ProfileResponseDto zawierający dane utworzonego profilu
  ```json
  {
    "userId": "string",
    "activityLevel": "string",
    "favoriteSports": ["string"],
    "travelerType": "string",
    "homeLocation": "string",
    "autoGenerate": boolean,
    "createdAt": "string",
    "updatedAt": "string"
  }
  ```

## 5. Przepływ danych

1. Odbiór żądania POST na endpoint `/profile`
2. Walidacja danych wejściowych za pomocą Zod
3. Pobranie identyfikatora użytkownika z kontekstu Astro (context.locals.supabase)
4. Przekształcenie DTO na Command Model poprzez dodanie userId
5. Wywołanie metody profileService.createProfile z Command Model
6. Service wykonuje insert do tabeli `public.profiles`
7. Mapowanie utworzonego rekordu na ProfileResponseDto
8. Zwrócenie odpowiedzi 201 z utworzonym profilem

## 6. Względy bezpieczeństwa

1. Uwierzytelnienie:
   - Endpoint wymaga uwierzytelnienia użytkownika
   - Implementacja middleware sprawdzającego token JWT

2. Autoryzacja:
   - Użytkownik może utworzyć tylko własny profil
   - Weryfikacja czy użytkownik nie ma już profilu (unikanie duplikatów)

3. Walidacja danych:
   - Użycie Zod do walidacji schematu danych wejściowych
   - Sanityzacja danych wejściowych przed zapisem do bazy

## 7. Obsługa błędów

- **400 Bad Request**: 
  - Brakujące wymagane pola
  - Nieprawidłowy format danych (np. favoriteSports nie jest tablicą)
  - Nieprawidłowy typ danych (np. autoGenerate nie jest boolean)

- **401 Unauthorized**:
  - Brak tokenu uwierzytelniającego
  - Nieprawidłowy token

- **409 Conflict**:
  - Profil dla danego użytkownika już istnieje

- **500 Internal Server Error**:
  - Błąd podczas komunikacji z bazą danych
  - Nieoczekiwany błąd serwera

## 8. Rozważania dotyczące wydajności

1. Indeksowanie:
   - Tabela `profiles` ma już indeks po `user_id` (primary key)

2. Transakcje:
   - Użycie transakcji dla zapewnienia atomowości operacji

3. Cachowanie:
   - Rozważenie cachowania profilu użytkownika po jego utworzeniu

## 9. Etapy wdrożenia

1. Utworzenie pliku endpointu w `src/pages/api/profile.ts`

2. Implementacja schematu walidacji Zod:
   ```typescript
   import { z } from "zod";
   
   const createProfileSchema = z.object({
     activityLevel: z.string().min(1),
     favoriteSports: z.array(z.string()).min(1),
     travelerType: z.string().min(1),
     homeLocation: z.string().min(1),
     autoGenerate: z.boolean()
   });
   ```

3. Utworzenie lub rozszerzenie ProfileService w `src/lib/services/profile.service.ts`:
   ```typescript
   import type { CreateProfileCommand, ProfileEntity } from "../../types";
   import { supabaseClient } from "../../db/supabase.client";
   
   export class ProfileService {
     async createProfile(command: CreateProfileCommand): Promise<ProfileEntity> {
       const { userId, activityLevel, favoriteSports, travelerType, homeLocation } = command;
       
       const { data, error } = await supabaseClient
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
   ```

4. Implementacja endpointu w `src/pages/api/profile.ts`:
   ```typescript
   import type { APIContext } from 'astro';
   import { z } from 'zod';
   import type { CreateProfileRequestDto, ProfileResponseDto } from '../../types';
   import { ProfileService } from '../../lib/services/profile.service';
   
   export const prerender = false;
   
   const createProfileSchema = z.object({
     activityLevel: z.string().min(1),
     favoriteSports: z.array(z.string()).min(1),
     travelerType: z.string().min(1),
     homeLocation: z.string().min(1),
     autoGenerate: z.boolean()
   });
   
   export async function POST({ request, locals }: APIContext): Promise<Response> {
     try {
       // Sprawdź uwierzytelnienie
       const session = await locals.supabase.auth.getSession();
       if (!session.data.session) {
         return new Response(JSON.stringify({ error: 'Unauthorized' }), { 
           status: 401, 
           headers: { 'Content-Type': 'application/json' } 
         });
       }
       
       const userId = session.data.session.user.id;
       
       // Parsuj i waliduj dane wejściowe
       const requestData = await request.json();
       const validationResult = createProfileSchema.safeParse(requestData);
       
       if (!validationResult.success) {
         return new Response(
           JSON.stringify({ 
             error: 'Invalid input', 
             details: validationResult.error.format() 
           }), 
           { 
             status: 400, 
             headers: { 'Content-Type': 'application/json' } 
           }
         );
       }
       
       const profileData = validationResult.data as CreateProfileRequestDto;
       
       // Sprawdź czy profil już istnieje
       const { data: existingProfile } = await locals.supabase
         .from('profiles')
         .select('user_id')
         .eq('user_id', userId)
         .maybeSingle();
       
       if (existingProfile) {
         return new Response(
           JSON.stringify({ error: 'Profile already exists' }), 
           { 
             status: 409, 
             headers: { 'Content-Type': 'application/json' } 
           }
         );
       }
       
       // Utwórz profil
       const profileService = new ProfileService();
       const profile = await profileService.createProfile({
         userId,
         ...profileData
       });
       
       // Zwróć odpowiedź
       const response: ProfileResponseDto = {
         ...profile,
         autoGenerate: profileData.autoGenerate
       };
       
       return new Response(JSON.stringify(response), { 
         status: 201, 
         headers: { 'Content-Type': 'application/json' } 
       });
     } catch (error) {
       console.error('Error creating profile:', error);
       return new Response(
         JSON.stringify({ error: 'Server error', message: 'Failed to create profile' }), 
         { 
           status: 500, 
           headers: { 'Content-Type': 'application/json' } 
         }
       );
     }
   }
   ```

5. Utworzenie testu jednostkowego dla endpointu w `src/tests/api/profile.test.ts`