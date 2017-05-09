schtasks /create /ru "NT AUTHORITY\LOCALSERVICE" /sc MINUTE /tn file-ingestor /tr c:\ProgramData\file-ingestor\ingest-files.bat
start .\python-3.6.1-amd64-webinstall.exe -ArgumentList /uninstall -wait
