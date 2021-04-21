# To prevent this warning: https://cmake.org/cmake/help/git-stage/policy/CMP0072.html
# if(POLICY CMP0072)
#   cmake_policy(SET CMP0072 NEW)
# endif()

# Ensure the directory exists
if( NOT IS_DIRECTORY ${THE_FORGE_DIR} )
	message( SEND_ERROR "Could not load THe-Forge, directory does not exist. ${THE_FORGE_DIR}" )
	return()
endif()

option(unittests "unittests" OFF)

#set(USE_D3D12 TRUE)
#set(USE_VULKAN TRUE)
#set(USE_D3D11 TRUE)

# windows supports USE_VULKAN, USE_D3D11 and USE_D3D12
# defaults to USE_D3D12
if (WIN32)
	if(NOT USE_VULKAN AND NOT USE_D3D11)
		set(USE_D3D12 TRUE)
	endif()

	if(USE_VULKAN)
		find_package(Vulkan REQUIRED)
	endif()
endif()
# TODO vulkan on metal support
if(APPLE)
	set(USE_METAL TRUE)
	set(USE_VULKAN FALSE)
endif()

# SET_MIN_VERSIONS()
set(LibName the-forge)
project(${LibName})

# set(Deps
# 		al2o3_platform
# 		al2o3_memory
# 		tiny_imageformat
# 		)

# set(Interface
# 		enums.h
# 		resourceloader.h
# 		resourceloaders_structs.h
# 		shaderreflection.h
# 		structs.h
# 		theforge.h
# 		)

set(Sources
		# theforge.cpp
		${THE_FORGE_DIR}/Common_3/OS/Core/ThreadSystem.cpp
		${THE_FORGE_DIR}/Common_3/OS/Core/Timer.cpp
		# ${THE_FORGE_DIR}/Common_3/OS/Image/Image.cpp
		${THE_FORGE_DIR}/Common_3/Renderer/CommonShaderReflection.cpp
		# ${THE_FORGE_DIR}/Common_3/Renderer/GpuProfiler.cpp
		# ${THE_FORGE_DIR}/Common_3/Renderer/ResourceLoader.cpp

		${THE_FORGE_DIR}/Common_3/ThirdParty/OpenSource/EASTL/allocator_forge.cpp
		${THE_FORGE_DIR}/Common_3/ThirdParty/OpenSource/EASTL/assert.cpp
		${THE_FORGE_DIR}/Common_3/ThirdParty/OpenSource/EASTL/hashtable.cpp
		${THE_FORGE_DIR}/Common_3/ThirdParty/OpenSource/EASTL/numeric_limits.cpp
		${THE_FORGE_DIR}/Common_3/ThirdParty/OpenSource/EASTL/red_black_tree.cpp
		${THE_FORGE_DIR}/Common_3/ThirdParty/OpenSource/EASTL/string.cpp
		${THE_FORGE_DIR}/Common_3/ThirdParty/OpenSource/EASTL/thread_support.cpp
		${THE_FORGE_DIR}/Common_3/ThirdParty/OpenSource/EASTL/EAStdC/EASprintf.cpp
		)

set(Headers
		${THE_FORGE_DIR}/Common_3/OS/Core/Atomics.h
		${THE_FORGE_DIR}/Common_3/OS/Core/Compiler.h
		${THE_FORGE_DIR}/Common_3/OS/Core/DLL.h
		${THE_FORGE_DIR}/Common_3/OS/Core/RingBuffer.h
		${THE_FORGE_DIR}/Common_3/OS/Core/ThreadSystem.h
		# ${THE_FORGE_DIR}/Common_3/OS/Image/Image.h
		${THE_FORGE_DIR}/Common_3/OS/Interfaces/ILog.h
		${THE_FORGE_DIR}/Common_3/OS/Interfaces/IMemory.h
		${THE_FORGE_DIR}/Common_3/OS/Interfaces/IOperatingSystem.h
		${THE_FORGE_DIR}/Common_3/OS/Interfaces/IProfiler.h
		${THE_FORGE_DIR}/Common_3/OS/Interfaces/IThread.h
		${THE_FORGE_DIR}/Common_3/OS/Interfaces/ITime.h
		${THE_FORGE_DIR}/Common_3/OS/Math/MathTypes.h
		# ${THE_FORGE_DIR}/Common_3/Renderer/GpuProfiler.h
		${THE_FORGE_DIR}/Common_3/Renderer/IRay.h
		${THE_FORGE_DIR}/Common_3/Renderer/IRenderer.h
		${THE_FORGE_DIR}/Common_3/Renderer/IShaderReflection.h
		# ${THE_FORGE_DIR}/Common_3/Renderer/ResourceLoader.h

		${THE_FORGE_DIR}/Common_3/ThirdParty/OpenSource/tinyimageformat/tinyimageformat_apis.h
		${THE_FORGE_DIR}/Common_3/ThirdParty/OpenSource/tinyimageformat/tinyimageformat_base.h
		${THE_FORGE_DIR}/Common_3/ThirdParty/OpenSource/tinyimageformat/tinyimageformat_bits.h
		${THE_FORGE_DIR}/Common_3/ThirdParty/OpenSource/tinyimageformat/tinyimageformat_decode.h
		${THE_FORGE_DIR}/Common_3/ThirdParty/OpenSource/tinyimageformat/tinyimageformat_encode.h
		${THE_FORGE_DIR}/Common_3/ThirdParty/OpenSource/tinyimageformat/tinyimageformat_query.h
		)
