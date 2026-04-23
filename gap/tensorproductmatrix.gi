

##############################################################################
##
##  TensorProductMatrix( A, B )  . . .  Tensor product of two matrices
##
##  This function computes the tensor (Kronecker) product of the matrices A and B.
##  It is intended as a faster alternative to GAP's built-in `KroneckerProduct`,
##  which in practical experiments has shown significantly slower performance.
##  For example, benchmarking with two 60×60 matrices shows that the native
##  command takes approximately twice as long as this implementation.
##
##  The resulting matrix has size (m*k) × (n*l), where A is an m×n matrix
##  and B is a k×l matrix. Each entry aᵢⱼ of A is multiplied by the whole matrix B,
##  and the resulting blocks are concatenated in the standard Kronecker product order.
##
##############################################################################

InstallGlobalFunction( TensorProductMatrix, function(A,B)
    local u, v, matrix;
    matrix:=[];
    for u in A do
        for v in B do
            Add(matrix,Flat(List(u,x->x*v)));
        od;
    od;
    return(matrix);
end );

InstallGlobalFunction(GetDimensions, function(M)
    if not IsList(M) then
        Error("The argument is not a list (matrix in GAP).");
    fi;

    if Length(M) = 0 then
        return [0, 0];
    fi;

    if not IsList(M[1]) then
        Error("The object does not have matrix form (list of lists).");
    fi;

    return [ Length(M), Length(M[1]) ];
end );