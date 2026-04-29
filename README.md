# PDF Agenda for 74. DKK 2026

This repository contains the source code for generating the PDF agenda for the 74th DKK 2026 conference. The agenda is generated using data from the wordpress backend, accessed via the WP REST API. The code is written in Typst, a modern typesetting system that allows for programmatic document generation.

## Update data

Run the following command to update the data from the WP REST API:

```bash
make refresh
```
