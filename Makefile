# Configurable variables
AGENDA_URL := https://dkk.dgfk.net/wp-json/wp/v2/dkk_agenda_item/?_embed=&per_page=100&_fields=title,content,guid,acf,_embedded,_links
AGENDA_OUT := agenda.json
LOCATIONS_URL := https://dkk.dgfk.net/wp-json/wp/v2/dkk_location/?_embed=&per_page=100&_fields=id,title,acf,_embedded
LOCATIONS_OUT := locations.json

FONTS_URL := https://api.fontsource.org/v1/download/source-sans-3
FONTS_DIR := fonts
FONTS_ARCHIVE := $(FONTS_DIR)/source-sans-3.zip

.PHONY: refresh clean help get-fonts clean-fonts

# Download
refresh:
	@echo "Download..."
	@curl -o $(AGENDA_OUT) "$(AGENDA_URL)" || { echo "Download failed"; exit 1; }
	@echo "Agenda data downloaded and saved to $(AGENDA_OUT)"
	@curl -o $(LOCATIONS_OUT) "$(LOCATIONS_URL)" || { echo "Download failed"; exit 1; }
	@echo "Locations data downloaded and saved to $(LOCATIONS_OUT)"

clean:
	@rm -f $(AGENDA_OUT) $(LOCATIONS_OUT)
	@echo "Removed $(AGENDA_OUT) and $(LOCATIONS_OUT)"

# Download and extract fonts
get-fonts: $(FONTS_ARCHIVE)

$(FONTS_ARCHIVE):
	@mkdir -p $(FONTS_DIR)
	@echo "Downloading fonts to $@..."
	@curl -L -o $@ "$(FONTS_URL)" || { echo "Font download failed"; rm -f $@; exit 1; }
	@echo "Downloaded $@"
	@which unzip >/dev/null 2>&1 || { echo "unzip not found; install unzip to extract fonts"; exit 1; }
	@unzip -o $@ -d $(FONTS_DIR) >/dev/null && echo "Extracted fonts to $(FONTS_DIR)" || (echo "Failed to extract fonts"; exit 1)
	@echo "Keeping only fonts with -latin-<3 digits> in filename..."
	@find $(FONTS_DIR) -type f | while IFS= read -r f; do \
		if ! printf '%s\n' "$$f" | grep -E '/[^/]*-latin-[0-9]{3}[^/]*$$' >/dev/null; then \
			rm -f "$$f"; \
		fi; \
	done
	@echo "Filtered fonts in $(FONTS_DIR)"

clean-fonts:
	@rm -rf $(FONTS_DIR)
	@echo "Removed $(FONTS_DIR) and archive"

# Typst render
TYPST ?= typst
TYPST_IN ?= agenda.typ
TYPST_OUT ?= dkk-programm.pdf
TYPST_FLAGS ?=

.PHONY: typst
typst: $(TYPST_OUT)

$(TYPST_OUT): $(TYPST_IN)
	@command -v $(TYPST) >/dev/null 2>&1 || { echo "Install typst: https://typst.org"; exit 1; }
	@echo "Rendering $(TYPST_IN) → $@"
	@$(TYPST) compile $(TYPST_IN) $@ $(TYPST_FLAGS)
