
<api_analysis>

1. Main Entities from Database Schema:

2. profiles – Stores user preferences linked one-to-one with auth.users (db-plan.md, public.profiles table).
3. notes – User‐created travel notes with optional template fields (db-plan.md, public.notes table).
4. generated_plans – AI‐generated travel plans with status enum (db-plan.md, public.generated_plans table).
5. plan_notes – Many‐to‐many linking table between generated_plans and notes (db-plan.md, public.plan_notes table).
6. plan_ratings – Stores user ratings for generated plans (db-plan.md, public.plan_ratings table).
7. auth.users – Supabase managed users table with id referenced in all user‐owned tables.
1. Key Business Functions from PRD:

2. User Registration, Login, Password Reset (US-001, US-002).
3. Profile Creation \& Editing (US-003, US-004).
4. Note CRUD with categories and optional structured template (US-005 to US-008).
5. Generate Plan on Demand \& Auto-generation (US-009, US-010).
6. List/View Generated \& Accepted Plans (US-011, US-014).
7. Accept/Reject Plan (US-012).
8. Rate Plan (US-013).
9. Dashboard Summary (US-017).
10. Account Deletion \& Security (US-016, US-018).
1. Mapping PRD Functions to Potential API Endpoints:
    - Registration/Login:
        - Option A: /auth/register and /auth/login calling Supabase SDK
        - Option B: Delegate entirely to Supabase Auth via client SDK
→ Choose A to centralize flows and capture profile creation post-registration.
    - Note CRUD:
        - Option A: /notes with GET/POST/PUT/DELETE
        - Option B: /profiles/{userId}/notes
→ Choose A with implicit user from JWT; simpler and follows resource‐centric design.
    - Generate Plan:
        - Option A: POST /plans/generate with noteId or payload of notes
        - Option B: POST /notes/{noteId}/plans
→ Choose A for flexibility (auto-generation uses all notes).
    - Accept/Reject:
        - Option A: PATCH /plans/{planId}/status with body {status: "accepted"}
        - Option B: POST /plans/{planId}/accept and /plans/{planId}/reject
→ Choose PATCH for RESTful uniformity.
    - Rate Plan:
        - Option A: POST /plans/{planId}/ratings
        - Option B: PATCH /plans/{planId}/rating with body {rating: X}
→ Choose A since each rating is a separate resource entry.
2. Security \& Performance Requirements:
    - Authentication: JWT via Supabase Auth for all endpoints (PRD requires secure strong passwords, session expiry).
    - Authorization: Validate auth.uid() matches resource user_id; enforce ownership (Row-Level Security in DB).
    - Rate Limiting: To protect AI endpoints, limit /plans/generate to X requests/hour.
    - Pagination \& Filtering: List endpoints (/notes, /plans) accept page, size, filter by category/status.
    - Validation: Enforce DB constraints in API layer (e.g., rating 1–5, required fields non-null).
3. Mapping Business Logic to Endpoints:
    - Auto-generation toggle in user settings: PATCH /profiles/settings with { autoGenerate: boolean }.
    - Dashboard counts derived from querying /notes?count, /plans?status=generated\&count, /plans?status=accepted\&count.
    - When plan is generated, persist plan_details JSON, link notes via plan_notes, notify via WebSocket or poll.
4. Validation Requirements from DB Schema:
    - profiles.activity_level NOT NULL, favorite_sports TEXT[] NOT NULL, traveler_type NOT NULL, home_location NOT NULL.
    - notes.content NOT NULL; num_people SMALLINT NULL; travel_date TIMESTAMPTZ NULL.
    - generated_plans.status ENUM default generated.
    - plan_ratings.rating must be between 1 and 5 (CHECK constraint).
</api_analysis>