# CrateLib

A lightweight PDF and EPUB reader that runs in your browser and remembers exactly where you left off, across all your devices.

Open a book on your Mac, read a few chapters, then pick up your iPhone: CrateLib opens it on the same page. There's no install and no build step. It's a single HTML file, with optional cloud sync through [Supabase](https://supabase.com).

**Live app:** https://cratelib.com

## Features

- **PDF and EPUB support.** PDFs are rendered with [PDF.js](https://mozilla.github.io/pdf.js/) and EPUBs with [epub.js](https://github.com/futurepress/epub.js).
- **Automatic progress saving.** Your position is saved on every page turn and whenever you switch away from the app.
- **Sync across devices.** Sign in to sync your books and reading progress. Add a book on one device and it shows up on the others. If you read further on another device, the open book jumps to your latest page.
- **Works offline.** Books you've opened are stored on the device, and changes sync when you're back online.
- **Personal library.** Each book shows a progress bar, your current page or percentage, and when you last read it.
- **Per-device zoom.** Fit-to-width or a custom zoom level is remembered for each PDF on each device.
- **Keyboard navigation.**

  | Key | Action |
  | --- | --- |
  | `→` / `Page Down` | Next page |
  | `←` / `Page Up` | Previous page |
  | `Esc` | Back to library |

- **Light and dark mode.** It follows your system setting.

## Getting started

Clone the repository and serve the folder with any static file server:

```bash
git clone https://github.com/AmaurisGonz/crate-lib.git
cd crate-lib
python3 -m http.server 8000
```

Then open [http://localhost:8000](http://localhost:8000).

Without sync configured, CrateLib works entirely on one device.

### Using it on iPhone

Open the live app in Safari, tap **Share**, then **Add to Home Screen**. It then opens full-screen like a regular app. Safari can clear data for websites you haven't visited in 7 days, but apps on the Home Screen are exempt, so your books stay stored.

## Setting up cloud sync

1. **Create a project.** Create a free account at [supabase.com](https://supabase.com) and start a new project.
2. **Create the database table and file storage.** Open **SQL Editor → New query**, paste the contents of [`supabase/setup.sql`](supabase/setup.sql), and click **Run**. This creates:
   - a `books` table for titles and reading progress
   - a private `books` storage bucket for the files
   - access rules so each user can only see their own books
3. **Allow email sign-in.** Go to **Authentication → Sign In / Providers** and make sure **Email** is enabled. To skip the confirmation email, turn off **Confirm email**.
4. **Connect the app.** In **Project Settings → API**, copy the **Project URL** and the **anon public** (or **publishable**) key into [`config.js`](config.js):

   ```js
   window.CRATELIB_CONFIG = {
     supabaseUrl: 'https://your-project.supabase.co',
     supabaseAnonKey: 'your-anon-or-publishable-key',
   };
   ```

5. **Publish.** Commit and push. Then open the app on each device, create an account on one, and sign in with it everywhere else.

> The anon/publishable key is designed to be public. Your data is protected by Supabase's row-level security rules in `setup.sql`, not by keeping this key secret. **Never** put the `service_role` or secret key in this repo.

## How it works

Each device keeps a full working copy in the browser's IndexedDB, so the app is fast and works offline. Supabase is the shared copy that all your devices sync with.

| Where | What's stored |
| --- | --- |
| IndexedDB `files` | The book files downloaded to this device |
| IndexedDB `meta` | Title, type, progress, last-opened time, zoom, and sync status |
| Supabase table `books` | One row per book: title, type, progress, and timestamps |
| Supabase Storage `books/<user id>/` | The book files |

- **Book identity:** books are identified by a SHA-256 hash of their contents. The same file matches on every device, even if it has a different name.
- **Conflicts:** each progress update is timestamped, and the most recent one wins.
- **When syncing happens:**
  - when you sign in or open the app
  - when you open a book
  - shortly after each page turn
  - when you leave the app or come back to it
  - when you go back online
- **Downloading books:** books added on another device show "☁ tap to download". They download the first time you open them.
- **Removing books:** removing a book takes it off every device.

## Limitations

- Supabase's free plan limits each file to 50 MB and total storage to 1 GB. It also pauses projects that go a week without activity; you can resume a paused project from the dashboard.
- PDFs show one page at a time, and you can't select or search text.
- An internet connection is needed to load PDF.js and epub.js from their CDNs.

## Roadmap

- [x] Sync reading progress across devices (Mac ↔ iPhone)
- [x] Identify books by their contents (SHA-256), so renamed copies still match
- [ ] Full offline support (service worker) and an app icon for the Home Screen
- [ ] Continuous scroll mode for PDFs
- [ ] Bookmarks and notes
- [ ] Text selection and search

## Built with

- [PDF.js](https://mozilla.github.io/pdf.js/) 3.11.174
- [epub.js](https://github.com/futurepress/epub.js) 0.3.93
- [JSZip](https://stuk.github.io/jszip/) 3.10.1
- [supabase-js](https://github.com/supabase/supabase-js) 2.117.3
- Plain HTML, CSS, and JavaScript, with no framework
