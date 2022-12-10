
BEGIN { x=1 ; cycle=1 }

$1 == "addx" {
    t[cycle]=x ; cycle++
    t[cycle]=x ; cycle++
    x+=$2
}
$1 == "noop" {
    t[cycle]=x ; cycle++
}

END { 
    for( a=0;a<6;a++ ) {
        printf " > "
        for( b=0;b<40;b++ ) {
            cycle=((a*40)+b)+1
            x=t[cycle]
            if( b==x || b==x+1 || b==x-1 ) { printf "X" }
            else { printf " " }
        }
        print " < "
    }
}

