// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'
// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'


Shader "ShaderSuperb/Session9/08-Depth of Field"
{
	Properties 
	{
		_MainTex ("Diffuse Texture", 2D) = "white" {}
		_BlurTex ("Blur Texture", 2D) = "white" {}
		_Color ("Color Tint", Color) = (1.0,1.0,1.0,1.0)
		_FogColor ("Fog Color", Color) = (1.0,1.0,1.0,1.0)
		_RangeStart ("Fog Close Distance", Float) = 25
		_RangeEnd ("Fog Far Distance", Float) = 25
		_BlurSize ("Blur Size", Range(0.0,1.0)) = 1.0
	}
	
	SubShader 
	{
		Pass 
		{
			Tags {"LightMode" = "ForwardBase"}
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			//user defined variables
			uniform sampler2D _MainTex;
			uniform half4 _MainTex_ST;
			uniform sampler2D _BlurTex;
			uniform half4 _BlurTex_ST;
			uniform fixed4 _Color;
			uniform fixed4 _FogColor;
			uniform half _RangeStart;
			uniform half _RangeEnd;
			uniform fixed _BlurSize;
			
			//unity defined variables
			uniform half4 _LightColor0;
			
			//base input structs
			struct vertexInput
			{
				half4 vertex : POSITION;
				half4 texcoord : TEXCOORD0;
			};

			struct vertexOutput
			{
				half4 pos : SV_POSITION;
				fixed depth : TEXCOORD0;
				half4 tex : TEXCOORD1;
			};
			
			//vertex Function
			vertexOutput vert(vertexInput v)
			{
				vertexOutput o;
				
				//unity transform position
				o.pos = UnityObjectToClipPos(v.vertex);
				
				//clamp z-depth to range
				o.depth = saturate( ( distance( mul(unity_ObjectToWorld, v.vertex) , _WorldSpaceCameraPos.xyz) -_RangeStart)/_RangeEnd );
				
				o.tex = v.texcoord;
				return o;
			}
			
			//fragment function
			fixed4 frag(vertexOutput i) : COLOR
			{
				//textures
				fixed4 tex = tex2D(_MainTex, _MainTex_ST.xy * i.tex.xy + _MainTex_ST.zw);
				fixed4 texB = tex2D(_BlurTex, _BlurTex_ST.xy * i.tex.xy + _BlurTex_ST.zw);
				
				//lerp based on distance
				fixed4 colorBlur = lerp(tex, texB, i.depth * _BlurSize);
				
				//return color
				return fixed4(colorBlur * _Color.xyz + i.depth * _FogColor.xyz, 1.0);
			}
			
			ENDCG
			
		}
	}
	//Fallback "Specular"
}
