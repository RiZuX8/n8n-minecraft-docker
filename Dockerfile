# Fase 1: Bouw mcrcon in een tijdelijke 'builder' image
FROM debian:buster-slim AS builder

# Installeer de benodigde tools om te compileren
RUN apt-get update && apt-get install -y git build-essential

# Kloon de mcrcon source code en compileer het
RUN git clone https://github.com/Tiiffi/mcrcon.git /tmp/mcrcon
WORKDIR /tmp/mcrcon
RUN gcc -std=gnu11 -pedantic -Wall -Wextra -O2 -s -o mcrcon mcrcon.c

# Fase 2: Bouw de definitieve n8n image
FROM n8nio/n8n:latest

# Schakel tijdelijk naar de root-gebruiker
USER root

# Kopieer het gecompileerde 'mcrcon' bestand uit de builder-fase
COPY --from=builder /tmp/mcrcon/mcrcon /usr/local/bin/mcrcon

# Zorg dat het bestand uitvoerbaar is
RUN chmod +x /usr/local/bin/mcrcon

# Schakel terug naar de standaard 'node' gebruiker
USER node