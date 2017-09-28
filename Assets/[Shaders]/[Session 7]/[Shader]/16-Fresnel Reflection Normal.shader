Shader "ShaderSuperb/Session7/16-Fresnel Reflection Normal"
{
	Properties 
	{
		_MainTint("Diffuse Tint", Color) = (1,1,1,1)
		_MainTex ("Base (RGB)", 2D) = "white" {}
		_NormalMap ("Normal Map", 2D) = "bump" {}
		_Cubemap ("Cubemap", CUBE) = ""{}
		_ReflectionAmount ("Reflection Amount", Range(0,1)) = 1
		_RimPower ("Fresnel Falloff", Range(0.1, 8)) = 2
		_SpecColor ("Specular Color", Color) = (1,1,1,1)
		_SpecPower ("Specular Power", Range(0,1)) = 0.5
	}
	
	SubShader 
	{
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		CGPROGRAM
		#pragma surface surf BlinnPhong
		#pragma target 3.0

		samplerCUBE _Cubemap;
		sampler2D _MainTex;
		sampler2D _NormalMap;
		float4 _MainTint;
		float _ReflectionAmount;
		float _RimPower;
		float _SpecPower;
		

		struct Input 
		{
			float2 uv_MainTex;
			float2 uv_NormalMap;
			float3 worldRefl;
			float3 viewDir;
			//使用uv_BumpMap，物体的平面法线将被修改，若需要使用它来影响反射。可以通过声明INTERNAL_DATA来访问修改后的法线信息
			//以及使用WorldReflectionVector (IN, o.Normal)去查找Cubemap中对应的反射信息。
			INTERNAL_DATA
		};

		void surf (Input IN, inout SurfaceOutput o) 
		{
			half4 c = tex2D (_MainTex, IN.uv_MainTex);
			
			float rim = 1-saturate(dot(o.Normal, normalize(IN.viewDir)));
			rim = pow(rim, _RimPower);

			float3 normals = UnpackNormal(tex2D(_NormalMap, IN.uv_NormalMap)).rgb;
			o.Normal = normals;
		
			o.Albedo = c.rgb * _MainTint.rgb;
			o.Emission = (texCUBE(_Cubemap, WorldReflectionVector(IN, o.Normal)).rgb * _ReflectionAmount)* rim;
			o.Specular = _SpecPower;
			o.Gloss = 1.0;
			o.Alpha = c.a;
		}
		ENDCG
	} 
	FallBack "Diffuse"
}
