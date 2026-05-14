#!/bin/bash
# grab_zscaler_certs.sh - Run from WSL to extract Zscaler certs via Windows PowerShell

SCRIPT_FILE=$(mktemp /tmp/zscaler_certs_XXXXXX.ps1)

cat > "$SCRIPT_FILE" << 'EOF'
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
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "$WIN_SCRIPT"
rm -f "$SCRIPT_FILE"
