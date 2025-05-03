# REST API Plan

## 1. Resources

- User (auth.users)
- Profile (public.profiles)
- Note (public.notes)
- GeneratedPlan (public.generated_plans)
- PlanNoteLink (public.plan_notes)
- PlanRating (public.plan_ratings)


## 2. Endpoints

### 2.1 Authentication

#### POST /auth/register

Description: Register a new user, create auth.user and profile stub.
Request JSON:

```json
{
  "email": "string",
  "password": "string"
}
```

Response 201:

```json
{ "userId": "uuid", "email": "string" }
```

Errors: 400 Bad Request (validation), 409 Conflict (email exists).

#### POST /auth/login

Description: Authenticate user, return JWT.
Request JSON:

```json
{ "email": "string", "password": "string" }
```

Response 200:

```json
{ "token": "jwt", "expiresIn": 1800 }
```


#### POST /auth/forgot-password

Reset link via email (delegated to Supabase email).

#### POST /auth/reset-password

Reset with token.

### 2.2 Profile

#### GET /profile

Description: Get current user profile.
Headers: Authorization: Bearer token
Response 200:

```json
{
  "userId": "uuid",
  "activityLevel": "string",
  "favoriteSports": ["string"],
  "travelerType": "string",
  "homeLocation": "string",
  "createdAt": "timestamp",
  "updatedAt": "timestamp",
  "autoGenerate": true
}
```

#### POST /profile

Description: Create profile after registration.
Request JSON:

```json
{
  "activityLevel": "string",
  "favoriteSports": ["string"],
  "travelerType": "string",
  "homeLocation": "string",
  "autoGenerate": boolean
}
```

Response 201: Created profile object.

#### PATCH /profile

Description: Update profile preferences.
Request JSON: same as POST, all fields optional
Response 200: Updated profile.

#### DELETE /profile

Description: Delete account and profile (cascade).
Body: { "password": "string" }
Response 204 No Content.

### 2.3 Notes

#### GET /notes

Description: List notes with pagination \& filtering.
Query params: page, size, category, search
Response 200:

```json
{
  "notes": [ {Note} ],
  "total": 123,
  "page": 1,
  "size": 20
}
```


#### GET /notes/{id}

Retrieve single note. Response 200: {Note}.

#### POST /notes

Create new note.

```json
{
  "noteCategory": "string",       // optional category
  "content": "string",            // required
  // optional template fields:
  "continent": "string",
  "country": "string",
  "season": "string",
  "travelDate": "ISO timestamp",
  "accommodationType": "string",
  "transportType": "string",
  "plannedActivities": "string",
  "numPeople": number
}
```

Response 201: Created note.

#### PATCH /notes/{id}

Update note fields. Same payload as POST, all optional. Response 200: Updated note.

#### DELETE /notes/{id}

Delete note. Response 204.

### 2.4 Generated Plans

#### GET /plans

List generated plans.
Query: page, size, status (generated|accepted|rejected), category
Response 200:

```json
{
  "plans": [ {GeneratedPlanSummary} ],
  "total": number,
  "page": number,
  "size": number
}
```


#### GET /plans/{id}

Get plan details.
Response 200:

```json
{
  "id": "uuid",
  "userId": "uuid",
  "planDetails": { /* JSON structure */ },
  "status": "enum",
  "notes": ["noteId1","noteId2"],
  "createdAt": timestamp,
  "updatedAt": timestamp
}
```


#### POST /plans/generate

Generate plan on demand.

```json
{
  "noteIds": ["uuid","uuid"],    // optional; if absent, use all user notes
  "force": false                 // ignore autoGenerate toggle
}
```

Response 202 Accepted:

```json
{ "planId": "uuid", "status": "generated" }
```


#### PATCH /plans/{id}/status

Update plan status.

```json
{ "status": "accepted" | "rejected", "reason": "string" } // reason optional
```

Response 200: Updated plan status.

### 2.5 Ratings

#### GET /plans/{planId}/ratings

List ratings for a plan.
Response 200:

```json
{ "ratings": [ {PlanRating} ] }
```


#### POST /plans/{planId}/ratings

Add rating.

```json
{ "rating": 1 }
```

Response 201: Created rating object.

#### PATCH /plans/{planId}/ratings/{ratingId}

Update rating.

```json
{ "rating": 5 }
```

Response 200.

#### DELETE /plans/{planId}/ratings/{ratingId}

Delete rating. Response 204.

### 2.6 Dashboard

#### GET /dashboard

Summary counters.
Response 200:

```json
{
  "notesCount": number,
  "generatedPlansCount": number,
  "acceptedPlansCount": number,
  "recentPlans": [ {GeneratedPlanSummary} ]
}
```


## 3. Authentication and Authorization

- Mechanism: JWT issued by Supabase Auth.
- All protected endpoints require Authorization header.
- Ownership enforced server-side by comparing JWT uid with resource.userId.
- Password policies: min 8 chars, uppercase, lowercase, digit, special char.
- Session expiry: 30 minutes inactivity.
- Rate Limiting: 100 requests/min per user; 10 plan-generation/min.


## 4. Validation and Business Logic

- profiles: All fields required; favoriteSports array must not be empty.
- notes: content non-empty; numPeople between 1 and 32767 if provided; travelDate ISO timestamp.
- plans/generate: Must have at least one noteId or existing notes; respects autoGenerate setting unless force=true.
- plan status transition: Only generated→accepted/rejected.
- ratings: rating integer 1–5.
- Auto-generation: Triggered on new note if profile.autoGenerate=true; enqueued background job via /plans/generate.
- Dashboard: Aggregates via efficient count queries; cached for 1 minute.
- Security: Input sanitized; DB RLS policies enforced.
- Performance: All list endpoints support pagination, indexing userId columns.
- Error handling: Standard JSON error responses with code and message.