// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'
// Upgrade NOTE: replaced '_World2Object' with 'unity_WorldToObject'
// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'



Shader "ShaderSuperb/Session9/10-Vertex Animation"
{
	Properties 
	{
		_Color ("Color Tint", Color) = (1.0,1.0,1.0,1.0)
		_SpecColor ("Specular Color", Color) = (1.0,1.0,1.0,1.0)
		_Shininess ("Shininess", Float) = 10.0
		_AnimSpeed ("Animation Speed", Float) = 10.0
		_AnimFreq ("Animation Frequency", Float) = 1.0
		_AnimPowerX ("Animation Power X", Float) = 0.0
		_AnimPowerY ("Animation Power Y", Float) = 0.1
		_AnimPowerZ ("Animation Power Z", Float) = 0.0
		_AnimOffsetX ("Animation Offset X", Float) = 10.0
		_AnimOffsetY ("Animation Offset Y", Float) = 0.0
		_AnimOffsetZ ("Animation Offset Z", Float) = 0.0
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
	        //animation
	        uniform half _AnimSpeed;
	        uniform half _AnimFreq;
	        uniform half _AnimPowerX;
	        uniform half _AnimPowerY;
	        uniform half _AnimPowerZ;
	        uniform half _AnimOffsetX;
	        uniform half _AnimOffsetY;
	        uniform half _AnimOffsetZ;
			
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
				
				//animation
				half3 animOffset = half3(_AnimOffsetX, _AnimOffsetY, _AnimOffsetZ) * v.vertex.xyz;
				half3 animPower = half3(_AnimPowerX, _AnimPowerY, _AnimPowerZ);
				half4 newPos = v.vertex;
				newPos.xyz = newPos.xyz + sin(_Time.x * _AnimSpeed + (animOffset.x + animOffset.y + animOffset.z) * _AnimFreq) * animPower.xyz;
				
				//normalDirection
				o.normalDir = normalize( mul( half4( v.normal, 0.0 ), unity_WorldToObject ).xyz );
				
				//unity transform position
				o.pos = UnityObjectToClipPos(newPos);
				
				//world position
				half4 posWorld = mul(unity_ObjectToWorld, newPos);
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
				
				fixed3 lightFinal = diffuseReflection + specularReflection + UNITY_LIGHTMODEL_AMBIENT.xyz;
				
				return fixed4(lightFinal * _Color.xyz, 1.0);
			}
			
			ENDCG
			
		}
	}
	//Fallback "Specular"
}
