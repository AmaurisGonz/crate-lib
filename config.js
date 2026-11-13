// Supabase connection settings.
// Find both values in your Supabase dashboard: Project Settings → API (or "Connect").
// The publishable/anon key is meant to be public — your data is protected by the
// row-level security policies in supabase/setup.sql, not by hiding this key.
// Leave these empty to use Lib Crate without sync (books stay on this device only).
window.LIBCRATE_CONFIG = {
  supabaseUrl: 'https://usmhxilyhqegqappokyt.supabase.co',      // e.g. 'https://abcdefghijklmnop.supabase.co'
  supabaseAnonKey: 'sb_publishable_u1S5AljHu63n55rbD98ONA_9ukEja8q',  // the "anon public" or "publishable" key
};
