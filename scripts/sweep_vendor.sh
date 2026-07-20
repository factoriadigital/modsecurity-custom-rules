#!/bin/bash
# Barrido de activación del vendor FACTORIADIGITAL (ejecutar EN cada servidor).
# Los configs .conf NUEVOS que llegan vía update del vendor entran INACTIVOS en
# cPanel (active: 0) y no bloquean nada hasta activarlos a mano. Este script
# detecta los inactivos, los activa y reinicia el webserver (graceful) solo si
# cambió algo. Idempotente: donde ya está todo activo no toca nada.
# Uso fleet-wide: for h in ...; do ssh root@$h 'bash -s' < scripts/sweep_vendor.sh; done
# Contexto: AGENTS.md, gotcha eservidor43 2026-07-20.
echo "### $(hostname) ($(hostname -I 2>/dev/null | awk '{print $1}'))"
OUT=$(whmapi1 modsec_get_vendors 2>/dev/null)
if ! echo "$OUT" | grep -qi "FACTORIADIGITAL"; then
  echo "RESULTADO: vendor FACTORIADIGITAL NO instalado"
  exit 0
fi
INACT=$(echo "$OUT" | awk '/active: 0/{f=1} /config:/{if(f){print $2; f=0}}' | grep FACTORIADIGITAL)
if [ -z "$INACT" ]; then
  echo "RESULTADO: todo ya activo"
  echo "$OUT" | awk '/config:/{c=$2} /vendor_id: FACTORIADIGITAL/{print "  activo: " c}' | sort -u
  exit 0
fi
echo "INACTIVOS encontrados:"
echo "$INACT" | sed 's/^/  /'
CH=0
for c in $INACT; do
  R=$(whmapi1 modsec_make_config_active config="$c" 2>/dev/null | grep -c "result: 1")
  [ "$R" = "1" ] && { echo "  ACTIVADO: $c"; CH=1; } || echo "  ERROR activando: $c"
done
if [ "$CH" = "1" ]; then
  /scripts/restartsrv_httpd >/dev/null 2>&1
  sleep 4
  CODE=$(curl -sk -o /dev/null -w "%{http_code}" -m8 https://127.0.0.1 2>/dev/null)
  echo "RESULTADO: activado y reiniciado; webserver responde: $CODE"
fi
