-- OTP codes table for WhatsApp OTP authentication (free alternative to SMS)
CREATE TABLE otp_codes (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  phone TEXT NOT NULL UNIQUE,
  otp TEXT NOT NULL,
  device_id TEXT,
  expires_at TIMESTAMPTZ NOT NULL,
  attempts INTEGER DEFAULT 0,
  verified BOOLEAN DEFAULT false,
  verified_at TIMESTAMPTZ,
  created_at TIMESTAMPTZ DEFAULT now(),
  updated_at TIMESTAMPTZ DEFAULT now()
);

-- Enable RLS
ALTER TABLE otp_codes ENABLE ROW LEVEL SECURITY;

-- Only service role can access OTP codes (for security)
CREATE POLICY otp_service_only ON otp_codes
  USING (false); -- No direct access from client

-- Function to increment OTP attempts
CREATE OR REPLACE FUNCTION increment_otp_attempts(p_phone TEXT)
RETURNS void AS $$
BEGIN
  UPDATE otp_codes 
  SET attempts = attempts + 1, updated_at = now()
  WHERE phone = p_phone;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Index for faster lookups
CREATE INDEX idx_otp_codes_phone ON otp_codes(phone);
CREATE INDEX idx_otp_codes_expires ON otp_codes(expires_at);

-- Cleanup old OTPs periodically (run via pg_cron or manually)
CREATE OR REPLACE FUNCTION cleanup_expired_otps()
RETURNS void AS $$
BEGIN
  DELETE FROM otp_codes WHERE expires_at < now() - INTERVAL '1 hour';
END;
$$ LANGUAGE plpgsql;
