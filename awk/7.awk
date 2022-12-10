
BEGIN {
    pwd="/"
    mx_part1=100000
    p2_target=40000000
}

/^\$ cd \.\./ { y=split(pwd,x,"/") ; pwd=substr(pwd,1,length(pwd)-(length(x[y-1])+1) ) ; next }
/^\$ cd / { pwd=pwd $3 "/" ; d[pwd]+=0 ; next }
/^dir / { next }
/^[0-9]/ {
    y=split(pwd,x,"/")
    for( i=(y-1) ; i>=1 ; i-- ) {
        p=""
        for( j=1 ; j<=i ; j++ ) {
            p=p x[j] "/"
        }
        d[p]+=$1
    }
    next
}

END {
    # part1
    for( i in d ) {
        if( d[i]<=mx_part1 ) {
            tot+=d[i]
            # print i " " d[i]
        }
    }
    print "part1 = " tot

    #part 2
    p2_del_size = (d["/"]-p2_target)
    del_dir="" ; del_sz=0
    for( i in d ) {
        if( d[i]>=p2_del_size ) {
            print i " " d[i]
        }
    }

}

