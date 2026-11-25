![Build Status](https://github.com/juniors90/QGNAG/actions/workflows/CI.yml/badge.svg)
![Docs Status](https://github.com/juniors90/QGNAG/actions/workflows/docs.yml/badge.svg)
[![codecov](https://codecov.io/gh/juniors90/QGNAG/graph/badge.svg?token=FWGGKQ46IC)](https://codecov.io/gh/juniors90/QGNAG)
[![issues](https://img.shields.io/github/issues/juniors90/QGNAG?color=teal)](https://github.com/juniors90/QGNAG/issues)
[![GitHub contributors](https://img.shields.io/github/contributors/juniors90/QGNAG?color=green)](https://github.com/juniors90/QGNAG/graphs/contributors)
[![Forks](https://img.shields.io/github/forks/juniors90/QGNAG)](https://github.com/juniors90/QGNAG/stargazers)
[![star](https://img.shields.io/github/stars/juniors90/QGNAG?color=yellow)](https://github.com/juniors90/QGNAG/network/members)

# The GAP package QGNAG

TODO: add a description of your package; perhaps also instructions how how to
install and use it, resp. where to find out more


## GAP files

All the GAP files used for our computations are stored in [https://github.com/juniors90/QGNAG/tree/main/gap](https://github.com/juniors90/QGNAG/tree/main/gap), together with the corresponding documentation.
The most relevant ones are

- \com{affinedouble.gi}: computes the Gr\"obner basis for the Nichols algebra $\B(\Aff(4,\omega),-1)$. 
- \com{fusion.gi}: computes the fusion rules of the simple $\Dd$-modules $\lambda\in\Lambda$.
- \com{socle.gi}: defines the Verma module $\V(\lambda)$ and computes the socle $\Ss(\lambda)\subset \V(\lambda)$. 
	It also calculates $\dim \Ss(\lambda)$, determines the characters $\car\Ss(\lambda)$ and defines the top-to-bottom permutation $\p\colon\Lambda\to\Lambda$. It also computes its Hilbert series $\tilde{\H}(\lambda)$ and checks whether it is palindromic.
- \com{quantumpols.gi}: expresses the Verma characters $\car\V(\mu)$ in terms of the irreducible characters $\car\L(\lambda)$, $\lambda,\mu\in\Lambda$. It also inverts this relation expressing $\car\L(\lambda)$ as a combination of the $\car\V(\mu)$.
- \com{braided.gi}: checks if $\p$ is compatible with the fusion rules in $\Rep\Dd$.
- \com{blocks.gi}: defines an equivalence relation between the weights and splits the category $\Rep\D$ into blocks.


## Contributors

Credits goes to these peoples:

<a href="https://github.com/juniors90/QGNAG/graphs/contributors">
  <img src="https://contrib.rocks/image?repo=juniors90/QGNAG" />
</a>


https://hub.bids.mybinder.org/user/juniors90-qgnag-sci7ht3s/notebooks/qgnag/examples/TETRAHEDRON/KAZHDANLUSZTIG/unified/Kazhdan-Lusztig_unificado.ipynb

https://mybinder.org/v2/gh/juniors90/QGNAG/HEAD?urlpath=notebooks%2Fqgnag%2Fexamples%2FTETRAHEDRON%2FKAZHDANLUSZTIG%2Funified%2FKazhdan-Lusztig_unificado.ipynb


## License

TODO: Provide information on the license of your package. A license is
important as it determines who has a right to distribute your package. The
"default" license to consider is GNU General Public License v2 or later, as
that is the license of GAP itself.


