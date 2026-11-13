# Bookmark Reader

A lightweight PDF and EPUB reader that runs in your browser and remembers exactly where you left off.

Open a book, read, close the tab, and come back later: Bookmark Reader reopens it on the same page. There's no account or install, and no build step. It's a single HTML file.

## Features

- **PDF and EPUB support.** PDFs are rendered with [PDF.js](https://mozilla.github.io/pdf.js/) and EPUBs with [epub.js](https://github.com/futurepress/epub.js).
- **Automatic progress saving.** Your position is saved on every page turn and whenever you switch away from the tab.
- **Personal library.** Books you open are stored locally in your browser, so you can reopen them with one click. Each book shows a progress bar, your current page or percentage, and when you last read it.
- **Per-book zoom.** Fit-to-width or a custom zoom level is remembered for each PDF.
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
git clone https://github.com/<your-username>/<repo-name>.git
cd <repo-name>
python3 -m http.server 8000
```

Then open [http://localhost:8000](http://localhost:8000).

You can also open `index.html` directly in Chrome, but serving it over `http://` is more reliable, especially in Safari.

## How it works

Everything stays on your device, in the browser's IndexedDB:

| Store | Contents |
| --- | --- |
| `files` | The raw bytes of each book you add |
| `meta` | Title, file type, last-opened time, zoom, and reading progress (page number for PDFs, location for EPUBs) |

A book is identified by its file name and size. If you add the same file again, the app keeps your existing progress instead of creating a duplicate.

## Limitations

- Your library and progress live in one browser on one device and aren't synced yet. See the roadmap.
- PDFs show one page at a time, and you can't select or search text.
- An internet connection is needed to load PDF.js and epub.js from their CDNs.
- Clearing your browser's site data removes your library.

## Roadmap

- [ ] Sync reading progress across devices (Mac ↔ iPhone)
- [ ] Identify books by their contents (a SHA-256 hash), so renamed copies still match
- [ ] Installable on the iPhone Home Screen as a progressive web app (PWA)
- [ ] Continuous scroll mode for PDFs
- [ ] Bookmarks and notes
- [ ] Text selection and search

## Built with

- [PDF.js](https://mozilla.github.io/pdf.js/) 3.11.174
- [epub.js](https://github.com/futurepress/epub.js) 0.3.93
- [JSZip](https://stuk.github.io/jszip/) 3.10.1
- Plain HTML, CSS, and JavaScript, with no framework
