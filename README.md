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

After building with `hugo`, deploy the contents of the `public/` directory to your web server.
