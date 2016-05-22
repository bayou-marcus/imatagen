# Imatagen

An OS X-only, command-line utility which inspects a directory for specified image types and adds Finder tags which describe their width dimension (ex: "Width: 1501-2000").

## Usage

Run without any parameters, by default Imatagen will tag .jpg, .jpeg, and .png files in the current user's home Pictures directory.  Full configuration choices include...

    Usage: imatagen [options]
    Options:
      -d, --directory=<s>    Search directory (default: /Users/<Your Home Directory>/Pictures)
      -r, --recurse          Recurse directory during search
      -f, --formats=<s+>     Formats (default: .jpg, .jpeg, .png)
      -t, --tag, --no-tag    Add width tags (default: true)
      -u, --untag            Remove all tags
      -v, --verbose          Use verbose mode
      -y, --dryrun           No alterations, verbose output
      -l, --log              Show last session's log
      -e, --version          Print version and exit
      -h, --help             Show this message

## Dependencies

Imatagen is a healthy part glue, with heavy lifting courtesy of the OS X `sips` and `xattr` utilities. [Trollop](https://github.com/ManageIQ/trollop) also lends a hand.
