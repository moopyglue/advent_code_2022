
function isnum(i) {
    if( i ~ /^[0-9]+/ ) return 1
    return 0
}

function packet_compare(a,b) {
    
    while( length(a)>0 || length(b)>0 ) {

        anext=substr(a,1,1) 
        if( isnum(a) ) anext=int(a)
        a=substr(a,length(anext)+1)
        
        bnext=substr(b,1,1) 
        if( isnum(b) ) bnext=int(b)
        b=substr(b,length(bnext)+1)

        if( isnum(anext) && bnext=="[" ) { a=anext"]"a ; anext="[" }
        if( isnum(bnext) && anext=="[" ) { b=bnext"]"b ; bnext="[" }

        aout=aout anext 
        bout=bout bnext 

        if( anext==bnext ) continue

        if( isnum(anext) && isnum(bnext) ) {
            if( anext>bnext ) return 0
            if( anext<bnext ) return 1
        }

        if( anext="]" && bnext=="," ) return 1
        if( anext="," && bnext=="]" ) return 0
        
        if( isnum(anext) ) return 1
        if( isnum(bnext) ) return 0

        if( anext=="]" ) return 1
        if( bnext=="]" ) return 0
    }

    return 1
}

BEGIN { as="" ; bs="" ; cnt=0 ; tot=0 }

as=="" {
    as=$0 ; next
}
bs=="" {
    bs=$0 ; cnt++
    list[(cnt*2)-1]=as
    list[(cnt*2)]=bs
    if( packet_compare(as,bs) ) tot+=cnt
    as="" ; bs=""
} 

END {
    print "part1=" tot

    list[length(list)+1]="[[2]]"
    list[length(list)+1]="[[6]]"

    for( x=1;x<=length(list);x++ ) {
        for( y=x+1;y<=length(list);y++ ) {
            if( packet_compare(list[x],list[y]) ) continue
            tmp=list[x]
            list[x]=list[y]
            list[y]=tmp
        }
    }
    for( i=1;i<=length(list);i++ ) {
        if( list[i]=="[[2]]" ) part2=i
        if( list[i]=="[[6]]" ) part2=part2*i
    }
    print "part2=" part2
}
