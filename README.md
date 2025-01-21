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
./run_with_libs.sh bin_bundle/btor2mlir-translate --import-btor test.btor2 -o test.mlir
```

2. Optimize MLIR:
```bash
./run_with_libs.sh bin_bundle/btor2mlir-opt test.mlir \
  --convert-btornd-to-llvm \
  --convert-btor-to-vector \
  --convert-arith-to-llvm \
  --convert-std-to-llvm \
  --convert-btor-to-llvm \
  --convert-vector-to-llvm \
  -o test_optimized.mlir
```

3. Generate LLVM IR:
```bash
./run_with_libs.sh bin_bundle/btor2mlir-translate --mlir-to-llvmir test_optimized.mlir -o test_final.ll
```

### Verification Steps:
```bash
# Validate MLIR syntax
./run_with_libs.sh bin_bundle/btor2mlir-opt test.mlir -verify

# Preview LLVM output
head -n 20 test_final.ll

# Verify exit code
echo $?
```

