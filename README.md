# Coccinelle Scripts for Wine

My coccinelle scripts for the use on the Wine source code.
Some of the scripts are generic.

## Getting Started

Some basic knowledge of coccinelle is assumed.
If not please see http://coccinelle.lip6.fr/documentation.php

Some of the scripts will need at times a bleeding edge coccinelle.
Please try first the latest coccinelle from git (https://github.com/coccinelle/coccinelle)
before reporting parse errors for scripts (spatch --parse-cocci <script.cocci>).

### Configuration

If you want to use the Makefile you'll have to change the
```
WINESRC = /home/michi/work/wine
```
to point to your Wine source git tree.

### Usage

Using the Makefile for a "script.cocci" file run:
```
# diff generation
make script.diff
# report mode
make script.out
```

Using coccicheck directly:
```
./coccicheck script.cocci path_to_wine_source/dir_or_file
```

## Author

**Michael Stefaniuc** [mstefani](https://github.com/mstefani)

## License

This project is licensed under the LGPLv2 License - see the [LICENSE](LICENSE) file for details.
The license was chosen to match that of Wine, but I'm open to relicense some files if there's a need for it.
