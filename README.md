# VibeTravel

An intelligent travel planner application that helps users organize notes and preferences to automatically generate detailed travel itineraries using AI.

## Tech Stack

**Frontend:**
*   Astro 5
*   React 19 (for interactive components)
*   TypeScript 5
*   Tailwind 4
*   Shadcn/ui

**Backend:**
*   Supabase (PostgreSQL, BaaS SDK, Auth)

**AI:**
*   Openrouter.ai (Access to various LLMs)

**CI/CD & Hosting:**
*   GitHub Actions
*   DigitalOcean (Docker)

## Getting Started Locally

Follow these steps to set up the project for local development.

**Prerequisites:**
*   Node.js (Version `22.14.0` - specified in `.nvmrc`)
*   npm (or yarn/pnpm)
*   Supabase account (or local instance) and API keys.
*   Openrouter.ai account and API key.

**Setup:**
1.  **Clone the repository:**
    ```bash
    git clone <your-repository-url>
    cd VibeTravel 
    ```
2.  **Install dependencies:**
    ```bash
    npm install 
    # or yarn install / pnpm install
    ```
3.  **Set up environment variables:**
    Create a `.env` file in the root directory and add your Supabase and Openrouter API keys. Refer to `.env.example` (if available) for required variables. 
    ```bash
    # .env
    PUBLIC_SUPABASE_URL=your_supabase_url
    PUBLIC_SUPABASE_ANON_KEY=your_supabase_anon_key
    OPENROUTER_API_KEY=your_openrouter_api_key 
    # Add any other required variables
    ```
    *Note: You might need to configure Supabase database schema and authentication settings.*
4.  **Run the development server:**
    ```bash
    npm run dev
    ```
    The application should now be running locally, typically at `http://localhost:4321`.

## Available Scripts

The following scripts are available in `package.json`:

*   `npm run dev`: Starts the Astro development server.
*   `npm run build`: Builds the application for production.
*   `npm run preview`: Runs a local preview of the production build.
*   `npm run astro`: Access Astro CLI commands.
*   `npm run lint`: Lints the codebase using ESLint.
*   `npm run lint:fix`: Attempts to automatically fix linting issues.
*   `npm run format`: Formats the code using Prettier.

## Project Scope

VibeTravel aims to streamline travel planning by:
*   Allowing users to create and manage notes (text, links, images).
*   Providing user authentication (registration/login).
*   Automatically tagging and categorizing notes for better organization.
*   Utilizing AI to generate detailed travel plans based on user notes and preferences.
*   Enabling users to save, share, and export their generated travel plans.

## Project Status

This project is currently in early development (Version 0.0.1).

## License

[License information not specified in package.json. Please add a license file or update package.json.]
