# Nomenclatura de reglas

## Generar nueva versión

https://www.factoriadigital.com/soporte/en/admin/selfservice/internal/1/interna/article/generar-nueva-version-del-proveedor-factoriadigital-de-modsecurity

## IMPORTANTE: activar los configs nuevos tras publicar

Si la versión nueva añade un archivo `.conf` que un servidor no tenía, el auto-update
del vendor lo instala **inactivo** (`active: 0`) y no bloquea nada hasta activarlo:

    whmapi1 modsec_make_config_active config=modsec_vendor_configs/FACTORIADIGITAL/<archivo>.conf

Tras cada publicación con archivo nuevo, barrer TODA la flota con `scripts/sweep_vendor.sh`
(idempotente; activa lo que falte y reinicia graceful solo si cambió algo).

## IMPORTANTE

Mantener siempre un ID único y secuencial

## Genéricas

Códigos 120xxxx

## Prestashop

Códigos 121xxxx

## WordPress/WooCommerce

Códigos 122xxxx

## Magento

Códigos 123xxxx

## Moodle

Códigos 124xxxx

## Proveedores

Códigos genéricos que nos proporcionarán los propios proveedores de I360, etc. No será necesario modificarlos.
