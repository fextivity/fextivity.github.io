TYPST ?= typst
PYTHON ?= python
PORT ?= 3000
HOST ?= 127.0.0.1
BOOK_DIR := book
TYPST_FLAGS := --format bundle --features html,bundle

.PHONY: build clean serve preview watch

build: clean
	$(TYPST) compile book.typ $(TYPST_FLAGS)

clean:
	$(PYTHON) -c "import shutil; shutil.rmtree(r'$(BOOK_DIR)', ignore_errors=True)"

serve:
	$(PYTHON) -m http.server $(PORT) --bind $(HOST) --directory $(BOOK_DIR)

preview: build serve

watch: clean
	$(TYPST) watch book.typ $(BOOK_DIR) $(TYPST_FLAGS) --port $(PORT)
