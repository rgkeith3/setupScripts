{|numBufs=12|
	var fibSinWt, randSinWt, mirSinWt, fibChebyWt, randChebyWt, mirChebyWt, pyrSinWt, envWt;
	fibSinWt = {|b, i|
		var wt = Signal.sineFill(512, Array.fib(i)).asWavetable;
		b.loadCollection(wt);
	};
	randSinWt = {|b, i|
		var wt = Signal.sineFill(512, Array.rand2(i, i.asFloat)).asWavetable;
		b.loadCollection(wt);
	};
	mirSinWt = {|b, i|
		var wt = Signal.sineFill(512, ([1,0]!i).flatten, Array.rand2(2*i, 1.0)).asWavetable;
		b.loadCollection(wt);
	};
	
	fibChebyWt = {|b, i|
		var wt = Signal.chebyFill(512, Array.fib(i)).asWavetable;
		b.loadCollection(wt);
	};
	randChebyWt = {|b, i|
		var wt = Signal.chebyFill(512, Array.rand2(i, i.asFloat)).asWavetable;
		b.loadCollection(wt);
	};
	mirChebyWt = {|b, i|
		var wt = Signal.chebyFill(512, ([1,0]!i).flatten).asWavetable;
		b.loadCollection(wt);
	};
	pyrSinWt = {|b, i|
		var wt = Signal.sineFill(512, ([1,0]!i).flatten.pyramid(i%10)).asWavetable;
		b.loadCollection(wt);
	};
	envWt = {|b, i|
		var numSegs, env, wt;
		numSegs = i+1;
		env = Env(
			{rrand(-1.0, 1.0)}!(numSegs + 1) * [-1, 1],
			{rrand(0.0, 5.0)}!numSegs,
			{rrand(-5.0, 5.0)}!numSegs
		);
		wt = env.asSignal(512).asWavetable;
		b.loadCollection(wt);
	};
	
	
	s.waitForBoot {
		w = [fibSinWt, randSinWt, mirSinWt, fibChebyWt, randChebyWt, mirChebyWt, pyrSinWt, envWt].collect {|func|
			Buffer.allocConsecutive(numBufs, s, 1024).collect(func);
		};
	};
	w;
}