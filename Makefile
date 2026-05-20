# Configurable variables
AGENDA_URL := https://dkk.dgfk.net/wp-json/wp/v2/dkk_agenda_item/?_embed=&per_page=100&_fields=title,content,guid,acf,_embedded,_links
AGENDA_OUT := agenda.json
LOCATIONS_URL := https://dkk.dgfk.net/wp-json/wp/v2/dkk_location/?_embed=&per_page=100&_fields=id,title,acf,_embedded
LOCATIONS_OUT := locations.json
SPEAKERS_URL := https://dkk.dgfk.net/wp-json/wp/v2/dkk_speaker/?_embed=&per_page=100&_fields=id,title,acf,_embedded
SPEAKERS_OUT := speakers.json

.PHONY: fetch-data clean help
# Download
fetch-data:
	@echo "Download..."
	@curl -o $(AGENDA_OUT) "$(AGENDA_URL)" || { echo "Download failed"; exit 1; }
	@echo "Agenda data downloaded and saved to $(AGENDA_OUT)"
	@curl -o $(LOCATIONS_OUT) "$(LOCATIONS_URL)" || { echo "Download failed"; exit 1; }
	@echo "Locations data downloaded and saved to $(LOCATIONS_OUT)"
	@curl -o $(SPEAKERS_OUT) "$(SPEAKERS_URL)" || { echo "Download failed"; exit 1; }
	@echo "Speakers data downloaded and saved to $(SPEAKERS_OUT)"

clean:
	@rm -f $(AGENDA_OUT) $(LOCATIONS_OUT)
	@echo "Removed $(AGENDA_OUT) and $(LOCATIONS_OUT)"
