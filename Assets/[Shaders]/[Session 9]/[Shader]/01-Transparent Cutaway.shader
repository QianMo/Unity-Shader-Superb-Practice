// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "ShaderSuperb/Session9/01-Transparent Cutaway"
{
	Properties
	{
		_Color ("Color", Color) = (1.0,1.0,1.0,1.0)
		_Height ("Cutoff Height", Range(-1.0,1.0)) = 1.0
	}
	SubShader
	{
		Tags { "Queue" = "Transparent" }

		Pass 
		{
			Cull Off
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			//user defined variables
			uniform float4 _Color;
			uniform float _Height;
			
			//base input structs
			struct vertexInput 
			{
				float4 vertex : Position;
			};
			struct vertexOutput 
			{
				float4 pos : SV_POSITION;
				float4 vertPos : TEXCOORD0;
			};
			
			//vertex function
			vertexOutput vert(vertexInput v)
			{
				vertexOutput o;
				o.pos = UnityObjectToClipPos(v.vertex);
				o.vertPos = v.vertex;
				return o;
			}
			//fragment function
			float4 frag(vertexOutput i) : COLOR
			{
				if(i.vertPos.y > _Height)
				{
					discard;
				}
				return _Color;
			}
			
			ENDCG
		}
	}
	//Fallback "Diffuse"
}
