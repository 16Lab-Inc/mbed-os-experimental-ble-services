add_library(mbed-os-experimental-ble-services INTERFACE)

target_include_directories(mbed-os-experimental-ble-services
    INTERFACE
        .
)

add_subdirectory(services)