# AGENTS.md

Personal resume repo: a one-page LaTeX PDF and a static site at eduard.vlasov.nl that carry the same content. See `README.md` for layout and commands.

## Commands

- Build the PDF: `./scripts/build-pdf.sh` (Docker, `blang/latex` image). Exits non-zero if the PDF is not exactly one page.
- Visual check: `PREVIEW=1 ./scripts/build-pdf.sh eduard-vlasov-ai`, then read `resume/eduard-vlasov-ai-preview.png`. Delete it afterwards. The same works for `eduard-vlasov`.
- Text layer check: `docker run --rm -v "$PWD":/data --entrypoint gs blang/latex -q -sDEVICE=txtwrite -o - eduard-vlasov.pdf`. It shows curly apostrophes as `Š`; that is a Ghostscript quirk, not a PDF problem.
- Site preview: `python3 -m http.server 8765` from the repo root.

Always rebuild and commit `eduard-vlasov.pdf` after editing `resume/eduard-vlasov.tex`, since the local site serves that copy. Rebuild and commit `eduard-vlasov-ai.pdf` after editing `resume/eduard-vlasov-ai.tex`. The AI-native PDF is not linked from the site.

## Keep the public resume in sync

`resume/eduard-vlasov.tex` and `index.html` hold the same text, except the site also carries two Staff bullets that exist only on the site and in the AI-native PDF: self-hosted LLM evaluation and the knowledge aggregation system. Any other change to the summary, a bullet, a title, a date, or a skill goes into `resume/eduard-vlasov.tex` and `index.html` in the same change. The site may wrap lines differently but the wording must match.

`resume/eduard-vlasov-ai.tex` is a separate one-page variant for AI-native companies. It uses a shorter summary, drops the storage-cost bullet, merges the early Miro bullets, and replaces the Data skills line with Data & AI. Those cuts stay in that file only. The two Staff bullets above must keep the same wording in `index.html` and `resume/eduard-vlasov-ai.tex`.

## Resume rules

- Exactly one A4 page. If an edit overflows, tighten wording before touching font size or margins. Current settings are 10pt with 1.6cm side margins.
- Single column, standard section names (Summary, Experience, Skills, Awards, Education), no tables for content, icons, or images. Education stays last.
- Keep `\pdfgentounicode=1`, `glyphtounicode`, T1 encoding, and disabled ligatures in the preamble. They keep the text layer readable for ATS and LLM screeners.
- Each title has its own dates on the same line. Promotions at one employer are separate `\position` blocks under one `\company`.
- Bullets: start with a past-tense action verb, one sentence, 1 to 2 lines, no period at the end, no pronouns. Don't leave 1 to 4 words alone on a wrapped last line.
- Use digits for numbers. Name tools inside the bullets where they were used, not only in Skills.
- Never add facts, metrics, titles, dates, or technologies the owner has not confirmed. Ask instead.

## Content to leave as is unless the owner says otherwise

- The phone number stays commented out in both files.
- The site must not contain the email as literal text, a `mailto:` link, or JSON-LD. `assets/site.js` rebuilds it at runtime (XOR 42). In `resume/eduard-vlasov.tex` the address is `\resumeemail`, built from short out-of-order pieces (`\euA`…`\euE`, `\ehA`…`\ehD`); the rendered PDF contains it in the clear, which is required.
- The pending senior staff promotion is not on the resume.
- Public GitHub repos are described as pet projects; there is no Projects section.

## Site

- No animations or decorative widgets; the owner removed them on purpose.
- Colors live in CSS variables at the top of `assets/site.css` (charcoal `#1a1a1a` text, slate `#4a5568` accent, white background).
- After editing `assets/site.css` or `assets/site.js`, bump the `?v=` query on its tag in `index.html`.
