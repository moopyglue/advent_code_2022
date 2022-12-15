#!bin/bash

cat 12.data | awk '

# Read in MAP data
{
    for( i=1;i<=length($1);i++ ) {
        if( substr($1,i,1) == "a" ) {
            print "cat 12.data | awk -v start="i":"NR " -f 12.awk"
        }
    }
}

' | bash |
awk '
    BEGIN{x=999}
    NF==6{if(x>$6)x=$6}
    END{print "part2 = "x}
'

