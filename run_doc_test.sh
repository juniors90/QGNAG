#!/bin/bash

## 1. Environment Variables Configuration
# ----------------------------------------
# Ensure $GAP points to the actual GAP executable on your system.
# We are using the variable defined by a Jupyter/testing environment.
export GAP=$JUPYTER_GAP_EXECUTABLE

# Optional: If 'gap' is in your PATH, you could use:
# export GAP="gap"

# RUNNER_TEMP is the temporary directory to save the log file.
# We use a fixed local directory for easier review.
export RUNNER_TEMP="./temp_logs"
mkdir -p "$RUNNER_TEMP"

echo "GAP defined as: $GAP"
echo "Log will be saved to: $RUNNER_TEMP/output.log"
echo "----------------------------------------"

## 2. Documentation Generation Logic
# -----------------------------------------------------------------

if [ -f "makedoc.g" ]; then
    echo "Option 1: makedoc.g found. Executing documentation..."
    
    # The actual execution of documentation
    # 2>&1 pipes both stdout and stderr to the tee command
    "$GAP" makedoc.g -c "QUIT;" 2>&1 | tee "$RUNNER_TEMP/output.log"
    
    # Check for success (GAP exit code 0)
    if [ $? -eq 0 ]; then
        echo "✅ Documentation generation completed successfully."
    else
        echo "❌ Error executing GAP/makedoc.g. Check the log."
        exit 1
    fi

elif [ -x "doc/make_doc" ]; then
    # This section would be ignored if makedoc.g exists,
    # but is kept for complete logic.
    echo "Option 2: doc/make_doc executable found. Executing..."
    # ... (rest of the logic requires $GAPROOT setup which is not in this script) ...
    exit 1 # Exit forced here as $GAPROOT is not defined in this simple script

elif [ -f "doc/make_doc" ]; then
    echo "doc/make_doc exists but is not executable!"
    exit 1

else
    echo "No makedoc.g file or doc/make_doc script found!"
    exit 1
fi

echo "---"
echo "Contents of $RUNNER_TEMP/output.log:"
cat "$RUNNER_TEMP/output.log"

# Cleanup: Remove the temporary directory
rm -rf "$RUNNER_TEMP"