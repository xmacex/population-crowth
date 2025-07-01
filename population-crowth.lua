---logistic map
-- → 1  clock
-- → 2  r
--   1 value t      →
--   2 value t_{-1} →
--   3 value t_{-2} →
--   4 value t_{-3} →

MINR  = 3
MAXR  = 4
MAXV  = 10 -- Eurorack spec
SCALE = 5

function l(t_)
    return public.r*t_*(1-t_)
end

function init()
    public{r      = 3.2}:range(MINR, MAXR):type('@')
    public{values = {0.1, 0.1, 0.1, 0.1}}:type('@')
    public{case   = 'osc 2'}:options{'osc 2', 'osc 4', 'osc 8', 'osc n', 'kaos'}:type('@')

    input[1]{mode = 'change', direction='rising'}
    input[1].change = function()
        local t = l(public.values[1])

        table.insert(public.values, 1, t)
        if #public.values > 4 then
            table.remove(public.values, 5)
        end

        for i=1,4 do
            output[i].volts = public.values[i] * SCALE
            public.view.output[i]() -- visualize
        end
    end

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
end
