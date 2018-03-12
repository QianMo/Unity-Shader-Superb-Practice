// a post rendering effect which acts like a spotlight.
// Camera script :
// https://pastebin.com/UwTPAcYG


Shader "ShaderSuperb/Session19/Post rendering/Spotlight"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_CenterX ("Center X", Range(0.0, 0.5)) = 0.05
		_CenterY ("Center Y", Range(0.0, 0.5)) = 0.36
		_Radius ("Radius", Range(0.01, 0.5)) = 0.4
		_Sharpness ("Sharpness", Range(1, 20)) = 15
	}
	SubShader
	{
		Pass
		{
			CGPROGRAM
			#pragma vertex vert_img
			#pragma fragment frag
			#include "UnityCG.cginc"
			
			sampler2D _MainTex;
			float _CenterX, _CenterY;
			float _Radius;
			float _Sharpness;

			fixed4 frag (v2f_img i) : SV_Target
			{
				float dist = distance(float2(_CenterX, _CenterY), ComputeScreenPos(i.pos).xy / _ScreenParams.x);
				fixed4 col = tex2D(_MainTex, i.uv);
				return col * (1 - pow(dist / _Radius, _Sharpness));
			}

			ENDCG
		}
	}
}