-- For dev: insert admin user (password should be hashed in real setup)
INSERT INTO users (id, email, name, role) VALUES ('00000000-0000-0000-0000-000000000001', 'admin@viraltics.test', 'Admin', 'admin')
ON CONFLICT DO NOTHING;
