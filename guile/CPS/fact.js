function fact(n, ret){
    if(n===0){
        ret(1);
    }else{
        fact(n-1, function(t0){
            ret(n* t0);
        });
    }
}
fact(5, function(n){
    console.log(n);
})

// call/cc
function callcc (f ,cc){
    f(function(x,k){ cc(x) }, cc);
}
    



