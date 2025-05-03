-- Migration: Disable RLS for Local Development
-- Created: 2024-06-19
-- Description: Disables Row Level Security on all tables for local development.
-- WARNING: This should ONLY be used for local development environments.
-- DO NOT apply this migration to production environments.

-- Disable RLS on all tables
ALTER TABLE public.profiles DISABLE ROW LEVEL SECURITY;
ALTER TABLE public.notes DISABLE ROW LEVEL SECURITY;
ALTER TABLE public.generated_plans DISABLE ROW LEVEL SECURITY;
ALTER TABLE public.plan_notes DISABLE ROW LEVEL SECURITY;
ALTER TABLE public.plan_ratings DISABLE ROW LEVEL SECURITY;

-- Comment: Row Level Security has been disabled on all tables.
-- This allows unrestricted access to all data for local development.
-- When deploying to production, you should enable RLS again and implement proper security policies. 