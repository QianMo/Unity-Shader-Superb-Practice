// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'
// Upgrade NOTE: replaced '_World2Object' with 'unity_WorldToObject'
// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'



Shader "ShaderSuperb/Session9/04-CubeMap Reflections - refract"
{
	Properties
	{
		_Cube ("Cube Map", Cube) = "" {}
	}

	SubShader
	{
		Pass 
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			
			//user defined variables
			uniform samplerCUBE _Cube;
			
			//Base Input Structs
			struct vertexInput 
			{
				float4 vertex : POSITION;
				float3 normal : NORMAL;
			};
			struct vertexOutput 
			{
				float4 pos : SV_POSITION;
				float3 normalDir : TEXCOORD0;
				float3 viewDir : TEXCOORD1;
			};
			
			//vertex function
			vertexOutput vert(vertexInput v)
			{
				vertexOutput o;
				
				o.normalDir = normalize( mul(float4(v.normal, 0.0), unity_WorldToObject).xyz );
				o.viewDir = float3(mul(unity_ObjectToWorld, v.vertex) - _WorldSpaceCameraPos).xyz;
				
				o.pos = UnityObjectToClipPos(v.vertex);
				return o;
			}
			//fragment function
			float4 frag(vertexOutput i) : COLOR
			{
				// use refract.no reflect.  refract the ray based on the normals to get the cube coordinates
				float3 reflectDir = refract(i.viewDir, i.normalDir, 1/1.3 );
				
				//texture maps
				float4 texC = texCUBE(_Cube, reflectDir);
				
				return texC;
			}

			ENDCG

		}
	}
	//Fallback "Diffuse"
}
