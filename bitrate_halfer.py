"""
reads a PCM audio file from stdin
writes the same file but only half of the bytes (every other byte)
for halfing audio file bitrate
example
 cat file.pcm | python3 bitrate_halfer.py | file_bitrate_halfed.pcm
"""

import sys

audio_bytes = sys.stdin.buffer.read()

modified_data = bytearray()
for i in range(len(audio_bytes) // 2):
    b1 = audio_bytes[2 * i]
    b2 = audio_bytes[2 * i + 1]
    if i % 2 == 0:
        modified_data.append(b1)
        modified_data.append(b2)

sys.stdout.buffer.write(modified_data)
