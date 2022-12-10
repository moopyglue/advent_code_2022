
{
    sz=length($1)
    for( i=1 ; i<=sz ; i++ ) {
        d[NR,i]=substr($1,i,1)+0
    }
}

END {
    max_score=0
    for(a=1;a<=sz;a++) {
        for(b=1;b<=sz;b++) {

            uv=0 ; dv=0 ; lv=0 ; rv=0
            for(s=1;s<=sz;s++) {
                if( a+s>sz )             { break }
                dv=s
                if( d[a+s,b] >= d[a,b] ) { break }
            }
            for(s=1;s<=sz;s++) {
                if( a-s<1 )             { break }
                uv=s
                if( d[a-s,b] >= d[a,b] ) { break }
            }
            for(s=1;s<=sz;s++) {
                if( b+s>sz )             { break }
                rv=s
                if( d[a,b+s] >= d[a,b] ) { break }
            }
            for(s=1;s<=sz;s++) {
                if( b-s<1 )             { break }
                lv=s
                if( d[a,b-s] >= d[a,b] ) { break }
            }
            score=uv*dv*lv*rv
            if( score>max_score ) max_score=score

        }
    }

    print max_score
}
