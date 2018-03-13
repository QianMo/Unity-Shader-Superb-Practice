//
// Antialiased Cel Shading
//
// We need to chop up color gradients into a small number of regions, 
// then flood those areas with a solid color. Let’s chop up the diffuse gradient into 4 intervals, 
// and chop specular into 2 intervals. Insert the gray lines into your fragment shader.
//
//  Reference:
//  [1] http://prideout.net/blog/?p=22
//  [2] https://github.com/candycat1992/NPR_Lab 		
//


Shader "ShaderSuperb/Session20/NPR/Antialiased Cel Shading" 
{
	Properties 
	{
		_MainTex ("Main Tex", 2D)  = "white" {}
		_Outline ("Outline", Range(0,1)) = 0.1
		_OutlineColor ("Outline Color", Color) = (0, 0, 0, 1)
		_DiffuseColor ("Diffuse Color", Color) = (1, 1, 1, 1)
		_SpecularColor ("Specular Color", Color) = (1, 1, 1, 1)
		_Shininess ("Shininess", Range(1, 500)) = 40
		_DiffuseInterval ("Diffuse Segment", Vector) = (0.1, 0.3, 0.6, 1.0)
		_SpecularInterval ("Specular Segment", Range(0, 1)) = 0.5
	}

	SubShader 
	{
		Tags { "RenderType"="Opaque" }
		LOD 200

		///-----------------------------------------
		///Pass1 : 描边-轮廓线 outline Pass
		///-----------------------------------------
		Pass 
		{
			NAME "OUTLINE"
			
			Cull Front
			
			CGPROGRAM
			
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			
			float _Outline;
			fixed4 _OutlineColor;
			
			struct a2v 
			{
				float4 vertex : POSITION;
				float3 normal : NORMAL;
			}; 
			
			struct v2f 
			{
				float4 pos : SV_POSITION;
			};
			
			v2f vert (a2v v) 
			{
				v2f o;
				
				float4 pos = mul(UNITY_MATRIX_MV, v.vertex); 
				float3 normal = mul((float3x3)UNITY_MATRIX_IT_MV, v.normal);  
				normal.z = -0.5;
				pos = pos + float4(normalize(normal), 0) * _Outline;
				o.pos = mul(UNITY_MATRIX_P, pos);
				
				return o;
			}
			
			float4 frag(v2f i) : SV_Target 
			{ 
				return float4(_OutlineColor.rgb, 1);               
			}
			
			ENDCG
		}

		//-----------------------------------------
		//Pass2 : 正向渲染主pass
		//-----------------------------------------
		Pass 
		{
			Tags { "LightMode"="ForwardBase" }
		
			CGPROGRAM
		
			#pragma vertex vert
			#pragma fragment frag
			
			#pragma multi_compile_fwdbase
		
			#include "UnityCG.cginc"
			#include "Lighting.cginc"
			#include "AutoLight.cginc"
		
			fixed4 _DiffuseColor;
			sampler2D _MainTex;
			float4 _MainTex_ST;
			fixed4 _SpecularColor;
			float _Shininess;
			fixed4 _DiffuseInterval;
			fixed _SpecularInterval;
		
			struct a2v 
			{
				float4 vertex : POSITION;
				float3 normal : NORMAL;
				float4 texcoord : TEXCOORD0;
			}; 
		
			struct v2f 
			{
				float4 pos : SV_POSITION;
				float2 uv : TEXCOORD0;
				fixed3 worldNormal : TEXCOORD1;
				float3 worldPos : TEXCOORD2;
				SHADOW_COORDS(3)
			};
			
			v2f vert (a2v v) 
			{
				v2f o;
				
				o.pos = UnityObjectToClipPos( v.vertex); 
				o.worldNormal  = mul(v.normal, (float3x3)unity_WorldToObject);
				o.worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
				o.uv = TRANSFORM_TEX (v.texcoord, _MainTex);
				
				TRANSFER_SHADOW(o);
		    	
				return o;
			}

			
			fixed4 frag(v2f i) : SV_Target 
			{ 
				//参数准备
				fixed3 worldNormal = normalize(i.worldNormal);
				fixed3 worldLightDir = UnityWorldSpaceLightDir(i.worldPos);
				fixed3 worldViewDir = UnityWorldSpaceViewDir(i.worldPos);
				fixed3 worldHalfDir = normalize(worldViewDir + worldLightDir);
				
				UNITY_LIGHT_ATTENUATION(atten, i, i.worldPos);
		    	
				//半兰伯特光照项（漫反射项）
				fixed diff = dot(worldNormal, worldLightDir);
				diff = diff * 0.5 + 0.5;

				//镜面反射项
				fixed spec = max(0, dot(worldNormal, worldHalfDir));
				spec = pow(spec, _Shininess);
				
				//抗锯齿卡通着色（Antialiased Cel Shading）-漫反射项的计算
				diff = AntialiasedCelShading_Diffuse(diff,_DiffuseInterval);

				//抗锯齿卡通着色（Antialiased Cel Shading）-镜面反射项的计算
				spec = AntialiasedCelShading_Specular(spec,_SpecularInterval);

				fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT;
				
				
				fixed3 texColor = tex2D(_MainTex, i.uv).rgb;
				fixed3 diffuse = diff * _LightColor0.rgb * _DiffuseColor.rgb * texColor;
				fixed3 specular = spec * _LightColor0.rgb * _SpecularColor.rgb;
				
				return fixed4(ambient + (diffuse + specular) * atten, 1);
			}
		
			ENDCG
		}
		
		//-----------------------------------------
		//Pass3 : 正向渲染附加pass
		//-----------------------------------------
		Pass 
		{
			Tags { "LightMode"="ForwardAdd" }
			
			Blend One One
			
			CGPROGRAM
			
			#pragma vertex vert
			#pragma fragment frag
			
			#pragma multi_compile_fwdadd
			
			#include "UnityCG.cginc"
			#include "Lighting.cginc"
			#include "AutoLight.cginc"
			
			fixed4 _DiffuseColor;
			sampler2D _MainTex;
			float4 _MainTex_ST;
			fixed4 _SpecularColor;
			float _Shininess;
			fixed4 _DiffuseInterval;
			fixed _SpecularInterval;
			
			struct a2v 
			{
				float4 vertex : POSITION;
				float3 normal : NORMAL;
				float4 texcoord : TEXCOORD0;
			}; 
			
			struct v2f 
			{
				float4 pos : SV_POSITION;
				float2 uv : TEXCOORD0;
				fixed3 worldNormal : TEXCOORD1;
				float3 worldPos : TEXCOORD2;
				SHADOW_COORDS(3)
			};
			
			v2f vert (a2v v) 
			{
				v2f o;
			
				o.pos = UnityObjectToClipPos( v.vertex); 
				o.worldNormal  = mul(v.normal, (float3x3)unity_WorldToObject);
				o.worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
				o.uv = TRANSFORM_TEX (v.texcoord, _MainTex);
				
				TRANSFER_SHADOW(o);
				
				return o;
			}
			
			fixed4 frag(v2f i) : SV_Target 
			{ 
				//参数准备
				fixed3 worldNormal = normalize(i.worldNormal);
				fixed3 worldLightDir = UnityWorldSpaceLightDir(i.worldPos);
				fixed3 worldViewDir = UnityWorldSpaceViewDir(i.worldPos);
				fixed3 worldHalfDir = normalize(worldViewDir + worldLightDir);
				
				UNITY_LIGHT_ATTENUATION(atten, i, i.worldPos);
				
				//半兰伯特光照项（漫反射项）
				fixed diff = dot(worldNormal, worldLightDir);
				diff = diff * 0.5 + 0.5;

				//镜面反射项
				fixed spec = max(0, dot(worldNormal, worldHalfDir));
				spec = pow(spec, _Shininess);
				
				//抗锯齿卡通着色（Antialiased Cel Shading）-漫反射项的计算
				diff = AntialiasedCelShading_Diffuse(diff,_DiffuseInterval);

				//抗锯齿卡通着色（Antialiased Cel Shading）-镜面反射项的计算
				spec = AntialiasedCelShading_Specular(spec,_SpecularInterval);
				
				fixed3 texColor = tex2D(_MainTex, i.uv).rgb;
				fixed3 diffuse = diff * _LightColor0.rgb * _DiffuseColor.rgb * texColor;
				fixed3 specular = spec * _LightColor0.rgb * _SpecularColor.rgb;
				
				return fixed4((diffuse + specular) * atten, 1);
			}
			
			ENDCG
		}
	}


	CGINCLUDE

	//-------------------------------------------------------------------
	// 抗锯齿卡通着色（Antialiased Cel Shading）-漫反射项的计算
	// chop up the diffuse gradient into 4 intervals
	//-------------------------------------------------------------------
	fixed AntialiasedCelShading_Diffuse(fixed diff,Vector intervals)
	{
		fixed w = fwidth(diff) * 2.0;
		if (diff < intervals.x + w) 
		{
			diff = lerp(intervals.x, intervals.y, smoothstep(intervals.x - w, intervals.x + w, diff));
			//diff = lerp(intervals.x, intervals.y, clamp(0.5 * (diff - intervals.x) / w, 0, 1));
		} 
		else if (diff < intervals.y + w) 
		{
			diff = lerp(intervals.y, intervals.z, smoothstep(intervals.y - w, intervals.y + w, diff));
			//diff = lerp(intervals.y, intervals.z, clamp(0.5 * (diff - intervals.y) / w, 0, 1));
		} 
		else if (diff < intervals.z + w) 
		{
			diff = lerp(intervals.z, intervals.w, smoothstep(intervals.z - w, intervals.z + w, diff));
			//diff = lerp(intervals.z, intervals.w, clamp(0.5 * (diff - intervals.z) / w, 0, 1));
		} 
		else 
		{
			diff = intervals.w;
		}
		return diff;
	}

	//-------------------------------------------------------------------
	// 抗锯齿卡通着色（Antialiased Cel Shading）-镜面反射项的计算
	// chop specular into 2 intervals
	//-------------------------------------------------------------------
	fixed AntialiasedCelShading_Specular(fixed spec,fixed intervals)
	{
		fixed w = fwidth(spec);
		if (spec < intervals + w) 
		{
			spec = lerp(0, 1, smoothstep(intervals - w, intervals + w, spec));
		} 
		else 
		{
			spec = 1;
		}
		return spec;
	}

	ENDCG
	
	FallBack "Diffuse"	    
}
