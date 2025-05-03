-- Migration: Initial Schema for VibeTravels MVP
-- Created: 2024-06-19
-- Description: Creates the initial database schema for VibeTravels including profiles, notes, 
--              generated plans, plan notes, plan ratings, and related security policies.

-- Create plan status enum type
CREATE TYPE public.plan_status_enum AS ENUM ('generated', 'accepted', 'rejected');

-- Create profiles table
CREATE TABLE public.profiles (
    user_id uuid PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
    activity_level text NOT NULL,
    favorite_sports text[] NOT NULL,
    traveler_type text NOT NULL,
    home_location text NOT NULL,
    created_at timestamptz NOT NULL DEFAULT now(),
    updated_at timestamptz NOT NULL DEFAULT now()
);

-- Create notes table
CREATE TABLE public.notes (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id uuid NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    note_category text,
    content text NOT NULL,
    continent text,
    country text,
    season text,
    travel_date timestamptz,
    accommodation_type text,
    transport_type text,
    planned_activities text,
    num_people smallint,
    created_at timestamptz NOT NULL DEFAULT now(),
    updated_at timestamptz NOT NULL DEFAULT now()
);

-- Create generated_plans table
CREATE TABLE public.generated_plans (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id uuid NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    plan_details jsonb NOT NULL,
    status plan_status_enum NOT NULL DEFAULT 'generated',
    created_at timestamptz NOT NULL DEFAULT now(),
    updated_at timestamptz NOT NULL DEFAULT now()
);

-- Create plan_notes linking table
CREATE TABLE public.plan_notes (
    plan_id uuid NOT NULL REFERENCES public.generated_plans(id) ON DELETE CASCADE,
    note_id uuid NOT NULL REFERENCES public.notes(id) ON DELETE CASCADE,
    PRIMARY KEY (plan_id, note_id)
);

-- Create plan_ratings table
CREATE TABLE public.plan_ratings (
    id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id uuid NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    plan_id uuid NOT NULL REFERENCES public.generated_plans(id) ON DELETE CASCADE,
    rating smallint NOT NULL CHECK (rating >= 1 AND rating <= 5),
    created_at timestamptz NOT NULL DEFAULT now()
);

-- Create indexes for optimizing RLS performance
CREATE INDEX idx_profiles_user_id ON public.profiles(user_id);
CREATE INDEX idx_notes_user_id ON public.notes(user_id);
CREATE INDEX idx_generated_plans_user_id ON public.generated_plans(user_id);
CREATE INDEX idx_plan_ratings_user_id ON public.plan_ratings(user_id);
CREATE INDEX idx_plan_notes_note_id ON public.plan_notes(note_id);
CREATE INDEX idx_plan_ratings_plan_id ON public.plan_ratings(plan_id);

-- Enable Row Level Security (RLS) on all tables
ALTER TABLE public.profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.notes ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.generated_plans ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.plan_notes ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.plan_ratings ENABLE ROW LEVEL SECURITY;

-- Create RLS policies for profiles table
-- Allows users to read their own profile
CREATE POLICY "allow anon select on profiles" 
ON public.profiles FOR SELECT 
TO anon
USING (false);

-- Allows authenticated users to read their own profile
CREATE POLICY "allow authenticated select on profiles" 
ON public.profiles FOR SELECT 
TO authenticated
USING (auth.uid() = user_id);

-- Allows authenticated users to update their own profile
CREATE POLICY "allow authenticated update on profiles" 
ON public.profiles FOR UPDATE 
TO authenticated
USING (auth.uid() = user_id);

-- Allows authenticated users to insert their own profile
CREATE POLICY "allow authenticated insert on profiles" 
ON public.profiles FOR INSERT 
TO authenticated
WITH CHECK (auth.uid() = user_id);

-- Create RLS policies for notes table
-- Allows users to read their own notes
CREATE POLICY "allow anon select on notes" 
ON public.notes FOR SELECT 
TO anon
USING (false);

-- Allows authenticated users to read their own notes
CREATE POLICY "allow authenticated select on notes" 
ON public.notes FOR SELECT 
TO authenticated
USING (auth.uid() = user_id);

