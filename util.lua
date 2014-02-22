function directionToVector(dir)
  if dir == 1 then
    return { x = 0, y = -1 }
  elseif dir == 2 then
    return { x = 1, y = 0 }
  elseif dir == 3 then
    return { x = 0, y = 1 }
  elseif dir == 4 then
    return { x = -1, y = 0 }
  else
    error "Major fuckup; direction bad"
  end
end

function pickRandomDirection()
  return love.math.random(1,4)
end 