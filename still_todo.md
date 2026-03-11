# VERITAS — STILL TODO LIST

## Intelligence Brief Reader
- [ ] **Fix Article Image Scraping**: Current implementation with `ruby-readability` and `Nokogiri` fails to consistently capture and display images from news sources (likely due to relative URLs, lazy-loading, or more complex DOM structures).
- [ ] **Handle Advanced Bot Protections**: Some sources still block headless scraping via Cloudflare or Paywalls even with enhanced headers.

## Real-Time Intelligence
- [ ] **Solid Cable Integration**: Implement real-time updates for the "Live Intelligence Feed" on the dashboard so new articles appear without a page refresh.

## Data Visualization
- [ ] **3D Globe Implementation**: Replace the static globe placeholder with a functional 3D visualization showing article geolocations.

## AI & Analysis
- [ ] **Phase 2 LLM Integration**: Implement the actual background analysis jobs to populate the "AI Analysis" panel with Trust Scores, Sentiment, and Threat Assessment.

## Semantic Intelligence (Vector Search)
- [ ] **Embedding Generation & Vector Database**: Upgrade VERITAS from keyword search to true semantic dot-connecting.
  - **The Tech Stack**: PostgreSQL `pgvector` extension + `neighbor` ruby gem.
  - **Database Update**: Add `embedding vector(1536)` column to the `Article` model.
  - **Pipeline Step 4**: After the VERITAS Triad finishes text extraction, send the summary to OpenAI's `text-embedding-3-small` API.
  - **Save Vectors**: Store the returned 1536-dimensional float array in the database.
  - **Feature 1: Semantic Threat Search**: Allow users to query concepts (e.g., "escalating maritime tensions") and find mathematically relevant articles even if keywords don't match.
  - **Feature 2: Narrative Convergence**: Add a "Related Intel" section to the article show page that runs a vector distance search (`Article.nearest_neighbors(:embedding)`) to find articles pushing the exact same storyline across different regions.
  - **Feature 3: RAG Briefings**: Enable chatting with the entire database. When a user asks a question, embed the query, find the top 10 most relevant articles, and feed them to Claude Haiku to generate a fully-cited intelligence report.