-- Allows authenticated users to insert their own notes
CREATE POLICY "allow authenticated insert on notes" 
ON public.notes FOR INSERT 
TO authenticated
WITH CHECK (auth.uid() = user_id);

-- Allows authenticated users to update their own notes
CREATE POLICY "allow authenticated update on notes" 
ON public.notes FOR UPDATE 
TO authenticated
USING (auth.uid() = user_id);

-- Allows authenticated users to delete their own notes
CREATE POLICY "allow authenticated delete on notes" 
ON public.notes FOR DELETE 
TO authenticated
USING (auth.uid() = user_id);

-- Create RLS policies for generated_plans table
-- Allows users to read their own plans
CREATE POLICY "allow anon select on generated_plans" 
ON public.generated_plans FOR SELECT 
TO anon
USING (false);

-- Allows authenticated users to read their own plans
CREATE POLICY "allow authenticated select on generated_plans" 
ON public.generated_plans FOR SELECT 
TO authenticated
USING (auth.uid() = user_id);

-- Allows authenticated users to insert their own plans
CREATE POLICY "allow authenticated insert on generated_plans" 
ON public.generated_plans FOR INSERT 
TO authenticated
WITH CHECK (auth.uid() = user_id);

-- Allows authenticated users to update their own plans
CREATE POLICY "allow authenticated update on generated_plans" 
ON public.generated_plans FOR UPDATE 
TO authenticated
USING (auth.uid() = user_id);

-- Allows authenticated users to delete their own plans
CREATE POLICY "allow authenticated delete on generated_plans" 
ON public.generated_plans FOR DELETE 
TO authenticated
USING (auth.uid() = user_id);

-- Create RLS policies for plan_notes linking table
-- Prevents anonymous access to plan_notes
CREATE POLICY "allow anon select on plan_notes" 
ON public.plan_notes FOR SELECT 
TO anon
USING (false);

-- Allows authenticated users to read plan_notes linked to their own plans
CREATE POLICY "allow authenticated select on plan_notes" 
ON public.plan_notes FOR SELECT 
TO authenticated
USING (
    EXISTS (
        SELECT 1 FROM public.generated_plans gp
        WHERE gp.id = plan_notes.plan_id AND gp.user_id = auth.uid()
    )
);

-- Allows authenticated users to insert plan_notes for their own plans
CREATE POLICY "allow authenticated insert on plan_notes" 
ON public.plan_notes FOR INSERT 
TO authenticated
WITH CHECK (
    EXISTS (
        SELECT 1 FROM public.generated_plans gp
        WHERE gp.id = plan_notes.plan_id AND gp.user_id = auth.uid()
    )
);

-- Allows authenticated users to delete plan_notes for their own plans
CREATE POLICY "allow authenticated delete on plan_notes" 
ON public.plan_notes FOR DELETE 
TO authenticated
USING (
    EXISTS (
        SELECT 1 FROM public.generated_plans gp
        WHERE gp.id = plan_notes.plan_id AND gp.user_id = auth.uid()
    )
);

-- Create RLS policies for plan_ratings table
-- Prevents anonymous access to plan_ratings
CREATE POLICY "allow anon select on plan_ratings" 
ON public.plan_ratings FOR SELECT 
TO anon
USING (false);

-- Allows authenticated users to read their own ratings
CREATE POLICY "allow authenticated select on plan_ratings" 
ON public.plan_ratings FOR SELECT 
TO authenticated
USING (auth.uid() = user_id);

-- Allows authenticated users to insert their own ratings
CREATE POLICY "allow authenticated insert on plan_ratings" 
ON public.plan_ratings FOR INSERT 
TO authenticated
WITH CHECK (auth.uid() = user_id);

-- Allows authenticated users to update their own ratings
CREATE POLICY "allow authenticated update on plan_ratings" 
ON public.plan_ratings FOR UPDATE 
TO authenticated
USING (auth.uid() = user_id);

-- Allows authenticated users to delete their own ratings
CREATE POLICY "allow authenticated delete on plan_ratings" 
ON public.plan_ratings FOR DELETE 
TO authenticated
USING (auth.uid() = user_id);

-- Comment: This migration establishes the core data model for VibeTravels MVP.
-- It creates all necessary tables with appropriate relationships, enables RLS,
-- and sets up granular security policies for data access control. 