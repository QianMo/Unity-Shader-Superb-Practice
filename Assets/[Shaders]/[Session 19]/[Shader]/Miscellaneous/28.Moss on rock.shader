// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

//Simulates moss on a model with a texture.

Shader "ShaderSuperb/Session19/Miscellaneous/Moss" 
{
	Properties 
	{
		_MainTex ("Main texture", 2D) = "white" {}
		_MossTex ("Moss texture", 2D) = "gray" {}
		_Direction ("Direction", Vector) = (0, 1, 0)
		_Amount ("Amount", Range(0, 1)) = 1
	}
	SubShader 
	{
		Pass
		{
			Tags { "RenderType"="Opaque" }
		
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#include "UnityCG.cginc"

			struct v2f 
			{
				float4 pos : SV_POSITION;
				float3 normal : NORMAL;
				float2 uv_Main : TEXCOORD0;
				float2 uv_Moss : TEXCOORD1;
			};

			sampler2D _MainTex;
			float4 _MainTex_ST;
			sampler2D _MossTex;
			float4 _MossTex_ST;

			v2f vert(appdata_full v) 
			{
				v2f o;
				o.pos = UnityObjectToClipPos(v.vertex);
				o.uv_Main = TRANSFORM_TEX(v.texcoord, _MainTex);
				o.uv_Moss = TRANSFORM_TEX(v.texcoord, _MossTex);
				o.normal = mul(unity_ObjectToWorld, v.normal);
				return o;
			}

			
			float3 _Direction;
			fixed _Amount;

			fixed4 frag(v2f i) : COLOR 
			{
				fixed val = dot(normalize(i.normal), _Direction);

				if(val < 1 - _Amount)
					val = 0;

				fixed4 tex1 = tex2D(_MainTex, i.uv_Main);
				fixed4 tex2 = tex2D(_MossTex, i.uv_Moss);
				return lerp(tex1, tex2, val);
			}

			ENDCG
		}
	} 
	FallBack "Diffuse"
}