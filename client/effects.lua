-- ตัวอย่างการทำเอฟเฟกต์ blackout
local function doBlackout(ms)
    DoScreenFadeOut(500)
    Wait(ms or 500)
    DoScreenFadeIn(500)
end

-- shake, sway, breath, etc.
-- Implement ฟังก์ชันอื่นๆ ตาม type ที่กำหนดใน StatusConfig.thresholds
