#!/bin/bash
# grab_zscaler_certs.sh - Run from WSL to extract Zscaler certs via Windows PowerShell

SCRIPT_FILE=$(mktemp /tmp/zscaler_certs_XXXXXX.ps1)

cat >"$SCRIPT_FILE" <<'EOF'
$certs = Get-ChildItem -Path Cert:\LocalMachine\Root | Where-Object { $_.Subject -like "*Zscaler*" }

$outputDir = Join-Path ([Environment]::GetFolderPath("MyDocuments")) "zscaler_certs"
if (-not (Test-Path $outputDir)) { New-Item -ItemType Directory -Path $outputDir | Out-Null }
$nameCount = @{}

if (-not $certs) {
    Write-Warning "No Zscaler certificates found in LocalMachine\Root store."
    exit 1
}

foreach ($cert in $certs) {
    $name = $cert.Subject -replace '[\\/:*?"<>|]', '_'

    if ($nameCount.ContainsKey($name)) {
        $nameCount[$name]++
        $filename = "${name}_$($nameCount[$name]).cer"
    } else {
        $nameCount[$name] = 0
        $filename = "${name}.cer"
    }

    $path = Join-Path $outputDir $filename
    [System.IO.File]::WriteAllBytes($path, $cert.Export([System.Security.Cryptography.X509Certificates.X509ContentType]::Cert))
    Write-Host "Saved: $path (Thumbprint: $($cert.Thumbprint))"
}

Write-Host "`nDone. $($certs.Count) certificate(s) exported to $outputDir"
EOF

WIN_SCRIPT=$(wslpath -w "$SCRIPT_FILE")
powershell.exe -NoProfile -Command "& {Get-Content '$WIN_SCRIPT' -Raw | Invoke-Expression}"
EXIT_CODE=$?
rm -f "$SCRIPT_FILE"

if [ $EXIT_CODE -ne 0 ]; then
	echo "Failed to export certificates from Windows store."
	exit $EXIT_CODE
fi

# Convert and install certs into WSL Ubuntu CA store
WIN_DOCS=$(powershell.exe -NoProfile -Command '[Environment]::GetFolderPath("MyDocuments")' | tr -d '\r')
CERT_DIR=$(wslpath "$WIN_DOCS/zscaler_certs")
CA_CERT_DIR="/usr/local/share/ca-certificates/zscaler"

if [ ! -d "$CERT_DIR" ] || [ -z "$(ls -A "$CERT_DIR" 2>/dev/null)" ]; then
	echo "No certificates found in $CERT_DIR"
	exit 1
fi

echo "Installing Zscaler certificates to $CA_CERT_DIR..."
sudo mkdir -p "$CA_CERT_DIR"

for cert in "$CERT_DIR"/*.cer; do
	filename=$(basename "$cert" .cer)
	# Sanitize filename: replace spaces and special chars with underscores
	clean_name=$(echo "$filename" | sed 's/[[:space:]]\+/_/g; s/[^a-zA-Z0-9._-]/_/g; s/__*/_/g; s/^_//; s/_$//')
	# Convert DER to PEM format
	sudo openssl x509 -inform DER -in "$cert" -out "$CA_CERT_DIR/${clean_name}.crt"
	echo "Installed: ${clean_name}.crt"
done

sudo update-ca-certificates
echo "Done. Zscaler certificates added to WSL CA store."
