-- Users
CREATE EXTENSION IF NOT EXISTS "pgcrypto";

CREATE TABLE users (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  email TEXT UNIQUE NOT NULL,
  password_hash TEXT,
  name TEXT,
  role TEXT NOT NULL DEFAULT 'user',
  timezone TEXT DEFAULT 'UTC',
  language TEXT DEFAULT 'en',
  created_at TIMESTAMP WITH TIME ZONE DEFAULT now(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT now()
);

-- System Settings (dynamic, encrypted)
CREATE TABLE system_settings (
  key TEXT PRIMARY KEY,
  value TEXT,
  encrypted BOOLEAN DEFAULT true,
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT now()
);

-- Connected accounts
CREATE TABLE connected_accounts (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES users(id),
  team_id UUID,
  platform TEXT NOT NULL,
  platform_user_id TEXT,
  username TEXT,
  display_name TEXT,
  profile_url TEXT,
  connected_at TIMESTAMP WITH TIME ZONE,
  last_synced_at TIMESTAMP WITH TIME ZONE,
  meta JSONB,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT now()
);

-- Videos
CREATE TABLE videos (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  connected_account_id UUID REFERENCES connected_accounts(id),
  platform_video_id TEXT,
  title TEXT,
  description TEXT,
  thumbnail_url TEXT,
  published_at TIMESTAMP WITH TIME ZONE,
  duration_seconds INT,
  url TEXT,
  raw_apify_payload JSONB,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT now(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT now()
);

-- Metrics history
CREATE TABLE metrics_history (
  id BIGSERIAL PRIMARY KEY,
  video_id UUID REFERENCES videos(id),
  snapshot_time TIMESTAMP WITH TIME ZONE DEFAULT now(),
  views BIGINT,
  likes BIGINT,
  comments BIGINT,
  shares BIGINT,
  watch_time_seconds DOUBLE PRECISION,
  raw_metrics_json JSONB
);
CREATE INDEX idx_metrics_video_time ON metrics_history (video_id, snapshot_time DESC);

-- AI reports
CREATE TABLE ai_reports (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES users(id),
  connected_account_id UUID REFERENCES connected_accounts(id),
  video_id UUID REFERENCES videos(id),
  report_type TEXT,
  input_snapshot JSONB,
  output_json JSONB,
  score INT,
  language TEXT,
  pdf_s3_url TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT now(),
  completed_at TIMESTAMP WITH TIME ZONE
);

-- Subscriptions
CREATE TABLE subscriptions (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES users(id),
  plan TEXT,
  gateway_subscription_id TEXT,
  status TEXT,
  current_period_end TIMESTAMP WITH TIME ZONE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT now()
);

-- Apify runs
CREATE TABLE apify_runs (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES users(id),
  connected_account_id UUID REFERENCES connected_accounts(id),
  apify_run_id TEXT,
  dataset_id TEXT,
  status TEXT,
  started_at TIMESTAMP WITH TIME ZONE,
  finished_at TIMESTAMP WITH TIME ZONE,
  result_url TEXT,
  meta JSONB
);

-- App logs
CREATE TABLE app_logs (
  id BIGSERIAL PRIMARY KEY,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT now(),
  level TEXT,
  component TEXT,
  message TEXT,
  meta JSONB
);
