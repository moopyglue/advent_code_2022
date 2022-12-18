
https://adventofcode.com/2022

THIS IS AN ATTEMPT TO SEE HOW FAR I CAN GO USING JUST 'awk'
INSTEAD OF A FANCY PROGRAMMING LANGUAGE.

'awk' VERSION 1 WAS FIRST WRITTEN IN 1977 AND REMAINS ONE OF
THE MOST POWERFUL COMMAND LINES TOOLS FOR PROCESSING TEXT 
FILES IF YOU WANT TO USE THE SHELL LAYER OF UNIX INSTEAD OF 
DROPPING INTO AN ADVANCED PROGRAMMING LANGUAGE

SIMON WALL
DECEMBER 2022

============================================================




--- Day 1: Calorie Counting ---

cat 1.txt | awk 'BEGIN{x=0} $0==""{print x;x=0;next}{x=x+$1}END{print x}' | sort -n | tail -3



--- Day 2: Rock Paper Scissors ---

# part 1
sort 2.txt | awk '/A X/{x+=4} /A Y/{x+=8} /A Z/{x+=3} /B X/{x+=1} /B Y/{x+=5} /B Z/{x+=9} /C X/{x+=7} /C Y/{x+=2} /C Z/{x+=6} END{print x}' # part 1

# part 2
sort 2.txt | awk '/A X/{x+=3} /A Y/{x+=4} /A Z/{x+=8} /B X/{x+=1} /B Y/{x+=5} /B Z/{x+=9} /C X/{x+=2} /C Y/{x+=6} /C Z/{x+=7} END{print x}' # part 2



--- Day 3: Rucksack Reorganization ---

# part 1
cat 3.txt | awk '
BEGIN { checks="abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ" ; tot=0 }
{
    l=length($1) ; a=substr($1,0,l/2) ; b=substr($1,(l/2)+1)
    for(i=0;i<52;i++) {
        c=substr(checks,i+1,1)
        if( a ~ c && b ~ c ) { tot+=(i+1) ; print c " " i " " a " " b ; break }
    }
}
END{print tot}'

# part 2
cat 3.txt | awk '
BEGIN { checks="abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ" ; tot=0 }
{
    a=$1 ; getline ; b=$1 ; getline; c=$1
    print a " " b " " c
    for(i=0;i<52;i++) {
        x=substr(checks,i+1,1)
        if( a ~ x && b ~ x && c ~ x ) { tot+=(i+1) ; print x " " i  ; break }
    }
}
END{print tot}'




--- Day 4: Camp Cleanup ---

awk -F, '

{
    split($1,a,"-")
    split($2,b,"-")

    # print $0 " = " a[1] " " a[2] " x " b[1] " " b[2]

    if( (a[1]>=b[1] && a[2]<=b[2]) ||
        (a[1]<=b[1] && a[2]>=b[2])) {
        x+=1
        y+=1
        print "p1=" x " p2=" y
        next
    }

    if( (a[1]>=b[1] && a[1]<=b[2]) ||
        (a[2]>=b[1] && a[2]<=b[2]) ||
        (b[1]>=a[1] && b[1]<=a[2]) ||
        (b[2]>=a[1] && b[2]<=a[2]) ) {
        y+=1
        print "p1=" x " p2=" y
        next
    }
}
'



--- Day 5: Supply Stacks ---

# part 1
awk '

$1=="=" { cols+=1 ; dock[cols]=$2 }

$1=="move" {
    print "" ; print
    for( j=1 ; j<=cols ; j++ ) { print j ":" dock[j] }
    for( i=$2 ; i>0 ; i-- ) {
        dock[$6] = dock[$6] substr(dock[$4],length(dock[$4]),1)
        dock[$4] = substr(dock[$4],1,length(dock[$4])-1)
        for( j=1 ; j<=cols ; j++ ) { print j ":" dock[j] }
    }

}

'

# part 2
awk '

$1=="=" { cols+=1 ; dock[cols]=$2 }

$1=="move" {
    print "" ; print
    for( j=1 ; j<=cols ; j++ ) { print j ":" dock[j] }
    dock[$6] = dock[$6] substr(dock[$4],length(dock[$4])-($2-1),$2)
    dock[$4] = substr(dock[$4],1,length(dock[$4])-$2)
    for( j=1 ; j<=cols ; j++ ) { print j ":" dock[j] }

}

