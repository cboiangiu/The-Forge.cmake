cmake_minimum_required(VERSION 3.12.4)
project(The-Forge)

# sets project version from api ver / git rev
include( cmake/version.cmake )

set_property( GLOBAL PROPERTY USE_FOLDERS ON )
set(CMAKE_CXX_STANDARD 14)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

# Makefile generators on apple need this flag to compile mixed objective/c++
if( APPLE AND NOT XCODE )
	set( CMAKE_CXX_FLAGS "-ObjC++" )
endif()

option( THE_FORGE_INSTALL     "Create installation target."                   ON  )
option( BGFX_CUSTOM_TARGETS   "Include convenience custom targets."           ON  )

set( BGFX_LIBRARY_TYPE     "STATIC" CACHE STRING "Linking type for library" )

set_property( CACHE BGFX_LIBRARY_TYPE PROPERTY STRINGS STATIC SHARED )

if( NOT THE_FORGE_DIR )
	set( THE_FORGE_DIR "${CMAKE_CURRENT_SOURCE_DIR}/The-Forge" CACHE STRING "Location of The-Forge." )
elseif( NOT IS_ABSOLUTE "${THE_FORGE_DIR}")
	get_filename_component(THE_FORGE_DIR "${THE_FORGE_DIR}" REALPATH BASE_DIR "${CMAKE_CURRENT_SOURCE_DIR}")
endif()

include( cmake/The-Forge.cmake )

if( THE_FORGE_INSTALL )
	include(GNUInstallDirs)

	# Layout. This works for all platforms:
	#   * <prefix>/lib*/cmake/<PROJECT-NAME>
	#   * <prefix>/lib*/
	#   * <prefix>/include/
	set(config_install_dir "${CMAKE_INSTALL_LIBDIR}/cmake/${PROJECT_NAME}")
	set(generated_dir "${CMAKE_CURRENT_BINARY_DIR}/generated")

	# Configuration
	set(version_config "${generated_dir}/${PROJECT_NAME}ConfigVersion.cmake")
	set(project_config "${generated_dir}/${PROJECT_NAME}Config.cmake")
	set(TARGETS_EXPORT_NAME "${PROJECT_NAME}Targets")
	set(namespace "${PROJECT_NAME}::")

	# Include module with fuction 'write_basic_package_version_file'
	include(CMakePackageConfigHelpers)

	# Configure '<PROJECT-NAME>ConfigVersion.cmake'
	# Use:
	#   * PROJECT_VERSION
	if(${CMAKE_VERSION} VERSION_LESS "3.11.0")
		set(BGFX_COMPATIBILITY SameMajorVersion)
	else()
		set(BGFX_COMPATIBILITY SameMinorVersion)
	endif()
	write_basic_package_version_file(
		"${version_config}"
		VERSION "1.47"
		COMPATIBILITY ${BGFX_COMPATIBILITY}
	)

	# Configure '<PROJECT-NAME>Config.cmake'
	# Use variables:
	#   * TARGETS_EXPORT_NAME
	#   * PROJECT_NAME
	configure_package_config_file(
		"cmake/Config.cmake.in"
		"${project_config}"
		INSTALL_DESTINATION "${config_install_dir}"
	)

	install(FILES ${THE_FORGE_DIR}/LICENSE DESTINATION ${CMAKE_INSTALL_DOCDIR})
	install(FILES README.md DESTINATION ${CMAKE_INSTALL_DOCDIR})

	install( TARGETS the-forge
			 EXPORT "${TARGETS_EXPORT_NAME}"
			 LIBRARY DESTINATION "${CMAKE_INSTALL_LIBDIR}"
			 ARCHIVE DESTINATION "${CMAKE_INSTALL_LIBDIR}"
			 RUNTIME DESTINATION "${CMAKE_INSTALL_BINDIR}"
			 INCLUDES DESTINATION "${CMAKE_INSTALL_INCLUDEDIR}"
	)
    # if (BGFX_CONFIG_RENDERER_WEBGPU)
	# 	install( TARGETS webgpu
	# 			 EXPORT "${TARGETS_EXPORT_NAME}"
	# 			 LIBRARY DESTINATION "${CMAKE_INSTALL_LIBDIR}"
	# 			 ARCHIVE DESTINATION "${CMAKE_INSTALL_LIBDIR}"
	# 			 RUNTIME DESTINATION "${CMAKE_INSTALL_BINDIR}"
	# 			 INCLUDES DESTINATION "${CMAKE_INSTALL_INCLUDEDIR}"
	# 	)
    # endif()

	# install headers (this should be done as a target probably... ^)
	file(COPY ${Headers} DESTINATION "${CMAKE_CURRENT_SOURCE_DIR}/include/The-Forge")

	# message( SEND_ERROR "Yes ${CMAKE_INSTALL_INCLUDEDIR}" )

	install( DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}/include/The-Forge" DESTINATION "${CMAKE_INSTALL_INCLUDEDIR}")
	# message( SEND_ERROR "Yes ${Headers}" )
	# return()

	# header required for shader compilation
	# install( FILES ${THE_FORGE_DIR}/src/bgfx_shader.sh ${THE_FORGE_DIR}/src/bgfx_compute.sh
	# 	DESTINATION "${CMAKE_INSTALL_INCLUDEDIR}/bgfx"
	# )

	# install tools
	# if( BGFX_BUILD_TOOLS )
	# 	install( TARGETS shaderc
	# 		EXPORT "${TARGETS_EXPORT_NAME}"
	# 		DESTINATION "${CMAKE_INSTALL_BINDIR}" )
	# 	install( TARGETS geometryc
	# 		EXPORT "${TARGETS_EXPORT_NAME}"
	# 		DESTINATION "${CMAKE_INSTALL_BINDIR}" )
    # 	install( TARGETS geometryv
	# 		EXPORT "${TARGETS_EXPORT_NAME}"
	# 		DESTINATION "${CMAKE_INSTALL_BINDIR}" )
	# 	install( TARGETS texturec
	# 		EXPORT "${TARGETS_EXPORT_NAME}"
	# 		DESTINATION "${CMAKE_INSTALL_BINDIR}" )
	# 	install( TARGETS texturev
	# 		EXPORT "${TARGETS_EXPORT_NAME}"
	# 		DESTINATION "${CMAKE_INSTALL_BINDIR}" )
	# endif()

	# Config
	#   * <prefix>/lib/cmake/bgfx/bgfxConfig.cmake
	#   * <prefix>/lib/cmake/bgfx/bgfxConfigVersion.cmake
	install(
		FILES "${project_config}" "${version_config}"
		DESTINATION "${config_install_dir}"
	)

	# Config
	#   * <prefix>/lib/cmake/bgfx/bgfxTargets.cmake
	install(
		EXPORT "${TARGETS_EXPORT_NAME}"
		NAMESPACE "${namespace}"
		DESTINATION "${config_install_dir}"
	)
endif()