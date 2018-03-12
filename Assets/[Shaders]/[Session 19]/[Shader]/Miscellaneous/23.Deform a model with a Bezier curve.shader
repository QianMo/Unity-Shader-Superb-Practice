// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Use the mathematical tool "bezier curve" to deform a model in a shader.
// Warning : This way to do it's quite cumbersome!
// More information :
// This shader doesn't work well with some of the Unity's primitives (cube, quad...)
// Import your own models.

Shader "ShaderSuperb/Session19/Miscellaneous/BezierCurve"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_ControlPoint ("Control point", vector) = (1, 1, 1, 1)
	}
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
				float2 uv : TEXCOORD0;
			};

			sampler2D _MainTex;
			float4 _MainTex_ST;
			float4 _ControlPoint;


			v2f vert (appdata_base v)
			{
				v2f o;
				float3 begin = float3(-0.5, v.vertex.y, v.vertex.z);
				float3 end = float3(0.5, v.vertex.y, v.vertex.z);

				float vertX = v.vertex.x + 0.5;

				v.vertex.xyz = (1 - vertX) * (1 - vertX) * begin.xyz
				+ 2.0 * (1 - vertX) * vertX * _ControlPoint.xyz;
				+ vertX * vertX * end.xyz;

				o.pos = UnityObjectToClipPos(v.vertex);
				o.uv = TRANSFORM_TEX(v.texcoord, _MainTex);
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				return tex2D(_MainTex, i.uv);
			}
			ENDCG
		}
	}
}