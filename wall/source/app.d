import std.stdio;
import std.random;
import std.algorithm;
import std.range;
import std.parallelism;

void main()
{
	enum N = 3000;
	enum STEP = 5000;

	double[][] py = new double[][](STEP, N);
	double[][] _vy = new double[][](STEP, N);
	double[][] vy = new double[][](STEP, N);
	py[0][] = 0;
	_vy[0][] = 0;
	vy[0][] = 0;
	foreach (i; 1 .. STEP)
	{
		py[i][] = py[i - 1][] + _vy[i - 1][];
		foreach (x; iota(0, N).parallel())
		{
			vy[i][x] = vy[i - 1][x] + uniform(-0.01, 0.01);
			auto tmp = vy[i-1][max(0, x - 1000) .. min(x + 1000, N)];
			_vy[i][x] = tmp.sum() / tmp.length;
			assert(_vy[i][x] != double.nan);
		}
	}

	writeln(`<svg xmlns="http://www.w3.org/2000/svg" stroke-width="1" fill="none" stroke="black" viewBox="0 0 300 300" stroke-opacity="0.05">`);

	enum OFFSET = 150;

	foreach (i; 0 .. STEP)
	{
		if (i % 10 == 0)
		{
			write(`    <path d="M`, 0, ",", py[i][0] + OFFSET, " ");
			foreach (x; 1 .. N)
			{
				write("L", cast(double)x / 10.0, ",", (py[i][x]).min(150).max(-150) + OFFSET, " ");
			}
			writeln(`"/>`);
		}

	}
	writeln(`</svg>`);
}
