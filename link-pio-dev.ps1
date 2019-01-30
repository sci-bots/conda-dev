$package = $args[0];
$module = $args[1];

if ($(-not $package) -or $(-not $module)) {
  $script = "$($MyInvocation.MyCommand)";
  echo "usage: $script <package name> <Python module name>";
  echo "";
  echo "example:";
  echo "";
  echo "  $script base-node-rpc base_node_rpc";
  exit -1;
}

link-py-dev $module;

foreach ($path_i in
         "$env:CONDA_PREFIX\Lib\site-packages\.conda-dev",
         "$env:CONDA_PREFIX\share\platformio\include\.conda-dev",
         "$env:CONDA_PREFIX\share\platformio\bin\.conda-dev") {
    if (-not $(Test-Path $path_i)) {
        mkdir $path_i;
    }
}

### Link include headers
foreach ($lib in $(dir lib\*)) {
  if (Test-Path "$env:CONDA_PREFIX\share\platformio\include\$($lib.Name)") {
    # Move existing directory to `.conda-dev` sub-directory.
    $conda_dev_dir = "$env:CONDA_PREFIX\share\platformio\include\.conda-dev";
    $conda_dev_path = "$conda_dev_dir\$($lib.Name)";
    if (Test-Path $conda_dev_path) {
        echo "warning: skipping $lib since $conda_dev_path already exists.";
        continue
    } else {
        mv "$env:CONDA_PREFIX\share\platformio\include\$($lib.Name)" $conda_dev_dir;
    }
  }
  cmd /C mklink /J "$env:CONDA_PREFIX\share\platformio\include\$($lib.Name)" $lib;
}

### Link compiled firmwares
If (Test-Path "$env:CONDA_PREFIX\share\platformio\bin\$package") {
  # Move existing directory to `.conda-dev` sub-directory.
  $conda_dev_path = "$env:CONDA_PREFIX\share\platformio\bin\.conda-dev";
  if (Test-Path "$conda_dev_path\$package") {
    echo "warning: skipping firmware link since $package already exists in $conda_dev_path.";
    exit -2;
  } else {
    mv "$env:CONDA_PREFIX\share\platformio\bin\$package" $conda_dev_path;
  }
}
If (-not (Test-Path .pioenvs\platformio.ini)) {
    cmd /C mklink /H .pioenvs\platformio.ini platformio.ini
}
cmd /C mklink /J "$env:CONDA_PREFIX\share\platformio\bin\$package" .pioenvs
