// Allow to tune the bump with a surface shader

Shader "ShaderSuperb/Session19/Surface shader/Customizable Bump" 
{
    Properties {
        _MainTex ("Base (RGB)", 2D) = "white" {}
        _Bump ("Normal map", 2D) = "bump" {}
        _Intensity ("Intensity", Range(-5,5)) = 0.0
    }
    SubShader {
        Tags { "RenderType"="Opaque" }
       
        CGPROGRAM
        #pragma surface surf Lambert
 
        sampler2D _MainTex;
        sampler2D _Bump;
        float _Intensity;
 
        struct Input {
            float2 uv_MainTex;
            float2 uv_Bump;
        };
 
        void surf (Input IN, inout SurfaceOutput o) {
            half4 c = tex2D (_MainTex, IN.uv_MainTex);
            fixed3 n = UnpackNormal(tex2D(_Bump, IN.uv_Bump));
            n.x *= _Intensity;
            n.y *= _Intensity;
            o.Normal = normalize(n);
            o.Albedo = c.rgb;
            o.Alpha = c.a;
        }
        ENDCG
    }
    FallBack "Diffuse"
}