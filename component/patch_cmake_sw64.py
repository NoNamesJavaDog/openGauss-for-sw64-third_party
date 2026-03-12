#!/usr/bin/env python3
"""Patch CMakeLists.txt for sw_64 (Sunway CPU / GCC 8.3):
   1. Remove -msse4.2 (x86-specific)
   2. Remove -Wno-enum-conversion (GCC 9+ only)
   3. Change -Wcast-align to -Wno-cast-align
"""
import sys
p = sys.argv[1] if len(sys.argv) > 1 else 'CMakeLists.txt'
c = open(p).read()

# Fix 1: -msse4.2
old1 = ('else ()\n'
        '    add_compile_options(-msse4.2 )\n'
        'endif ()\n')
new1 = ('elseif (OS_ARCH STREQUAL "x86_64" OR OS_ARCH STREQUAL "i686")\n'
        '    add_compile_options(-msse4.2 )\n'
        'endif ()\n')
if old1 in c:
    c = c.replace(old1, new1, 1)
    print(f'[OK] msse4.2 restricted to x86')
elif new1 in c:
    print(f'[INFO] msse4.2 already patched')
else:
    print(f'[WARN] msse4.2 pattern not found')

# Fix 2: remove -Wno-enum-conversion (GCC 9+ only)
c = c.replace('add_compile_options(-Wno-enum-conversion)\n', '# sw_64: removed -Wno-enum-conversion (requires GCC 9+)\n')

# Fix 3: -Wcast-align -> -Wno-cast-align
c = c.replace('add_compile_options(-Wcast-align)\n', 'add_compile_options(-Wno-cast-align)\n')

open(p, 'w').write(c)
print(f'[OK] DSS CMakeLists.txt patched for sw_64')
