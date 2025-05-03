-- Migration: Disable Initial Policies
-- Created: 2024-06-19
-- Description: Disables all row-level security policies created in the initial schema migration.

-- Drop policies for profiles table
DROP POLICY IF EXISTS "allow anon select on profiles" ON public.profiles;
DROP POLICY IF EXISTS "allow authenticated select on profiles" ON public.profiles;
DROP POLICY IF EXISTS "allow authenticated update on profiles" ON public.profiles;
DROP POLICY IF EXISTS "allow authenticated insert on profiles" ON public.profiles;

-- Drop policies for notes table
DROP POLICY IF EXISTS "allow anon select on notes" ON public.notes;
DROP POLICY IF EXISTS "allow authenticated select on notes" ON public.notes;
DROP POLICY IF EXISTS "allow authenticated insert on notes" ON public.notes;
DROP POLICY IF EXISTS "allow authenticated update on notes" ON public.notes;
DROP POLICY IF EXISTS "allow authenticated delete on notes" ON public.notes;

-- Drop policies for generated_plans table
DROP POLICY IF EXISTS "allow anon select on generated_plans" ON public.generated_plans;
DROP POLICY IF EXISTS "allow authenticated select on generated_plans" ON public.generated_plans;
DROP POLICY IF EXISTS "allow authenticated insert on generated_plans" ON public.generated_plans;
DROP POLICY IF EXISTS "allow authenticated update on generated_plans" ON public.generated_plans;
DROP POLICY IF EXISTS "allow authenticated delete on generated_plans" ON public.generated_plans;

-- Drop policies for plan_notes table
DROP POLICY IF EXISTS "allow anon select on plan_notes" ON public.plan_notes;
DROP POLICY IF EXISTS "allow authenticated select on plan_notes" ON public.plan_notes;
DROP POLICY IF EXISTS "allow authenticated insert on plan_notes" ON public.plan_notes;
DROP POLICY IF EXISTS "allow authenticated delete on plan_notes" ON public.plan_notes;

-- Drop policies for plan_ratings table
DROP POLICY IF EXISTS "allow anon select on plan_ratings" ON public.plan_ratings;
DROP POLICY IF EXISTS "allow authenticated select on plan_ratings" ON public.plan_ratings;
DROP POLICY IF EXISTS "allow authenticated insert on plan_ratings" ON public.plan_ratings;
DROP POLICY IF EXISTS "allow authenticated update on plan_ratings" ON public.plan_ratings;
DROP POLICY IF EXISTS "allow authenticated delete on plan_ratings" ON public.plan_ratings;

-- Comment: Note that Row Level Security remains enabled on all tables,
-- but with no policies, no access will be granted to any users by default.
-- Consider adding new policies to grant appropriate access. 