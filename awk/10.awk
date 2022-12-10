
BEGIN { x=1 ; cycle=1 ; list="20,60,100,140,180,220" }

$1 == "addx" { t[cycle]=x ; cycle++ ; t[cycle]=x ; cycle++ ; x+=$2 }
$1 == "noop" { t[cycle]=x ; cycle++ }

END { 
    n=split(list,res,",")
    for( i=1;i<=n;i++ ){
        printf("%s ",res[i] "=" t[res[i]] * res[i])
        tot+=t[res[i]]*res[i]
    }
    print "\npart1 = " tot

    print "\npart2 = " 
    for( a=0;a<6;a++ ) {
        for( b=0;b<40;b++ ) {
            cycle=((a*40)+b)+1
            x=t[cycle]
            if( b==x || b==x+1 || b==x-1 ) { printf "X" }
            else { printf " " }
        }
        print ""
    }
}

