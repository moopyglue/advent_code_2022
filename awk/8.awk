
BEGIN {
    RED="\033[01;31m"
    CLEAR="\033[01;00m"
}

{
    sz=length($1)
    for( i=1 ; i<=sz ; i++ ) {
        d[NR,i]=substr($1,i,1)+0
    }
}

END {
    hidden=0
    for(a=1;a<=sz;a++) {
        for(b=1;b<=sz;b++) {

            uv=1 ; dv=1 ; lv=1 ; rv=1
            for(s=1;s<=sz;s++) {
                if( dv==1 ) {
                    if( a+s>sz )             { break }
                    if( d[a+s,b] >= d[a,b] ) { dv=0 }
                }
                if( uv==1 ) {
                    if( a-s<1 )              { break }
                    if( d[a-s,b] >= d[a,b] ) { uv=0 }
                }
                if( rv==1 ) {
                    if( b+s>sz )             { break }
                    if( d[a,b+s] >= d[a,b] ) { rv=0 }
                }
                if( lv==1 ) {
                    if( b-s<1 )              { break }
                    if( d[a,b-s] >= d[a,b] ) { lv=0 }
                }
                if( uv+dv+lv+rv == 0 ) { hidden+=1 ; d2[a,b]="X" ; break }
            }

        }
    }

    print (sz*sz)-hidden
}
