project(the-forge)

if( NOT IS_DIRECTORY ${THE_FORGE_DIR} )
	message( SEND_ERROR "Could not load THe-Forge, directory does not exist. ${THE_FORGE_DIR}" )
	return()
endif()

set(OS_PLATFORM_SPECIFIC_FILES "")

source_group(${THE_FORGE_DIR}\\Common_3\\OS\\Interfaces FILES ${OS_INTERFACES_FILES})

source_group(${THE_FORGE_DIR}\\Common_3\\OS\\Input FILES ${OS_INPUT_FILES})

source_group(${THE_FORGE_DIR}\\Common_3\\OS\\FileSystem FILES ${OS_FILESYSTEM_FILES})

source_group(${THE_FORGE_DIR}\\Common_3\\OS\\MemoryManager FILES ${OS_MEMORYMANAGER_FILES})

source_group(${THE_FORGE_DIR}\\Common_3\\OS\\Camera FILES ${OS_CAMERA_FILES})

source_group(${THE_FORGE_DIR}\\Common_3\\OS\\Math FILES ${OS_MATH_FILES})

set(OS_IMAGE_FILES
	${THE_FORGE_DIR}/Common_3/ThirdParty/OpenSource/basis_universal/transcoder/basisu_transcoder.cpp
        )

source_group(${THE_FORGE_DIR}\\Common_3\\OS\\Image FILES ${OS_IMAGE_FILES})

set(OS_MACOS_FILES
		${THE_FORGE_DIR}/Common_3/OS/macOS/macOSBase.mm
        ${THE_FORGE_DIR}/Common_3/OS/macOS/macOSFileSystem.mm
        ${THE_FORGE_DIR}/Common_3/OS/macOS/macOSLog.cpp
        ${THE_FORGE_DIR}/Common_3/OS/macOS/macOSThread.cpp
        )

if (APPLE_PLATFORM MATCHES ON)
    source_group(OS\\macOS FILES ${OS_MACOS_FILES})

    set(OS_PLATFORM_SPECIFIC_FILES ${OS_MACOS_FILES})

    set(RENDERER_FILES ${RENDERER_FILES}
            ../the-forge/Common_3/Renderer/Metal/MetalRaytracing.mm
            ../the-forge/Common_3/Renderer/Metal/MetalMemoryAllocator.h
            ../the-forge/Common_3/Renderer/Metal/MetalRenderer.mm
            ../the-forge/Common_3/Renderer/Metal/MetalShaderReflection.mm
            )

    set(CMAKE_CXX_FLAGS "-x objective-c++")
endif()

set(OS_WINDOWS_FILES
        ../the-forge/Common_3/OS/Windows/WindowsBase.cpp
        ../the-forge/Common_3/OS/Windows/WindowsFileSystem.cpp
        ../the-forge/Common_3/OS/Windows/WindowsLog.cpp
        ../the-forge/Common_3/OS/Windows/WindowsStackTraceDump.cpp
        ../the-forge/Common_3/OS/Windows/WindowsStackTraceDump.h
        ../the-forge/Common_3/OS/Windows/WindowsThread.cpp
        ../the-forge/Common_3/OS/Windows/WindowsTime.cpp
        )

if (WINDOWS MATCHES ON)
    source_group(OS\\Windows FILES ${OS_WINDOWS_FILES})

    set(OS_PLATFORM_SPECIFIC_FILES ${OS_WINDOWS_FILES})

    set(RENDERER_FILES ${RENDERER_FILES}
            ../the-forge/Common_3/Renderer/Vulkan/Vulkan.cpp
            ../the-forge/Common_3/Renderer/Vulkan/VulkanCapsBuilder.h
            ../the-forge/Common_3/Renderer/Vulkan/VulkanRaytracing.cpp
            ../the-forge/Common_3/Renderer/Vulkan/VulkanShaderReflection.cpp
            )
endif()

source_group(Renderer FILES ${RENDERER_FILES})

source_group(Logging FILES ${LOGGING_FILES})

source_group(Core FILES ${CORE_FILES})

source_group(ThirdParty\\OpenSource\\EASTL FILES ${THIRDPARTY_OSS_EASTL_FILES})

source_group(ThirdParty\\OpenSource\\TinyEXR FILES ${THIRDPARTY_OSS_TINYEXR_FILES})

source_group(Middleware_3\\ECS FILES ${MIDDLEWARE_ECS_FILES})

source_group(Middleware_3\\UI FILES ${MIDDLEWARE_UI_FILES})

add_library(the-forge STATIC
        ${OS_INTERFACES_FILES}
        ${OS_INPUT_FILES}
        ${OS_FILESYSTEM_FILES}
        ${OS_MEMORYMANAGER_FILES}
        ${OS_CAMERA_FILES}
        ${OS_MATH_FILES}
        ${OS_IMAGE_FILES}
        ${OS_PLATFORM_SPECIFIC_FILES}
        ${RENDERER_FILES}
        ${THIRDPARTY_OSS_EASTL_FILES}
        ${THIRDPARTY_OSS_TINYEXR_FILES}
        ${LOGGING_FILES}
        ${OS_CORE_FILES}
        ${MIDDLEWARE_ECS_FILES}
        ${MIDDLEWARE_UI_FILES}
        ${RMEM_FILES}
        ${GAINPUT_STATIC_FILES}
        )

set_property(TARGET the-forge PROPERTY CXX_STANDARD 17)

target_link_libraries(the-forge ${RENDER_LIBRARIES} ${GLOBAL_LIBRARIES})
target_include_directories(the-forge PUBLIC ${RENDER_INCLUDES})

target_compile_definitions(the-forge PUBLIC ${GLOBAL_DEFINES})

if (APPLE_PLATFORM MATCHES ON)
    set_property (TARGET the-forge APPEND_STRING PROPERTY COMPILE_FLAGS "-fobjc-arc")
endif()
