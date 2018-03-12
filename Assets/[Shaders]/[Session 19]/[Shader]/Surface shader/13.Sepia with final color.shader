//How to use the final function in surface shader.
//More information :
// Original shader from Alastair https://alastaira.wordpress.com/2013/12/02/sepia-shader/
// Grayscale to sepia http://www.techrepublic.com/blog/how-do-i/how-do-i-convert-images-to-grayscale-and-sepia-tone-using-c/
// Shader sepia https://wiki.delphigl.com/index.php/shader_sepia

Shader "ShaderSuperb/Session19/Surface shader/FinalColorSepia"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_SepiaIntensity ("SepiaIntensity", Range(0, 1)) = 0
	}

	SubShader
	{
		Tags {"Queue"="Geometry" "RenderType"="Opaque"}

		CGPROGRAM
		#pragma surface surf Lambert finalcolor:SepiaColor

		struct Input {
			float2 uv_MainTex;
		};

		fixed _SepiaIntensity;

		void SepiaColor(Input IN, SurfaceOutput s, inout fixed4 col) {
			fixed3 c = col;
			c.r = dot(col.rgb, half3(0.393, 0.769, 0.189));
			c.g = dot(col.rgb, half3(0.349, 0.686, 0.168));
			c.b = dot(col.rgb, half3(0.272, 0.534, 0.131));
			col.rgb = lerp(col, c, _SepiaIntensity);
		}
		
		sampler2D _MainTex;

		void surf(Input IN, inout SurfaceOutput o) {
			o.Albedo = tex2D(_MainTex, IN.uv_MainTex).rgb;
			o.Alpha = 1.0;
		}

		ENDCG
	}

	FallBack "Diffuse"
}