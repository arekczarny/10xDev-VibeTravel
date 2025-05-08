import { describe, it, expect, vi, beforeEach } from 'vitest';
import type { APIContext } from 'astro';
import { POST } from '../../pages/api/profile';

// Mock the supabase client module
vi.mock('../../db/supabase.client', () => ({
  DEFAULT_USER_ID: '123',
  supabaseClient: {
    from: vi.fn()
  }
}));

describe('POST /profile', () => {
  let mockContext: APIContext;
  const DEFAULT_USER_ID = '123';
  
  beforeEach(() => {
    // Reset all mocks before each test
    vi.resetAllMocks();

    // Create mock functions for the query chain
    const mockSelect = vi.fn().mockReturnThis();
    const mockEq = vi.fn().mockReturnThis();
    const mockInsert = vi.fn().mockReturnThis();
    const mockMaybeSingle = vi.fn();
    const mockSingle = vi.fn();

    // Create the query chain mock
    const mockQueryChain = {
      select: mockSelect,
      eq: mockEq,
      insert: mockInsert,
      maybeSingle: mockMaybeSingle,
      single: mockSingle
    };

    // Create the mock Supabase client
    const mockSupabase = {
      from: vi.fn().mockReturnValue(mockQueryChain)
    };

    // Create the mock context
    mockContext = {
      request: new Request('http://localhost/profile', {
        method: 'POST',
      }),
      locals: {
        supabase: mockSupabase
      }
    } as unknown as APIContext;
  });

  it('should create a new profile successfully', async () => {
    const profileData = {
      activityLevel: 'moderate',
      favoriteSports: ['hiking', 'swimming'],
      travelerType: 'adventurer',
      homeLocation: 'Warsaw',
      autoGenerate: true
    };

    const mockRequest = new Request('http://localhost/profile', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify(profileData)
    });

    mockContext.request = mockRequest;

    // Mock the Supabase responses
    const { supabase } = mockContext.locals;
    const queryChain = supabase.from('profiles');

    // Mock check for existing profile (should return null)
    queryChain.maybeSingle.mockResolvedValueOnce({ data: null });

    // Mock profile creation
    queryChain.single.mockResolvedValueOnce({
      data: {
        user_id: DEFAULT_USER_ID,
        activity_level: profileData.activityLevel,
        favorite_sports: profileData.favoriteSports,
        traveler_type: profileData.travelerType,
        home_location: profileData.homeLocation,
        created_at: '2024-03-20T12:00:00Z',
        updated_at: '2024-03-20T12:00:00Z'
      }
    });

    const response = await POST(mockContext);
    const responseData = await response.json();

    expect(response.status).toBe(201);
    expect(responseData).toMatchObject({
      userId: DEFAULT_USER_ID,
      activityLevel: profileData.activityLevel,
      favoriteSports: profileData.favoriteSports,
      travelerType: profileData.travelerType,
      homeLocation: profileData.homeLocation,
      autoGenerate: profileData.autoGenerate
    });

    // Verify Supabase calls
    expect(supabase.from).toHaveBeenCalledWith('profiles');
    expect(queryChain.select).toHaveBeenCalled();
    expect(queryChain.insert).toHaveBeenCalledWith({
      user_id: DEFAULT_USER_ID,
      activity_level: profileData.activityLevel,
      favorite_sports: profileData.favoriteSports,
      traveler_type: profileData.travelerType,
      home_location: profileData.homeLocation
    });
  });

  it('should return 400 for invalid input', async () => {
    const invalidData = {
      activityLevel: '',  // Invalid: empty string
      favoriteSports: [], // Invalid: empty array
      travelerType: 'adventurer',
      homeLocation: 'Warsaw',
      autoGenerate: true
    };

    const mockRequest = new Request('http://localhost/profile', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify(invalidData)
    });

    mockContext.request = mockRequest;

    const response = await POST(mockContext);
    const responseData = await response.json();

    expect(response.status).toBe(400);
    expect(responseData.error).toBe('Invalid input');
    expect(responseData.details).toBeDefined();
  });

  it('should return 409 if profile already exists', async () => {
    const profileData = {
      activityLevel: 'moderate',
      favoriteSports: ['hiking'],
      travelerType: 'adventurer',
      homeLocation: 'Warsaw',
      autoGenerate: true
    };

    const mockRequest = new Request('http://localhost/profile', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify(profileData)
    });

    mockContext.request = mockRequest;

    // Mock the Supabase response for existing profile
    const { supabase } = mockContext.locals;
    const queryChain = supabase.from('profiles');
    
    // Mock the check for existing profile (should return a profile)
    queryChain.maybeSingle.mockResolvedValueOnce({ 
      data: { user_id: DEFAULT_USER_ID } 
    });

    const response = await POST(mockContext);
    const responseData = await response.json();

    expect(response.status).toBe(409);
    expect(responseData.error).toBe('Profile already exists');

    // Verify Supabase calls
    expect(supabase.from).toHaveBeenCalledWith('profiles');
    expect(queryChain.select).toHaveBeenCalled();
    expect(queryChain.eq).toHaveBeenCalledWith('user_id', DEFAULT_USER_ID);
  });
}); 