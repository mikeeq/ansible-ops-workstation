#!/bin/bash
# grab_zscaler_certs.sh - Run from WSL to extract Zscaler certs via Windows PowerShell

powershell.exe -NoProfile -ExecutionPolicy Bypass -Command '
$certs = Get-ChildItem -Path Cert:\LocalMachine\Root | Where-Object { $_.Subject -like "*Zscaler*" }

$outputDir = [Environment]::GetFolderPath("MyDocuments")
$nameCount = @{}

if (-not $certs) {
    Write-Warning "No Zscaler certificates found in LocalMachine\Root store."
    exit 1
}

foreach ($cert in $certs) {
    $name = $cert.Subject -replace "[\\\\/:*?\"<>|]", "_"

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
'
