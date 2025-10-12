# Taryma.com

Source files for the Ewa Taryma-Myslinski art portfolio website, built with Hugo static site generator.

## Prerequisites

Install Hugo (extended version recommended):

```bash
# Ubuntu/Debian
sudo snap install hugo

# or using apt
sudo apt install hugo

# macOS
brew install hugo

# For other systems, see: https://gohugo.io/installation/
```

## Development

To run the development server:

```bash
hugo server -D
```

Then open your browser to `http://localhost:1313`

## Building the Site

To build the static site:

```bash
hugo
```

The built site will be in the `public/` directory.

## Project Structure

- `content/` - Markdown content files
  - `bio.md` - Biography page
  - `exhibitions.md` - Exhibitions list
  - `studies/` - Art study pages
- `layouts/` - HTML templates
  - `_default/baseof.html` - Base template
  - `_default/single.html` - Single page template
  - `_default/list.html` - List page template
  - `index.html` - Home page template
- `static/` - Static assets (CSS, images)
- `hugo.toml` - Hugo configuration

## Deployment

For local or custom deployment on a static file host, run the `hugo` command and deploy the contents of the `public/` directory to your web server.

## Gallery

The gallery data is located in `data/gallery.json` and includes all 657 artworks. To build the gallery files in `content/gallery/*.md`, you can run the script `data/build_gallery.py`. First ensure that you have pandas installed with `pip install pandas`, then run `cd data; python3 build_gallery.py`.

## Current setup

Currently the site is hosted on `statichost.eu` where it is built off of the `main` branch of this repo via webhook.

All media files are hosted on Hetzner Cloud in the `taryma-com-public` bucket of the `hel1` object store region.

DNS records are held by Hetzner Cloud.

Domain registration is via A2Hosting.com.