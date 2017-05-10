# ye olde file ingestor
$__PATH__ = split-path $MyInvocation.MyCommand.Definition

$config = (get-content -path $__PATH__\config.json) -join "`n" | convertfrom-json
[Environment]::SetEnvironmentVariable("AWS_ACCESS_KEY_ID", $config.aws_access_key_id, "Process")
[Environment]::SetEnvironmentVariable("AWS_SECRET_ACCESS_KEY", $config.aws_secret_access_key, "Process")
[Environment]::SetEnvironmentVariable("AWS_DEFAULT_REGION", $config.aws_region, "Process")
[Environment]::SetEnvironmentVariable("AWS_REGION", $config.aws_region, "Process")

$p = aws s3 ls s3://$($config.bucket) 2>&1
if (!$?) {
  # configuration is not valid
  write-host 'Configuration is not valid. Please check the configuration in c:\ProgramData\Cimpress\FileIngestor\config.json'
  exit -1
}

# check that we have paths configured
if (!($config.paths) -or ($config.paths.count -eq 0)) {
  write-host "No paths configured. Exiting."
  exit -2
}

# get the unique values (Windows does not care about case)
$config.paths | Sort-Object -Unique | % {
  $from = $_
  # ensure the source path exists
  if (!(test-path $from)) {
    write-host "Configured path ($from) does not exist. Skipping."
    continue
  }

  $targetName = split-path $_ -leaf
  if ($targetName -eq $from) {
    # this only happens with the root, such as "c:\\"
    $targetName = ""
  }
  $target = "s3://$($config.bucket)/$(split-path $from -leaf)"
  $exclude = ""
  if ($config.exclude -and ($config.exclude.length -gt 0)) {
    $exclude = "--exclude $($config.exclude -join ' --exclude ')"
  }
  write-host "$(get-date -format g): Syncing from $from to $target"
  aws s3 sync $from $target --exclude "*.bak" --exclude ".git/*"
}
