
BEGIN {
    knots=10
    for( i=1;i<=knots;i++ ) { kx[i]=1 ; ky[i]=1 }
}

{ print }
{
    for( i=1;i<=$2;i++ ) {

        # move head
        if( $1=="U" ) ky[1]+=1
        if( $1=="D" ) ky[1]-=1
        if( $1=="L" ) kx[1]-=1
        if( $1=="R" ) kx[1]+=1
      
        # follow head
        for( s=1 ; s<knots ; s++ ) { 

            if( (kx[s]-kx[s+1])>1 || (ky[s]-ky[s+1])>1 || (kx[s]-kx[s+1])<-1 || (ky[s]-ky[s+1])<-1 ) {
                if( kx[s]>kx[s+1] ) kx[s+1]+=1
                if( ky[s]>ky[s+1] ) ky[s+1]+=1
                if( kx[s]<kx[s+1] ) kx[s+1]-=1
                if( ky[s]<ky[s+1] ) ky[s+1]-=1
            }
        }
        part1[kx[2],ky[2]]="X"   
        part2[kx[10],ky[10]]="X" 

        for( j=1 ; j<=length(kx) ; j++ ) { printf("%s:%s,%s  ",j,kx[j],ky[j]) }
        print ""
    }
}

END { print "part1=" length(part1) " part2=" length(part2) }

