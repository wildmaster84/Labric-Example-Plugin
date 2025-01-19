# ------------in short---------------
# - make sure to set "XEDK" environment variable to the root folder of the XDK

# - we compile with cl.exe every .cpp into .obj
# - after that we link with link.exe the .obj into a EXE
# - then imagexex.exe create a xex image that the xbox 360 can run
# - all the output files are in build/ :}
# - also add to Vs Code the xdks headers for intellisense
# ------------XDK stuff---------------
XDKPATH := $(subst \,/,$(XEDK))

# Path for XDK Linker, Compiler and ImageXex, libs and header include 
CC := "$(XDKPATH)/bin/win32/cl.exe"
LINKER := "$(XDKPATH)/bin/win32/link.exe"
IX := "$(XDKPATH)/bin/win32/imagexex.exe"
XLIB_DIR := "$(XDKPATH)/lib/xbox"
XINC_DIR := "$(XDKPATH)/include/xbox"
XLIBS := xapilib.lib d3d9ltcg.lib d3dx9.lib xgraphics.lib xboxkrnl.lib xnet.lib xaudio2.lib xact3ltcg.lib x3daudioltcg.lib xmcoreltcg.lib vcomp.lib

# -------------------------------------




# ----------"config" and stuff-------------
PROJECT_NAME := Example-Labric
SRC_DIR := src
OUTPUT_DIR := build
DLL_NAME := $(OUTPUT_DIR)/$(PROJECT_NAME).dll

# FLAGS :}
CFLAGS := /c /Zi /nologo /W3 /WX- /Ox /Os /GL /D NDEBUG /D _XBOX /D LTCG /GF /Gm- /MT /GS- /Gy /fp:fast /fp:except- /I$(XINC_DIR) /Zc:wchar_t /Zc:forScope /GR- /openmp- /Fd"$(OUTPUT_DIR)/vc100.pdb"
LFLAGS := /ERRORREPORT:PROMPT /INCREMENTAL:NO /NOLOGO /LIBPATH:$(XLIB_DIR) $(XLIBS) /MANIFESTUAC:"level='asInvoker' uiAccess='false'" /DEBUG /STACK:262144,262144 /OPT:REF /OPT:ICF /LTCG /TLBID:1 /RELEASE /IMPLIB:$(OUTPUT_DIR)/$(PROJECT_NAME).lib /OUT:$(DLL_NAME) /DLL /ENTRY:"_DllMainCRTStartup" /ALIGN:128,4096 /XEX:NO
IXFLAGS := /out:$(OUTPUT_DIR)/$(PROJECT_NAME).xex $(DLL_NAME)

# -----------------------------------------



# generated stuff for make file (grabs all .cpp files and all .obj files)
# Add sources path and build path to compile them, yes it's manual for now i know :/
SOURCES := $(SRC_DIR)/DLLMain.cpp
OBJECTS := $(SOURCES:$(SRC_DIR)/%.cpp=$(OUTPUT_DIR)/%.obj)

# Default target
all: $(DLL_NAME)

# Build DLL and XEX
$(DLL_NAME): $(OBJECTS)
	$(LINKER) $(OBJECTS) $(LFLAGS) /OUT:$(DLL_NAME)
	$(IX) $(IXFLAGS)

# Compile source files to object files
$(OUTPUT_DIR)/%.obj: $(SRC_DIR)/%.cpp | $(OUTPUT_DIR)
	$(CC) $(CFLAGS) /c $< /Fo$@

# --------------create_dirs and remove_dirs_dirs---------------
# this create and clean the folders for obj files inside of build/ for the linker
# I'm sure there's a simpler and better way to automate everything also for $SOURCES too (cmake I guess lol) but I've banged my head enough with this file so, if it works, it works
$(OUTPUT_DIR):
	@mkdir $(OUTPUT_DIR)

# Clean up build artifacts
clean:
	del /F /Q $(OUTPUT_DIR)