'



--- Day 6: Tuning Trouble ---

::::::::::::::
6.awk
::::::::::::::

{
	s=$1
	printf("%s... ",substr(s,1,10))
    for( sz=4;sz<15;sz+=10 ) {
	    for(i=1;i<length(s);i++){
		    nextchar=0
		    for(a=0;a<(sz-1);a++) {
			    for(b=(a+1);b<sz;b++) {
				    if( substr(s,i+a,1)==substr(s,i+b,1) ) nextchar=1
				    if( nextchar==1 ) break
			    }
			    if( nextchar==1 ) break
		    }
		    if( nextchar==1 ) continue
            printf("sz=%s:%s:%s ",sz,(i+sz)-1,substr(s,i,sz) )
		    break
	    } 
    }
    print ""
}

---

$ cat 6.data | awk -f 6.awk
mjqjpqmgbl... sz=4:7:jpqm sz=14:19:qmgbljsphdztnv
bvwbjplbgv... sz=4:5:vwbj sz=14:23:vbhsrlpgdmjqwf
nppdvjthql... sz=4:6:pdvj sz=14:23:ldpwncqszvftbr
nznrnfrfnt... sz=4:10:rfnt sz=14:29:wmzdfjlvtqnbhc
zcfzfwzzqf... sz=4:11:zqfr sz=14:26:jwzlrfnpqdbhtm
pwjwljjjvq... sz=4:1235:qrpl sz=14:3051:htcfvnmzjswldr



--- Day 7: No Space Left On Device ---

$ more *.awk | cat
::::::::::::::
7.awk
::::::::::::::

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

---

$ cat 7.data | awk -f 7.awk  | sort -k 2 -n -r | tail -2
/pcqjnl/lrrl/nwjggvr/bwmglvmt/ 1623571
part1 = 1778099



--- Day 8: Treetop Tree House ---

::::::::::::::
8.awk
::::::::::::::

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

---

$ cat 8.data | awk -f 8.awk
1823

::::::::::::::
8b.awk
::::::::::::::

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

---

$ cat 8.data | awk -f 8b.awk
211680



--- Day 9: Rope Bridge ---

::::::::::::::
9.awk
::::::::::::::

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

---

$ cat 9.data | awk -f 9.awk | tail -1
part1=6236 part2=2449



--- Day 10: Cathode-Ray Tube ---

::::::::::::::
10.awk
::::::::::::::

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

---

$ cat 10.data | awk -f 10.awk
20=420 60=1020 100=2100 140=2380 180=3780 220=4620
part1 = 14320

part2 =
XXX   XX  XXX  XXX  X  X  XX  XXX    XX
X  X X  X X  X X  X X X  X  X X  X    X
X  X X    X  X XXX  XX   X  X X  X    X
XXX  X    XXX  X  X X X  XXXX XXX     X
X    X  X X    X  X X X  X  X X    X  X
X     XX  X    XXX  X  X X  X X     XX



--- Day 11: Monkey in the Middle ---

::::::::::::::
10.awk
::::::::::::::

function join (array, sep, result, i)
{
    for( i in array ) { result = result sep array[i] } 
    result=substr(result,length(sep)+1)
    return result
}

BEGIN {
    RS="" ; FS="\n"
    if( loop == "" ) loop=1  # loop is 1 unless prvided asa variable
    if( divs=="" ) divs=1    # divs is 1 unless prvided asa variable
    if( crop=="" ) crop=="no"
    maxstress=1
}

