--- Population crowth
-- → 1 clock
-- → 2 r
--   1 value x_n     →
--   2 value x_{n-1} →
--   3 value x_{n-2} →
--   4 value x_{n-3} →

MINR  = 3
MAXR  = 4
MAXV  = 10 -- Eurorack spec

function logistic_map(x_prev)
    return public.r * x_prev * (1-x_prev)
end

function init()
    public{r      = 3.2}:range(MINR, MAXR):type('@')
    public{values = {0.1, 0.1, 0.1, 0.1}}:type('@')
    public{case   = 'osc 2'}:type('@')

    input[1]{mode = 'change', direction='rising'}
    input[1].change = function()
        local x = logistic_map(public.values[1])

        table.insert(public.values, 1, x)
        if #public.values > 4 then
            table.remove(public.values, 5)
        end

        for i=1,4 do
            output[i].volts = public.values[i] * MAXV
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
