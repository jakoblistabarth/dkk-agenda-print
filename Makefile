# Configurable variables
DATA_URL := https://dkk.dgfk.net/wp-json/wp/v2/dkk_agenda_item/?_embed=&per_page=100&_fields=title,content,guid,acf,_embedded,_links
DATA_OUT := agenda.json

FONTS_URL := https://api.fontsource.org/v1/download/source-sans-3
FONTS_DIR := fonts
FONTS_ARCHIVE := $(FONTS_DIR)/source-sans-3.zip

.PHONY: get-data refresh validate clean help get-fonts clean-fonts

# Default target
get-data: $(DATA_OUT)

# Download only when remote is newer (uses curl -z)
$(DATA_OUT):
	@echo "Downloading data to $@..."
	@curl -z $@ -o $@ "$(DATA_URL)" || { echo "Download failed"; exit 1; }
	@echo "Data downloaded and saved to $@"

# Force re-download
refresh:
	@echo "Forcing re-download..."
	@curl -o $(DATA_OUT) "$(DATA_URL)" || { echo "Download failed"; exit 1; }
	@echo "Data downloaded and saved to $(DATA_OUT)"

clean:
	@rm -f $(DATA_OUT)
	@echo "Removed $(DATA_OUT)"

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