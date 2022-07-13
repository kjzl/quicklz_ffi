<!-- 
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/guides/libraries/writing-package-pages). 

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-library-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/developing-packages). 
-->

## QuickLZ v1.5 in Dart via FFI - currently limited to Windows only...

...with following Settings:

COMPRESSION_LEVEL = 1
>Set to 1, 2 or 3. Level 1 gives the fastest compression speed while level 3 gives the fastest decompression speed.

MEMORY_SAFE = false
>If enabled, decompression of corrupted data cannot crash, meaning that it's guaranteed to terminate and guaranteed not to make spurious memory access. Enabling decreases decompression speed in the order of 15-20%.

STREAMING_BUFFER = 0
>Because LZ compression is based on finding repeated strings, compression ratio can degrade if a data entity is being split into smaller packets (less than 10 - 50 Kbytes) that are compressed individually.
>Set to 0 to disable streaming mode or to 100000 or 1000000 (suggested values) to enable and make QuickLZ store a history buffer of QLZ_STREAMING_BUFFER bytes in size.
>When enabled, data must be decompressed in the same order as it was compressed. Further issues apply - see the manual for the C version.

## Additional information
http://www.quicklz.com/index.php
>QuickLZ is the world's fastest compression library, reaching 308 Mbyte/s per core. It can be used under a commercial license if such has been acquired or under GPL 1, 2 or 3 where anything released into public must be open source.
>Simple to use and easy to integrate. Get done in minutes and continue developing!
>
>Streaming mode for optimal compression ratio of small packets down to 200 - 300 bytes in size.
>
>Auto-detection and fast treatment of incompressible data.
