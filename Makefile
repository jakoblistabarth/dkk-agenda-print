# Configurable variables
AGENDA_URL := https://dkk.dgfk.net/wp-json/wp/v2/dkk_agenda_item/?_embed=&per_page=100&_fields=title,content,guid,acf,_embedded,_links
AGENDA_OUT := agenda.json
LOCATIONS_URL := https://dkk.dgfk.net/wp-json/wp/v2/dkk_location/?_embed=&per_page=100&_fields=id,title,acf,_embedded
LOCATIONS_OUT := locations.json

.PHONY: refresh clean help
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
