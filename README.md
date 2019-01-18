# conda-dev #

Powershell scripts to link/unlink working copies of Conda packages during development.


<!-- vim-markdown-toc GFM -->

* [Install](#install)
* [Usage](#usage)
    * [Python module](#python-module)
    * [PlatformIO project with Python module](#platformio-project-with-python-module)
* [How it works](#how-it-works)
* [License](#license)
* [Contributors](#contributors)

<!-- vim-markdown-toc -->

-------------------------------------------------------------------------------

Install
-------

The latest [`conda-dev` release][3] is available as a
[Conda][2] package from the [`sci-bots`][4] channel.

To install `conda-dev` in an **activated Conda environment**, run:

    conda install -c sci-bots -c conda-forge conda-dev

-------------------------------------------------------------------------------

Usage
-----

### Python module

From within parent directory of Python module, run:

```sh
link-py-dev <module name>
```
To restore originally installed module, from within parent directory of Python
module, run:

```sh
unlink-py-dev <module name>
```

For example:

```sh
$ link-py-dev foo_bar
Junction created for C:\Users\chris\mc2-x86\envs\db-dev2\Lib\site-packages\foo_bar <<===>> foo_bar
$ unlink-py-dev foo_bar
Restored `C:\Users\chris\mc2-x86\envs\db-dev2\Lib\site-packages\.conda-dev\dropbot` -> `C:\Users\chris\mc2-x86\envs\db-dev2\Lib\site-packages\dropbot`
```

### PlatformIO project with Python module

From within parent directory of Python module, run:

```sh
link-pio-dev <package name> <Python module name>
```
To restore originally installed module, from within parent directory of Python
module, run:

```sh
unlink-pio-dev <package name> <Python module name>
```

For example:

```sh
$ link-pio-dev foo-bar foo_bar
Junction created for C:\Users\chris\mc2-x86\envs\db-dev2\Lib\site-packages\foo <<===>> foo
Junction created for C:\Users\chris\mc2-x86\envs\db-dev2\share\platformio\include\FooBar <<===>> lib\FooBar
Junction created for C:\Users\chris\mc2-x86\envs\db-dev2\share\platformio\include\Wire <<===>> lib\Wire
Junction created for C:\Users\chris\mc2-x86\envs\db-dev2\share\platformio\bin\foo <<===>> .pioenvs
$ unlink-pio-dev foo-bar foo_bar
Restored `C:\Users\chris\mc2-x86\envs\db-dev2\share\platformio\include\.conda-dev\FooBar` -> `C:\Users\chris\mc2-x86\envs\db-dev2\share\platformio\include\FooBar`
Restored `C:\Users\chris\mc2-x86\envs\db-dev2\share\platformio\include\.conda-dev\FIFO` -> `C:\Users\chris\mc2-x86\envs\db-dev2\share\platformio\include\FIFO`
Restored `C:\Users\chris\mc2-x86\envs\db-dev2\share\platformio\include\.conda-dev\Wire` -> `C:\Users\chris\mc2-x86\envs\db-dev2\share\platformio\include\Wire`
Restored `C:\Users\chris\mc2-x86\envs\db-dev2\share\platformio\bin\.conda-env\foo-bar` -> `C:\Users\chris\mc2-x86\envs\db-dev2\share\platformio\bin\foo-bar`
Restored `C:\Users\chris\mc2-x86\envs\db-dev2\Lib\site-packages\.conda-dev\foo_bar` -> `C:\Users\chris\mc2-x86\envs\db-dev2\Lib\site-packages\foo_bar`
```

-------------------------------------------------------------------------------

How it works
------------

For each relevant Conda environment directory, the scripts create a
`.conda-dev` subdirectory.  When **linking**, the directory containing the
installed files is moved to into the corresponding `.conda-dev` subdirectory,
and the working copy directory is linked in its place.  When **unlinking**, the
directory containing the originally installed files is restored to its original
location.

-------------------------------------------------------------------------------

License
-------

This project is licensed under the terms of the [BSD license](/LICENSE.md)

-------------------------------------------------------------------------------

Contributors
------------

 - Christian Fobel ([@sci-bots](https://github.com/sci-bots))


[2]: https://conda.io/
[3]: https://github.com/sci-bots/conda-dev
[4]: https://anaconda.org/sci-bots/conda-dev

```sh
```
