
//http://wiki.unity3d.com/index.php/TransparentShadowCaster

Shader "ShaderSuperb/Session11/08-TransparentShadowCaster"
{

	Properties 
	{ 
	 	// Ususal stuffs
		_Color ("Main Color", Color) = (1,1,1,1)
		_SpecColor ("Specular Color", Color) = (0.5, 0.5, 0.5, 0)
		_Shininess ("Shininess", Range (0.01, 1)) = 0.078125
		_MainTex ("Base (RGB) TransGloss (A)", 2D) = "white" {}
	 
		// Bump stuffs
		//_Parallax ("Height", Range (0.005, 0.08)) = 0.02
		_BumpMap ("Normalmap", 2D) = "bump" {}
		//_ParallaxMap ("Heightmap (A)", 2D) = "black" {}
	 
		// Shadow Stuff
		_Cutoff ("Shadow Alpha cutoff", Range(0.25,0.9)) = 1.0
	} 
	 
	 
	SubShader 
	{ 
		Tags 
		{
			"Queue"="AlphaTest" 
			"IgnoreProjector"="True" 
			"RenderType"="Transparent"
		}
	 
		LOD 300
	 
	 
	 
		Pass
	        { 
				Name "ShadowCaster"
				Tags { "LightMode" = "ShadowCaster" }
	 
				Fog {Mode Off}
				ZWrite On ZTest Less Cull Off
				Offset 1, 1
	 
				CGPROGRAM
				// Upgrade NOTE: excluded shader from OpenGL ES 2.0 because it does not contain a surface program or both vertex and fragment programs.
				#pragma exclude_renderers gles
				#pragma vertex vert
				#pragma fragment frag
				#pragma fragmentoption ARB_precision_hint_fastest
				#pragma multi_compile_shadowcaster
				#include "ShadowCastCG.cginc"
	 
	 
				v2f vert( appdata_full v )
				{
					v2f o;
					//UNITY_INITIALIZE_OUTPUT(v,o);
					TRANSFER_SHADOW_CASTER(o)
	 
				  return o;
				}
	 
				float4 frag( v2f i ) : COLOR
				{
					fixed4 texcol = tex2D( _MainTex, i.uv );
					clip( texcol.a - _Cutoff );
					SHADOW_CASTER_FRAGMENT(i)
				}
				ENDCG
	        } 
	 
	 
			CGPROGRAM
			#pragma surface surf BlinnPhong alpha vertex:vert fullforwardshadows approxview
			#include "ShadowCastCG.cginc"
	 
	 
			half _Shininess;
	 
			sampler2D _BumpMap;
			//sampler2D _ParallaxMap;
			float _Parallax;
	 
			struct Input 
			{
				float2 uv_MainTex;
				float2 uv_BumpMap;
				//float3 viewDir;
			};
	 
			v2f vert (inout appdata_full v) 
			{ 
				v2f o;
				return o; 
			} 
	 
			void surf (Input IN, inout SurfaceOutput o) 
			{
				// Comment the next 4 following lines to get a standard bumped rendering
				// [Without Parallax usage, which can cause strange result on the back side of the plane]
				/*half h = tex2D (_ParallaxMap, IN.uv_BumpMap).w;
				float2 offset = ParallaxOffset (h, _Parallax, IN.viewDir);
				IN.uv_MainTex += offset;
				IN.uv_BumpMap += offset;*/
	 
				fixed4 tex = tex2D(_MainTex, IN.uv_MainTex);
				o.Albedo = tex.rgb * _Color.rgb;
				o.Gloss = tex.a;
				o.Alpha = tex.a * _Color.a;
				//clip(o.Alpha - _Cutoff);
				o.Specular = _Shininess;
				o.Normal = UnpackNormal(tex2D(_BumpMap, IN.uv_BumpMap));
			}

			ENDCG
		}
	 
	Fallback "Transparent/VertexLit"
}