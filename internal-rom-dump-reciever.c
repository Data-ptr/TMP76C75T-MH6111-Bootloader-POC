/*# C code to recieve dumped internal ROM from MH6111/TMP76C75T
  # Jane Hacker 10, Feb 2022
  #*/
#include <stdio.h>   /* Standard input/output definitions */
#include <string.h>  /* String function definitions */
#include <unistd.h>  /* UNIX standard function definitions */
#include <fcntl.h>   /* File control definitions */
#include <errno.h>   /* Error number definitions */
#include <termios.h> /* POSIX terminal control definitions */

int fd = 0;

int open_port(void) {
  int fd; /* File descriptor for the port */

  fd = open("/dev/cu.USB", O_RDWR | O_NOCTTY | O_NDELAY);

  if(fd == -1) {
   /*
    * Could not open the port.
    */
    perror("open_port: Unable to open serial port - ");
  } else {
    fcntl(fd, F_SETFL, 0);
  }

  return fd;
}

int main() {
  fd = open_port();
  fcntl(fd, F_SETFL, 0);
  close(fd);
}
