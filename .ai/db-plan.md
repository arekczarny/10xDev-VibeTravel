# VibeTravels PostgreSQL Database Schema (MVP)

## 1. Tables

### `public.profiles`
Stores user preferences, linked one-to-one with `auth.users`.

| Column          | Type        | Constraints                                                | Notes                                  |
| --------------- | ----------- | ---------------------------------------------------------- | -------------------------------------- |
| `user_id`       | `uuid`      | `PRIMARY KEY`, `REFERENCES auth.users(id) ON DELETE CASCADE` | Links to the Supabase auth user        |
| `activity_level`| `TEXT`      | `NOT NULL`                                                 | User's preferred activity level        |
| `favorite_sports`| `TEXT[]`    | `NOT NULL`                                                 | Array of user's favorite sports        |
| `traveler_type` | `TEXT`      | `NOT NULL`                                                 | User's preferred traveler type         |
| `home_location` | `TEXT`      | `NOT NULL`                                                 | User's home location (e.g., city)      |
| `created_at`    | `TIMESTAMPTZ` | `NOT NULL`, `DEFAULT now()`                                | Timestamp of profile creation          |
| `updated_at`    | `TIMESTAMPTZ` | `NOT NULL`, `DEFAULT now()`                                | Timestamp of last profile update       |

### `public.notes`
Stores user-created travel notes.

| Column             | Type        | Constraints                                                | Notes                                      |
| ------------------ | ----------- | ---------------------------------------------------------- | ------------------------------------------ |
| `id`               | `uuid`      | `PRIMARY KEY`, `DEFAULT gen_random_uuid()`                 | Unique identifier for the note             |
| `user_id`          | `uuid`      | `NOT NULL`, `REFERENCES auth.users(id) ON DELETE CASCADE`  | Links to the user who created the note     |
| `note_category`    | `TEXT`      | `NULLABLE`                                                 | Category of the note (e.g., Summer vacation) |
| `content`          | `TEXT`      | `NOT NULL`                                                 | Main content of the note                   |
| `continent`        | `TEXT`      | `NULLABLE`                                                 | Structured field for template notes        |
| `country`          | `TEXT`      | `NULLABLE`                                                 | Structured field for template notes        |
| `season`           | `TEXT`      | `NULLABLE`                                                 | Structured field for template notes        |
| `travel_date`      | `TIMESTAMPTZ`| `NULLABLE`                                                 | Structured field for template notes        |
| `accommodation_type`| `TEXT`      | `NULLABLE`                                                 | Structured field for template notes        |
| `transport_type`   | `TEXT`      | `NULLABLE`                                                 | Structured field for template notes        |
| `planned_activities`| `TEXT`      | `NULLABLE`                                                 | Structured field for template notes        |
| `num_people`       | `SMALLINT`  | `NULLABLE`                                                 | Structured field for template notes        |
| `created_at`       | `TIMESTAMPTZ` | `NOT NULL`, `DEFAULT now()`                                | Timestamp of note creation                 |
| `updated_at`       | `TIMESTAMPTZ` | `NOT NULL`, `DEFAULT now()`                                | Timestamp of last note update              |

### `public.plan_status_enum` (Type)
Defines the possible statuses for a generated plan.

```sql
CREATE TYPE public.plan_status_enum AS ENUM ('generated', 'accepted', 'rejected');
```

### `public.generated_plans`
Stores AI-generated travel plans.

| Column        | Type                 | Constraints                                                | Notes                                       |
| ------------- | -------------------- | ---------------------------------------------------------- | ------------------------------------------- |
| `id`          | `uuid`               | `PRIMARY KEY`, `DEFAULT gen_random_uuid()`                 | Unique identifier for the plan              |
| `user_id`     | `uuid`               | `NOT NULL`, `REFERENCES auth.users(id) ON DELETE CASCADE`  | Links to the user for whom the plan was generated |
| `plan_details`| `JSONB`              | `NOT NULL`                                                 | Stores detailed plan info (transport, accommodation, etc.) |
| `status`      | `plan_status_enum`   | `NOT NULL`, `DEFAULT 'generated'`                          | Current status of the plan                  |
| `created_at`  | `TIMESTAMPTZ`        | `NOT NULL`, `DEFAULT now()`                                | Timestamp of plan generation                |
| `updated_at`  | `TIMESTAMPTZ`        | `NOT NULL`, `DEFAULT now()`                                | Timestamp of last plan update (e.g., status change) |

### `public.plan_notes`
Linking table for the many-to-many relationship between `generated_plans` and `notes`.

| Column   | Type   | Constraints                                                         | Notes                                                |
| -------- | ------ | ------------------------------------------------------------------- | ---------------------------------------------------- |
| `plan_id`| `uuid` | `NOT NULL`, `REFERENCES public.generated_plans(id) ON DELETE CASCADE` | Links to the generated plan                          |
| `note_id`| `uuid` | `NOT NULL`, `REFERENCES public.notes(id) ON DELETE CASCADE`           | Links to the note used in the plan generation        |
|          |        | `PRIMARY KEY (plan_id, note_id)`                                    | Composite primary key prevents duplicate associations |

### `public.plan_ratings`
Stores user ratings for generated plans.

