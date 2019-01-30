$package = $args[0]
$module = $args[1]

if ($(-not $args[0]) -or $(-not $args[1])) {
  $script = "$($MyInvocation.MyCommand)";
  echo "usage: $script <package name> <Python module name>";
  echo "";
  echo "example:";
  echo "";
  echo "  $script base-node-rpc base_node_rpc";
  exit -1;
}

$site_packages = "$env:CONDA_PREFIX\Lib\site-packages";
$site_packages_dev = "$site_packages\.conda-dev";
$include = "$env:CONDA_PREFIX\share\platformio\include";
$include_dev = "$include\.conda-dev";
$firmware = "$env:CONDA_PREFIX\share\platformio\bin";
$firmware_dev = "$firmware\.conda-dev";

### Restore originally installed include headers
foreach ($lib in $(dir lib\*)) {
  $lib_name = $lib.Name;
  $lib_dev = "$include_dev\$lib_name";
  $lib_link = "$include\$lib_name";
  if ($($(Get-Item -Path $lib_link -Force).LinkType -eq "Junction")) {
    if (Test-Path $lib_dev) {
      # Delete development link.
      cmd /C rmdir $lib_link;
      # Restore existing installed library header directory.
      mv $lib_dev $lib_link;
      echo "Restored ``$lib_dev`` -> ``$lib_link``";
    } else {
      echo "warning: skipping $lib_name since $lib_dev (i.e., copy of originally installed library) does not exist.";
      continue;
    }
  } else {
    echo "warning: skipping $lib_name since $lib_link is not a junction.";
    continue;
  }
}

### Restore originally installed compiled firmwares
$bin_name = $package;
$bin_link = "$firmware\$bin_name";
$bin_dev = "$firmware_dev\$bin_name";
if ($($(Get-Item -Path $bin_link -Force).LinkType -eq "Junction")) {
  if (Test-Path $bin_dev) {
    # Delete development link.
    cmd /C rmdir $bin_link;
    # Restore existing installed library header directory.
    mv $bin_dev $bin_link;
    echo "Restored ``$bin_dev`` -> ``$bin_link``";
  } else {
    echo "warning: skipping $bin_name since $bin_dev (i.e., copy of originally installed firmware package) does not exist.";
    continue;
  }
} else {
  echo "warning: skipping $bin_name since $bin_link is not a junction.";
  continue;
}

if ((Test-Path .pioenvs\platformio.ini) -and
    ($(Get-Item -Path .pioenvs\platformio.ini -Force).LinkType -eq
     "HardLink")) {
    del .pioenvs\platformio.ini
    echo 'Removed `.pioenvs\platformio.ini -> platformio.ini` link';
}

unlink-py-dev $module;
