//Use a texture to retrieve pseudo random values

Shader "ShaderSuperb/Session19/Noises or Patterns/Noise/PseudoRandom"
{
	Properties
	{
		_Factor1 ("Factor 1", float) = 1
		_Factor2 ("Factor 2", float) = 1
		_Factor3 ("Factor 3", float) = 1
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

			float noise(half2 uv)
			{
				return frac(sin(dot(uv, float2(_Factor1, _Factor2))) * _Factor3);
			}

			fixed4 frag (v2f_img i) : SV_Target
			{
				fixed4 col = noise(i.uv);
				return col;
			}
			ENDCG
		}
	}
}