. non_x86_arch_inc_*.env

if [ "$1" = -u  ]
then
  if [ -d arch ]
  then
    echo "move all archs into the kernel tree"
    for d in $ARCHS
    do
      mv arch/$d linux/arch
    done
    rmdir arch
    for d in $INCARCHS
    do
      mv include/$d linux/include
    done
    rmdir include
  else
    echo "arch not moved out of source tree yet, try without -u option"
    exit 1
  fi
else
  if [ ! -d arch ]
  then
    echo "move non x86 architectures code out of kernel tree"
    mkdir  arch
    mkdir  include
    for d in $ARCHS
    do
      mv linux/arch/$d arch
    done

    for d in $INCARCHS
    do
      mv linux/include/$d include
    done
  else
    echo "arch seems to be moved out of source tree already, try -u option to undo"
    exit 1
  fi
fi

