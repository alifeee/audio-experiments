-- reads a PCM file from stdin
-- writes the same file but at twice the volume (truncated(?))
-- for doubling audio file volume
-- example
--  cat file.pcm | lua double_volume.lua | file_volume_doubled.pcm

-- 2 bytes per audio file sample
BYTES_PER_SAMPLE = 2
LITTLE_ENDIAN_16_BIT_FORMAT = "<i2"

while true do
  local c = io.read(BYTES_PER_SAMPLE)
  if c == nil then break end

  -- unpack string to little-endian 16-bit integer
  local byte = string.unpack(LITTLE_ENDIAN_16_BIT_FORMAT, c)

  local louder_byte = byte * 2

  io.write(string.pack(LITTLE_ENDIAN_16_BIT_FORMAT, louder_byte))
end