{
    # read in each record
    split($1,t1,/[ :,]+/) ; split($2,t2,/[^[0-9]+/); split($3,t3,/[ :,]+/) 
    split($4,t4,/[ :,]+/) ; split($5,t5,/[ :,]+/) ; split($6,t6,/[ :,]+/) 
    delete t2[1]
    monkey[t1[2]] = t3[6] " " t3[7] " " t4[5] " " t5[7] " " t6[7] " ," join(t2,",")

    # calculate product of all 'divisbles' to keep numbers small
    # thisis used to mudulus all results every time calculated
    # otherwise we would be dealing with intergers which are over
    # a million digits long
    maxstress*=t4[5]
}

END {

    for( l=1;l<=loop;l++ ) {

        for( i=0;i<length(monkey);i++ ) {
    
            # print "MONKEY: " monkey[i]
            split(monkey[i],a," ")
            split(a[6],b,",")
            for( j=2;j<=length(b);j++ ) {
                mcount[i]++
                val=b[j]
                op=a[2]
                if( op=="old" ) op=val
                if( a[1] == "+" ) res=val+op
                if( a[1] == "*" ) res=val*op
                res=int(res/divs)
                if( crop=="yes" ) res=res%maxstress
                if( (res % a[3]) == 0 ) { sendto=a[4] } else { sendto=a[5] }
                monkey[sendto] = monkey[sendto] "," res
                monkey[i] = a[1] " " a[2] " " a[3] " " a[4] " " a[5] " "
            }
        }

    }

    for( i=0;i<length(monkey);i++ ) {
        print "monkey " i " inspects " mcount[i] " times"
    }
    
}

---

# part 1

$ cat 11.data | awk -f 11.awk -v loop=20 -v divs=3 -v crop=no | sort -k4 -n
monkey 2 inspects 20 times
monkey 3 inspects 48 times
monkey 4 inspects 55 times
monkey 6 inspects 188 times
monkey 5 inspects 211 times
monkey 1 inspects 218 times
monkey 7 inspects 222 times
monkey 0 inspects 228 times

$ echo $(( 222 * 228 ))
50616

# part 2 

$ cat 11.data | awk -f 11.awk -v loop=10000 -v divs=1 -v crop=yes | sort -k4 -n
monkey 3 inspects 16402 times
monkey 2 inspects 49031 times
monkey 5 inspects 65512 times
monkey 7 inspects 81799 times
monkey 1 inspects 98133 times
monkey 6 inspects 98135 times
monkey 4 inspects 106342 times
monkey 0 inspects 106346 times

$ echo $(( 106342 * 106346 ))
11309046332



--- Day 12: Hill Climbing Algorithm ---

::::::::::::::
12.awk
::::::::::::::

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



::::::::::::::
12b.awk
::::::::::::::
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

--

$ cat 12.data | awk -f 12.awk
begin 1:21 end 138:21 part1  437

$ bash ./12b.awk
part2 = 430



--- Day 13: Distress Signal ---


::::::::::::::
13.awk
::::::::::::::

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

--

$ time cat 13.data | awk -f 13.awk 
part1=6187
part2=23520

real    0m14.124s
user    0m5.283s
sys     0m8.835s



--- Day 14: Regolith Reservoir ---

::::::::::::::
14.awk
::::::::::::::

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

::::::::::::::
14b.awk
::::::::::::::

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
    bottom+=1
    keepgoing=1
    while( keepgoing ) {
        sandx=500
        for(sandy=0;sandy<=bottom;sandy++) {
            if( sandy==bottom ) { plot(sandx,sandy,"o") ; sand_at_rest++ ; break }
            if( cave[sandx,sandy+1]=="" ) { continue }
            if( cave[sandx-1,sandy+1]=="" ) { sandx-- ; continue }
            if( cave[sandx+1,sandy+1]=="" ) { sandx++ ; continue }
            plot(sandx,sandy,"o")
            sand_at_rest++
            if( sandy==0 ) { keepgoing=0 }
            break
        }

    }

    #for(j in cave) {
    #    n=split(j,t,"<")
    #    if( right<t[1] )  right=t[1]
    #    if( left>t[1] )   left=t[1]
    #}
    #for(y=0;y<=bottom+1;y++ ) {
    #    for(x=left-2;x<=right+2;x++ ) {
    #        if( y>bottom ) { printf "#" ; continue }
    #        if( cave[x,y]=="" ) printf "."
    #        else printf cave[x,y]
    #    }
    #    print ""
    #}
    print "part2="sand_at_rest
}

--

$ cat 14.data | awk -f 14.awk
part1=838

$ cat 14.data | awk -f 14b.awk
part2=27539

