//https://docs.unity3d.com/Manual/SL-VertexFragmentShaderExamples.html

// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

Shader "ShaderSuperb/Session2/06-Tri-Planar Texturing"
{
    Properties 
    {
        _MainTex ("Texture", 2D) = "white" {}
        _Tiling ("Tiling", Float) = 1.0
        _OcclusionMap("Occlusion", 2D) = "white" {}
    }

    SubShader
    {
        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"

            sampler2D _MainTex;
            float4 _MainTex_ST;
            sampler2D _OcclusionMap;
            float4 _OcclusionMap_ST;
            float _Tiling;

            //---------------------------------
            //顶点输入结构体
            //---------------------------------
            struct a2v
            {
                float4 vertex:POSITION;//从Unity获取顶点位置
                float3 normal:NORMAL;//从Unity获取法线坐标
                float4 tangent : TANGENT;//从Unity获取切线坐标
                float4 texcoordMainTex : TEXCOORD0;
                float4 texcoordOcclusionMap : TEXCOORD1; 
            };


            //---------------------------------
            //顶点输出，片元输入结构体
            //---------------------------------
            struct v2f 
            {
                half3 objNormal : TEXCOORD0;
                float3 coords : TEXCOORD1;
                float2 uvMainTex : TEXCOORD2; 
                float2 uvOcclusionMap : TEXCOORD3;
                float4 pos : SV_POSITION;
            };

            v2f vert (a2v v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                o.coords = v.vertex.xyz * _Tiling;
                o.objNormal = v.normal;
                //o.uv = uv;
                //#define TRANSFORM_TEX(tex,name) (tex.xy * name##_ST.xy + name##_ST.zw)
                o.uvMainTex = TRANSFORM_TEX(v.texcoordMainTex,_MainTex);
                o.uvOcclusionMap = TRANSFORM_TEX(v.texcoordOcclusionMap,_OcclusionMap);
                return o;
            }
        
            fixed4 frag (v2f i) : SV_Target
            {

                // 得到每个分量的绝对值 || use absolute value of normal as texture weights
                half3 blend = abs(i.objNormal);
                // make sure the weights sum up to 1 (divide by sum of x+y+z)
                blend /= dot(blend,1.0);
                // read the three texture projections, for x,y,z axes
                fixed4 cx = tex2D(_MainTex, i.coords.yz);
                fixed4 cy = tex2D(_MainTex, i.coords.xz);
                fixed4 cz = tex2D(_MainTex, i.coords.xy);
                // blend the textures based on weights
                fixed4 c = cx * blend.x + cy * blend.y + cz * blend.z;
                // modulate by regular occlusion map
                c *= tex2D(_OcclusionMap, i.uvOcclusionMap);
                return c;
            }
            ENDCG
        }
    }
}