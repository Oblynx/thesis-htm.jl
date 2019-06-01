N= 2000_000
w= 2000
wh= 30
th= 20

lazybinom(n,k)= begin
  (k==0 || k==n) && return (1,1)
  k > n-k ?
    (k+1:n, 1:(n-k)) :
    (n-k+1:n, 1:k)
end
reducebinom(num,den,prec=20)=
  prod(BigFloat.(num, precision=prec)) / prod(BigFloat.(den,precision=prec))
binom(n,k)= reducebinom(lazybinom(n,k)...)

ovp_set= sum( binom.(wh,th:wh) .* binom.(N-wh, wh.-(th:wh)) )
space_size= binom(N,w)
p= ovp_set / space_size
