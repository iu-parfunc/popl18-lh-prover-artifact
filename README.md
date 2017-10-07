# Artifact for "Towards Complete Verification via SMT"

[![Docker Pulls](https://img.shields.io/docker/pulls/parfunc/popl18-lh-prover-artifact.svg)](https://hub.docker.com/r/parfunc/popl18-lh-prover-artifact/)

The paper presents how we extended Liquid Haskell 
to allow complete verification via SMTs.
You can run Liquid Haskell online, 
using a docker VM, *or* 
build it from source.
This artifact describes

- [Online Demo:](#online) How to run online the examples presented in the paper. 
- [Running Benchmarks:](#benchmarks) How to run the banchmarks of Table 1 of the paper.
- [Source Files:](#source-files) How to check the source files of the benchmarks of Table 1.



## <a name="online"></a> Online Demo


The examples presented in the paper (Sections 2 and 3) can be viewed 
and checked at the interactive, online demo links below: 


We provide interactive Liquid Haskell code for 
the examples presented in Sections 2 and 3 of the paper. 
The Liquid Haskell queries are checked by sending requests to 
the Liquid Haskell server hosted at [http://goto.ucsd.edu:8090/](http://goto.ucsd.edu:8090/).

- §2 Overview: [.html file](http://goto.ucsd.edu/~nvazou/popl18/_site/Overview.html), [.lhs source](https://raw.githubusercontent.com/ucsd-progsys/liquidhaskell/popl18/benchmarks/popl18/with_ple/Overview.lhs)
- §2.5 Laws for Lists: [.html file](http://goto.ucsd.edu/~nvazou/popl18/_site/LawsForLists.html), [.lhs source](https://raw.githubusercontent.com/ucsd-progsys/liquidhaskell/popl18/benchmarks/popl18/with_ple/LawsForLists.lhs) 
- §3.3 Natural Deduction: [.html file](http://goto.ucsd.edu/~nvazou/popl18/_site/NaturalDeduction.html), [lhs source](https://raw.githubusercontent.com/ucsd-progsys/liquidhaskell/popl18/benchmarks/popl18/with_ple/NaturalDeduction.lhs)


## <a name="benchmarks"></a> Running Benchmarks

To run the benchmarks, you can

1. Use a Docker image 
2. Install Liquid Haskell from source 


### Build Option 1: Docker 

- Please install [docker, here](https://docs.docker.com/engine/installation/).

- Then, you can run the tests:

    ```
    $ docker run -it parfunc/popl18-lh-prover-artifact
    ```

    Or open an interactive shell:

    ```
    $ docker run -it parfunc/popl18-lh-prover-artifact bash
    ```

### Build Option 2: Source 

You can install Liquid Haskell on your own machine from github. 

#### Download & Install:

1. Install `z3` from [this link](https://github.com/Z3Prover/z3/releases).

2. Install `stack` from [this link](https://docs.haskellstack.org/en/stable/README/).

3. Clone this artifact and build LiquidHaskell:

    ```
    $ git clone --recursive https://github.com/iu-parfunc/popl18-lh-prover-artifact.git 
    ```

A recursive checkout here acquires three submodules in the
`checkouts/` directory:
 
 * `liquidhaskell` - core implementation
 * `verified-instances` - benchmark code and examples
 * `lvars` - modified software related to another benchmark

You can then install Liquid Haskell on your system with:
        
```bash
$ cd checkout/liquidhaskell
$ stack install
```

Stack by default will put the binary in `~/.local/bin`, but the
`--local-bin-path` option can change this.


#### Run Benchmarks

After getting Liquid Haskell and the benchmarks via the above,
you can now run Liquid Haskell on the benchmarks.

##### Run Individual Files

Now you can run specific benchmarks in that shell, whether inside
Docker or not, e.g.  to check the files `Unification.hs` and
`Solver.hs`, do:

    stack exec -- liquid benchmarks/popl18/with_ple/Overview.lhs
    stack exec -- liquid benchmarks/popl18/with_ple/LawsForLists.lhs
    stack exec -- liquid benchmarks/popl18/with_ple/NaturalDeduction.lhs
    stack exec -- liquid benchmarks/popl18/with_ple/pos/Unification.hs
    stack exec -- liquid benchmarks/popl18/with_ple/pos/Solver.hs

##### Run All the Benchmarks of Table 1

We split the benchmarks of Table 1 to 3 categories.


1. To run the benchmarks in categories "Arithmetic", "Class-Laws", "Higher-Order", and "Functional Correctness" of Table 1 _with_ PLE _with_ and _without_ PLE, respectively, do:

    ```bash
    cd liquidhaskell
    stack test liquidhaskell --test-arguments="-p with_ple"    
    stack test liquidhaskell --test-arguments="-p without_ple"
    ```


2. To run the benchmarks in "Conc. Sets" _with_ and _without_ PLE, respectively, do:

    ```bash
    cd lvars
    make DOCKER=false TIMEIT=true PLE=true
    make DOCKER=false TIMEIT=true PLE=false
    ```

3. Finally, run the benchmarks in "n-body" & "Par. Reducers" categories, _with_ and _without_ PLE, respectively, do:

    ```bash
    cd verified-instances 
    make DOCKER=false TIMEIT=true PLE=true
    make DOCKER=false TIMEIT=true PLE=false
    ```

Each test will print a timing to the screen, corresponding to the
"Time (s)" numbers in Table 1.

If you look inside the generated `.liquid` directory alongside each
checked `.hs` file you can glean extra information.  For example,
to count the number of calls to the SMT solver, try this:

    $ grep -c check-sat ./examples/dpj/.liquid/IntegerSumReduction2.hs.smt2
    10



## Proof Size Measurements

Size measurements depend on GNU coreutils and sloccount.  Using the
Docker image is recommended.  If running from source, note that we
noticed some bugs when trying to run our scripts on Perl 5.26, so if
they don’t work, try using Perl 5.24.

To reproduce the proof sizes, do:

```
$ cd liquidhaskell
$ make count
```
```
$ cd verified-instances
$ make count
```
$ cd lvars
$ make count
```

You should see output that looks like:

```
src/Data/VerifiedEq/Instances/Sum.hs
CODE: 59
SPEC: 34
CODE + SPEC: 93
```

For each file `Foo.hs` we print:

* CODE = lines of haskell code (including proofs)
- i.e. the sum of the “Impl (l)” and “Proof (l)” columns from Table 1
(we have to partition the two by manual inspection as, after all all the motivation of the paper is that proofs are just code!)


* SPEC = lines of theorem specifications (including liquid & haskell sigs)
- i.e. the the “Spec (l)” column of Table 1



## <a name="source-files"></a>Source Files 

The source files of Benchmarks in Table 1 can be located as follows.

| Category      | _Without_ PLE Search                                                                                                                             | _With_ PLE Search                                                                                                                             |
| :---------    | :-----------------------                                                                                                                         | :--------------------                                                                                                                         |
| Arithmetic    | [Fibonacci.hs](https://raw.githubusercontent.com/ucsd-progsys/liquidhaskell/popl18/benchmarks/popl18/without_ple/pos/Fibonacci.hs)               | [Fibonacci.hs](https://raw.githubusercontent.com/ucsd-progsys/liquidhaskell/popl18/benchmarks/popl18/with_ple/pos/Fibonacci.hs)               |
|               | [Ackermann.hs](https://raw.githubusercontent.com/ucsd-progsys/liquidhaskell/popl18/benchmarks/popl18/without_ple/pos/Ackermann.hs)               | [Ackermann.hs](https://raw.githubusercontent.com/ucsd-progsys/liquidhaskell/popl18/benchmarks/popl18/with_ple/pos/Ackermann.hs)               |
| Class Laws    | [MonoidMaybe.hs](https://raw.githubusercontent.com/ucsd-progsys/liquidhaskell/popl18/benchmarks/popl18/without_ple/pos/MonoidMaybe.hs)           | [MonoidMaybe.hs](https://raw.githubusercontent.com/ucsd-progsys/liquidhaskell/popl18/benchmarks/popl18/with_ple/pos/MonoidMaybe.hs)           |
|               | [MonoidList.hs](https://raw.githubusercontent.com/ucsd-progsys/liquidhaskell/popl18/benchmarks/popl18/without_ple/pos/MonoidList.hs)             | [MonoidList.hs](https://raw.githubusercontent.com/ucsd-progsys/liquidhaskell/popl18/benchmarks/popl18/with_ple/pos/MonoidList.hs)             |
|               | [FunctorId.hs](https://raw.githubusercontent.com/ucsd-progsys/liquidhaskell/popl18/benchmarks/popl18/without_ple/pos/FunctorId.hs)               | [FunctorId.hs](https://raw.githubusercontent.com/ucsd-progsys/liquidhaskell/popl18/benchmarks/popl18/with_ple/pos/FunctorId.hs)               |
|               | [FunctorMaybe.hs](https://raw.githubusercontent.com/ucsd-progsys/liquidhaskell/popl18/benchmarks/popl18/without_ple/pos/FunctorMaybe.hs)         | [FunctorMaybe.hs](https://raw.githubusercontent.com/ucsd-progsys/liquidhaskell/popl18/benchmarks/popl18/with_ple/pos/FunctorMaybe.hs)         |
|               | [FunctorList.hs](https://raw.githubusercontent.com/ucsd-progsys/liquidhaskell/popl18/benchmarks/popl18/without_ple/pos/FunctorList.hs)           | [FunctorList.hs](https://raw.githubusercontent.com/ucsd-progsys/liquidhaskell/popl18/benchmarks/popl18/with_ple/pos/FunctorList.hs)           |
|               | [ApplicativeId.hs](https://raw.githubusercontent.com/ucsd-progsys/liquidhaskell/popl18/benchmarks/popl18/without_ple/pos/ApplicativeId.hs)       | [ApplicativeId.hs](https://raw.githubusercontent.com/ucsd-progsys/liquidhaskell/popl18/benchmarks/popl18/with_ple/pos/ApplicativeId.hs)       |
|               | [ApplicativeMaybe.hs](https://raw.githubusercontent.com/ucsd-progsys/liquidhaskell/popl18/benchmarks/popl18/without_ple/pos/ApplicativeMaybe.hs) | [ApplicativeMaybe.hs](https://raw.githubusercontent.com/ucsd-progsys/liquidhaskell/popl18/benchmarks/popl18/with_ple/pos/ApplicativeMaybe.hs) |
|               | [ApplicativeList.hs](https://raw.githubusercontent.com/ucsd-progsys/liquidhaskell/popl18/benchmarks/popl18/without_ple/pos/ApplicativeList.hs)   | [ApplicativeList.hs](https://raw.githubusercontent.com/ucsd-progsys/liquidhaskell/popl18/benchmarks/popl18/with_ple/pos/ApplicativeList.hs)   |
|               | [MonadId.hs](https://raw.githubusercontent.com/ucsd-progsys/liquidhaskell/popl18/benchmarks/popl18/without_ple/pos/MonadId.hs)                   | [MonadId.hs](https://raw.githubusercontent.com/ucsd-progsys/liquidhaskell/popl18/benchmarks/popl18/with_ple/pos/MonadId.hs)                   |
|               | [MonadMaybe.hs](https://raw.githubusercontent.com/ucsd-progsys/liquidhaskell/popl18/benchmarks/popl18/without_ple/pos/MonadMaybe.hs)             | [MonadMaybe.hs](https://raw.githubusercontent.com/ucsd-progsys/liquidhaskell/popl18/benchmarks/popl18/with_ple/pos/MonadMaybe.hs)             |
|               | [MonadList.hs](https://raw.githubusercontent.com/ucsd-progsys/liquidhaskell/popl18/benchmarks/popl18/without_ple/pos/MonadList.hs)               | [MonadList.hs](https://raw.githubusercontent.com/ucsd-progsys/liquidhaskell/popl18/benchmarks/popl18/with_ple/pos/MonadList.hs)               |
| Higher-Order  | [FoldrUniversal.hs](https://raw.githubusercontent.com/ucsd-progsys/liquidhaskell/popl18/benchmarks/popl18/without_ple/pos/FoldrUniversal.hs)     | [FoldrUniversal.hs](https://raw.githubusercontent.com/ucsd-progsys/liquidhaskell/popl18/benchmarks/popl18/with_ple/pos/FoldrUniversal.hs)     |
|               | [NaturalDeduction.hs](https://raw.githubusercontent.com/ucsd-progsys/liquidhaskell/popl18/benchmarks/popl18/without_ple/pos/NaturalDeduction.hs) | [NaturalDeduction.hs](https://raw.githubusercontent.com/ucsd-progsys/liquidhaskell/popl18/benchmarks/popl18/with_ple/pos/NaturalDeduction.hs) |
| Func. Correct | [Solver.hs](https://raw.githubusercontent.com/ucsd-progsys/liquidhaskell/popl18/benchmarks/popl18/without_ple/pos/Solver.hs)                     | [Solver.hs](https://raw.githubusercontent.com/ucsd-progsys/liquidhaskell/popl18/benchmarks/popl18/with_ple/pos/Solver.hs)                     |
|               | [Unification.hs](https://raw.githubusercontent.com/ucsd-progsys/liquidhaskell/popl18/benchmarks/popl18/without_ple/pos/Unification.hs)           | [Unification.hs](https://raw.githubusercontent.com/ucsd-progsys/liquidhaskell/popl18/benchmarks/popl18/with_ple/pos/Unification.hs)           |
| Conc-Sets     | [SumNoPLE.hs](https://raw.githubusercontent.com/iu-parfunc/lvars/popl18/src/lvish/tests/verified/SumNoPLE.hs)                                    | [Sum.hs](https://raw.githubusercontent.com/iu-parfunc/lvars/popl18/src/lvish/tests/verified/Sum.hs)                                           |
| N-Body        | [allpairs_verifiedNoPLE.hs](https://raw.githubusercontent.com/iu-parfunc/verified-instances/popl18/examples/nbody/allpairs_verifiedNoPLE.hs)     | [allpairs_verified.hs](https://raw.githubusercontent.com/iu-parfunc/verified-instances/popl18/examples/nbody/allpairs_verified.hs)            |
| Par-Reducers  | [IntegerSumReduction2NoPLE.hs](https://raw.githubusercontent.com/iu-parfunc/verified-instances/popl18/examples/dpj/IntegerSumReduction2NoPLE.hs) | [IntegerSumReduction2.hs](https://raw.githubusercontent.com/iu-parfunc/verified-instances/popl18/examples/dpj/IntegerSumReduction2.hs)        |