| Column     | Type        | Constraints                                                         | Notes                               |
| ---------- | ----------- | ------------------------------------------------------------------- | ----------------------------------- |
| `id`       | `uuid`      | `PRIMARY KEY`, `DEFAULT gen_random_uuid()`                          | Unique identifier for the rating    |
| `user_id`  | `uuid`      | `NOT NULL`, `REFERENCES auth.users(id) ON DELETE CASCADE`           | Links to the user who gave the rating |
| `plan_id`  | `uuid`      | `NOT NULL`, `REFERENCES public.generated_plans(id) ON DELETE CASCADE` | Links to the rated plan             |
| `rating`   | `SMALLINT`  | `NOT NULL`, `CHECK (rating >= 1 AND rating <= 5)`                   | Rating value (1-5 stars)            |
| `created_at`| `TIMESTAMPTZ` | `NOT NULL`, `DEFAULT now()`                                         | Timestamp of rating creation        |

## 2. Relationships

- **`auth.users` <-> `public.profiles`**: One-to-One (A profile exists for each user).
- **`auth.users` <-> `public.notes`**: One-to-Many (A user can have many notes).
- **`auth.users` <-> `public.generated_plans`**: One-to-Many (A user can have many generated plans).
- **`auth.users` <-> `public.plan_ratings`**: One-to-Many (A user can rate many plans).
- **`public.generated_plans` <-> `public.notes`**: Many-to-Many, via `public.plan_notes` (A plan can be generated from many notes, and a note can contribute to many plans).
- **`public.generated_plans` <-> `public.plan_ratings`**: One-to-Many (A plan can have many ratings).

## 3. Indexes

- Primary key indexes are automatically created for all `PRIMARY KEY` constraints.
- Foreign key indexes are generally automatically created by PostgreSQL for `REFERENCES` constraints.
- **Crucial:** Ensure indexes exist on all `user_id` columns (`profiles.user_id`, `notes.user_id`, `generated_plans.user_id`, `plan_ratings.user_id`) to optimize Row-Level Security (RLS) policy performance.
- Consider adding indexes on `plan_notes.note_id` if lookups by note are frequent.
- Consider adding indexes on `plan_ratings.plan_id` if retrieving all ratings for a plan is frequent.

## 4. Row-Level Security (RLS) Policies

RLS should be enabled on all tables containing user-specific data to ensure users can only access their own information.

- **Enable RLS on tables:** `profiles`, `notes`, `generated_plans`, `plan_notes`, `plan_ratings`.

- **Example Policies:**

  ```sql
  -- Policy for profiles: Users can only access their own profile
  CREATE POLICY "Allow individual read access on profiles"
  ON public.profiles FOR SELECT
  USING (auth.uid() = user_id);

  CREATE POLICY "Allow individual update access on profiles"
  ON public.profiles FOR UPDATE
  USING (auth.uid() = user_id);

  -- Policy for notes: Users can access/modify their own notes
  CREATE POLICY "Allow individual access on notes"
  ON public.notes FOR ALL
  USING (auth.uid() = user_id);

  -- Policy for generated_plans: Users can access/modify their own plans
  CREATE POLICY "Allow individual access on generated_plans"
  ON public.generated_plans FOR ALL
  USING (auth.uid() = user_id);

  -- Policy for plan_notes: Users can access links related to their own plans
  -- (Assumes user_id is the primary key for data ownership check)
  CREATE POLICY "Allow access to plan_notes linked to own plans"
  ON public.plan_notes FOR SELECT
  USING (
    EXISTS (
      SELECT 1 FROM public.generated_plans gp
      WHERE gp.id = plan_notes.plan_id AND gp.user_id = auth.uid()
    )
  );
  -- Consider INSERT/DELETE policies based on ownership of the plan being linked/unlinked

  -- Policy for plan_ratings: Users can manage their own ratings, but only read others' ratings for plans they own?
  -- Simple approach: Users can manage their own ratings.
  CREATE POLICY "Allow individual access on plan_ratings"
  ON public.plan_ratings FOR ALL
  USING (auth.uid() = user_id);

  -- More complex read access for plan owners might be added if needed.
  ```

  *Note: Define specific policies for `INSERT`, `UPDATE`, `DELETE` as needed, potentially reusing the `USING` clause or adding `WITH CHECK` clauses.*

## 5. Additional Notes

- **UUIDs:** All primary keys are `UUID` type, aligning with Supabase defaults. Requires the `pgcrypto` extension (usually enabled in Supabase) for `gen_random_uuid()`.
- **Timestamps:** Standard `created_at` and `updated_at` columns are included. Supabase may have mechanisms (e.g., triggers via `supabase/functions-hooks`) to automatically handle `updated_at` updates, otherwise, manual triggers are needed.
- **TEXT Flexibility:** Using `TEXT` for fields like `note_category`, `activity_level`, `traveler_type` provides flexibility but requires robust validation in the backend application logic to ensure data integrity and consistency.
- **JSONB:** The `plan_details` column uses `JSONB` for efficient storage and querying of structured plan data.
- **ON DELETE CASCADE:** Used extensively on foreign keys linked to `auth.users`. This ensures that when a user is deleted from the `auth.users` table, all their associated data (profile, notes, plans, ratings) is automatically removed, maintaining referential integrity. Similarly used on links to `generated_plans` and `notes` where appropriate (e.g., deleting a plan removes its ratings and links to notes). Evaluate if this cascading behavior is always desired in every case during implementation.
- **RLS Performance:** Indexes on `user_id` are critical for RLS performance. Without them, policy checks can lead to full table scans.
- **MVP Focus:** This schema focuses on MVP requirements. Further denormalization or indexing strategies might be considered later based on performance analysis and evolving requirements. 