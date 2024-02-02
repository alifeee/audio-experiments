--[[
  reads a PCM audio file from stdin
  writes the same file but only half of the bytes (every other byte)
  for halfing audio file bitrate
  example
    cat file.pcm | lua bitrate_halfer.lua | file_bitrate_halfed.pcm
]]

-- 2 bytes per audio file sample
BYTES_PER_SAMPLE = 2

local i = 0
while true do
  local c = io.read(BYTES_PER_SAMPLE)
  if c == nil then break end

  if i % 2 == 0 then
    io.write(c)
  end

  i = i + 1
end
