# PDF Agenda for 74. DKK 2026

This repository contains the source code for generating the PDF agenda for the 74th DKK 2026 conference. The agenda is generated using data from the wordpress backend, accessed via the WP REST API. The code is written in [Typst](https://typst.app/), a modern typesetting system that allows for programmatic document generation.

## How to …

### Get latest data

Run the following command to fetch the latest data from the website's WP REST API:

```bash
make refresh
```

### Render / compile

For the best development experience, we recommend using the [tinymist](https://github.com/Myriad-Dreamin/tinymist), e.g. available as a [Visual Studio Code extension](https://marketplace.visualstudio.com/items?itemName=myriad-dreamin.tinymist). It provides syntax highlighting, code formatting, error checking and a live preview.
