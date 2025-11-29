# ==============================================================================
# Makefile for GAP Package Documentation Generation
# ==============================================================================

# ------------------------------------------------------------------------------
# 1. Configuration Variables
# ------------------------------------------------------------------------------

# Define the path to the GAP executable.
# ADJUST THIS: If 'gap' is in your PATH, just use 'gap'.
# Otherwise, use the full path (e.g., /usr/local/bin/gap).
GAP := gap

# Define the temporary directory for logs (simulating $RUNNER_TEMP)
# We use a file name for the log, as it's the final output.
LOG_DIR := temp_logs
LOG_FILE := $(LOG_DIR)/output.log

# Define the base path for GAP directories (only needed for Option 2)
# Required if the doc/make_doc script needs access to the GAP installation.
GAPROOT := $(shell dirname $(shell which $(GAP)))/../

.PHONY: doc clean

# ------------------------------------------------------------------------------
# 2. Main Target: doc
# ------------------------------------------------------------------------------

doc: $(LOG_FILE)
	@echo ""
	@echo "✅ Documentation generation finished. Check the log and the doc/ folder."

# ------------------------------------------------------------------------------
# 3. Rule to generate the log file (Main Logic)
# ------------------------------------------------------------------------------

$(LOG_FILE):
	@echo "------------------------------------------------------------"
	@echo "🔎 Attempting to generate documentation..."
	@echo "GAP: $(GAP)"
	@echo "Log: $(LOG_FILE)"
	@echo "------------------------------------------------------------"

	# Create the log directory if it doesn't exist
	@mkdir -p $(LOG_DIR)

	# Original script logic: if makedoc.g exists, use GAP
ifeq ($(wildcard makedoc.g), makedoc.g)
	@echo "Option 1: makedoc.g found. Executing with GAP..."
	# Execute GAP, redirect stdout and stderr, and save with tee
	@$(GAP) makedoc.g -c "QUIT;" 2>&1 | tee $(LOG_FILE)
	@if [ $$? -ne 0 ]; then \
		echo "❌ Error executing $(GAP)/makedoc.g. Check the log."; \
		exit 1; \
	fi

	# Original script logic: if doc/make_doc is executable
else ifeq ($(shell [ -x doc/make_doc ] && echo 1), 1)
	@echo "Option 2: doc/make_doc executable found. Executing..."
	@echo "Simulated GAPROOT: $(GAPROOT)"
	
	# Create symbolic links and execute inside doc/
	@([ -d ../../doc ] && echo "../../doc exists" || ln -s $(GAPROOT)/doc ../../doc)
	@([ -d ../../etc ] && echo "../../etc exists" || ln -s $(GAPROOT)/etc ../../etc)
	
	@cd doc && ./make_doc 2>&1 | tee ../$(LOG_FILE)
	@if [ $$? -ne 0 ]; then \
		echo "❌ Error executing doc/make_doc. Check the log."; \
		exit 1; \
	fi

	# Original script logic: if doc/make_doc exists but is not executable
else ifeq ($(wildcard doc/make_doc), doc/make_doc)
	@echo "doc/make_doc exists but is not executable!"
	@exit 1

	# Original script logic: Failure, no option found
else
	@echo "No makedoc.g file or doc/make_doc script found!"
	@exit 1

endif

# ------------------------------------------------------------------------------
# 4. Clean Target
# ------------------------------------------------------------------------------

clean:
	@echo "Cleaning log files and temporary files..."
	@rm -rf $(LOG_DIR)
	# If your documentation generates files in the 'doc/' folder, add them here:
	@rm -f doc/*.html doc/*.pdf doc/*.txt doc/*.xml doc/*.css doc/*.js doc/QGNAG.* doc/manual.*