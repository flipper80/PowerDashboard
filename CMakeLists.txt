cmake_minimum_required(VERSION 3.16)

project(PowerDashboard VERSION 0.1 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 REQUIRED COMPONENTS Quick)

qt_standard_project_setup(REQUIRES 6.8)

qt_add_executable(appPowerDashboard
    main.cpp
)

qt_add_qml_module(appPowerDashboard
    URI PowerDashboard
    VERSION 1.0
    QML_FILES
        Main.qml
        RESOURCES components/qmldir
        RESOURCES utils/qmldir
        RESOURCES data/qmldir
        QML_FILES components/AxisSystem.qml
        QML_FILES
        QML_FILES data/J1939Simulator.qml
        QML_FILES components/PowerArc.qml
        QML_FILES
        QML_FILES components/ParametricRect.qml
        QML_FILES data/PolarUtils.qml
        QML_FILES components/HydRectangle.qml
        QML_FILES
        QML_FILES utils/Utilities.qml
        QML_FILES
        QML_FILES utils/TriangularSignal.qml
        QML_FILES components/Animation.qml
        RESOURCES .gitignore
        QML_FILES
        QML_FILES components/PowerArcBackup.qml
        QML_FILES MainBackup.qml
)

# Qt for iOS sets MACOSX_BUNDLE_GUI_IDENTIFIER automatically since Qt 6.1.
# If you are developing for iOS or macOS you should consider setting an
# explicit, fixed bundle identifier manually though.
set_target_properties(appPowerDashboard PROPERTIES
#    MACOSX_BUNDLE_GUI_IDENTIFIER com.example.appPowerDashboard
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
)

target_link_libraries(appPowerDashboard
    PRIVATE Qt6::Quick
)

include(GNUInstallDirs)
install(TARGETS appPowerDashboard
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
