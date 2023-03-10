# Dockerized Inno Setup 6

[![docker-image](https://github.com/avalak-work/winno-setup/actions/workflows/build-image.yml/badge.svg)](https://github.com/avalak-work/winno-setup/actions/workflows/build-image.yml)

---

## Usage

Current work dir mapped to `/Data` (`Z:\Data\`)

```bash
# /usr/bin/local/iscc
iscc /?
```

```bash
 λ ./iscc.sh /?
Inno Setup 6 Command-Line Compiler
Copyright (C) 1997-2021 Jordan Russell. All rights reserved.
Portions Copyright (C) 2000-2021 Martijn Laan. All rights reserved.
Portions Copyright (C) 2001-2004 Alex Yackimoff. All rights reserved.
https://www.innosetup.com

Usage:  iscc [options] scriptfile.iss
or to read from standard input:  iscc [options] -
Options:
  /O(+|-)            Enable or disable output (overrides Output)
  /O<path>           Output files to specified path (overrides OutputDir)
  /F<filename>       Overrides OutputBaseFilename with the specified filename
  /S<name>=<command> Sets a SignTool with the specified name and command
  /Q                 Quiet compile (print error messages only)
  /Qp                Enable quiet compile while still displaying progress
  /D<name>[=<value>] Emulate #define public <name> <value>
  /$<letter>(+|-)    Emulate #pragma option -<letter>(+|-)
  /P<letter>(+|-)    Emulate #pragma parseroption -<letter>(+|-)
  /I<paths>          Emulate #pragma include <paths>
  /J<filename>       Emulate #include <filename>
  /{#<string>        Emulate #pragma inlinestart <string>
  /}<string>         Emulate #pragma inlineend <string>
  /V<number>         Emulate #pragma verboselevel <number>
  /?                 Show this help screen

Example: iscc /$c- /Pu+ "/DLic=Trial Lic.txt" /IC:\INC;D:\INC scriptfile.iss
```
