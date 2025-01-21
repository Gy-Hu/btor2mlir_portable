# btor2mlir_portable

Adapt from `https://github.com/jetafese/hwmcc20-mlir`

Personal used only, recommend to use docker of `btor2mlir` instead of using this repo

## Usage Guide

### Deployment on New Machine:
```bash
# Extract files
cat sea_part_* > sea.tar.gz
cat btor2mlir_part_* > btor2mlir.tar.gz
tar -xzf btor2mlir_portable.tar.gz

# Enter directory
cd btor2mlir_portable

# Execute programs
./run_with_libs.sh bin_bundle/btor2mlir-opt [parameters]
./run_with_libs.sh bin_bundle/btor2mlir-translate [parameters]
./run_with_libs.sh bin_bundle/smt2mlir-opt [parameters]
./run_with_libs.sh bin_bundle/smt2mlir-translate [parameters]
```

### Important Notes:
1. System Requirements:
   - x86_64 architecture
   - Linux distribution
   
2. Permission Setup:
   ```bash
   chmod +x run_with_libs.sh
   chmod +x bin_bundle/*
   ```

3. Library Diagnostics:
   ```bash
   # Check library dependencies
   LD_LIBRARY_PATH=./lib_bundle ldd bin_bundle/btor2mlir-opt
   
   # Trace library loading
   LD_DEBUG=libs LD_LIBRARY_PATH=./lib_bundle ./run_with_libs.sh bin_bundle/btor2mlir-opt --help
   ```

### Conversion Workflow Example:

1. Convert Btor2 to MLIR:
```bash
./run_with_libs.sh bin_bundle/btor2mlir-translate --import-btor ./TestCases/test1.btor2 -o ./TestCases/test1.mlir
```

2. Optimize MLIR:
```bash
./run_with_libs.sh bin_bundle/btor2mlir-opt ./TestCases/test1.mlir \
  --convert-btornd-to-llvm \
  --convert-btor-to-vector \
  --convert-arith-to-llvm \
  --convert-std-to-llvm \
  --convert-btor-to-llvm \
  --convert-vector-to-llvm \
  -o ./TestCases/test1_optimized.mlir
```

3. Generate LLVM IR:
```bash
./run_with_libs.sh bin_bundle/btor2mlir-translate --mlir-to-llvmir ./TestCases/test1_optimized.mlir -o ./TestCases/test1_final.ll
```

4. Optimize by seahorn
```bash
./run_with_libs.sh seahorn/bin/sea bnd-smt -O3 --inline --enable-loop-idiom --enable-indvar --no-lower-gv-init-struct --externalize-addr-taken-functions --no-kill-vaarg --with-arith-overflow=true --horn-unify-assumes=true --horn-gsa --no-fat-fns=bcmp,memcpy,assert_bytes_match,ensure_linked_list_is_allocated,sea_aws_linked_list_is_valid --dsa=sea-cs-t --devirt-functions=types --bmc=opsem --horn-vcgen-use-ite --horn-vcgen-only-dataflow=true --horn-bmc-coi=true --sea-opsem-allocator=static --horn-explicit-sp0=false --horn-bv2-lambdas --horn-bv2-simplify=false --horn-bv2-extra-widemem -S --keep-temps --temp-dir=/tmp/btor2mlir --horn-stats=true -o TestCases/test1.smt2 TestCases/test1_final.ll 
```