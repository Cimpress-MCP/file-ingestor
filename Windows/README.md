Windows Download, Install, and Configure
===

To install this tool, open a Powershell command window *as Administrator* and run the following command:
```
invoke-webrequest https://raw.githubusercontent.com/Cimpress-MCP/file-ingestor/master/Windows/install.ps1 -UseBasicParsing -outfile .\file-ingestor-install.ps1; .\file-ingestor-install.ps1
```

If prompted, allow the script to make changes to your system.

The script will do the following things:
* Install Python, if you do not already have it
* Install awscli, if you do not already have it
* Create a folder, `ProgramData\file-ingestor` and place the main script there.
* Prompt you for configuration information (AWS keys, bucket name, source path, etc.) in order to setup the config.json file, which also goes into `ProgramData\file-ingestor`
* Create a scheduled task to run every minute to synchronize files.

Additional Configuration options
---
The configuration is stored in `c:\ProgramData\file-ingestor\config.json`. If you open this file, you will see you have a few more options you can specify directly in the file:
* You can monitor multiple paths for changed files. Just add new paths to the paths array.
* You can provide exclude patterns. The default exclusions are .git and .bak.
