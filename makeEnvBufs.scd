{
	var makeEnvBuf;
		e = (
			perc: [[0,0,1],\cub],
			saw: [[0,0,1],\lin],
			trap: [[1,1,1],\sin],
			ramp: [[1,0,0],\lin],
			tri: [[0,1,0],\lin]
		);

		makeEnvBuf = { |times|
			var env = Env([0,1,1,0], times[0], times[1]);
			Buffer.sendCollection(s, env.discretize, 1);
		};

		e.keysValuesChange({|key, envTimes|
			makeEnvBuf.value(envTimes);
		});
}