// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// The closer, the lighter a model is.
// Uses the Z Buffer to determine the distance from the camera
// Shader source :
// https://pastebin.com/UdjGnuhK
 
// Camera script :
// https://pastebin.com/etZLkWJD
 
// Models come from :
// http://tf3dm.com/3d-model/house-interior--81890.html


Shader "ShaderSuperb/Session19/Post rendering/ZBuffer"
{
	SubShader
	{
		Tags { "RenderType"="Opaque" }
		
		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#include "UnityCG.cginc"

			struct v2f
			{
				float4 pos : SV_POSITION;
				float4 screenuv : TEXCOORD1;
			};
			
			v2f vert (appdata_base v)
			{
				v2f o;
				o.pos = UnityObjectToClipPos(v.vertex);
				o.screenuv = ComputeScreenPos(o.pos);
				return o;
			}
			
			sampler2D _CameraDepthTexture;

			fixed4 frag (v2f i) : SV_Target
			{
				float2 uv = i.screenuv.xy / i.screenuv.w;
				float depth = 1 - Linear01Depth(SAMPLE_DEPTH_TEXTURE(_CameraDepthTexture, uv));
				return fixed4(depth, depth, depth, 1);
			}
			ENDCG
		}
	}
}