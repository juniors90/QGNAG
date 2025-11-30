BindGlobal( "ConfigSDP", rec( p := 4, m := 6 ) );

K := SmallGroup(4,2);;
H := CyclicGroup(6);;
AutK := AutomorphismGroup( K );;
AllHoms := AllHomomorphisms(H, AutK);;
T := AllHoms[5];;
G := SemidirectProduct(H, T, K);;

allPairsInG := [
    Identity(G),       #1 1           (0, 0)
    G.1,               #2 F1          (0, g)
    G.2,               #3 F2          (0, g^2)
    G.1*G.2,           #6 F1F2        (0, g^3)
    G.2^2,             #9 F2^2        (0, g^4)
    G.1*G.2^2,         #13 F1F2^2     (0, g^5) 
    G.4,               #5 F4          (1, 0)
    G.1*G.3*G.4,       #16 F4F1       (1, g)
    G.2*G.3,           #10 F2F3       (1, g^2)
    G.1*G.2*G.4,       #15 F1F2F4     (1, g^3)
    G.2^2*G.3*G.4,     #23 F2F3F2     (1, g^4)
    G.1*G.2^2*G.3,     #20 F1F2^2F3   (1, g^5)  
    G.3,               #4 F3          (w, 0)
    G.1*G.4,           #8 F1F4        (w, g)
    G.2*G.3*G.4,       #19 F3F2       (w, g^2)
    G.1*G.2*G.3,       #14 F1F2F3     (w, g^3)
    G.2^2*G.4,         #18 F2^2F4     (w, g^4)
    G.1*G.2^2*G.3*G.4, #24 F1F2F3F2   (w, g^5)
    G.3*G.4,           #12 F3F4       (w^2, 0)
    G.1*G.3,           #7 F1F3        (w^2, g)
    G.2*G.4,           #11 F2F4       (w^2, g^2)
    G.1*G.2*G.3*G.4,   #22 F1F3F2     (w^2, g^3) 
    G.2^2*G.3,         #17 F2^2F3     (w^2, g^4)
    G.1*G.2^2*G.4      #23 F1F2^2F4   (w^2, g^5)  
];;

BindConstant( "allPairsInG", allPairsInG );
