find_package(Git QUIET)

execute_process(COMMAND "${GIT_EXECUTABLE}" -C The-Forge describe --abbrev=0 --tags
                WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
                OUTPUT_VARIABLE GIT_LATEST_TAG
                ERROR_QUIET)

string(REGEX MATCH "v([^\)]+)\\."
        PROJECT_VERSION_MAJOR ${GIT_LATEST_TAG})
string(REGEX MATCH "\\.([^\)]+)"
        PROJECT_VERSION_MINOR ${GIT_LATEST_TAG})

# set project specific versions
set(PROJECT_VERSION ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR})
