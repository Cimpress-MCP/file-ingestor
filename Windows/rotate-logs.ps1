$__PATH__ = split-path $MyInvocation.MyCommand.Definition
$main_log_file = "$__PATH__\logs\ingest-files.log"
if ((gi $main_log_file).length -gt 10mb) {
  $new_log_file = "$__PATH__\logs\{0:G}.log" -f [int][double]::Parse((get-date -uformat %s))
  [void] (mi $main_log_file $new_log_file)
  [void] (ri $main_log_file)
}