if (WIN32)
	if(USE_D3D11)
		list(APPEND Sources ${THE_FORGE_DIR}/Common_3/Renderer/Direct3D11/Direct3D11.cpp)
		list(APPEND Sources ${THE_FORGE_DIR}/Common_3/Renderer/Direct3D11/Direct3D11Raytracing.cpp)
		list(APPEND Sources ${THE_FORGE_DIR}/Common_3/Renderer/Direct3D11/Direct3D11ShaderReflection.cpp)
	endif()

	if(USE_D3D12)
		list(APPEND Sources ${THE_FORGE_DIR}/Common_3/Renderer/Direct3D12/Direct3D12.cpp)
		list(APPEND Sources ${THE_FORGE_DIR}/Common_3/Renderer/Direct3D12/Direct3D12Hooks.cpp)
		list(APPEND Headers ${THE_FORGE_DIR}/Common_3/Renderer/Direct3D12/Direct3D12Hooks.h)
		list(APPEND Sources ${THE_FORGE_DIR}/Common_3/Renderer/Direct3D12/Direct3D12MemoryAllocator.cpp)
		list(APPEND Headers ${THE_FORGE_DIR}/Common_3/Renderer/Direct3D12/Direct3D12MemoryAllocator.h)
		list(APPEND Sources ${THE_FORGE_DIR}/Common_3/Renderer/Direct3D12/Direct3D12Raytracing.cpp)
		list(APPEND Sources ${THE_FORGE_DIR}/Common_3/Renderer/Direct3D12/Direct3D12ShaderReflection.cpp)
	endif()

	list(APPEND Sources ${THE_FORGE_DIR}/Common_3/OS/Windows/WindowsThread.cpp)
	list(APPEND Sources ${THE_FORGE_DIR}/Common_3/OS/Windows/WindowsTime.cpp)
endif ()

if(USE_VULKAN)
	list(APPEND Sources ${THE_FORGE_DIR}/Common_3/Renderer/Vulkan/Vulkan.cpp)
	list(APPEND Sources ${THE_FORGE_DIR}/Common_3/Renderer/Vulkan/VulkanRaytracing.cpp)
	list(APPEND Sources ${THE_FORGE_DIR}/Common_3/Renderer/Vulkan/VulkanShaderReflection.cpp)
	list(APPEND Headers ${THE_FORGE_DIR}/Common_3/Renderer/Vulkan/VulkanCapsBuilder.h)

	list(APPEND Sources ${THE_FORGE_DIR}/Common_3/Tools/SpirvTools/SpirvTools.cpp)
	list(APPEND Headers ${THE_FORGE_DIR}/Common_3/Tools/SpirvTools/SpirvTools.h)
endif()

if (APPLE)
	if( USE_METAL )
		list(APPEND Headers ${THE_FORGE_DIR}/Common_3/Renderer/Metal/MetalMemoryAllocator.h)
		list(APPEND Headers ${THE_FORGE_DIR}/Common_3/Renderer/Metal/MetalCapBuilder.h)
		list(APPEND Sources ${THE_FORGE_DIR}/Common_3/Renderer/Metal/MetalRaytracing.mm)
		list(APPEND Sources ${THE_FORGE_DIR}/Common_3/Renderer/Metal/MetalRenderer.mm)
		list(APPEND Sources ${THE_FORGE_DIR}/Common_3/Renderer/Metal/MetalShaderReflection.mm)
	endif()

	list(APPEND Sources ${THE_FORGE_DIR}/Common_3/OS/Darwin/DarwinThread.cpp)
	# list(APPEND Sources ${THE_FORGE_DIR}/Common_3/OS/Darwin/DarwinTime.cpp)
endif ()


add_library(${LibName} ${Sources})

if(USE_VULKAN)
	add_compile_definitions(${LibName} VULKAN)
	target_include_directories(${LibName} PRIVATE Vulkan::Vulkan)
	target_link_libraries(${LibName} PRIVATE Vulkan::Vulkan)
endif()

if (APPLE)
	add_compile_definitions(${LibName} METAL)
	target_compile_options(${LibName} PRIVATE -fobjc-arc -ObjC++)

	target_link_libraries(${LibName} PUBLIC
			stdc++
			objc
			"-framework Foundation"
			"-framework Cocoa"
			"-framework IOKit"
			"-framework Metal"
			"-framework MetalKit"
			"-framework MetalPerformanceShaders"
			"-framework QuartzCore"
			)
endif ()

if(WIN32)
	if(USE_D3D12)
		target_compile_definitions(${LibName} PRIVATE DIRECT3D12)
	endif()

	if(USE_D3D11)
		target_compile_definitions(${LibName} PRIVATE DIRECT3D11)
	endif()

	target_link_libraries(${LibName} PRIVATE
			winmm
			${THE_FORGE_DIR}/Common_3/ThirdParty/OpenSource/winpixeventruntime/bin/WinPixEventRuntime.lib)

	configure_file(
			${THE_FORGE_DIR}/Common_3/ThirdParty/OpenSource/winpixeventruntime/bin/WinPixEventRuntime.dll
			${CMAKE_LIBRARY_OUTPUT_DIRECTORY}/WinPixEventRuntime.dll COPYONLY)

endif()

set_target_properties( ${LibName} PROPERTIES FOLDER "${LibName}" )
