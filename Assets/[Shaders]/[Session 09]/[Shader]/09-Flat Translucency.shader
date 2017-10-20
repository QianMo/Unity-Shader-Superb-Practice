// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'
// Upgrade NOTE: replaced '_World2Object' with 'unity_WorldToObject'
// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'
// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'


Shader "ShaderSuperb/Session9/09-Flat Translucency"
{
	Properties 
	{
		_Color ("Color Tint", Color) = (1.0,1.0,1.0,1.0)
		_SpecColor ("Specular Color", Color) = (1.0,1.0,1.0,1.0)
		_Shininess ("Shininess", Float) = 10.0
		_BackScatter ("Back Translucent color", Color) = (1.0,1.0,1.0,1.0)
		_Translucence ("Forward Translucent Color", Color) = (1.0,1.0,1.0,1.0)
		_Intensity ("Translucent Intensity", Float) = 10.0
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
			uniform fixed4 _Color;
	        uniform fixed4 _SpecColor; 
	        uniform half _Shininess; 
	        uniform fixed4 _BackScatter; 
	        uniform fixed4 _Translucence; 
	        uniform half _Intensity; 
			
			//unity defined variables
			uniform half4 _LightColor0;
			
			//base input structs
			struct vertexInput
			{
				half4 vertex : POSITION;
				half3 normal : NORMAL;
			};
			struct vertexOutput
			{
				half4 pos : SV_POSITION;
				fixed3 normalDir : TEXCOORD0;
				fixed4 lightDir : TEXCOORD1;
				fixed3 viewDir : TEXCOORD2;
			};
			
			//vertex Function
			vertexOutput vert(vertexInput v)
			{
				vertexOutput o;
				
				//normalDirection
				o.normalDir = normalize( mul( half4( v.normal, 0.0 ), unity_WorldToObject ).xyz );
				
				//unity transform position
				o.pos = UnityObjectToClipPos(v.vertex);
				
				//world position
				half4 posWorld = mul(unity_ObjectToWorld, v.vertex);
				//view direction
				o.viewDir = normalize( _WorldSpaceCameraPos.xyz - posWorld.xyz );
				//light direction
				half3 fragmentToLightSource = _WorldSpaceLightPos0.xyz - posWorld.xyz;
				o.lightDir = fixed4(
					normalize( lerp(_WorldSpaceLightPos0.xyz , fragmentToLightSource, _WorldSpaceLightPos0.w) ),
					lerp(1.0 , 1.0/length(fragmentToLightSource), _WorldSpaceLightPos0.w)
				);
				
				return o;
			}
			
			//fragment function
			fixed4 frag(vertexOutput i) : COLOR
			{
				
				//Lighting
				//dot product
				fixed nDotL = saturate(dot(i.normalDir, i.lightDir.xyz));
				//diffuse
				fixed3 diffuseReflection = i.lightDir.w * _LightColor0 * nDotL;
				//specular
				fixed3 specularReflection = diffuseReflection * _SpecColor.xyz * pow( saturate( dot( reflect( -i.lightDir.xyz, i.normalDir ), i.viewDir ) ), _Shininess );
				
				//translucency
				fixed3 backScatter = i.lightDir.w * _LightColor0.xyz * _BackScatter.xyz * saturate( dot( i.normalDir, -i.lightDir.xyz ) );
				fixed3 translucence = i.lightDir.w * _LightColor0.xyz * _Translucence.xyz * pow( saturate( dot(-i.lightDir.xyz, i.viewDir) ), _Intensity );
				
				fixed3 lightFinal = diffuseReflection + specularReflection + backScatter + translucence + UNITY_LIGHTMODEL_AMBIENT.xyz;
				
				return fixed4(lightFinal * _Color.xyz, 1.0);
			}
			
			ENDCG
			
		}
	}
	//Fallback "Specular"
}
