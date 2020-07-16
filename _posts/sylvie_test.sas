%let phi=0.5;
%let gamma=0.8;
%let beta=1;
%let nobs=10;

data one(keep=time y);
      xlag = 0.5;
      call streaminit(1234);
      do time = 1 to &nobs;
         eps = normal(1);
         x = &phi*xlag + &gamma*eps;
         eta = normal(1);
         y = &beta*exp(x/2)*eta;
         output;
         xlag = x;
      end;
   run;
%casdist(dsin=one, libin=work);


%let seed=1234;
%let N=1000;

proc smc data=sascas1.one seed = &seed nthreads = 1;
   id time = time;
   var y;
   statevar x;
   parameters phi = &phi gamma_sq = 0.64 beta_sq = 1;
   initstate x.L1 ~ degenerate(0.5);
   initstate x ~ normal(0, sqrt(gamma_sq/(1-phi**2)) ) ;
   state x ~ normal(x.l1*phi, sqrt(gamma_sq));
   model y ~ normal(0, sqrt(beta_sq)*exp(x/2));
   filter nparticle = &N algorithm=BF outsim=sascas1.simfi
              out=sascas1.outfi;
run;

%let phi=0.5;
%let gamma=0.4;
%let beta=1;


proc iml;

*Module sampinitp: sample from the distribution of the initial state: initstate x ~ normal(0, sqrt(gamma_sq/(1-phi**2)) )  *;
start sampinitp(y);
   var_initial = &gamma**2/(1-&phi**2);
   call randgen(rn,"Normal");
   x = sqrt(var_initial)*rn;
return(x);
finish sampinitp;

*Module evalmeas: log(pdf) of the current observation y[t] given current state x[t]: model y ~ normal(0, sqrt(beta_sq)*exp(x/2))*;
start evalmeas(x, y) ;
   var_observe = (&beta**2)*exp(x[1]);
   ll= -(y[1]**2)/(2*var_observe) -
         log( sqrt(2*constant("pi")*var_observe));
return(ll) ;
finish evalmeas;

*Module samptranp: sample from the pdf of current state given past state : state x ~ normal(x.l1*phi, sqrt(gamma_sq))*;
start samptranp(xprev, y);
   call randgen(rn,"Normal");
   x = xprev[1]*&phi+&gamma*rn;
return(x) ;
finish samptranp;

**Module stratified_sample;
   *using stratified re-sampling method *; 
   * ww is the probabilities, row vector, sum = 1*;  
   *k is the size of number*;
   *the last weight is set to be 1 so that it guarantee the index of weight will not go beyond its size*;
   *the reason is that the sum of weight array may be a litter smaller than 1 due to floating error*;
start stratified_sample(ww, k ,seed);
   i1 = 1;
   i2 = 1;
   count1 = ncol(ww);
   count2 = k;
   seed_all = J(k,1,seed);
   u = uniform(seed_all);
   cw = ww[i1];
   last_w = ww[count1];
   ww[count1] = 1; *set to 1 just in case*;
   z = J(1,count2,0);
   do i2 = 1 to k;
     do while (cw < ((i2-1+u[i2])/count2));
         i1 = i1+1;
         cw = cw + ww[i1];
     end;
     z[i2] = i1;
   end;
   ww[count1]=last_w;
   return (z);
finish stratified_sample;

call randseed(&seed);
use one var _all_;
read all var {time y};
NT=nrow(y);


x = j(&N,NT, 0);*particles;
A=j(&N,NT, 0);*ancestor Indices;
w=j(&N,NT, 1);*weights;
wn=j(&N,NT, 1/&N);  *normalised Weights ;
TimeID=j(NT*&N,1,0);
ParticleID=j(NT*&N,1,0);
Weight_iml=j(NT*&N,1,0);
State_1_iml=j(NT*&N,1,0);
logLikelihood = j(NT,2,.);*log of the marginal likelihood;

*t=1;
do k=1 to &N;
  x1=sampinitp(y);*simulate initial particles at t=1;
  x[k,1]=x1;
  w[k,1]=exp(evalmeas(x1, y[1]));
end;
wn[,1]=w[,1]/sum(w[,1]); 

TimeID[(1-1)*&N+1:(1*&N)]=j(&N,1,1);
ParticleID[(1-1)*&N+1:(1*&N)]=1:&N;
Weight_iml[(1-1)*&N+1:(1*&N)]=wn[,1];
State_1_iml[(1-1)*&N+1:(1*&N)]=x[,1];
logLikelihood[1,]=1||log(mean(w[,1]));

do t = 2 to NT;
    newanc=stratified_sample(wn[,(t-1)], &N, &seed);*sample index that will be stored in A[,(t-1)] and used below to select the corresponding previous x, xprev;
    A[,(t-1)]=newanc`;

    do k=1 to &N;
        xprev=x[A[k,(t-1)],(t-1)];
        xkt=samptranp(xprev, y);
        x[k,t]=xkt;
        w[k,t]=exp(evalmeas(xkt, y[t]));
    end;
    wn[,t]=w[,t]/sum(w[,t]); 

    TimeID[(t-1)*&N+1:(t*&N)]=j(&N,1,t);
    ParticleID[(t-1)*&N+1:(t*&N)]=1:&N;
    Weight_iml[(t-1)*&N+1:(t*&N)]=wn[,t];
    State_1_iml[(t-1)*&N+1:(t*&N)]=x[,t];
    llt=log(sum(w[,t]))+logLikelihood[t-1,2];
    logLikelihood[t,]=t||llt;
end; 
create simfi_iml var {TimeID ParticleID Weight_iml State_1_iml};
append ;
close simfi_iml;

cnames={"TimeID" "LogLikelihood_iml"};
create outev_iml from logLikelihood [colname=cnames];
append from logLikelihood;
close outev_iml;
quit;

proc means data=simfi_iml mean p25 p50 p75 noprint;
var state_1_iml;
weight weight_iml;
by TimeID;
output out=outfi_iml mean=Expectation_iml P25=P_1_iml P50=P_2_iml P75=P_3_iml;
run;

data outfi_iml;
  set outfi_iml;
  Median_iml=P_2_iml;
  StateID_iml=1;
drop _TYPE_ _FREQ_ ;
run;

data outfi_comb;
  merge outfi outfi_iml;
  by TimeID;
run;

proc sgplot data= outfi_comb;
series x=TimeID y=Expectation;
series x=TimeID y=Expectation_iml;
run;

proc sgplot data= outfi_comb;
series x=TimeID y=Median;
series x=TimeID y=Median_iml;
run;

proc sgplot data= outfi_comb;
series x=TimeID y=P_1;
series x=TimeID y=P_1_iml;
run;

proc sgplot data= outfi_comb;
series x=TimeID y=P_3;
series x=TimeID y=P_3_iml;
run;
