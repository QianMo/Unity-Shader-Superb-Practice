//Faces disappear when not face of the camera.

Shader "ShaderSuperb/Session19/Miscellaneous/FadingWhenTooEdge"
{
    Properties
    {
        _MainTex ("Main Texture", 2D) = "white" {}
        _Threshold ("Threshold", Range(0.0, 1.0)) = 0.0
    }
    SubShader
    {
        Tags { "RenderType"="Transparent" }
        Blend SrcAlpha OneMinusSrcAlpha
        Cull Off
 
        Pass {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"
 
            struct v2f {
                float4 pos : SV_POSITION;
                half2 uv : TEXCOORD0;
                fixed val : TEXCOORD1;
            };
 
            sampler2D _MainTex;
            float4 _MainTex_ST;
 
            v2f vert(appdata_base v) {
                v2f o;
                float4 worldpos = mul(unity_ObjectToWorld, v.vertex);
                o.pos = mul(UNITY_MATRIX_VP, worldpos);
                o.uv = TRANSFORM_TEX(v.texcoord, _MainTex);
 
                float3 worldnormal = normalize(mul(v.normal, (float3x3)unity_WorldToObject));
                float3 viewDir = normalize(_WorldSpaceCameraPos.xyz - worldpos.xyz);
                o.val = abs(dot(worldnormal, viewDir));
                return o;
            }
 
            fixed _Threshold;
 
            fixed4 frag(v2f i) : SV_Target {
                fixed4 col = tex2D(_MainTex, i.uv);
                col.a *= step(_Threshold + 0.01, i.val);
                return col;
            }
 
            ENDCG
        }
    }
}