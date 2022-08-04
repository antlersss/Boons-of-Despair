
function rgba2uint(r, g, b, a)
  a = a or 1
  local r = bit.lshift(r * 255, 24)
  local g = bit.lshift(g * 255, 16)
  local b = bit.lshift(b * 255, 8)
  local a = a * 255
  return bit.bor( r, g, b, a )
end

local function hslToRgb(h, s, l)
  if s == 0 then return l, l, l end
  local function to(p, q, t)
      if t < 0 then t = t + 1 end
      if t > 1 then t = t - 1 end
      if t < .16667 then return p + (q - p) * 6 * t end
      if t < .5 then return q end
      if t < .66667 then return p + (q - p) * (.66667 - t) * 6 end
      return p
  end
  local q = l < .5 and l * (1 + s) or l + s - l * s
  local p = 2 * l - q
  return to(p, q, h + .33334), to(p, q, h), to(p, q, h - .33334)
end

local function get_color(h, s, l)
  local r, g, b = hslToRgb(h, s, l)
  return {r, g, b}
end

local eid = GetUpdatedEntityID()
local gec_id = EntityGetFirstComponentIncludingDisabled( eid, "GameEffectComponent" )
local current = math.min( ComponentGetValue2( gec_id, "frames" ), 496 ) / 720
local pec_id = EntityGetFirstComponentIncludingDisabled( eid, "ParticleEmitterComponent" )
local rgb_list = get_color( current, 0.9, 0.5 )
local final_color = rgba2uint( 0.9, rgb_list[3], rgb_list[2], rgb_list[1] )
--print( "R:" .. rgb_list[1] .. " G:" .. rgb_list[2] .. " B:" .. rgb_list[3] .. " H:" .. current )   Extol: old print to check rgb values
ComponentSetValue2( pec_id, "color", final_color )
