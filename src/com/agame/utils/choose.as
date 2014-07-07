package com.agame.utils
{
	public function choose(... args):*
	{
		return args[Math.floor(Math.random() * args.length)];
	}
}
