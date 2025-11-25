# Viraltics - Full Scaffold (Dynamic Settings + Admin)

This scaffold contains a production-oriented starter for Viraltics:
- Backend (Node.js + TypeScript + Express)
- Frontend (Next.js + Tailwind) - basic pages & Admin Settings UI
- Dynamic Settings stored encrypted in DB and editable via Admin
- Worker skeleton (BullMQ)
- Webhooks endpoints (Apify, Paddle)
- Database migrations (Postgres SQL)
- Docker & docker-compose for local dev

**Important:** No secret keys are stored. Add service keys from Admin -> Integrations after deployment.
