# ==============================================================================
# Makefile.in — gapcxx-style kernel extension + documentation
# ==============================================================================
# Generado como 'Makefile' vía ./configure [GAPPATH]
# ==============================================================================

# ------------------------------------------------------------------------------
# 1. Kernel extension (C/C++) — target por defecto
# ------------------------------------------------------------------------------
# IMPORTANTE: esta sección va PRIMERO. El primer target definido en un
# Makefile (acá, el que trae Makefile.gappkg) es el que corre 'make' sin
# argumentos. Todo lo de documentación va DESPUÉS, para no pisarlo.

KEXT_NAME = qgnag

KEXT_SOURCES = $(shell find src -type f -name '*.cc')

KEXT_LDFLAGS = -lstdc++

CPPFLAGS += -Isrc
CXXFLAGS += -fopenmp
LDFLAGS  += -fopenmp

GAPPATH = ../..
include Makefile.gappkg

# ------------------------------------------------------------------------------
# 2. Documentación — targets adicionales, no afectan el default goal
# ------------------------------------------------------------------------------

GAP     := gap
LOG_DIR := temp_logs
LOG_FILE := $(LOG_DIR)/output.log
DOC_GAPROOT := $(shell dirname $(shell which $(GAP)))/../
PACKAGE := QGNAG

.PHONY: doc clean-doc distclean

doc: $(LOG_FILE)
	@echo ""
	@echo "✅ Documentation generation finished. Check the log and the doc/ folder."

$(LOG_FILE):
	@echo "------------------------------------------------------------"
	@echo "🔎 Attempting to generate documentation..."
	@echo "GAP: $(GAP)"
	@echo "Log: $(LOG_FILE)"
	@echo "------------------------------------------------------------"
	@mkdir -p $(LOG_DIR)
ifeq ($(wildcard makedoc.g), makedoc.g)
	@echo "Option 1: makedoc.g found. Executing with GAP..."
	@$(GAP) makedoc.g -c "QUIT;" 2>&1 | tee $(LOG_FILE)
	@if [ $$? -ne 0 ]; then \
		echo "❌ Error executing $(GAP)/makedoc.g. Check the log."; \
		exit 1; \
	fi
else ifeq ($(shell [ -x doc/make_doc ] && echo 1), 1)
	@echo "Option 2: doc/make_doc executable found. Executing..."
	@echo "Simulated GAPROOT: $(DOC_GAPROOT)"
	@([ -d ../../doc ] && echo "../../doc exists" || ln -s $(DOC_GAPROOT)/doc ../../doc)
	@([ -d ../../etc ] && echo "../../etc exists" || ln -s $(DOC_GAPROOT)/etc ../../etc)
	@cd doc && ./make_doc 2>&1 | tee ../$(LOG_FILE)
	@if [ $$? -ne 0 ]; then \
		echo "❌ Error executing doc/make_doc. Check the log."; \
		exit 1; \
	fi
else ifeq ($(wildcard doc/make_doc), doc/make_doc)
	@echo "doc/make_doc exists but is not executable!"
	@exit 1
else
	@echo "No makedoc.g file or doc/make_doc script found!"
	@exit 1
endif

# ------------------------------------------------------------------------------
# 3. Limpieza de documentación (separada de 'clean' del kernel)
# ------------------------------------------------------------------------------
# Ojo: 'clean' ya viene definido por Makefile.gappkg (limpia .o y el .so
# de la extensión). Por eso NO redefinimos 'clean' acá — eso pisaría el
# target del kernel con un warning de make ("overriding recipe"). En su
# lugar, este target se llama 'clean-doc', y 'distclean' junta ambos.

clean-doc:
	@echo "Cleaning log files and documentation temporary files..."
	@rm -rf $(LOG_DIR)
	@rm -f doc/*.html doc/*.pdf doc/*.txt doc/*.xml \
	       doc/*.css doc/*.js doc/manual.*
	@rm -f ./doc/$(PACKAGE).aux \
	       ./doc/$(PACKAGE).bbl \
	       ./doc/$(PACKAGE).brf \
	       ./doc/$(PACKAGE).blg \
	       ./doc/$(PACKAGE).idx \
	       ./doc/$(PACKAGE).ilg \
	       ./doc/$(PACKAGE).ind \
	       ./doc/$(PACKAGE).log \
	       ./doc/$(PACKAGE).out \
	       ./doc/$(PACKAGE).pnr \
	       ./doc/$(PACKAGE).tex \
	       ./doc/$(PACKAGE).toc

distclean: clean clean-doc
	@echo "Kernel extension and documentation artifacts removed."

.PHONY: test
test:
	@echo "Running qgnag test suite..."
	@gap -q -A -T --quitonbreak tst/testall.g

clean-tex:
	find examples/TETRAHEDRON/KL/ORDERED/ -type f \( \
		-name "*.aux" -o \
		-name "*.log" -o \
		-name "*.out" -o \
		-name "*.toc" -o \
		-name "*.tex" -o \
		-name "*.lof" -o \
		-name "*.lot" -o \
		-name "*.fls" -o \
		-name "*.fdb_latexmk" -o \
		-name "*.synctex.gz" \
	\) -delete

	find examples/TETRAHEDRON/KAZHDANLUSZTIG/ -type f \( \
		-name "*.aux" -o \
		-name "*.log" -o \
		-name "*.out" -o \
		-name "*.toc" -o \
		-name "*.tex" -o \
		-name "*.lof" -o \
		-name "*.lot" -o \
		-name "*.fls" -o \
		-name "*.fdb_latexmk" -o \
		-name "*.synctex.gz" \
	\) -delete