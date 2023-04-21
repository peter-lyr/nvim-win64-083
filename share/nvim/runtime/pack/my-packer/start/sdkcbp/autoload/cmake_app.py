import os
import re
import sys

rootdir = sys.argv[1].replace('\\', '/')

projectName = sys.argv[2].replace('\\', '/')

projFileNames = []
projFileNames_last = []

patt1 = re.compile('directory="(.+)"')
patt2 = re.compile('<File name="(.+?)"')
with open(os.path.join(rootdir, 'CMakeLists.txt'), 'wb') as ff:
  ff.write(b'cmake_minimum_required(VERSION 3.5)\n')
  ff.write(b'set(PROJECT_NAME proj_name)\n')
  ff.write(b'project(${PROJECT_NAME})\n\n')
  d = {}
  for i, j, k in os.walk(rootdir):
    for f in k:
      if f.split('.')[-1] == 'cbp':
        if f == 'app.cbp':
          if projectName != 'projects' and projectName not in i.replace(rootdir, ''):
            continue

        ss = os.path.join(i, f).replace(rootdir, '').strip('/').strip('\\')
        if f == 'app.cbp':
          projFileNames_last = [ss]
        else:
          projFileNames.append(ss)
        with open(os.path.join(i, f), 'rb') as fff:
          content = fff.read().decode('utf-8')
        directories = re.findall(patt1, content)
        directories = [os.path.normpath(os.path.join(i, directory)) for directory in directories]
        d[ss] = directories

  for key, val in d.items():
    if key.split('.')[0].split('\\')[-1] == 'app':
      xl = key.split('\\')[0]
      ff.write(("file(GLOB_RECURSE SOURCE_FILES ${CMAKE_CURRENT_SOURCE_DIR}/%s/*.c)\n" % xl).encode('utf-8'))
      ff.write(("file(GLOB_RECURSE ASM_SOURCE_FILES ${CMAKE_CURRENT_SOURCE_DIR}/%s/*.S)\n" % xl).encode('utf-8'))
      ff.write(b"add_executable(${PROJECT_NAME} ${SOURCE_FILES} ${ASM_SOURCE_FILES})\n")
      bb = ['target_include_directories(${PROJECT_NAME} PUBLIC ${PROJECT_SOURCE_DIR}/%s)' % aa.replace('\\', '/').replace(rootdir, '').strip('\\').strip('/').replace('\\', '/') for aa in val]
      ff.write(('\n'.join(bb).encode('utf-8')) + b'\n\n')
    elif key.split('.')[0].split('\\')[0] == 'libs':
      xl = '/'.join(key.split('\\')[0:2])
      libname = key.split('\\')[1]
      ff.write(("file(GLOB_RECURSE SOURCE_FILES ${CMAKE_CURRENT_SOURCE_DIR}/%s/*.c)\n" % xl).encode('utf-8'))
      ff.write(("file(GLOB_RECURSE ASM_SOURCE_FILES ${CMAKE_CURRENT_SOURCE_DIR}/%s/*.S)\n" % xl).encode('utf-8'))
      ff.write(("add_library(%s STATIC ${SOURCE_FILES} ${ASM_SOURCE_FILES})\n" % libname).encode('utf-8'))
      bb = ['target_include_directories(%s PUBLIC ${PROJECT_SOURCE_DIR}/%s)' % (libname, aa.replace('\\', '/').replace(rootdir, '').strip('\\').strip('/').replace('\\', '/')) for aa in val]
      ff.write(('\n'.join(bb).encode('utf-8')) + b'\n')
      ff.write(("target_link_libraries(${PROJECT_NAME} %s)\n\n" % libname).encode('utf-8'))

  #  ff.write(b'file(GLOB libraries ${CMAKE_CURRENT_SOURCE_DIR}/app/platform/libs/*.a)\n')
  #  ff.write(b'target_link_libraries(${PROJECT_NAME} ${libraries})\n')

projFileNames = [fname.replace("/", "\\") for fname in projFileNames + projFileNames_last]
projFileNames = [f'    <Project filename="{fname}" />' for fname in projFileNames]
with open(os.path.join(rootdir, f'{projectName}.workspace'), 'wb') as ff:
  ff.write(b'<?xml version="1.0" encoding="UTF-8" standalone="yes" ?>\n')
  ff.write(b'<CodeBlocks_workspace_file>\n')
  ff.write(b'  <Workspace title="Workspace">\n')
  ff.write(('\n'.join(projFileNames).encode('utf-8')) + b'\n')
  ff.write(b'  </Workspace>\n')
  ff.write(b'</CodeBlocks_workspace_file>\n')

os.system('cd ' + rootdir + r' && del /s /q .cache & rd /s /q .cache & del /s /q build & rd /s /q build & cmake -B build -G "MinGW Makefiles" -DCMAKE_EXPORT_COMPILE_COMMANDS=1 && cd build & copy compile_commands.json ..\ /y & cd ..')
