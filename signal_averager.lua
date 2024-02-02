-- reads a PCM file from stdin
-- writes the same file but with a rolling average
-- for "smoothing" an audio file
-- this mostly just makes the file sound really muffled. which is pretty funny I guess
-- example
--   cat file.pcm | lua signal_averager.lua > file_signal_averaged.pcm
-- you can also provide how many samples over which to take the median (default 30)
--   with an argument to the lua script, e.g.,
--    cat file.pcm | lua signal_averager.lua 50 > file_signal_averaged.pcm

-- 2 bytes per audio file sample
BYTES_PER_SAMPLE = 2
LITTLE_ENDIAN_16_BIT_FORMAT = "<i2"

-- number of samples to take rolling median over
MEDIAN_NO = 30
if arg[1] then MEDIAN_NO = arg[1] end

local i = 1
local bytes = {}
while true do
  local c = io.read(BYTES_PER_SAMPLE)
  if c == nil then break end

  -- unpack string to little-endian 16-bit integer
  local byte = string.unpack(LITTLE_ENDIAN_16_BIT_FORMAT, c)

  -- keep track of bytes for median-ing
  bytes[i] = byte

  -- get bytes of most recent MEDIAN_NO bytes
  local localgroup = {}
  local k = 1
  for j = -MEDIAN_NO, 0 do
    if bytes[i + j] then
      localgroup[k] = bytes[i + j]
      k = k + 1
    end
  end

  -- sort and find median (index half the length)
  table.sort(localgroup)
  local median
  if #localgroup % 2 == 1 then
    median = localgroup[(#localgroup + 1) / 2]
  else
    median = localgroup[(#localgroup) / 2]
  end

  -- write back to stdout
  io.write(string.pack(LITTLE_ENDIAN_16_BIT_FORMAT, median))

  i = i + 1
end
