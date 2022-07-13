cmake_minimum_required(VERSION 3.23)

project(quicklz
  LANGUAGES
    C
)

set(CMAKE_WINDOWS_EXPORT_ALL_SYMBOLS ON)

add_library(quicklz SHARED quicklz.c)
