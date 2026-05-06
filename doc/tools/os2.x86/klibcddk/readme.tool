The kLibC trunk headers for getting at include/os2ddk/ ones.

Created like this:
    svn export https://svn.netlabs.org/repos/libc/trunk/libc/include -r 3951
    copy doc\tools\os2.x86\klibcddk\readme.tool
    zip -r9X ../os2.x86.klibcddk.r3951.zip .

