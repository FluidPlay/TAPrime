-- "missiletrailcorroyspecial"

return {
     ["missiletrailcorroyspecial"] = {
    --groundflash = {
    --  circlealpha        = 0,
    --  circlegrowth       = 0,
    --  flashalpha         = 0.025,
    --  flashsize          = 50,
    --  ttl                = 12,
    --  color = {
    --    [1]  = 1,
    --    [2]  = 0.75,
    --    [3]  = 0.25,
    --  },
    --},
    -- engine = {
      -- air                = true,
      -- class              = [[CBitmapMuzzleFlame]],
      -- count              = 1,
      -- ground             = true,
      -- underwater         = 1,
      -- water              = true,
      -- properties = {
        -- colormap           = [[1 0.7 0.4 0.01   1.0 0.66 0.25 0.01   1.0 0.5 0.15 0.01   0.55 0.3 0.1 0.012   0 0 0 0   0 0 0 0]],
        -- dir                = [[dir]],
        -- frontoffset        = 0,
        -- fronttexture       = [[none]],
        -- length             = -1,
        -- sidetexture        = [[muzzleside]],
        -- size               = 4.3,
        -- sizegrowth         = 0,
        -- ttl                = 27,
      -- },
    -- },
	    fire = {
      air                = true,
      class              = [[CSimpleParticleSystem]],
      count              = 1,
      ground             = true,
      water              = true,
      properties = {
        airdrag            = 0.25,
        colormap           = [[0.85 0.66 0.33 0.15   0.44 0.26 0.09 0.2    0.27 0.055 0 0.17    0.08 0.03 0 0.11    0.02 0.0066 0 0.06	 0 0 0 0.01]],
        directional        = true,
        emitrot            = 45,
        emitrotspread      = 45,
        emitvector         = [[0.0, 1, 0.0]],
        gravity            = [[0.0, 0.1, 0.0]],
        numparticles       = 7,
        particlelife       = 5,
        particlelifespread = 4,
        particlesize       = 2.15,
        particlesizespread = 1.4,
        particlespeed      = 0.75,
        particlespeedspread = 2.1,
        pos                = [[0.0, 2, 0.0]],
        sizegrowth         = -0.36,
        sizemod            = 0.9,
        texture            = [[dirt]],
        useairlos          = true,
      },
    },
    fireglow = {
      air                = true,
      class              = [[CSimpleParticleSystem]],
      count              = 1,
      ground             = true,
      water              = true,
      properties = {
        airdrag            = 0,
        colormap           = [[0.1 0.08 0.025 0.08   0 0 0 0.01]],
        directional        = true,
        emitrot            = 90,
        emitrotspread      = 0,
        emitvector         = [[0.0, 1, 0.0]],
        gravity            = [[0.0, 0.0, 0.0]],
        numparticles       = 1,
        particlelife       = 2,
        particlelifespread = 0,
        particlesize       = 40,
        particlesizespread = 6,
        particlespeed      = 0,
        particlespeedspread = 0,
        pos                = [[0.0, 0, 0.0]],
        sizegrowth         = -1.7,
        sizemod            = 1,
        texture            = [[dirt]],
        useairlos          = true,
      },
    },
    trail = {
      air                = true,
      class              = [[CSimpleParticleSystem]],
      count              = 1,
      ground             = true,
      water              = true,
      properties = {
        airdrag            = 0.55,
        colormap           = [[0 0 0 0.015 0 0 0 0.23   0.07 0.07 0.07 0.2   0.07 0.07 0.07 0.16   0.06 0.06 0.06 0.12    0.035 0.035 0.035 0.066    0 0 0 0]],
        directional        = true,
        emitrot            = 90,
        emitrotspread      = 0,
        emitvector         = [[0.0, 1, 0.0]],
        gravity            = [[0.0, -0.01, 0.0]],
        numparticles       = 1,
        particlelife       = 30,
        particlelifespread = 28,
        particlesize       = 2.7,
        particlesizespread = 2.7,
        particlespeed      = 0.4,
        particlespeedspread = 0.8,
        pos                = [[0.0, 1, 0.0]],
        sizegrowth         = 0.07,
        sizemod            = 1,
        texture            = [[dirt]],
        useairlos          = true,
      },
    },
  },
  

}

