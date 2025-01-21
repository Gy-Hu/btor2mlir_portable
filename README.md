# btor2mlir_portable

## Usage Guide

### Deployment on New Machine:
```bash
# Extract files
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
