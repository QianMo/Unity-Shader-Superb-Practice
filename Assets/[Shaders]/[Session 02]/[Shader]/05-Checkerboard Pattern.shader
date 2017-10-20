//https://docs.unity3d.com/Manual/SL-VertexFragmentShaderExamples.html

// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

Shader "ShaderSuperb/Session2/04-SkyReflection Per Pixel With Texture"
{
    Properties 
    {
        _Density ("Density", Range(2,50)) = 30
    }

    SubShader
    {
        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"

            float _Density;

            //---------------------------------
            //顶点输入结构体
            //---------------------------------
            struct a2v
            {
                float4 vertex:POSITION;//从Unity获取顶点位置
                float2 uv : TEXCOORD0; //从Unity获取第一组纹理坐标
            };


            //---------------------------------
            //顶点输出，片元输入结构体
            //---------------------------------
            struct v2f 
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };

            v2f vert (a2v v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv * _Density;
                return o;
            }
        
            fixed4 frag (v2f i) : SV_Target
            {
                float2 c = i.uv;
                c = floor(c) / 2;
                float checker = frac(c.x + c.y) * 2;
                return checker;
            }
            ENDCG
        }
    }
}