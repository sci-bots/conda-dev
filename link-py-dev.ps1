$module = $args[0]

if (-not $args[0]) {
  $script = "$($MyInvocation.MyCommand)";
  echo "usage: $script <module name>";
  echo "";
  echo "example:";
  echo "";
  echo "  $script base_node_rpc";
  exit -1;
}

$site_packages_dir = "$env:CONDA_PREFIX\Lib\site-packages";
$conda_dev_dir = "$site_packages_dir\.conda-dev";

if (-not $(Test-Path "$conda_dev_dir")) {
    mkdir $conda_dev_dir;
}

$module_dir = "$site_packages_dir\$module"
If (Test-Path "$module_dir") {
  # Move existing directory to `.conda-dev` sub-directory.
  $conda_dev_path = "$conda_dev_dir\$module";
  if (Test-Path $conda_dev_path) {
    echo "warning: skipping module link since $module already exists in $conda_dev_dir.";
    exit -2;
  } else {
    mv $module_dir $conda_dev_dir;
  }
}
cmd /C mklink /J $module_dir $module
