#!/bin/bash
echo "Clone Upstream Kernel Source
/usr/bin/git clone git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git /usr/src/linux-next 2> ../logs/03-build_kernel_linux_next.sh.log;
# CD to  Kernel Source and Do work
cd /usr/src/linux-next && yes "" |make oldconfig && make rpm
