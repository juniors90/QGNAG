LogTo("/home/juandavid/Descargas/gap-4.13.1/pkg/qgnag/examples/FK3/BRAIDED/braided.log");
# %% [markdown]
# 

# %% [markdown]
# Si cada módulo tiene exactamente un *bottom*, entonces lo que tenemos es una aplicación
# $$
# f:\{1,\dots,n\}\to\{1,\dots,n\},
# $$
# donde
# $$
# f(i)=j \text{ si y solo si } bottom(M_{i})=M_{j}.
# $$
# 
# Como además cada módulo aparece exactamente una vez como bottom, entonces $f$ es una permutación y **GAP** la construye muy fácilmente.
# 
# Supongamos que guardamos

# %%
n := 8;;

# %%
ModuleData := List([1..n], i -> rec(
    top := i,
    bottom := fail
));

# %% [markdown]
# $$
# \begin{array}{|c|l|}
# \hline
# M_{1} & M(e,+) \\
# M_{2} & M(e,-) \\
# M_{3} & M(e,\rho) \\
# M_{4} & M(\sigma, +)\\
# \hline
# M_{5} & M(\sigma, -)) \\
# M_{6} & M(0,\tau_{0}) \\
# M_{7} & M(3,\tau_{1}) \\
# M_{8} & M(3,\tau_{2})\\
# \hline
# \end{array}
# $$

# %%
ModuleData[1].bottom := 1;;
ModuleData[2].bottom := 2;;
ModuleData[3].bottom := 6;;
ModuleData[4].bottom := 4;;
ModuleData[5].bottom := 5;;
ModuleData[6].bottom := 3;;
ModuleData[7].bottom := 7;;
ModuleData[8].bottom := 8;;

# %%
perm_list := List(ModuleData, x -> x.bottom);

# %%
perm_list; # [5,3,1,4,2]

# %%
sigma := PermList(perm_list);


