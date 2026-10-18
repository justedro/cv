#!/usr/bin/env bash
# Builds resume/eduard-vlasov.tex into ./eduard-vlasov.pdf and fails if it is not exactly one page.
set -euo pipefail

cd "$(dirname "$0")/.."

IMAGE="${LATEX_IMAGE:-blang/latex}"
NAME="eduard-vlasov"
RESUME_DIR="$PWD/resume"

tex() {
  docker run --rm -v "$RESUME_DIR":/data "$IMAGE" "$@"
}

gs_in_image() {
  docker run --rm -v "$RESUME_DIR":/data --entrypoint gs "$IMAGE" "$@"
}

# Two passes so hyperref outlines settle.
for _ in 1 2; do
  if ! tex pdflatex -interaction=nonstopmode -halt-on-error "$NAME.tex" > "$RESUME_DIR/build.log"; then
    tail -40 "$RESUME_DIR/build.log"
    exit 1
  fi
done

pages="$(gs_in_image -q -dNODISPLAY -dNOSAFER -c "($NAME.pdf) (r) file runpdfbegin pdfpagecount = quit" | tr -d '[:space:]')"
if [ "$pages" != "1" ]; then
  echo "error: $NAME.pdf has $pages pages, expected 1" >&2
  exit 1
fi

if grep -q "Overfull" "$RESUME_DIR/build.log"; then
  echo "warning: overfull boxes in build log, check resume/build.log" >&2
fi

cp "$RESUME_DIR/$NAME.pdf" "$NAME.pdf"

if [ "${PREVIEW:-0}" = "1" ]; then
  gs_in_image -q -sDEVICE=png16m -r150 -o "/data/preview.png" "$NAME.pdf"
  echo "preview: resume/preview.png"
fi

rm -f "$RESUME_DIR"/*.aux "$RESUME_DIR"/*.out "$RESUME_DIR/$NAME.log"
echo "built $NAME.pdf (1 page)"
