/* vi: set sw=4 ts=4: */
/*
 * Mini autologin implementation for busybox
 *
 * Licensed under GPLv2 or later, see file LICENSE in this source tree.
 */

//usage:#define autologin_trivial_usage
//usage:#define autologin_full_usage "\n\n"

#include "libbb.h"
#include <syslog.h>


#include <unistd.h>
#include <stdio.h>
int autologin_main(int argc, char **argv) MAIN_EXTERNALLY_VISIBLE;
int autologin_main(int argc UNUSED_PARAM, char **argv)
{
       int nrv = 0;
       FILE* fptr = 0;
       char user[64];
       // clear buffer
       memset(user,'\0',64);

       // open autologin profile file
       fptr = fopen("/usr/autologin.profile\0","r\0");

       // make sure the file exists and was opened
       if (fptr != 0)
       {
               // the return value from fscanf will be 1 if the autologin profile name is read correctly
               nrv = fscanf(fptr,"%s\0",user);
       }

       // only autologin if the profile name was read successfully,
       // otherwise show the regular login prompt
       if (nrv > 0)
               nrv = execlp("login\0","login\0","-f\0",user,0);
       else
               nrv = execlp("login\0","login\0","\0",0,0);

       return 0;
}
