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
	@curl -o $(AGENDA_OUT) --max-time 5 "$(AGENDA_URL)" || { echo "Download failed"; exit 1; }
	@echo "Agenda data downloaded and saved to $(AGENDA_OUT)"
	@sleep 2
	@curl -o $(LOCATIONS_OUT) --max-time 5 "$(LOCATIONS_URL)" || { echo "Download failed"; exit 1; }
	@echo "Locations data downloaded and saved to $(LOCATIONS_OUT)"
	@sleep 2
	@curl -o $(SPEAKERS_OUT) --max-time 5 "$(SPEAKERS_URL)" || { echo "Download failed"; exit 1; }
	@echo "Speakers data downloaded and saved to $(SPEAKERS_OUT)"

clean:
	@rm -f $(AGENDA_OUT) $(LOCATIONS_OUT) $(SPEAKERS_OUT)
	@echo "Removed $(AGENDA_OUT), $(LOCATIONS_OUT) and $(SPEAKERS_OUT)"
