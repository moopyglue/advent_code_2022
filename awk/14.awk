
function sign(x) { if( x==0 ) return 0 ; if( x>0 ) return 1 ; return -1 }
function plot(x,y,v) { cave[x,y]=v }

BEGIN { FS=" -> " }

{ 
    # read in the data into a cave map cave[]

    for(i=1;i<=NF;i++) {
        split($i,a,",")
        if( right==""  || right<a[1] )  right=a[1]
        if( bottom=="" || bottom<a[2] ) bottom=a[2]
        if( left==""   || left>a[1] )   left=a[1]
    }
    for(i=1;i<NF;i++) {
        split($i,a,",")
        split($(i+1),b,",")
        plotx=a[1] ; ploty=a[2]
        while( plotx!=b[1] || ploty!=b[2] ) {
            plot(plotx,ploty,"#")
            plotx+=sign(b[1]-a[1])
            ploty+=sign(b[2]-a[2])
        }
        plot(plotx,ploty,"#")
            
    }
}

END {
    keepgoing=1
    while( keepgoing ) {
        sandx=500 
        for(sandy=0;sandy<=bottom;sandy++) {
            if( sandy==bottom ) { keepgoing=0 ; break }
            if( cave[sandx,sandy+1]=="" ) { continue }
            if( cave[sandx-1,sandy+1]=="" ) { sandx-- ; continue }
            if( cave[sandx+1,sandy+1]=="" ) { sandx++ ; continue }
            plot(sandx,sandy,"o")
            sand_at_rest++
            break
        }

    }
    #for(y=0;y<=bottom;y++ ) {
    #    for(x=left;x<=right;x++ ) { 
    #        if( cave[x,y]=="" ) printf "." 
    #        else printf cave[x,y]
    #    }
    #    print ""
    #}
    print "part1=" sand_at_rest
}

