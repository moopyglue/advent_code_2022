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
