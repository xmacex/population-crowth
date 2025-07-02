--- Population crowth
-- Patch programmable r, patch output1 to input1
-- → 1 t_{-1}
-- → 2 r
--   1 r            →
--   2 value t_     →
--   3 value t_{-1} →
--   4 value t_{-2} →

MINR  = 3
MAXR  = 4
MAXV  = 10 -- Eurorack spec
SCALE = 5

function l(t_)
    return public.r*t_*(1-t_)
end

function tick()
    while true do
        public.t = input[1].volts / MAXV
        output[1].volts = l(public.t) * MAXV

        table.insert(public.values, 1, public.t)
        if #public.values > 3 then
            table.remove(public.values, 4)
        end

        -- logistic map and history at outputs 2-4
        for i=2,4 do
            output[i].volts = public.values[i-1] * SCALE
        end

        -- visualize
        for i=2,4 do
            public.view.output[i]()
        end

        -- clock.sleep(1)
        clock.sync(1/public.clockdiv)
    end
end


function init()
    public{clockdiv = 4}:range(1, 128)
    public{t        = 0.02 }:type('@slider'):range(0,1)
    public{r        = 3.2}:range(MINR, MAXR):type('@')
    public{values   = {0.1, 0.1, 0.1, 0.1}}:type('@')
    public{case     = 'osc 2'}:type('@') --:options{'osc 2', 'osc 4', 'osc 8', 'osc n', 'kaos'}

    input[1]{mode = 'none'}

    input[2]{mode = 'stream', time = 0.01 }
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
end
