# Put compiled object files into the same sub-directory as their sources
AUTOMAKE_OPTIONS = subdir-objects

# Point to our macro directory and pick up user flags from the environment
ACLOCAL_AMFLAGS  = -I macros ${ACLOCAL_FLAGS}

# Make warnings always fatal at distcheck time, and disable execution
# of tools that change files not installed by the package itself
DISTCHECK_CONFIGURE_FLAGS = --enable-warnings=fatal --disable-update-mime-database

#SUBDIRS =

AM_CXXFLAGS = $(PROJECT_CFLAGS) $(PROJECT_WXXFLAGS) $(BOOST_CPPFLAGS)

# TODO: Why do we still need to specify this for each executable that we build?
COMMON_CXXFLAGS = $(PROJECT_CFLAGS) $(PROJECT_WXXFLAGS) $(BOOST_CPPFLAGS)

check_PROGRAMS = \
  src/topological-sort/example

TESTS = $(check_PROGRAMS)

#List of source files needed to build the executable:
src_topological_sort_example_SOURCES = \
	src/topological-sort/main.cc
src_topological_sort_example_CXXFLAGS = \
	$(COMMON_CXXFLAGS)
src_topological_sort_example_LDADD = \
	$(PROJECT_LIBS) \
	$(BOOST_SYSTEM_LIB) \
	$(BOOST_TIMER_LIB)


