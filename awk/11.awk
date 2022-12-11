
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
