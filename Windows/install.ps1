$p = &{pip -V} 2>&1

if ($p -is [System.Management.Automation.ErrorRecord]) {
  invoke-webrequest https://www.python.org/ftp/python/3.6.1/python-3.6.1-amd64-webinstall.exe -UseBasicParsing -OutFile .\python-3.6.1-amd64-webinstall.exe
  start .\python-3.6.1-amd64-webinstall.exe -ArgumentList /passive,PrependPath=1,Include_doc=0,InstallAllUsers=1,SimpleInstall=1,Include_test=0,Include_tcltk=0 -wait
}
#install awscli
$p = pip show awscli
if (!$?) {
  pip install awscli
}

#create dir
$ingestor_home = 'c:\ProgramData\file-ingestor'
if (!(test-path $ingestor_home)) {
  [void] (mkdir $ingestor_home\logs)
}
#copy in files
#cpi .\ingest-files.* $ingestor_home
invoke-webrequest https://raw.githubusercontent.com/Cimpress-MCP/file-ingestor/master/Windows/ingest-files.ps1 -OutFile $ingestor_home\ingest-files.ps1
invoke-webrequest https://raw.githubusercontent.com/Cimpress-MCP/file-ingestor/master/Windows/ingest-files.bat -OutFile $ingestor_home\ingest-files.bat
invoke-webrequest https://raw.githubusercontent.com/Cimpress-MCP/file-ingestor/master/Windows/uninstall.ps1 -OutFile $ingestor_home\uninstall.ps1
invoke-webrequest https://raw.githubusercontent.com/Cimpress-MCP/file-ingestor/master/Windows/rotate-logs.ps1 -OutFile $ingestor_home\rotate-logs.ps1

#configure
if (!(test-path $ingestor_home\config.json)) {
  $config = @{}
  $config.aws_access_key_id = read-host -prompt 'AWS Access Key ID'
  $config.aws_secret_access_key = read-host -prompt 'AWS Secret Access Key'
  $config.aws_region = read-host -prompt 'Region'
  $config.bucket = read-host -prompt 'S3 Bucket Name'
  $path = read-host -prompt 'Path'
  $config.paths = ,$path
  $config.exclude = "*.bak",".git/*"

  $config | convertto-json | out-file (join-path $ingestor_home 'config.json') -Encoding ascii
}

#create scheduled task
$p = schtasks /create /ru "NT AUTHORITY\LOCALSERVICE" /sc MINUTE /tn file-ingestor /tr $ingestor_home\ingest-files.bat /f
if (!$?) {
  write-host $p
} else { write-host 'Done.' }
