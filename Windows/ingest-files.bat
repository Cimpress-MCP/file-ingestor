@echo off
set localpath=%~dp0
powershell %localpath%ingest-files.ps1 >>  %localpath%logs\ingest-files.log
powershell %localpath%rotate-logs.ps1
