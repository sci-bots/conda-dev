echo "# Linked Python development modules:"
echo ""
foreach ($i in $(dir $env:CONDA_PREFIX\Lib\site-packages\.conda-dev)) {
    # Get target of development link.
    $link_path = "$($i.FullName)\..\..\$($i.Name)"
    if ((Test-Path $link_path) -and
        ($(Get-Item -Path $link_path -Force).LinkType -eq "Junction")) {
        $target = Get-Item -Path $link_path |
            Select-Object -ExpandProperty Target;
        echo "    $i -> $target";
    } else {
        echo "    $i";
    }
}
