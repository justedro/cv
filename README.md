# cv

Source for [eduard.vlasov.nl](https://eduard.vlasov.nl/) and the one-page PDF resume it links to.

| Path | What it is |
| --- | --- |
| `resume/eduard-vlasov.tex` | General one-page resume |
| `eduard-vlasov.pdf` | Built PDF, served by the site at `/eduard-vlasov.pdf` |
| `resume/eduard-vlasov-ai.tex` | AI-native one-page variant (shorter summary and earlier roles, two extra Staff bullets) |
| `eduard-vlasov-ai.pdf` | Built AI-native PDF, not linked from the site |
| `index.html`, `assets/` | The site, plain HTML, CSS, and JS with no build step |
| `scripts/build-pdf.sh` | Builds the PDF and checks it is exactly one page |
| `.github/workflows/jekyll-gh-pages.yml` | Builds the PDF and deploys the site to GitHub Pages |

## Build the PDF

Requires Docker. The script runs `pdflatex` inside the `blang/latex` image, the same one CI uses, so line breaks match between local builds and the deployed PDF.

```sh
./scripts/build-pdf.sh
```

With no arguments it builds both resumes. Pass a basename to build one: `./scripts/build-pdf.sh eduard-vlasov-ai`. Each compile runs twice, fails if the result is not exactly one page, warns on overfull boxes, and copies the PDF to the repo root. On a LaTeX error it prints the end of `resume/build.log`.

To also render a PNG of the page for a quick visual check:

```sh
PREVIEW=1 ./scripts/build-pdf.sh eduard-vlasov-ai   # writes resume/eduard-vlasov-ai-preview.png
```

## Check what an ATS sees

Automated screeners read the PDF's text layer, not the layout. After a build, extract the text and confirm it reads top to bottom, each job title sits next to its dates, and nothing is garbled:

```sh
docker run --rm -v "$PWD":/data --entrypoint gs blang/latex -q -sDEVICE=txtwrite -o - eduard-vlasov.pdf
```

The Ghostscript in that image prints curly apostrophes as `Š` (for example `teamsŠ`). That is a quirk of its text output; pdftotext and pypdf read the same PDF as `’`.

## Preview the site

```sh
python3 -m http.server 8765
```

Then open <http://127.0.0.1:8765/>. After changing `assets/site.css` or `assets/site.js`, bump the `?v=` number on its link in `index.html` so browsers drop the cached copy.

## Deploy

A push to `master` runs the workflow: it builds the PDF, assembles `index.html`, `assets/`, `CNAME`, and the PDF into `public/`, and deploys that to GitHub Pages at `eduard.vlasov.nl`.
