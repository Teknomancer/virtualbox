OS/2 DDK base & video headers, libs, ++ from the February 2004 version.

Assuming the source is IBMDDKit-2004.zip (md5: 71704f1f917598cd57bfc9b0207f70db)
from https://archive.org/details/IBMDDKit2004, this tools package contains the
unzipped DDK\ZIP\COMBASE.ZIP (md5: 2c8117df6c2e31ff5042dc65a492897d) and
DDK\ZIP\COMVIDEO.ZIP (md5: f6002457df1ad46ba5d2ee2d9e1e3d98) with the addition
of doc\tools\os2.x86\ddk\readme.tool (this file).

The following directories was removed to save a little space:
        DDK/video/rel/os2c/retail
        DDK/video/tools

Zipped up like this:
        zip -r9X ../os2.x86.ddk.200402-base.zip .
