$package = $args[0]

if (-not $args[0]) {
  $script = "$($MyInvocation.MyCommand)";
  echo "usage: $script <package name>";
  echo "";
  echo "example:";
  echo "";
  echo "  $script base-node-rpc";
  exit -1;
}

foreach ($path_i in "$env:CONDA_PREFIX\Lib\site-packages\.conda-dev", "$env:CONDA_PREFIX\share\platformio\include\.conda-dev", "$env:CONDA_PREFIX\share\platformio\bin\.conda-dev") {
    if (-not $(Test-Path $path_i)) {
        mkdir $path_i;
    } else {
        echo "$path_i already exists"
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
cmd /C mklink /J "$env:CONDA_PREFIX\share\platformio\bin\$package" .pioenvs
