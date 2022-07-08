# add a target to generate API documentation with Doxygen
find_package(Doxygen QUIET)
if(DOXYGEN_FOUND)
  set(GUDHI_MODULES ${GUDHI_MODULES} "cpp-documentation" CACHE INTERNAL "GUDHI_MODULES")

  # starting from cmake 3.9 the usage of DOXYGEN_EXECUTABLE is deprecated
  if(TARGET Doxygen::doxygen)
    get_property(DOXYGEN_EXECUTABLE TARGET Doxygen::doxygen PROPERTY IMPORTED_LOCATION)
  endif()

  message("++ Project = ${CMAKE_PROJECT_NAME}")
  if (CMAKE_PROJECT_NAME STREQUAL "GUDHIdev")
    # Set Doxyfile.in variables for the developer version
    set(GUDHI_DOXYGEN_SOURCE_PREFIX "${CMAKE_SOURCE_DIR}/src")
    foreach(GUDHI_MODULE ${GUDHI_MODULES_FULL_LIST})
      if(EXISTS "${GUDHI_DOXYGEN_SOURCE_PREFIX}/${GUDHI_MODULE}/doc/")
        set(GUDHI_DOXYGEN_IMAGE_PATH "${GUDHI_DOXYGEN_IMAGE_PATH}    ${GUDHI_DOXYGEN_SOURCE_PREFIX}/${GUDHI_MODULE}/doc/ \\  \n")
      endif()
      if(EXISTS "${GUDHI_DOXYGEN_SOURCE_PREFIX}/${GUDHI_MODULE}/example/")
        set(GUDHI_DOXYGEN_EXAMPLE_PATH "${GUDHI_DOXYGEN_EXAMPLE_PATH}    ${GUDHI_DOXYGEN_SOURCE_PREFIX}/${GUDHI_MODULE}/example/ \\  \n")
      endif()
      if(EXISTS "${GUDHI_DOXYGEN_SOURCE_PREFIX}/${GUDHI_MODULE}/utilities/")
        set(GUDHI_DOXYGEN_EXAMPLE_PATH "${GUDHI_DOXYGEN_EXAMPLE_PATH}    ${GUDHI_DOXYGEN_SOURCE_PREFIX}/${GUDHI_MODULE}/utilities/ \\  \n")
      endif()
    endforeach(GUDHI_MODULE ${GUDHI_MODULES_FULL_LIST})
    set(GUDHI_DOXYGEN_COMMON_DOC_PATH "${GUDHI_DOXYGEN_SOURCE_PREFIX}/common/doc")
    set(GUDHI_DOXYGEN_UTILS_PATH "*/utilities")
    endif()
  if (CMAKE_PROJECT_NAME STREQUAL "GUDHI")
    # Set Doxyfile.in variables for the user version
    set(GUDHI_DOXYGEN_SOURCE_PREFIX "${CMAKE_SOURCE_DIR}")
    foreach(GUDHI_MODULE ${GUDHI_MODULES_FULL_LIST})
      if(EXISTS "${GUDHI_DOXYGEN_SOURCE_PREFIX}/doc/${GUDHI_MODULE}")
        set(GUDHI_DOXYGEN_IMAGE_PATH "${GUDHI_DOXYGEN_IMAGE_PATH}    ${GUDHI_DOXYGEN_SOURCE_PREFIX}/doc/${GUDHI_MODULE}/ \\  \n")
      endif()
      if(EXISTS "${GUDHI_DOXYGEN_SOURCE_PREFIX}/example/${GUDHI_MODULE}")
        set(GUDHI_DOXYGEN_EXAMPLE_PATH "${GUDHI_DOXYGEN_EXAMPLE_PATH}    ${GUDHI_DOXYGEN_SOURCE_PREFIX}/example/${GUDHI_MODULE}/ \\  \n")
      endif()
      if(EXISTS "${GUDHI_DOXYGEN_SOURCE_PREFIX}/utilities/${GUDHI_MODULE}")
        set(GUDHI_DOXYGEN_EXAMPLE_PATH "${GUDHI_DOXYGEN_EXAMPLE_PATH}    ${GUDHI_DOXYGEN_SOURCE_PREFIX}/utilities/${GUDHI_MODULE}/ \\  \n")
      endif()
    endforeach(GUDHI_MODULE ${GUDHI_MODULES_FULL_LIST})
    set(GUDHI_DOXYGEN_COMMON_DOC_PATH "${GUDHI_DOXYGEN_SOURCE_PREFIX}/doc/common")
    set(GUDHI_DOXYGEN_UTILS_PATH "utilities/*")
  endif()

  message("++ Doxygen version ${DOXYGEN_VERSION}")
  if (DOXYGEN_VERSION VERSION_LESS 1.9.3)
    set(GUDHI_DOXYGEN_CLASS_DIAGRAMS "CLASS_DIAGRAMS = NO")
  else()
    set(GUDHI_DOXYGEN_CLASS_DIAGRAMS "")
  endif()
  if (DOXYGEN_VERSION VERSION_LESS 1.9.2)
    set(GUDHI_DOXYGEN_MATHJAX_VERSION "MATHJAX_VERSION = MathJax_2")
    set(GUDHI_DOXYGEN_MATHJAX_EXTENSIONS "TeX/AMSmath TeX/AMSsymbols")
  else()
    set(GUDHI_DOXYGEN_MATHJAX_VERSION "MATHJAX_VERSION = MathJax_3")
    set(GUDHI_DOXYGEN_MATHJAX_EXTENSIONS "ams")
  endif()

  configure_file(${GUDHI_DOXYGEN_SOURCE_PREFIX}/Doxyfile.in "${CMAKE_CURRENT_BINARY_DIR}/Doxyfile" @ONLY)

  add_custom_target(doxygen ${DOXYGEN_EXECUTABLE} ${CMAKE_CURRENT_BINARY_DIR}/Doxyfile
                    WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
                    COMMENT "Generating API documentation with Doxygen in 'html' directory" VERBATIM)
else()
  set(GUDHI_MISSING_MODULES ${GUDHI_MISSING_MODULES} "cpp-documentation" CACHE INTERNAL "GUDHI_MISSING_MODULES")
endif()
