
BEGIN {
    raw="abcdefghijklmnopqrstuvwxyz"
    for( i=1;i<=length(raw);i++ ) { lkup[substr(raw,i,1)]=i }
    if( start != "" ) { override_start=start }
      RED="\033[01;41m\033[01;37m"
    GREEN="\033[01;42m\033[01;37m"
    CLEAR="\033[01;00m"
}

# Read in MAP data
{
    for( i=1;i<=length($1);i++ ) {
        val=substr($1,i,1);
        if(val=="S") { val="a" ; start=i":"NR }
        if(val=="E") { val="z" ; end=i":"NR }
        map[i":"NR]=lkup[val]
        map2[i":"NR]=val
    }
    dx=length($0)
    dy=NR
}

END {

    if( override_start != "" ) { start=override_start }
    distsz[start]=0 ; distsrc[start]=start ; queue[start]="X" 
    printf "begin " start " end " end " part1  "

    while( length(queue)>0 ) {

        # select shortest route in queue
        mx=999999 ; target=""
        for(i in queue) { if( distsz[i]<mx ) { mx=distsz[i];target=i } }

        split(target,x,":")
        list[1]=(x[1]+1)":"(x[2]+0) ; list[2]=(x[1]-1)":"(x[2]+0)
        list[3]=(x[1]+0)":"(x[2]+1) ; list[4]=(x[1]+0)":"(x[2]-1)

        for( j=1;j<=4;j++ ) {

            #if( list[j] in map && ( map[target] == map[list[j]] || map[target]+1 == map[list[j]] || map[target]-1 == map[list[j]] ) ) {
            if( list[j] in map && map[list[j]] <= map[target]+1) {

                newsz=distsz[target]+1

                if( list[j] in distsz) {
                    if ( newsz < distsz[list[j]] ) {
                        distsz[list[j]] = newsz
                        distsrc[list[j]] = target
                        queue[list[j]] = "X"
                    } else {
                    }
                } else {
                    distsz[list[j]] = newsz
                    distsrc[list[j]] = target
                    queue[list[j]] = "X"
                }

            }
        }
        delete queue[target]
    }

    print distsz[end]
    
    if( debug != "" ) { 

        print end " " dx " " dy
        for(a=1;a<=dy;a++) {
            for(b=1;b<=dx;b++) {
                kk=b":"a
                k3=""
                if( kk in distsz) { k3=RED }
                printf("%s%s%s",k3,map2[kk],CLEAR);
            }
            print ""
        }
    }

}



