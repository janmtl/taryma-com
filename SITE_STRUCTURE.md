# Hugo Site Structure

## Directory Layout

```
taryma-com/
├── hugo.toml              # Hugo configuration
├── README.md              # Setup and build instructions
├── .gitignore            # Git ignore rules
│
├── content/              # All content in markdown
│   ├── _index.md         # Home page
│   ├── bio.md            # Biography page
│   ├── exhibitions.md    # Exhibitions page
│   └── studies/          # Studies section
│       ├── _index.md     # Studies list page
│       ├── venice.md
│       ├── arizona.md
│       ├── yellowstone.md
│       ├── rocky-mountains.md
│       ├── trees.md
│       ├── fish.md
│       ├── american-natives.md
│       ├── the-alaskan-trapper.md
│       ├── canada-geese.md
│       ├── selection-1.md
│       ├── selection-2.md
│       ├── posters.md
│       ├── drawings.md
│       ├── mexico.md
│       ├── water.md
│       ├── algonquin.md
│       ├── copies-of-masters.md
│       └── lake-mono.md
│
├── layouts/              # HTML templates
│   ├── _default/
│   │   ├── baseof.html   # Base template with header/footer
│   │   ├── single.html   # Template for single pages
│   │   └── list.html     # Template for list pages
│   └── index.html        # Home page template
│
└── static/               # Static assets
    └── css/
        └── style.css     # Main stylesheet

```

## Page URLs

Once built, the site will have these URLs:

- `/` - Home page
- `/bio/` - Biography
- `/exhibitions/` - Exhibitions
- `/studies/` - Studies list
- `/studies/venice/` - Venice study
- `/studies/arizona/` - Arizona study
- ... (all other studies)

## Features

- Clean, minimal design focused on artwork
- Responsive layout (mobile-friendly)
- Proper navigation menu
- Studies ordered by weight (1-18)
- All images hosted on external object storage
- Hugo's fast build system

## Next Steps

1. Install Hugo: `sudo snap install hugo` (or see README.md)
2. Test locally: `hugo server -D`
3. Build for production: `hugo`
4. Deploy `public/` directory to web server

