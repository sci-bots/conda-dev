$module_name = $args[0]

if (-not $args[0]) {
  $script = "$($MyInvocation.MyCommand)";
  echo "usage: $script <module name>";
  echo "";
  echo "example:";
  echo "";
  echo "  $script base_node_rpc";
  exit -1;
}

$site_packages = "$env:CONDA_PREFIX\Lib\site-packages";
$site_packages_dev = "$site_packages\.conda-dev";

### Restore originally installed compiled firmwares
$module_link = "$site_packages\$module_name";
$module_dev = "$site_packages_dev\$module_name";
if ((-not (Test-Path $module_link)) -or
    ($(Get-Item -Path $module_link -Force).LinkType -eq "Junction")) {
  if (Test-Path $module_dev) {
    if (Test-Path $module_link) {
        # Delete development link.
        cmd /C rmdir $module_link;
    }
    # Restore existing installed library header directory.
    mv $module_dev $module_link;
    echo "Restored ``$module_dev`` -> ``$module_link``";
  } else {
    echo "warning: skipping ``$module_name`` since ``$module_dev`` (i.e., copy of originally installed Python module) does not exist.";
    continue;
  }
} else {
  echo "warning: skipping ``$module_name`` since ``$module_link`` is not a junction.";
  continue;
}
