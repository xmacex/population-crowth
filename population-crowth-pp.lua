--- Population crowth
-- Patch programmable x_{n-1}, patch output1 to input1
-- → 1 x_n
-- → 2 r
--   1 value x_n     →

MINR  = 3
MAXR  = 4
MAXV  = 10 -- Eurorack spec

-- Version of the logistic map which stores data in the cable
function logistic_map_cv_store()
    return public.r * input[1].volts/MAXV * (1-input[1].volts/MAXV)
end

function tick()
    while true do
        -- store the current value of the map in the cable
        output[1].volts = logistic_map_cv_store() * MAXV
        public.view.output[1]() -- visualize
        clock.sync(1/public.clockdiv)
    end
end

function init()
    public{clockdiv = 4}:range(1, 128)
    public{r        = 3.2}:range(MINR, MAXR):type('@')
    public{case     = 'osc 2'}:type('@')

    input[1]{mode = 'none'}

    input[2]{mode = 'stream', time = 0.01}
    input[2].stream = function(v)
        public.r = math.max(MINR, math.min(MINR+v/MAXV, MAXR))
        if     public.r <= 3.44949 then public.case = 'osc 2'
        elseif public.r <= 3.54409 then public.case = 'osc 4'
        elseif public.r <= 3.56441 then public.case = 'osc 8'
        elseif public.r <= 3.56995 then public.case = 'osc n'
        else public.case = 'kaos'
        end
    end

    clock_id = clock.run(tick)
    clock.tempo = 137
end
