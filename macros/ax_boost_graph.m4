# ===========================================================================
#      http://www.gnu.org/software/autoconf-archive/ax_boost_graph.html
# ===========================================================================
#
# SYNOPSIS
#
#   AX_BOOST_GRAPH
#
# DESCRIPTION
#
#   Test for Graph library from the Boost C++ libraries. The macro requires
#   a preceding call to AX_BOOST_BASE. Further documentation is available at
#   <http://randspringer.de/boost/index.html>.
#
#   This macro calls:
#
#     AC_SUBST(BOOST_GRAPH_LIB)
#
#   And sets:
#
#     HAVE_BOOST_GRAPH
#
# LICENSE
#
#   Copyright (c) 2012 Xiyue Deng <manphiz@gmail.com>
#   Copyright (c) 2016 Murray Cumming <murrayc@openismus.com>
#
#   Copying and distribution of this file, with or without modification, are
#   permitted in any medium without royalty provided the copyright notice
#   and this notice are preserved. This file is offered as-is, without any
#   warranty.

#serial 2 (based on serial 1 of ax_boost_locale.m4 with some simple find/replace by Murray Cumming)

AC_DEFUN([AX_BOOST_GRAPH],
[
	AC_ARG_WITH([boost-graph],
	AS_HELP_STRING([--with-boost-graph@<:@=special-lib@:>@],
                   [use the Graph library from boost - it is possible to specify a certain library for the linker
                        e.g. --with-boost-graph=boost_graph-gcc-mt ]),
        [
        if test "$withval" = "no"; then
			want_boost="no"
        elif test "$withval" = "yes"; then
            want_boost="yes"
            ax_boost_user_graph_lib=""
        else
		    want_boost="yes"
		ax_boost_user_graph_lib="$withval"
		fi
        ],
        [want_boost="yes"]
	)

	if test "x$want_boost" = "xyes"; then
        AC_REQUIRE([AC_PROG_CC])
        AC_REQUIRE([AC_CANONICAL_BUILD])
		CPPFLAGS_SAVED="$CPPFLAGS"
		CPPFLAGS="$CPPFLAGS $BOOST_CPPFLAGS"
		export CPPFLAGS

		LDFLAGS_SAVED="$LDFLAGS"
		LDFLAGS="$LDFLAGS $BOOST_LDFLAGS"
		export LDFLAGS

        AC_CACHE_CHECK(whether the Boost::Graph library is available,
					   ax_cv_boost_graph,
        [AC_LANG_PUSH([C++])
			 CXXFLAGS_SAVE=$CXXFLAGS

			 AC_COMPILE_IFELSE([AC_LANG_PROGRAM([[@%:@include <boost/graph/ajacency_list.hpp>]],
                                   [[boost::graph::adjacency_list<boost::graph::vecS, boost::graph::vecS, boost::graph::, bidirectionalS>();]])],
                   ax_cv_boost_graph=yes, ax_cv_boost_graph=no)
			 CXXFLAGS=$CXXFLAGS_SAVE
             AC_LANG_POP([C++])
		])
		if test "x$ax_cv_boost_graph" = "xyes"; then
			AC_SUBST(BOOST_CPPFLAGS)

			AC_DEFINE(HAVE_BOOST_GRAPH,,[define if the Boost::Graph library is available])
            BOOSTLIBDIR=`echo $BOOST_LDFLAGS | sed -e 's/@<:@^\/@:>@*//'`

			LDFLAGS_SAVE=$LDFLAGS
            if test "x$ax_boost_user_graph_lib" = "x"; then
                for libextension in `ls $BOOSTLIBDIR/libboost_graph*.so* $BOOSTLIBDIR/libboost_graph*.dylib* $BOOSTLIBDIR/libboost_graph*.a* 2>/dev/null | sed 's,.*/,,' | sed -e 's;^lib\(boost_graph.*\)\.so.*$;\1;' -e 's;^lib\(boost_graph.*\)\.dylib.*$;\1;' -e 's;^lib\(boost_graph.*\)\.a.*$;\1;'` ; do
                     ax_lib=${libextension}
				    AC_CHECK_LIB($ax_lib, exit,
                                 [BOOST_GRAPH_LIB="-l$ax_lib"; AC_SUBST(BOOST_GRAPH_LIB) link_graph="yes"; break],
                                 [link_graph="no"])
				done
                if test "x$link_graph" != "xyes"; then
                for libextension in `ls $BOOSTLIBDIR/boost_graph*.dll* $BOOSTLIBDIR/boost_graph*.a* 2>/dev/null | sed 's,.*/,,' | sed -e 's;^\(boost_graph.*\)\.dll.*$;\1;' -e 's;^\(boost_graph.*\)\.a.*$;\1;'` ; do
                     ax_lib=${libextension}
				    AC_CHECK_LIB($ax_lib, exit,
                                 [BOOST_GRAPH_LIB="-l$ax_lib"; AC_SUBST(BOOST_GRAPH_LIB) link_graph="yes"; break],
                                 [link_graph="no"])
				done
                fi

            else
               for ax_lib in $ax_boost_user_graph_lib boost_graph-$ax_boost_user_graph_lib; do
				      AC_CHECK_LIB($ax_lib, exit,
                                   [BOOST_GRAPH_LIB="-l$ax_lib"; AC_SUBST(BOOST_GRAPH_LIB) link_graph="yes"; break],
                                   [link_graph="no"])
                  done

            fi
            if test "x$ax_lib" = "x"; then
                AC_MSG_ERROR(Could not find a version of the library!)
            fi
			if test "x$link_graph" = "xno"; then
				AC_MSG_ERROR(Could not link against $ax_lib !)
			fi
		fi

		CPPFLAGS="$CPPFLAGS_SAVED"
	LDFLAGS="$LDFLAGS_SAVED"
	fi
])
