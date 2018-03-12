//Draw an arabesque pattern

Shader "ShaderSuperb/Session19/Noises or Patternscf/Noise/Truchet - Arabesque"
{
	Properties
	{
		_Factor1 ("Factor 1", float) = 1.0
		_Factor2 ("Factor 2", float) = 1.0
		_Factor3 ("Factor 3", float) = 1.0

		_GridSize ("GridSize", float) = 1.0
		_Border ("Border", range(0.0, 0.5)) = 0.1
	}

	SubShader
	{
		Tags { "RenderType"="Opaque" }

		Pass
		{
			CGPROGRAM
			#pragma vertex vert_img
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			
			float _Factor1;
			float _Factor2;
			float _Factor3;

			float _GridSize;

			float2 truchetPattern(float2 uv, float index)
			{
				index = frac((index - 0.5) * 2.0);

				if(index > 0.75)
				{
					return float2(1.0, 1.0) - uv;
				}
				
				if(index > 0.5)
				{
					return float2( uv.x, uv.y);
				}

				if(index > 0.25)
				{
					return 1.0 - float2(1.0 - uv.x, uv.y);
				}

				return uv;
			}

			float noise(half2 uv)
			{
				return frac(sin(dot(uv, float2(_Factor1, _Factor2))) * _Factor3);
			}

			#define Circle(uv, center, radius, border)  step(length(uv - center), radius + border/2) - step(length(uv - center), radius - border/2)

			float _Border;

			fixed4 frag (v2f_img i) : SV_Target
			{
				i.uv *= _GridSize;
				float2 intVal = floor(i.uv);
				float2 fracVal = frac(i.uv);

				float2 tile = truchetPattern(fracVal, noise(intVal));

				fixed val = Circle(tile, float2(0.5, 1.0), 0.25, _Border)
				+ Circle(tile, float2(0.0, 0.0), 0.25, _Border)
				+ Circle(tile, float2(0.0, 0.5), 0.25, _Border)
				+ Circle(tile, float2(0.0, 1.0), 0.50, _Border)
				+ Circle(tile, float2(1.0, 0.0), 0.50, _Border)
				+ Circle(tile, float2(1.0, 0.0), 0.25, _Border)
				+ Circle(tile, float2(1.0, 0.625), 0.125, _Border);

				return fixed4(val, val, val, 1);
			}
			ENDCG
		}
	}
}